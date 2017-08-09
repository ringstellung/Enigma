module EnigmaM3 (module EnigmaM3) where

import Data.Char
import Auxiliars
import Types
import Rotors

{-
                                     CIFRADO
-}

isInPositionToCJump :: RotorGS -> Bool
isInPositionToCJump (RotorGS r c) = c  `elem` (extractNotch r)

rotateRotorOne :: RotorGS -> RotorGS
rotateRotorOne (RotorGS (Rotor rr n r w iw) c) = RotorGS (Rotor (rotateLevOne rr) n r (rotateLevOne w) (rotateLevOne iw)) d
                where
                  d = nextInAlphabet c

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
                             FUNCIONES PARA EL CIFRADO CON PLUGBOARD

-}

processAChar :: Pb -> RotorSet -> Char -> Char
processAChar pb rs c = equivalentChar (foldr t m [(iw1,rs1,gs1),(iw2,rs2,gs2),(iw3,rs3,gs3),(r,0,0),(w3,rs3,gs3),(w2,rs2,gs2),(w1,rs1,gs1)]) pb
  where
    m   = equivalentChar c pb
    w1  = extractWiring.extractRotorFromRotorGS.extractRGS1RotorSet $ rs
    a1  = extractRSW.extractRotorFromRotorGS.extractRGS1RotorSet $ rs
    rs1 = 1 + a1
    gs1 = charToIndexA.extractCharFromRotorGS.extractRGS1RotorSet $ rs
    w2  = extractWiring.extractRotorFromRotorGS.extractRGS2RotorSet $ rs
    a2  = extractRSW.extractRotorFromRotorGS.extractRGS2RotorSet $ rs
    rs2 = 1 + a2
    gs2 = charToIndexA.extractCharFromRotorGS.extractRGS2RotorSet $ rs    
    w3  = extractWiring.extractRotorFromRotorGS.extractRGS3RotorSet $ rs
    a3  = extractRSW.extractRotorFromRotorGS.extractRGS3RotorSet $ rs
    rs3 = 1 + a3
    gs3 = charToIndexA.extractCharFromRotorGS.extractRGS3RotorSet $ rs    
    r   = extractWiringRef.extractRefRotorSet $ rs
    iw3 = extractIWiring.extractRotorFromRotorGS.extractRGS3RotorSet $ rs
    iw2 = extractIWiring.extractRotorFromRotorGS.extractRGS2RotorSet $ rs
    iw1 = extractIWiring.extractRotorFromRotorGS.extractRGS1RotorSet $ rs

encodeTextEnigmaM3 :: RotorSet -> Pb -> String -> String
encodeTextEnigmaM3 rs pb str = zipWith (processAChar pb) (iterate stepForward nrsSf) str
                    where
                      nrsSf   = stepForward.norm $ rs

