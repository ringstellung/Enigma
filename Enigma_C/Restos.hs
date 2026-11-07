module Restos (module Restos) where

{-
conector :: RotorDay -> Char -> Char
conector r c = alphabet !! (((ord c) - 65 - x) `mod` 26)  
	where 
	  w  = extractWiring.extractRotorFromRotorDay $ r
	  pd = ord(head w) - 65 
 	  x  = (ord.extractCharFromRotorDay $ r) - 65
-}

conector :: RotorDay -> Char -> Char
conector r c = alphabet !! (((ord c) - 65 - x) `mod` 26)  
  where
    x  = (ord.extractCharFromRotorDay $ r) - 65

{-
 Vamos a abreviar "processACharString" por "pcs". Imaginamos que c
 es el caracter a cifrar y s es el la biyección de un rotor (lo hemos
 llamado "wiring" aquí). "psc" no hace sino calcular la imagen de un
 carácter, según su posición en el alfabeto ordinario, por medio de la
 permutación s.
-}

pcs :: String -> Char -> Char
pcs s c = s !! ((ord c)-65)


{-
 La composición de "conector.pcs", más o menos, ha dado lugar a la función
 "f" del módulo auxiliar.
-}
