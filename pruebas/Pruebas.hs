-- Comprueba las máquinas con mensajes reales, con vectores de otra
-- implementación y con las propiedades de la Enigma.
--
-- Desde la raíz del repositorio:  make pruebas
module Main (main) where

import Control.Exception (ErrorCall, evaluate, try)
import Control.Monad (unless)
import Data.Char (toLower)
import qualified EnigmaComercial as C
import qualified EnigmaI as I
import qualified EnigmaM3 as M3
import qualified EnigmaM4 as M4
import qualified Data.ByteString.Char8 as BC
import Data.List (nub)
import EnigmaNucleo (Montaje, Pb, Reflector, Rotor, cifrar, cifrarBytes, crearPb, posiciones, sinClavijero)
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

comercial :: C.Modelo -> String -> String -> String -> Char -> Montaje
comercial m [a, b, c] [p, q, r] [x, y, z] =
  C.rotorSetup m (C.W (k a) (k b) (k c))
    (C.RS (C.CharacterI p) (C.CharacterI q) (C.CharacterI r)) (C.GS x y z)
  where
    k '1' = C.rotor_K1
    k '2' = C.rotor_K2
    k '3' = C.rotor_K3
    k n   = error [n]
comercial _ _ _ _ = error "comercial"

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

-- Texto del mensaje de Barbarossa, tal como lo da Rijmenants.
barbarossa1c, barbarossa1, barbarossa2c, barbarossa2 :: String
barbarossa1c = "EDPUDNRGYSZRCXNUYTPOMRMBOFKTBZREZKMLXLVEFGUEYSIOZVEQMIKUBPMMYLKLTTDEISMDICAGYKUACTCDOMOHWXMUUIAUBSTSLRNBZSZWNRFXWFYSSXJZVIJHIDISHPRKLKAYUPADTXQSPINQMATLPIFSVKDASCTACDPBOPVHJK"
barbarossa1 = "AUFKLXABTEILUNGXVONXKURTINOWAXKURTINOWAXNORDWESTLXSEBEZXSEBEZXUAFFLIEGERSTRASZERIQTUNGXDUBROWKIXDUBROWKIXOPOTSCHKAXOPOTSCHKAXUMXEINSAQTDREINULLXUHRANGETRETENXANGRIFFXINFXRGTX"
barbarossa2c = "SFBWDNJUSEGQOBHKRTAREEZMWKPPRBXOHDROEQGBBGTQVPGVKBVVGBIMHUSZYDAJQIROAXSSSNREHYGGRPISEZBOVMQIEMMZCYSGQDGRERVBILEKXYQIRGIRQNRDNVRXCYYTNJR"
barbarossa2 = "DREIGEHTLANGSAMABERSIQERVORWAERTSXEINSSIEBENNULLSEQSXUHRXROEMXEINSXINFRGTXDREIXAUFFLIEGERSTRASZEMITANFANGXEINSSEQSXKMXKMXOSTWXKAMENECXK"

main :: IO ()
main = do
  mensajes <- map campos . lines <$> readFile "pruebas/mensajes.txt"
  azar     <- map campos . lines <$> readFile "pruebas/azar.txt"
  vectoresC <- map words . lines <$> readFile "pruebas/comercial.txt"
  let bienM [u, rs, an, po, ps, c, cl] = cifrar (maquina u (words rs) an po) (pb ps) c == cl
      bienM _ = False
      bienA [u, rs, an, po, ps, n, s, h] =
        suma (cifrar (maquina u (words rs) an po) (pb ps) (texto (read n) (read s))) == read h
      bienA _ = False
      bienC [mo, rs, an, po, [u], cl, ci] =
        let m = if mo == "D" then C.EnigmaD else C.EnigmaK
        in C.encodeTextEnigmaComercial (comercial m rs an po u) cl == ci
      bienC _ = False
      tras m = posiciones (snd' (cifrarBytes m sinClavijero (BC.pack "A")))
      snd' (_, b) = b
      nc = length (filter (not . bienC) vectoresC)
      ck = comercial C.EnigmaK "123" "DUR" "ERK"
      letraI = I.CharacterI
      ei1 = I.rotorSetup (I.W I.rotor_02 I.rotor_04 I.rotor_05)
              (I.RS (letraI 'B') (letraI 'U') (letraI 'L')) (I.GS 'W' 'X' 'C') I.reflector_B
      pi1 = I.createPbSet "AV BS CG DL FU HZ IN KM OW RX"
      enI1 g = I.encodeTextEnigmaI (I.resetGrundstellung ei1 g) pi1
      ei2 = I.rotorSetup (I.W I.rotor_01 I.rotor_02 I.rotor_05)
              (I.RS (I.IntegerI 6) (I.IntegerI 22) (I.IntegerI 14)) (I.GS 'E' 'H' 'Z') I.reflector_B
      pi2 = I.createPbSet "PO ML IU KJ NH YT GB VF RE DC"
      enI2 g = I.encodeTextEnigmaI (I.resetGrundstellung ei2 g) pi2
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
    , comprueba "Enigma I: indicadores de Barbarossa"
        (enI1 (I.GS 'W' 'X' 'C') "KCH" == "BLA" && enI1 (I.GS 'C' 'R' 'S') "YPJ" == "LSD")
    , comprueba "Enigma I: primera parte de Barbarossa"
        (enI1 (I.GS 'B' 'L' 'A') barbarossa1c == barbarossa1)
    , comprueba "Enigma I: segunda parte de Barbarossa"
        (enI1 (I.GS 'L' 'S' 'D') barbarossa2c == barbarossa2)
    , comprueba "Enigma I: ejemplo de Dönitz, con anillos numéricos"
        (enI2 (I.GS 'E' 'H' 'Z') "TBS" == "XWB"
           && enI2 (I.GS 'X' 'W' 'B') "QBLTWLDAHHYEOEFPTWYBLENDPMKOXLDFAMUDWIJDXRJZ"
                == "DERFUEHRERISTTODXDERKAMPFGEHTWEITERXDOENITZX")
    , comprueba (show (length vectoresC) ++ " vectores de la comercial, " ++ show nc ++ " fallos") (nc == 0)
    , comprueba "K: el rápido III lleva al central al pasar de N"
        (tras (comercial C.EnigmaK "123" "AAA" "AAN" 'A') == "ABO")
    , comprueba "K: el anillo no mueve la letra del salto"
        (tras (comercial C.EnigmaK "123" "AAF" "AAN" 'A') == "ABO")
    , comprueba "K: doble paso del central en E"
        (tras (comercial C.EnigmaK "123" "AAA" "AEA" 'A') == "BFB")
    , comprueba "D: con el anillo en A, salta al pasar de Z"
        (tras (comercial C.EnigmaD "123" "AAA" "AAZ" 'A') == "ABA")
    , comprueba "D: el salto es la letra anterior a la del anillo"
        (tras (comercial C.EnigmaD "123" "AAC" "AAB" 'A') == "ABC")
    , comprueba "comercial: involución en las 26 posiciones del reflector"
        (and [ C.encodeTextEnigmaComercial (ck u) (C.encodeTextEnigmaComercial (ck u) t) == t
             | u <- ['A' .. 'Z'] ])
    , comprueba "comercial: ninguna letra se cifra en sí misma"
        (and (zipWith (/=) t (C.encodeTextEnigmaComercial (ck 'L') t)))
    , comprueba "comercial: las 26 posiciones del reflector difieren"
        (length (nub [ take 200 (C.encodeTextEnigmaComercial (ck u) t) | u <- ['A' .. 'Z'] ]) == 26)
    ]
  unless (and rs) exitFailure
