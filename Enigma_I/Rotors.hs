

module Rotors (module Rotors) where

import Types

{- ROTORES USADOS EN LA ENIGMA I -}

rotor_01 :: Rotor
rotor_01 = Rotor ['A'..'Z'] "Q" (IntegerI 0) "EKMFLGDQVZNTOWYHXUSPAIBRCJ" "UWYGADFPVZBECKMTHXSLRINQOJ"

rotor_02 :: Rotor
rotor_02 = Rotor ['A'..'Z'] "E" (IntegerI 0) "AJDKSIRUXBLHWTMCQGZNPYFVOE" "AJPCZWRLFBDKOTYUQGENHXMIVS"

rotor_03 :: Rotor
rotor_03 = Rotor ['A'..'Z'] "V" (IntegerI 0) "BDFHJLCPRTXVZNYEIWGAKMUSQO" "TAGBPCSDQEUFVNZHYIXJWLRKOM"

rotor_04 :: Rotor
rotor_04 = Rotor ['A'..'Z'] "J" (IntegerI 0) "ESOVPZJAYQUIRHXLNFTGKDCMWB" "HZWVARTNLGUPXQCEJMBSKDYOIF"

rotor_05 :: Rotor
rotor_05 = Rotor ['A'..'Z'] "Z" (IntegerI 0) "VZBRGITYUPSDNHLXAWMJQOFECK" "QCYLXWENFTZOSMVJUDKGIARPHB"

{- REFLECTORES USADOS EN LA ENIGMA I -}

reflector_B :: Reflector
reflector_B = Reflector "YRUHQSLDPXNGOKMIEBFZCWVJAT"

reflector_C :: Reflector
reflector_C = Reflector "FVPJIAOYEDRZXWGCTKUQSBNMHL"

