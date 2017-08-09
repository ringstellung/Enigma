module Types (module Types) where

import Data.Maybe
import qualified Data.Map as Map
import Auxiliars

class TypesWithNormalization b where
 norm :: b -> b                       --normalización

data CharOrInt =  CharacterI Char | IntegerI Int deriving Show 

{-
 Extraer un dato del tipo CharOrInt es convertir a entero su número o su carácter.
 Preferimos esto porque al final se tratará de rotar una lista y así ya tenemos el
 número de posiciones a rotar. Nótese que habremos dado números del 1 al 26, que
 han de ser convertidos a un número del 0 al 25.
-}

extractCI :: CharOrInt -> Int
extractCI (IntegerI n)    = n - 1
extractCI (CharacterI c)  = charToIndex c alphabet 

{-
  El tipo que simula el Ringstellung
-}

data Ringstellung = RS CharOrInt CharOrInt CharOrInt deriving Show

extractRS :: Ringstellung -> Int -> Int
extractRS (RS coi3 coi2 coi1) 1 = extractCI coi1
extractRS (RS coi3 coi2 coi1) 2 = extractCI coi2
extractRS (RS coi3 coi2 coi1) 3 = extractCI coi3

{-
  El tipo que simula el Grundstellung
-}

data Grundstellung = GS Char Char Char deriving Show

extractGS :: Grundstellung -> Int -> Char
extractGS (GS c3 c2 c1) 1 = c1
extractGS (GS c3 c2 c1) 2 = c2
extractGS (GS c3 c2 c1) 3 = c3


{-
 En "Rotor", el sentido del:
  -) primer string es la carcasa del rotor; será desplazada al hacer el
     Ringstellung.
  -) segundo string situa las muescas visible del rotor, lo llamamos "notch"
  -) el entero es su situación según un Ringstellung, por defecto es cero por 'A'
  -) tercer string es la permutación directa, la llamamos "wiring"
  -) cuarto string es la permutación inversa

-}

data Rotor = Rotor String String CharOrInt String String deriving Show

{-
 Funciones de despiece de un Rotor para poder operar con él.
-}

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

{-
                                  INVERTIR UN ROTOR
-}

reverseWiring :: Rotor -> String
reverseWiring r = [alphabet !! (charToIndex a w) | a <- alphabet] 
              where w = extractWiring r

{-
                ALTERAR UN ROTOR SEGÚN LO CORRESPONDIENTE DEL RINGSTELLUNG
-}

{- "setRSRotor" (colocar el Ringstellung en el rotor) altera un rotor
con la parte del Ringstellung que le correponde a dicho rotor. ¡Mucho
ojo! el dato del Ringstellung tiene que ser dado sobre el alfabeto
enumerado desde 1 y ello para hacer cómoda la entrada según datos
originales; pero cuando dejamos constancia del ajuste en el rotor,
lo hacemos según el alfabeto enumerado desde 0.  -}

setRSRotor :: Rotor -> CharOrInt -> Rotor
setRSRotor (Rotor rr nt r w iw) (IntegerI n) = Rotor (rotateLev m rr) nt (IntegerI (n-1)) w iw
           where
                m = extractCI (IntegerI n)
setRSRotor r (CharacterI c) = setRSRotor r coi
           where
                coi = IntegerI (1 + extractCI (CharacterI c))

{-
 Definición del tipo de dato Reflector.
-}

data Reflector = Reflector String deriving Show

extractWiringRef :: Reflector -> String
extractWiringRef (Reflector s) = s

{-
 La elección de tres rotores, en bruto, es el Walzenlage. Este objeto será la base
 para la configuración: aplicándole el Ringstellung y seguidamente el Grundstellung
-}

data Walzenlage = W Rotor Rotor Rotor deriving Show

{- setRSW (colocar un Ringstellung en un Walzenlage) coloca un
Ringstellung en un Walzenlagen. ¡OJO! No olvidar reimplementar esto
con un zipWith hecho al efecto.-}

setRSW :: Walzenlage -> Ringstellung -> Walzenlage
setRSW (W r3 r2 r1) (RS coi3 coi2 coi1) = W w3 w2 w1 
       where
        w3 = setRSRotor r3 coi3
        w2 = setRSRotor r2 coi2
        w1 = setRSRotor r1 coi1

{- RotorGS por RotorGrundstellung: indica la posición básica del rotor
NO OLVIDAR que Rotor debe estar posicionado según el Ringstellung, es
decir el primer string podría aparecer desplazado, antes de construir el
RotorGS que sea -}

data RotorGS = RotorGS Rotor Char deriving Show

{-
 Comunicación del tipo de dato RotorGS con el exterior
-}

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

data RotorSet =  RotorSet Reflector RotorGS RotorGS RotorGS deriving Show

extractRefRotorSet :: RotorSet -> Reflector
extractRefRotorSet (RotorSet r rd3 rd2 rd1) = r

extractRGS3RotorSet :: RotorSet -> RotorGS
extractRGS3RotorSet (RotorSet r rd3 rd2 rd1) = rd3

extractRGS2RotorSet :: RotorSet -> RotorGS
extractRGS2RotorSet (RotorSet r rd3 rd2 rd1) = rd2

extractRGS1RotorSet :: RotorSet -> RotorGS
extractRGS1RotorSet (RotorSet r rd3 rd2 rd1) = rd1

{-
  la normalización de un "RotorSetup" es exactamente la normalización de cada
  rotor en el setup de rotores.
-}

instance TypesWithNormalization (RotorSet) where
  norm (RotorSet r r3 r2 r1) = RotorSet r (norm r3) (norm r2) (norm r1)

rotorSetup :: Walzenlage -> Ringstellung ->  Grundstellung -> Reflector -> RotorSet
rotorSetup w rs (GS c3 c2 c1) r = norm(RotorSet r rgs3 rgs2 rgs1)  
           where
             W w3 w2 w1 = setRSW w rs
             rgs3 = RotorGS w3 c3
             rgs2 = RotorGS w2 c2
             rgs1 = RotorGS w1 c1

resetGrundstellung :: RotorSet ->  Grundstellung -> RotorSet
resetGrundstellung (RotorSet r r3 r2 r1) (GS c3 c2 c1) = norm(RotorSet r rgs3 rgs2 rgs1)
     where
       rgs1 = RotorGS (extractRotorFromRotorGS r1) c1
       rgs2 = RotorGS (extractRotorFromRotorGS r2) c2
       rgs3 = RotorGS (extractRotorFromRotorGS r3) c3

type Pb = Map.Map Char Char

createPbSetAux :: Int -> String -> Pb
createPbSetAux 0 _  = Map.empty
createPbSetAux _ strng | length strng < 2 = Map.empty
createPbSetAux n (f:s:cs) = Map.insert f s (createPbSetAux (n-1) cs)  

createPbSet :: String -> Pb
createPbSet strng = createPbSetAux 10 cs
            where
             cs = removeWhite(strng)
{-
   invertBijection invierte un diccionario. Construye lo esperado si bajo el 
   diccionario subyace una inyección; si subyace una no-inyección, al invertir
   los valores y asociarle las claves a al valor que se repetía le asocia la 
   primera clave que lo indexaba e ignora la inversión de las posterires.
   *Dict> let pb = createPbSet "AV BS CG DL FU HZ IN KM OW RX"
   *Dict> let pb1 = createPbSet "AV BV CG DL FU HZ IN KM OW RX"
   *Dict> invertBijection pb
   fromList [('G','C'),('L','D'),('M','K'),('N','I'),('S','B'),('U','F'),('V','A'),('W','O'),('X','R'),('Z','H')]
   *Dict> invertBijection pb1
   fromList [('G','C'),('L','D'),('M','K'),('N','I'),('U','F'),('V','A'),('W','O'),('X','R'),('Z','H')]
   *Dict> 
   Como vemos el resultado de "invertBijection pb1" contempla ('V','A') y no ('V','B')
   Por suerte, en nuestra aplicación a la máquina Enigma sólo aparecen biyecciones y 
   funcionará bien.
-}

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
