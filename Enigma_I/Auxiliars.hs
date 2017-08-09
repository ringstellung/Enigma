module Auxiliars (module Auxiliars) where

import Data.List   -- para usar elemIndex
import Data.Maybe

type Alph = String

{-
 alphabet es el alfabeto grabado en los rotores
 de cualquier Enigma, en particular la Enigma I
-}

alphabet :: Alph 
alphabet = ['A'..'Z']

removeWhiteAux :: String -> String -> String
removeWhiteAux "" strng = strng
removeWhiteAux (c:cs) strng
               | c == ' '  = removeWhiteAux cs strng
               | otherwise = removeWhiteAux cs (c:strng)
               
--removeWhite :: String -> String
--removeWhite cs = reverse(removeWhiteAux cs "")

removeWhite :: String -> String
removeWhite cs = reverse.removeWhiteAux cs $ ""

{-             FUNCIONES DE MANEJO DEL ALFABETO                           -}

{-
 No usaremos el alfabeto en su posición dentro del listado UTF-8, por
 si esto cambiara o por si decidiéramos aumentar experimentalmente
 nuestro alfabeto. Ahora implementamos una serie de funciones para
 traducir caractéres en números y viceversa.
-}

charToIndex :: Char -> Alph -> Int
charToIndex x strn = fromJust $ elemIndex x strn

charToIndexA :: Char -> Int
charToIndexA = \x -> charToIndex x alphabet

indexToCharAux :: Int -> Alph -> Maybe Char
indexToCharAux n strn
  | n < 0 || n >= length strn = Nothing
  | otherwise                 = Just (strn !! n)

indexToChar :: Int -> Alph -> Char
indexToChar n strn = fromJust $ indexToCharAux n strn

indexToCharA :: Int -> Char
indexToCharA = \n -> indexToChar n alphabet

-- Residuales, no se usan

selectChar :: Int -> Char
selectChar (n) = "ABCDEFGHIJKLMNOPQRSTUVWXYZ" !! (n-1)

{-
 la función "findPosition a" busca el índice de la lista al que
 está asociada la entrada a.
-}

findPosition :: Eq a => a -> [a] -> Int
findPosition a = (\(Just i) -> i) . findIndex (== a)

-- fin residuales no se usan---

                             {- FIN DE FUNCIONES DE MANEJO DEL ALFABETO    -}


{-                               FUNCIÓN DE DESPLAZAMIENTO EN EL ALFABETO     -}

nextInAlphabet :: Char -> Char 
nextInAlphabet c = indexToCharA(((charToIndexA(c)+1) `mod` 26))

{-
                                 FUNCIONES DE ROTACIÓN
-}

rotateLevAux :: String -> [String]
rotateLevAux xs = take len $ map (take len) $ tails $ cycle xs
  where
    len = length xs

--- rotateLev gira n posiciones el string xs en sentido levógiro 
rotateLev :: Int ->  String -> String
rotateLev n xs = (rotateLevAux xs) !! n

-- gira una posición el string xs en el sentido levógiro 
rotateLevOne :: String -> String
rotateLevOne xs = rotateLev 1 xs


{-
 rotateDes gira un número entero de posiciones un string en sentido
 destrógiro
-}

rotateDes :: Int -> String -> String
rotateDes 0 xs = xs
rotateDes n xs = rotateDes (n-1) (last xs : init xs)

-- gira el rotor una posición en el sentido destrógiro
rotateDesOne :: String -> String
rotateDesOne xs = rotateDes 1 xs

{-
                                 FIN DE FUNCIONES DE ROTACIÓN
-}


{-
   FUNCIONES PARA REGULAR EL VIAJE DE LA SEÑAL POR EL SET DE ROTORES
-}

{-
 En el código de t, wiring debe ser entendido como un cableado (el directo o el inverso)
 de un rotor. El parámetro rs es la parte del Ringstellung que atañe al rotor y gs
 es la parte del Grunstellung para ese rotor, convertido en entero. Es decir:

 where
        walze  = extractRotorFromRotorGS rgs
        wiring = extractWiring walze
        rs     = 1 + extractRSW walze
        gs     = charToIndexA (extractCharFromRotorGS rgs) 
-}

t :: (String,Int,Int) -> Char -> Char
t (wiring,rs,gs) c = alphabet !! (((charToIndexA (wiring !! (charToIndexA c))) - gs+rs) `mod` 26)

{-
   FIN DE FUNCIONES PARA REGULAR EL VIAJE DE LA SEÑAL POR EL SET DE ROTORES
-}
