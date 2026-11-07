-- La Enigma I del Ejército y la Aviación: tres rotores móviles elegidos entre
-- los cinco primeros (I a V) y los reflectores A, B y C.
module EnigmaI
  ( module EnigmaI
  , rotor_01, rotor_02, rotor_03, rotor_04, rotor_05
  , reflector_A, reflector_B, reflector_C
  , CharOrInt (..)
  , Rotor
  , Reflector
  , Pb
  , createPbSet
  , crearPb
  , posiciones
  ) where

import EnigmaNucleo
import Rotors

data Ringstellung  = RS CharOrInt CharOrInt CharOrInt deriving Show
data Grundstellung = GS Char Char Char deriving Show
data Walzenlage    = W Rotor Rotor Rotor deriving Show

type RotorSet = Montaje

rotorSetup :: Walzenlage -> Ringstellung -> Grundstellung -> Reflector -> RotorSet
rotorSetup (W r3 r2 r1) (RS a3 a2 a1) (GS c3 c2 c1) u =
  montar u [(r3, a3, c3), (r2, a2, c2), (r1, a1, c1)]

resetGrundstellung :: RotorSet -> Grundstellung -> RotorSet
resetGrundstellung rs (GS c3 c2 c1) = reposicionar rs [c3, c2, c1]

encodeTextEnigmaI :: RotorSet -> Pb -> String -> String
encodeTextEnigmaI = cifrar
