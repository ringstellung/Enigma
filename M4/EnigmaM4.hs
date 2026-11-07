-- La Enigma M4: tres rotores móviles y un griego fijo a su izquierda.
module EnigmaM4
  ( module EnigmaM4
  , module Rotors
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

data Ringstellung  = RS CharOrInt CharOrInt CharOrInt CharOrInt deriving Show
data Grundstellung = GS Char Char Char Char deriving Show
data Walzenlage    = W Rotor Rotor Rotor Rotor deriving Show

type RotorSet = Montaje

rotorSetup :: Walzenlage -> Ringstellung -> Grundstellung -> Reflector -> RotorSet
rotorSetup (W r4 r3 r2 r1) (RS a4 a3 a2 a1) (GS c4 c3 c2 c1) u =
  montar u [(r4, a4, c4), (r3, a3, c3), (r2, a2, c2), (r1, a1, c1)]

resetGrundstellung :: RotorSet -> Grundstellung -> RotorSet
resetGrundstellung rs (GS c4 c3 c2 c1) = reposicionar rs [c4, c3, c2, c1]

encodeTextEnigmaM4 :: RotorSet -> Pb -> String -> String
encodeTextEnigmaM4 = cifrar
