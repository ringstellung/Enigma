module Rotors (module Rotors) where

import EnigmaNucleo

{- ROTORES USADOS EN LAS MÁQUINAS CONOCIDAS -}

rotor_01, rotor_02, rotor_03, rotor_04, rotor_05, rotor_06, rotor_07, rotor_08 :: Rotor
rotor_01 = hacerRotor "EKMFLGDQVZNTOWYHXUSPAIBRCJ" "Q"
rotor_02 = hacerRotor "AJDKSIRUXBLHWTMCQGZNPYFVOE" "E"
rotor_03 = hacerRotor "BDFHJLCPRTXVZNYEIWGAKMUSQO" "V"
rotor_04 = hacerRotor "ESOVPZJAYQUIRHXLNFTGKDCMWB" "J"
rotor_05 = hacerRotor "VZBRGITYUPSDNHLXAWMJQOFECK" "Z"
rotor_06 = hacerRotor "JPGVOUMFYQBENHZRDKASXLICTW" "ZM"
rotor_07 = hacerRotor "NZJHGRCXMYSWBOUFAIVLPEKQDT" "ZM"
rotor_08 = hacerRotor "FKQHTLXOCBJSPDZRAMEWNIUYGV" "ZM"

beta, gamma :: Rotor
beta  = hacerRotor "LEYJVCNIXWPBQMDRTAKZGFUHOS" ""
gamma = hacerRotor "FSOKANUERHMBTIYCWLQPZXVGJD" ""

{- REFLECTORES USADOS EN LAS MÁQUINAS CONOCIDAS -}

reflector_A, reflector_B, reflector_C, reflector_B_Thin, reflector_C_Thin :: Reflector
reflector_A      = hacerReflector "EJMZALYXVBWFCRQUONTSPIKHGD"
reflector_B      = hacerReflector "YRUHQSLDPXNGOKMIEBFZCWVJAT"
reflector_C      = hacerReflector "FVPJIAOYEDRZXWGCTKUQSBNMHL"
reflector_B_Thin = hacerReflector "ENKQAUYWJICOPBLMDXZVFTHRGS"
reflector_C_Thin = hacerReflector "RDOBJNTKVEHMLFCWZAXGYIPSUQ"

-- La máquina comercial: Crypto Museum, «Enigma wiring». Las muescas son las
-- de la K; en la D dependen del anillo (véase EnigmaComercial).
etw_QWERTZ :: Entrada
etw_QWERTZ = hacerEntrada "QWERTZUIOASDFGHJKPYXCVBNML"

rotor_K1, rotor_K2, rotor_K3 :: Rotor
rotor_K1 = hacerRotor "LPGSZMHAEOQKVXRFYBUTNICJDW" "Y"
rotor_K2 = hacerRotor "SLVGBTFXJQOHEWIRZYAMKPCNDU" "E"
rotor_K3 = hacerRotor "CJGDPSHKTURAWZXFMYNQOBVLIE" "N"

reflector_K :: Reflector
reflector_K = hacerReflector "IMETCGFRAYSQBZXWLHKDVUPOJN"
