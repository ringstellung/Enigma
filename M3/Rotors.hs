module Rotors (module Rotors) where

--import Dictionary
import Types

{- ROTORES USADOS EN LAS MÁQUINAS CONOCIDAS -}

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

rotor_06 :: Rotor
rotor_06 = Rotor ['A'..'Z'] "ZM" (IntegerI 0) "JPGVOUMFYQBENHZRDKASXLICTW" "SKXQLHCNWARVGMEBJPTYFDZUIO"

rotor_07 :: Rotor
rotor_07 = Rotor ['A'..'Z'] "ZM" (IntegerI 0) "NZJHGRCXMYSWBOUFAIVLPEKQDT" "QMGYVPEDRCWTIANUXFKZOSLHJB"

rotor_08 :: Rotor
rotor_08 = Rotor ['A'..'Z'] "ZM" (IntegerI 0) "FKQHTLXOCBJSPDZRAMEWNIUYGV" "QJINSAYDVKBFRUHMCPLEWZTGXO"

beta :: Rotor
beta = Rotor ['A'..'Z'] "" (IntegerI 0) "LEYJVCNIXWPBQMDRTAKZGFUHOS" "RLFOBVUXHDSANGYKMPZQWEJICT"

gamma :: Rotor
gamma = Rotor ['A'..'Z'] "" (IntegerI 0) "FSOKANUERHMBTIYCWLQPZXVGJD" "ELPZHAXJNYDRKFCTSIBMGWQVOU"


{- REFLECTORES USADOS EN LAS MÁQUINAS CONOCIDAS -}

reflector_B :: Reflector
reflector_B = Reflector "YRUHQSLDPXNGOKMIEBFZCWVJAT"

reflector_C :: Reflector
reflector_C = Reflector "FVPJIAOYEDRZXWGCTKUQSBNMHL"

reflector_B_Thin :: Reflector
reflector_B_Thin = Reflector "ENKQAUYWJICOPBLMDXZVFTHRGS"

reflector_C_Thin :: Reflector
reflector_C_Thin = Reflector "RDOBJNTKVEHMLFCWZAXGYIPSUQ"

