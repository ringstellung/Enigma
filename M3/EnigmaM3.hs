-- La Enigma M3: tres rotores móviles.
module EnigmaM3
  ( module EnigmaM3
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

data Ringstellung  = RS CharOrInt CharOrInt CharOrInt deriving Show
data Grundstellung = GS Char Char Char deriving Show
data Walzenlage    = W Rotor Rotor Rotor deriving Show

type RotorSet = Montaje

rotorSetup :: Walzenlage -> Ringstellung -> Grundstellung -> Reflector -> RotorSet
rotorSetup (W r3 r2 r1) (RS a3 a2 a1) (GS c3 c2 c1) u =
  montar u [(r3, a3, c3), (r2, a2, c2), (r1, a1, c1)]

resetGrundstellung :: RotorSet -> Grundstellung -> RotorSet
resetGrundstellung rs (GS c3 c2 c1) = reposicionar rs [c3, c2, c1]

encodeTextEnigmaM3 :: RotorSet -> Pb -> String -> String
encodeTextEnigmaM3 = cifrar
