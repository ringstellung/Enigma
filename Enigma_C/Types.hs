module Types (module Types) where

import Data.Char
import Dictionary
import Auxiliars

class TypesWithNormalization b where
 norm :: b -> b                       --normalización

{-
 En "Rotor", el sentido del:
  -) primer string es la permutación directa, la llamamos "wiring"
  -) segundo string situa las muescas visible del rotor, lo llamamos "notch"
  -) tercer string es la letra en la que se aplica la de la muesca, enotch
  -) cuarto string es la permutación inversa
-}

data Rotor = Rotor String String String String deriving Show

{-
 Funciones de despiece de un Rotor para poder operar con él.
-}

extractWiring :: Rotor -> String
extractWiring (Rotor wiring notch enotch iwiring) = wiring

extractNotch :: Rotor -> String
extractNotch (Rotor wiring notch enotch iwiring) = notch

extractENotch :: Rotor -> String
extractENotch (Rotor wiring notch enotch iwiring) = enotch

extractIWiring :: Rotor -> String
extractIWiring (Rotor wiring notch enotch iwiring) = iwiring


{-
                                  INVERTIR UN ROTOR
-}

reverseWiring :: Rotor -> String
reverseWiring r = [chr(65 + findPosition a w) | a <- ['A'..'Z']] 
              where w = extractWiring r


{-
 Ejemplos de rotores. Son los usados en las máquinas conocidas.
-}

rotor_01 :: Rotor   -- 'X'
rotor_01 = Rotor "EKMFLGDQVZNTOWYHXUSPAIBRCJ" "Q" "X" "UWYGADFPVZBECKMTHXSLRINQOJ"

rotor_02 :: Rotor   -- 'S'
rotor_02 = Rotor "AJDKSIRUXBLHWTMCQGZNPYFVOE" "E" "S" "AJPCZWRLFBDKOTYUQGENHXMIVS"

rotor_03 :: Rotor   -- 'M'
rotor_03 = Rotor "BDFHJLCPRTXVZNYEIWGAKMUSQO" "V" "M" "TAGBPCSDQEUFVNZHYIXJWLRKOM"

rotor_04 :: Rotor   -- 'Q'
rotor_04 = Rotor "ESOVPZJAYQUIRHXLNFTGKDCMWB" "J" "Q" "HZWVARTNLGUPXQCEJMBSKDYOIF"

rotor_05 :: Rotor   -- 'K'
rotor_05 = Rotor "VZBRGITYUPSDNHLXAWMJQOFECK" "Z" "K" "QCYLXWENFTZOSMVJUDKGIARPHB"

rotor_06 :: Rotor   -- "WN"
rotor_06 = Rotor "JPGVOUMFYQBENHZRDKASXLICTW" "ZM" "WN" "SKXQLHCNWARVGMEBJPTYFDZUIO"

rotor_07 :: Rotor   -- "TB"
rotor_07 = Rotor "NZJHGRCXMYSWBOUFAIVLPEKQDT" "ZM" "TB" "QMGYVPEDRCWTIANUXFKZOSLHJB"

rotor_08 :: Rotor   -- "VP"
rotor_08 = Rotor "FKQHTLXOCBJSPDZRAMEWNIUYGV" "ZM" "VP" "QJINSAYDVKBFRUHMCPLEWZTGXO"

beta :: Rotor       -- ""
beta = Rotor "LEYJVCNIXWPBQMDRTAKZGFUHOS" "" "" "RLFOBVUXHDSANGYKMPZQWEJICT"

gamma :: Rotor      -- ""
gamma = Rotor "FSOKANUERHMBTIYCWLQPZXVGJD" "" "" "ELPZHAXJNYDRKFCTSIBMGWQVOU"

{-
 Definición del tipo de dato Reflector.
-}

data Reflector = Reflector String deriving Show

extractWiringRef :: Reflector -> String
extractWiringRef (Reflector s) = s

{-
 Ejemplos de Reflectores usados en los módelos conocidos de máquina Enigma.
-}

reflector_B :: Reflector
reflector_B = Reflector "YRUHQSLDPXNGOKMIEBFZCWVJAT"

reflector_C :: Reflector
reflector_C = Reflector "FVPJIAOYEDRZXWGCTKUQSBNMHL"

reflector_B_Thin :: Reflector
reflector_B_Thin = Reflector "ENKQAUYWJICOPBLMDXZVFTHRGS"

reflector_C_Thin :: Reflector
reflector_C_Thin = Reflector "RDOBJNTKVEHMLFCWZAXGYIPSUQ"

data RotorDay = RotorDay Rotor Char deriving Show

{-
 Comunicación del tipo de dato RotorDay con el exterior
-}

extractRotorFromRotorDay :: RotorDay -> Rotor
extractRotorFromRotorDay (RotorDay rotor character) = rotor

extractCharFromRotorDay :: RotorDay -> Char
extractCharFromRotorDay (RotorDay rotor character) = character


instance TypesWithNormalization (RotorDay) where
  norm (RotorDay (Rotor w n en iw) p) = RotorDay (Rotor w' n en iw') p
                       where
                         m   = findPosition p "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
                         w'  = rotateLev m w
                         iw' = rotateLev m iw   -- antes era iw' = rotateDes m iw

data RotorSet =  RotorSet Reflector RotorDay RotorDay RotorDay deriving Show

extractRefRotorSet :: RotorSet -> Reflector
extractRefRotorSet (RotorSet r rd3 rd2 rd1) = r

extractRd3RotorSet :: RotorSet -> RotorDay
extractRd3RotorSet (RotorSet r rd3 rd2 rd1) = rd3

extractRd2RotorSet :: RotorSet -> RotorDay
extractRd2RotorSet (RotorSet r rd3 rd2 rd1) = rd2

extractRd1RotorSet :: RotorSet -> RotorDay
extractRd1RotorSet (RotorSet r rd3 rd2 rd1) = rd1

{-
  la normalización de un "RotorSetup" es exactamente la normalización de cada
  rotor en el setup de rotores.
-}

instance TypesWithNormalization (RotorSet) where
  norm (RotorSet r r3 r2 r1) = RotorSet r (norm r3) (norm r2) (norm r1)

type Pb = Dictionary Char Char 


