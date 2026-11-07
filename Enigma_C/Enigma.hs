module Enigma (module Enigma) where

import Data.Char

import Dictionary
import Auxiliars
import Types
import Examples

{- Teníamos como isInPositionToCJump la función:

isInPositionToCJump :: RotorDay -> Bool
isInPositionToCJump (RotorDay r c) = c == (head . extractNotch $ r)

y la hemos generalizado a isInPositionToCJumpGen 

isInPositionToCJumpGen :: RotorDay -> Bool
isInPositionToCJumpGen (RotorDay r c) = c  `elem` (extractNotch r)

por los rotores que tienen más de una muesca. Parece que funciona 
-}

--isInPositionToCJump :: RotorDay -> Bool
--isInPositionToCJump (RotorDay r c) = c == (head . extractNotch $ r)

isInPositionToCJump :: RotorDay -> Bool
isInPositionToCJump (RotorDay r c) = c  `elem` (extractNotch r)

rotateRotorOne :: RotorDay -> RotorDay
rotateRotorOne (RotorDay (Rotor w n en iw) p) = RotorDay (Rotor (rotateLevOne w) n en (rotateLevOne iw)) q
                                          where
                                            q = chr(((ord(p)-65+1) `mod` 26) + 65) 

{-
  stepForward ordena el avance de un set de rotores para proceder al cifrado de
  un caracter entrante.
-}

stepForward :: RotorSet -> RotorSet
stepForward (RotorSet r r3 r2 r1)
  | (not i) && (not ii)   = RotorSet r r3 r2 (rotateRotorOne r1)
  | (not i) && ii         = RotorSet r (rotateRotorOne r3) (rotateRotorOne r2) (rotateRotorOne r1)
  |      i  && (not ii)   = RotorSet r r3 (rotateRotorOne r2) (rotateRotorOne r1)
  |      i  && ii         = RotorSet r (rotateRotorOne r3) (rotateRotorOne r2) (rotateRotorOne r1)
           where
             i   = isInPositionToCJump r1
             ii  = isInPositionToCJump r2

{-
En la siguiente función f, s será en nuestro contexto el Wiring de un
rotor de un RotorDay de un RotorSet, o bien el Wiring del reflector.
f es algo así como la composición "conector.pcs" modificada para que
quepa el reflector como caso particular. El código de las aludidas funciones
está en Restos.hs
-}

f :: (String,Char) -> Char -> Char
f (s,c1) c2 = alphabet !! (((ord c) - ord c1) `mod` 26)
              where
                c = s !! ((ord c2) - 65)  
{-
   "nrsSf" es el rotor del día normalizado y con un paso adelante.
-}


equivalentCharIn :: Char -> Pb -> Char
equivalentCharIn c pb
  | isinkey            = valueInDict c pb
  | keysindict /= []   = head keysindict
  | otherwise          = c
      where
        isinkey = isKeyInDict c $ pb
        keysindict = keysInDict c pb

equivalentCharOut :: Char -> Pb -> Char
equivalentCharOut c pb
  | keysindict /= []   = head keysindict
  | isinkey            = valueInDict c pb
  | otherwise          = c
      where
        keysindict = keysInDict c pb
        isinkey = isKeyInDict c $ pb

{-
                             FUNCIONES PARA EL CIFRADO CON PLUGBOARD
-}

processACharWHE :: Pb -> RotorSet -> Char -> Char
processACharWHE pb nrsSf c = equivalentCharOut (foldr f m [(iw1,wr1),(iw2,wr2),(iw3,wr3),(r,'A'),(w3,wr3),(w2,wr2),(w1,wr1)]) pb
  where
    m   = equivalentCharIn c pb
    w1  = extractWiring.extractRotorFromRotorDay.extractRd1RotorSet $ nrsSf
    wr1 = extractCharFromRotorDay.extractRd1RotorSet $ nrsSf -- lectura de la ventana del rotor.
    w2  = extractWiring.extractRotorFromRotorDay.extractRd2RotorSet $ nrsSf
    wr2 = extractCharFromRotorDay.extractRd2RotorSet $ nrsSf
    w3  = extractWiring.extractRotorFromRotorDay.extractRd3RotorSet $ nrsSf
    wr3 = extractCharFromRotorDay.extractRd3RotorSet $ nrsSf
    r   = extractWiringRef.extractRefRotorSet $ nrsSf
    iw3 = extractIWiring.extractRotorFromRotorDay.extractRd3RotorSet $ nrsSf
    iw2 = extractIWiring.extractRotorFromRotorDay.extractRd2RotorSet $ nrsSf
    iw1 = extractIWiring.extractRotorFromRotorDay.extractRd1RotorSet $ nrsSf



encodeText :: RotorSet -> Pb -> String -> String
encodeText rs pb str = zipWith (processACharWHE pb) (iterate stepForward nrsSf) str
                    where
                      nrsSf   = stepForward.norm $ rs

{-
                         FIN DE FUNCIONES PARA EL CIFRADO SIN PLUGBOARD
-}


{-
                             FUNCIONES PARA EL CIFRADO SIN PLUGBOARD
-}

processACharRotorSetup :: RotorSet -> Char -> Char
processACharRotorSetup nrsSf c = foldr f c [(iw1,wr1),(iw2,wr2),(iw3,wr3),(r,'A'),(w3,wr3),(w2,wr2),(w1,wr1)]
                            where
                              w1  = extractWiring.extractRotorFromRotorDay.extractRd1RotorSet $ nrsSf
                              wr1 = extractCharFromRotorDay.extractRd1RotorSet $ nrsSf -- lectura de la ventana del rotor.
                              w2  = extractWiring.extractRotorFromRotorDay.extractRd2RotorSet $ nrsSf
                              wr2 = extractCharFromRotorDay.extractRd2RotorSet $ nrsSf
                              w3  = extractWiring.extractRotorFromRotorDay.extractRd3RotorSet $ nrsSf
                              wr3 = extractCharFromRotorDay.extractRd3RotorSet $ nrsSf
                              r   = extractWiringRef.extractRefRotorSet $ nrsSf
                              iw3 = extractIWiring.extractRotorFromRotorDay.extractRd3RotorSet $ nrsSf
                              iw2 = extractIWiring.extractRotorFromRotorDay.extractRd2RotorSet $ nrsSf
                              iw1 = extractIWiring.extractRotorFromRotorDay.extractRd1RotorSet $ nrsSf


encodeTextWpb :: RotorSet -> String -> String
encodeTextWpb rs str = zipWith processACharRotorSetup (iterate stepForward nrsSf) str
                    where
                      nrsSf   = stepForward.norm $ rs


{-
                         FIN DE FUNCIONES PARA EL CIFRADO SIN PLUGBOARD
-}
