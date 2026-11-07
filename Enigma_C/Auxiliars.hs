module Auxiliars (module Auxiliars) where

import Data.List

alphabet :: String
alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"


{-
                                 FUNCIONES DE ROTACIÓN
-}

rotateLevAux :: String -> [String]
rotateLevAux xs = take len $ map (take len) $ tails $ cycle xs
  where
    len = length xs

--- rotateLev gira n posiciones en sentido levógiro el string xs
rotateLev :: Int ->  String -> String
rotateLev n xs = (rotateLevAux xs) !! n

-- gira una posición en el sentido levógiro el string xs
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
                                 FUNCIONES PARA LA CONFIGURACIÓN 
-}

selectChar :: Int -> Char
selectChar (n) = "ABCDEFGHIJKLMNOPQRSTUVWXYZ" !! (n-1)

{-
 la función "findPosition a" busca el índice de la lista al que
 está asociada la entrada a.
-}

findPosition :: Eq a => a -> [a] -> Int
findPosition a = (\(Just i) -> i) . findIndex (== a)

