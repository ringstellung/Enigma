-- La Enigma comercial, modelos D (1926) y K (1927): tres rotores, disco de
-- entrada en orden QWERTZ, reflector que se ajusta a mano en 26 posiciones y
-- que no se mueve al cifrar, y sin clavijero.
--
-- Las dos comparten el cableado. Se diferencian en la muesca:
--   * en la K va unida al anillo de letras, y cada rotor salta al pasar
--     de una letra fija de la ventana: Y, E y N;
--   * en la D va unida al cuerpo del rotor, de modo que la letra de la
--     ventana a la que salta es la anterior a la del anillo, en los tres.
module EnigmaComercial
  ( module EnigmaComercial
  , rotor_K1, rotor_K2, rotor_K3
  , reflector_K
  , CharOrInt (..)
  , Rotor
  , Reflector
  , posiciones
  ) where

import EnigmaNucleo
import Rotors

data Modelo = EnigmaD | EnigmaK deriving (Show, Eq)

data Ringstellung  = RS CharOrInt CharOrInt CharOrInt deriving Show
data Grundstellung = GS Char Char Char deriving Show
data Walzenlage    = W Rotor Rotor Rotor deriving Show

type RotorSet = Montaje

-- La última letra es la posición del reflector.
rotorSetup :: Modelo -> Walzenlage -> Ringstellung -> Grundstellung -> Char -> RotorSet
rotorSetup m (W r3 r2 r1) (RS a3 a2 a1) (GS c3 c2 c1) p =
  montarCon etw_QWERTZ (girarReflector p reflector_K)
    [(ajusta r3 a3, a3, c3), (ajusta r2 a2, a2, c2), (ajusta r1 a1, a1, c1)]
  where
    ajusta r a = case m of
      EnigmaK -> r
      EnigmaD -> conMuescas [anterior a] r

anterior :: CharOrInt -> Char
anterior a = toEnum (65 + (indiceAnillo a + 25) `mod` 26)

resetGrundstellung :: RotorSet -> Grundstellung -> RotorSet
resetGrundstellung rs (GS c3 c2 c1) = reposicionar rs [c3, c2, c1]

encodeTextEnigmaComercial :: RotorSet -> String -> String
encodeTextEnigmaComercial rs = cifrar rs sinClavijero
