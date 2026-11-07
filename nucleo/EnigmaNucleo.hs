{-# LANGUAGE BangPatterns #-}
{-
  Núcleo común de las máquinas Enigma de tres y cuatro rotores.

  Una máquina es una lista de rotores montados, del de la izquierda al de la
  derecha. Solo avanzan los tres de la derecha; el griego de la M4, si lo
  hay, se queda quieto. M3 y M4 son módulos finos sobre este.

  Para ir deprisa, cada rotor guarda dos tablas de 676 entradas con su
  permutación para cada desplazamiento (posición menos anillo), y lo que hay
  a la izquierda del rotor rápido se resume en una sola tabla de 26 entradas,
  que solo se recalcula cuando se mueve el rotor central.
-}
module EnigmaNucleo
  ( CharOrInt (..)
  , Rotor
  , Reflector
  , Pb
  , Montaje
  , hacerRotor
  , hacerReflector
  , crearPb
  , createPbSet
  , montar
  , reposicionar
  , posiciones
  , cifrar
  , cifrarBytes
  ) where

import qualified Data.ByteString as B
import qualified Data.ByteString.Char8 as BC
import qualified Data.ByteString.Internal as BI
import qualified Data.ByteString.Unsafe as BU
import Data.Char (chr, isAsciiUpper, ord, toUpper)
import Data.List (nub, sort)
import Data.Word (Word8)
import Foreign.Marshal.Alloc (allocaBytes)
import Foreign.Ptr (Ptr)
import Foreign.Storable (peekByteOff, pokeByteOff)
import System.IO.Unsafe (unsafeDupablePerformIO)

-- Un anillo se puede dar por su letra o por su número, de 1 a 26.
data CharOrInt = CharacterI Char | IntegerI Int deriving Show

data Rotor = Rotor
  { cableado    :: String
  , muescas     :: !B.ByteString   -- 26 entradas: 1 si hay muesca
  , tablaIda    :: !B.ByteString
  , tablaVuelta :: !B.ByteString
  }

instance Show Rotor where
  show = ("Rotor " ++) . cableado

newtype Reflector = Reflector B.ByteString

instance Show Reflector where
  show (Reflector t) = "Reflector " ++ show (map letra (B.unpack t))

-- El clavijero es una tabla de 26 entradas.
newtype Pb = Pb B.ByteString deriving Eq

instance Show Pb where
  show (Pb t) = unwords [ [a, b] | (a, b) <- zip l (map letra (B.unpack t)), a < b ]
    where l = ['A' .. 'Z']

letra :: Word8 -> Char
letra n = chr (65 + fromIntegral n)

indice :: Char -> Maybe Int
indice c
  | isAsciiUpper u = Just (ord u - 65)
  | otherwise      = Nothing
  where u = toUpper c

indiceSeguro :: String -> Char -> Int
indiceSeguro donde c = maybe (error (donde ++ ": carácter no válido: " ++ show c)) id (indice c)

esPermutacion :: String -> Bool
esPermutacion s = sort s == ['A' .. 'Z']

-- Tabla de 676 entradas: para el desplazamiento o y la entrada x, da
-- (w[(x + o) mod 26] - o) mod 26.
tablaDe :: [Int] -> B.ByteString
tablaDe w = B.pack
  [ fromIntegral ((BU.unsafeIndex v ((x + o) `mod` 26) `suma` (26 - o)) `mod` 26)
  | o <- [0 .. 25], x <- [0 .. 25 :: Int] ]
  where
    v = B.pack (map fromIntegral w)
    suma a b = fromIntegral a + b :: Int

hacerRotor :: String -> String -> Rotor
hacerRotor w ms
  | not (esPermutacion w) = error ("hacerRotor: el cableado no es una permutación: " ++ w)
  | otherwise = Rotor w tablaM (tablaDe d) (tablaDe i)
  where
    d = map (indiceSeguro "hacerRotor") w
    i = [ p | x <- [0 .. 25], (p, y) <- zip [0 ..] d, y == x ]
    ns = map (indiceSeguro "hacerRotor") ms
    tablaM = B.pack [ if n `elem` ns then 1 else 0 | n <- [0 .. 25] ]

hacerReflector :: String -> Reflector
hacerReflector w
  | not (esPermutacion w) = error ("hacerReflector: no es una permutación: " ++ w)
  | any malo [0 .. 25]    = error ("hacerReflector: debe ser involución sin puntos fijos: " ++ w)
  | otherwise             = Reflector t
  where
    t = B.pack (map (fromIntegral . indiceSeguro "hacerReflector") w)
    malo n = let m = fromIntegral (B.index t n) in m == n || fromIntegral (B.index t m) /= n

-- Construye el clavijero. A diferencia de createPbSet, no aborta.
crearPb :: String -> Either String Pb
crearPb s
  | any ((== Nothing) . indice) letras = Left ("clavijero: carácter no válido en " ++ show s)
  | odd (length letras)                = Left ("clavijero: hay una letra sin pareja en " ++ show s)
  | length (nub us) /= length us       = Left ("clavijero: letra repetida en " ++ show s)
  | otherwise                          = Right (Pb tabla)
  where
    letras = filter (/= ' ') s
    us     = map toUpper letras
    ps     = map (indiceSeguro "clavijero") us
    pares  = trozos ps
    tabla  = B.pack [ fromIntegral (imagen n) | n <- [0 .. 25] ]
    imagen n = case [ b | (a, b) <- pares ++ map cambia pares, a == n ] of
      (b : _) -> b
      []      -> n
    cambia (a, b) = (b, a)
    trozos (a : b : r) = (a, b) : trozos r
    trozos _           = []

createPbSet :: String -> Pb
createPbSet = either error id . crearPb

data Disco = Disco
  { dRotor  :: !Rotor
  , dAnillo :: !Int
  , dPos    :: !Int
  } deriving Show

-- Reflector y discos: el rápido, el central, el lento y el griego. En una
-- máquina de tres rotores, el griego es la identidad.
data Montaje = Montaje !B.ByteString !Disco !Disco !Disco !Disco
  deriving Show

identidad :: Disco
identidad = Disco (hacerRotor ['A' .. 'Z'] "") 0 0

indiceAnillo :: CharOrInt -> Int
indiceAnillo (CharacterI c) = indiceSeguro "anillo" c
indiceAnillo (IntegerI n)
  | n >= 1 && n <= 26 = n - 1
  | otherwise         = error ("anillo: debe estar entre 1 y 26: " ++ show n)

-- Los rotores se dan de izquierda a derecha, cada uno con anillo y posición.
montar :: Reflector -> [(Rotor, CharOrInt, Char)] -> Montaje
montar (Reflector u) rs = case reverse (map disco rs) of
  [d1, d2, d3]     -> Montaje u d1 d2 d3 identidad
  [d1, d2, d3, d4] -> Montaje u d1 d2 d3 d4
  _                -> error "montar: hacen falta tres o cuatro rotores"
  where
    disco (r, a, p) = Disco r (indiceAnillo a) (indiceSeguro "posición" p)

-- Cambia las posiciones, dadas de izquierda a derecha.
reposicionar :: Montaje -> [Char] -> Montaje
reposicionar (Montaje u d1 d2 d3 d4) ps = case reverse (map (indiceSeguro "posición") ps) of
  [a, b, c]    -> Montaje u d1 {dPos = a} d2 {dPos = b} d3 {dPos = c} d4
  [a, b, c, d] -> Montaje u d1 {dPos = a} d2 {dPos = b} d3 {dPos = c} d4 {dPos = d}
  _            -> error "reposicionar: hacen falta tres o cuatro posiciones"

-- Posiciones actuales, de izquierda a derecha.
posiciones :: Montaje -> String
posiciones (Montaje _ d1 d2 d3 d4) = map (letra . fromIntegral . dPos) (griego ++ [d3, d2, d1])
  where griego = [ d4 | cableado (dRotor d4) /= ['A' .. 'Z'] ]

-- Desplazamiento de un disco en una posición dada.
despl :: Disco -> Int -> Int
despl d p = (p - dAnillo d + 26) `mod` 26
{-# INLINE despl #-}

en :: B.ByteString -> Int -> Int
en t i = fromIntegral (BU.unsafeIndex t i)
{-# INLINE en #-}

-- Lo que hay a la izquierda del rotor rápido: ida, reflector y vuelta.
recomponer :: Ptr Word8 -> B.ByteString -> Montaje -> Int -> Int -> Int -> IO ()
recomponer !m !u (Montaje _ _ d2 d3 d4) !o2 !o3 !o4 = go 0
  where
    !i2 = tablaIda (dRotor d2) ; !v2 = tablaVuelta (dRotor d2)
    !i3 = tablaIda (dRotor d3) ; !v3 = tablaVuelta (dRotor d3)
    !i4 = tablaIda (dRotor d4) ; !v4 = tablaVuelta (dRotor d4)
    !a2 = o2 * 26 ; !a3 = o3 * 26 ; !a4 = o4 * 26
    go :: Int -> IO ()
    go 26 = pure ()
    go !x = do
      let !y = en i4 (a4 + en i3 (a3 + en i2 (a2 + x)))
          !z = en u y
          !w = en v2 (a2 + en v3 (a3 + en v4 (a4 + z)))
      pokeByteOff m x (fromIntegral w :: Word8)
      go (x + 1)

-- Cifra un bloque y devuelve la máquina en su posición final. Las entradas
-- deben ser letras mayúsculas.
cifrarBytes :: Montaje -> Pb -> B.ByteString -> (B.ByteString, Montaje)
cifrarBytes mo@(Montaje u d1 d2 d3 d4) (Pb pb) texto =
  unsafeDupablePerformIO (BI.createUptoN' n trabajo)
  where
    !n  = B.length texto
    !i1 = tablaIda (dRotor d1)
    !v1 = tablaVuelta (dRotor d1)
    !n1 = muescas (dRotor d1)
    !n2 = muescas (dRotor d2)
    !o4 = despl d4 (dPos d4)
    trabajo sal = allocaBytes 26 $ \m -> do
      let inc x = if x == 25 then 0 else x + 1 :: Int
          fin p1 p2 p3 = (n, Montaje u d1 {dPos = p1} d2 {dPos = p2} d3 {dPos = p3} d4)
          comp p2 p3 = recomponer m u mo (despl d2 p2) (despl d3 p3) o4
          bucle :: Int -> Int -> Int -> Int -> Int -> IO (Int, Montaje)
          bucle !k !p1 !o1 !p2 !p3
            | k == n    = pure (fin p1 p2 p3)
            | otherwise = do
                let !dobleP = en n2 p2 /= 0
                    !llevaP = en n1 p1 /= 0
                    !p1' = inc p1
                    !o1' = inc o1
                if dobleP
                  then do
                    let !p2' = inc p2 ; !p3' = inc p3
                    comp p2' p3'
                    letraBucle k o1'
                    bucle (k + 1) p1' o1' p2' p3'
                  else if llevaP
                    then do
                      let !p2' = inc p2
                      comp p2' p3
                      letraBucle k o1'
                      bucle (k + 1) p1' o1' p2' p3
                    else do
                      letraBucle k o1'
                      bucle (k + 1) p1' o1' p2 p3
          letraBucle :: Int -> Int -> IO ()
          letraBucle !k !o = do
            let !c = en texto k - 65
                !a = o * 26
                !x = en i1 (a + en pb c)
            z <- peekByteOff m x :: IO Word8
            let !w = en v1 (a + fromIntegral z)
            pokeByteOff sal k (fromIntegral (en pb w) + 65 :: Word8)
      comp (dPos d2) (dPos d3)
      bucle 0 (dPos d1) (despl d1 (dPos d1)) (dPos d2) (dPos d3)

-- Cifra una cadena de cualquier longitud, a trozos, sin perder la pereza.
-- Admite minúsculas y aborta con cualquier otro carácter.
cifrar :: Montaje -> Pb -> String -> String
cifrar mo pb s = case splitAt tamTrozo s of
  ([], _) -> []
  (t, r)  -> let (sal, mo') = cifrarBytes mo pb (BC.pack (map limpia t))
             in BC.unpack sal ++ cifrar mo' pb r
  where
    limpia c = chr (65 + indiceSeguro "texto" c)

tamTrozo :: Int
tamTrozo = 4096
