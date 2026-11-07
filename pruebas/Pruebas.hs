-- Comprueba las máquinas con mensajes reales, con vectores de otra
-- implementación y con las propiedades de la Enigma.
--
-- Desde la raíz del repositorio:  make pruebas
module Main (main) where

import Control.Exception (ErrorCall, evaluate, try)
import Control.Monad (unless)
import Data.Char (toLower)
import qualified EnigmaM3 as M3
import qualified EnigmaM4 as M4
import EnigmaNucleo (Montaje, Pb, Reflector, Rotor, cifrar, crearPb, posiciones)
import Rotors
import System.Exit (exitFailure)

rotor :: String -> Rotor
rotor n = case lookup n tabla of
  Just r  -> r
  Nothing -> error n
  where
    tabla = [ ("I", rotor_01), ("II", rotor_02), ("III", rotor_03), ("IV", rotor_04)
            , ("V", rotor_05), ("VI", rotor_06), ("VII", rotor_07), ("VIII", rotor_08)
            , ("beta", beta), ("gamma", gamma) ]

reflector :: String -> Reflector
reflector "A"  = reflector_A
reflector "B"  = reflector_B
reflector "C"  = reflector_C
reflector "Bf" = reflector_B_Thin
reflector "Cf" = reflector_C_Thin
reflector n    = error n

maquina :: String -> [String] -> String -> String -> Montaje
maquina u [a, b, c] [p, q, r] [x, y, z] =
  M3.rotorSetup (M3.W (rotor a) (rotor b) (rotor c))
    (M3.RS (M3.CharacterI p) (M3.CharacterI q) (M3.CharacterI r)) (M3.GS x y z) (reflector u)
maquina u [a, b, c, d] [p, q, r, s] [x, y, z, t] =
  M4.rotorSetup (M4.W (rotor a) (rotor b) (rotor c) (rotor d))
    (M4.RS (M4.CharacterI p) (M4.CharacterI q) (M4.CharacterI r) (M4.CharacterI s))
    (M4.GS x y z t) (reflector u)
maquina _ _ _ _ = error "maquina"

campos :: String -> [String]
campos s = case break (== '\t') s of
  (a, _ : r) -> a : campos r
  (a, [])    -> [a]

texto :: Int -> Int -> String
texto n sem = [ toEnum (65 + (i * 7 + i * i * 3 + sem) `mod` 26) | i <- [0 .. n - 1] ]

suma :: String -> Int
suma = foldl' (\h c -> (h * 131 + fromEnum c) `mod` 2147483647) 0

comprueba :: String -> Bool -> IO Bool
comprueba nombre ok = do
  putStrLn ((if ok then "bien   " else "MAL    ") ++ nombre)
  pure ok

falla :: String -> IO Bool
falla s = do
  r <- try (evaluate (length s)) :: IO (Either ErrorCall Int)
  pure (either (const True) (const False) r)

pb :: String -> Pb
pb = M3.createPbSet

main :: IO ()
main = do
  mensajes <- map campos . lines <$> readFile "pruebas/mensajes.txt"
  azar     <- map campos . lines <$> readFile "pruebas/azar.txt"
  let bienM [u, rs, an, po, ps, c, cl] = cifrar (maquina u (words rs) an po) (pb ps) c == cl
      bienM _ = False
      bienA [u, rs, an, po, ps, n, s, h] =
        suma (cifrar (maquina u (words rs) an po) (pb ps) (texto (read n) (read s))) == read h
      bienA _ = False
      m1 = maquina "B" ["II", "IV", "V"] "BUL" "BLA"
      m4 = maquina "Bf" ["beta", "I", "II", "III"] "AAAA" "AAAA"
      p  = pb "AV BS CG DL FU HZ IN KM OW RX"
      t  = texto 20000 5
      c1 = cifrar m1 p t
      nb = length (filter (not . bienM) mensajes)
      na = length (filter (not . bienA) azar)
  e1 <- falla (cifrar m1 p "HOLA 1")
  e2 <- falla (cifrar (maquina "B" ["I", "II", "III"] "AAA" "AAA") (pb "AB") "ÑU")
  rs <- sequence
    [ comprueba (show (length mensajes) ++ " mensajes reales, " ++ show nb ++ " fallos") (nb == 0)
    , comprueba (show (length azar) ++ " configuraciones al azar, " ++ show na ++ " fallos") (na == 0)
    , comprueba "cifrar dos veces es la identidad" (cifrar m1 p c1 == t)
    , comprueba "ninguna letra se cifra en sí misma" (and (zipWith (/=) t c1))
    , comprueba "las minúsculas equivalen a mayúsculas" (cifrar m1 p (map toLower t) == c1)
    , comprueba "el texto infinito se cifra perezosamente"
        (take 10 (cifrar m1 p (cycle "A")) == take 10 (cifrar m1 p (replicate 10 'A')))
    , comprueba "la máquina no cambia al cifrar" (posiciones m1 == "BLA" && posiciones m4 == "AAAA")
    , comprueba "el reposicionado coincide con montar de nuevo"
        (cifrar (M3.resetGrundstellung m1 (M3.GS 'Q' 'E' 'V')) p t
           == cifrar (maquina "B" ["II", "IV", "V"] "BUL" "QEV") p t)
    , comprueba "letra repetida en el clavijero" (either (const True) (const False) (crearPb "AB AC"))
    , comprueba "letra sin pareja en el clavijero" (either (const True) (const False) (crearPb "ABC"))
    , comprueba "se admiten trece clavijas"
        (either (const False) (const True) (crearPb "AB CD EF GH IJ KL MN OP QR ST UV WX YZ"))
    , comprueba "un carácter no válido en el texto aborta" e1
    , comprueba "una letra fuera del alfabeto aborta" e2
    ]
  unless (and rs) exitFailure
