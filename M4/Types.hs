module Types (module Types) where

import qualified Data.Map as Map
import Data.Maybe
import Auxiliars

class TypesWithNormalization b where
    norm :: b -> b        --normalization

data CharOrInt =  CharacterI Char | IntegerI Int deriving Show

extractCI :: CharOrInt -> Int
extractCI (IntegerI n)    = n - 1
extractCI (CharacterI c)  = charToIndex c alphabet

data Ringstellung = RS CharOrInt CharOrInt CharOrInt CharOrInt deriving Show

extractRS :: Ringstellung -> Int -> Int
extractRS (RS coi4 coi3 coi2 coi1) 1 = extractCI coi1
extractRS (RS coi4 coi3 coi2 coi1) 2 = extractCI coi2
extractRS (RS coi4 coi3 coi2 coi1) 3 = extractCI coi3
extractRS (RS coi4 coi3 coi2 coi1) 4 = extractCI coi4

data Grundstellung = GS Char Char Char Char deriving Show

extractGS :: Grundstellung -> Int -> Char
extractGS (GS c4 c3 c2 c1) 1 = c1
extractGS (GS c4 c3 c2 c1) 2 = c2
extractGS (GS c4 c3 c2 c1) 3 = c3
extractGS (GS c4 c3 c2 c1) 4 = c4

data Rotor = Rotor String String CharOrInt String String deriving Show

extractRotR :: Rotor -> String
extractRotR (Rotor rotRing notch ringstellung wiring iwiring) = rotRing

extractNotch :: Rotor -> String
extractNotch (Rotor rotRing notch ringstellung wiring iwiring) = notch

extractRSW :: Rotor -> Int
extractRSW (Rotor rotRing notch ringstellung wiring iwiring) = extractCI ringstellung

extractWiring :: Rotor -> String
extractWiring (Rotor rotRing notch ringstellung wiring iwiring) = wiring

extractIWiring :: Rotor -> String
extractIWiring (Rotor rotRing notch ringstellung wiring iwiring) = iwiring

reverseWiring :: Rotor -> String
reverseWiring r = [alphabet !! (charToIndex a w) | a <- alphabet] 
    where w = extractWiring r

setRSRotor :: Rotor -> CharOrInt -> Rotor
setRSRotor (Rotor rr nt r w iw) (IntegerI n) = Rotor (rotateLev m rr) nt (IntegerI (n-1)) w iw
    where
        m = extractCI (IntegerI n)
setRSRotor r (CharacterI c) = setRSRotor r coi
    where
        coi = IntegerI (1 + extractCI (CharacterI c))

data Reflector = Reflector String deriving Show

extractWiringRef :: Reflector -> String
extractWiringRef (Reflector s) = s

data Walzenlage = W Rotor Rotor Rotor Rotor deriving Show

setRSW :: Walzenlage -> Ringstellung -> Walzenlage
setRSW (W r4 r3 r2 r1) (RS coi4 coi3 coi2 coi1) = W w4 w3 w2 w1 
    where
        w4 = setRSRotor r4 coi4
        w3 = setRSRotor r3 coi3
        w2 = setRSRotor r2 coi2
        w1 = setRSRotor r1 coi1

data RotorGS = RotorGS Rotor Char deriving Show

extractRotorFromRotorGS :: RotorGS -> Rotor
extractRotorFromRotorGS (RotorGS rotor character) = rotor

extractCharFromRotorGS :: RotorGS -> Char
extractCharFromRotorGS (RotorGS rotor character) = character

instance TypesWithNormalization (RotorGS) where
 norm (RotorGS (Rotor rr n r w iw) c) = RotorGS (Rotor rr' n r w' iw') c
                   where
                     m   = charToIndex c rr
                     rr' = rotateLev m rr
                     w'  = rotateLev m w
                     iw' = rotateLev m iw

data RotorSet =  RotorSet Reflector RotorGS RotorGS RotorGS RotorGS deriving Show

extractRefRotorSet :: RotorSet -> Reflector
extractRefRotorSet (RotorSet r rd4 rd3 rd2 rd1) = r

extractRGS4RotorSet :: RotorSet -> RotorGS
extractRGS4RotorSet (RotorSet r rd4 rd3 rd2 rd1) = rd4

extractRGS3RotorSet :: RotorSet -> RotorGS
extractRGS3RotorSet (RotorSet r rd4 rd3 rd2 rd1) = rd3

extractRGS2RotorSet :: RotorSet -> RotorGS
extractRGS2RotorSet (RotorSet r rd4 rd3 rd2 rd1) = rd2

extractRGS1RotorSet :: RotorSet -> RotorGS
extractRGS1RotorSet (RotorSet r rd4 rd3 rd2 rd1) = rd1

instance TypesWithNormalization (RotorSet) where
 norm (RotorSet r r4 r3 r2 r1) = RotorSet r (norm r4) (norm r3) (norm r2) (norm r1)

rotorSetup :: Walzenlage -> Ringstellung ->  Grundstellung -> Reflector -> RotorSet
rotorSetup w rs (GS c4 c3 c2 c1) r = norm(RotorSet r rgs4 rgs3 rgs2 rgs1)
       where
         W w4 w3 w2 w1 = setRSW w rs
         rgs4 = RotorGS w4 c4
         rgs3 = RotorGS w3 c3
         rgs2 = RotorGS w2 c2
         rgs1 = RotorGS w1 c1

resetGrundstellung :: RotorSet ->  Grundstellung -> RotorSet
resetGrundstellung (RotorSet r r4 r3 r2 r1) (GS c4 c3 c2 c1) = norm(RotorSet r rgs4 rgs3 rgs2 rgs1)
    where
        rgs1 = RotorGS (extractRotorFromRotorGS r1) c1
        rgs2 = RotorGS (extractRotorFromRotorGS r2) c2
        rgs3 = RotorGS (extractRotorFromRotorGS r3) c3
        rgs4 = RotorGS (extractRotorFromRotorGS r4) c4

type Pb = Map.Map Char Char

createPbSetAux :: Int -> String -> Pb
createPbSetAux 0 _  = Map.empty
createPbSetAux _ strng | length strng < 2 = Map.empty
createPbSetAux n (f:s:cs) = Map.insert f s (createPbSetAux (n-1) cs)  

createPbSet :: String -> Pb
createPbSet strng = createPbSetAux 10 cs
            where
             cs = removeWhite(strng)

invertBijection :: (Ord k, Ord v) => Map.Map k v -> Map.Map v k
invertBijection = Map.foldrWithKey (flip Map.insert) Map.empty

equivalentChar :: Char -> Pb -> Char
equivalentChar c pb
    | isinkey   =  pb Map.! c
    | isinvalue = ipb Map.! c
    | otherwise = c
        where
            isinkey = Map.member c pb
            isinvalue = Map.member c ipb
            ipb = invertBijection pb