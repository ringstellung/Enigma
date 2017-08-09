module EnigmaM3 (module EnigmaM3) where

--        módulos para el módulo de Types.hs
import Data.Maybe  -- para usar Maybe
import qualified Data.Map as Map
-- fin de módulos para el módulo de Types.hs

--        módulos para el módulo Auxiliars.hs
import Data.List   -- para usar elemIndex
-- fin de módulos para el módulo Auxiliars.hs

class TypesWithNormalization b where
 norm :: b -> b                       --normalización

type Alph = String

{-
 alphabet es el alfabeto grabado en los rotores
 de cualquier Enigma, en particular la Enigma I
-}

alphabet :: Alph 
alphabet = ['A'..'Z']

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
  El tipo que refleja el Ringstellung
-}

data Ringstellung = RS CharOrInt CharOrInt CharOrInt deriving Show

extractRS :: Ringstellung -> Int -> Int
extractRS (RS coi3 coi2 coi1) 1 = extractCI coi1
extractRS (RS coi3 coi2 coi1) 2 = extractCI coi2
extractRS (RS coi3 coi2 coi1) 3 = extractCI coi3

{-
  El tipo que refleja el Grundstellung
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
reflejamos lo hacemos según el alfabeto enumerado desde 0.  -}

setRSRotor :: Rotor -> CharOrInt -> Rotor
setRSRotor (Rotor rr nt r w iw) (IntegerI n) = Rotor (rotateLev m rr) nt (IntegerI (n-1)) w iw
           where
                m = extractCI (IntegerI n)
setRSRotor r (CharacterI c) = setRSRotor r coi
           where
                coi = IntegerI (1 + extractCI (CharacterI c))
{-
                 Ejemplos de rotores. Son los usados en las máquinas conocidas.
-}

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

removeWhiteAux :: String -> String -> String
removeWhiteAux "" strng = strng
removeWhiteAux (c:cs) strng
               | c == ' '  = removeWhiteAux cs strng
               | otherwise = removeWhiteAux cs (c:strng)
               
removeWhite :: String -> String
removeWhite cs = reverse(removeWhiteAux cs "")

{-
 "createPbSet strng" crea un diccionario a partir de una lista de caracteres
 del alfabeto. En virtud del diseño de "createPbSetAux" sólo aprovecha los
 20 primeros caracteres de strng. 
 
-}

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


{-             FUNCIONES DE MANEJO DEL ALFABETO                           -}

{-
 No usaremos el alfabeto en su posición dentro del listado UTF-8, por
 si esto cambiara o por si decidiéramos aumentar experimentalmente
 nuestro alfabeto. Ahora implementamos una serie de funciones para
 traducir caractéres en números y viceversa.
-}

charToIndex :: Char -> Alph -> Int
charToIndex x strn = fromJust $ elemIndex x strn

charToIndexA :: Char -> Int
charToIndexA = \x -> charToIndex x alphabet

indexToCharAux :: Int -> Alph -> Maybe Char
indexToCharAux n strn
  | n < 0 || n >= length strn = Nothing
  | otherwise                 = Just (strn !! n)

indexToChar :: Int -> Alph -> Char
indexToChar n strn = fromJust $ indexToCharAux n strn

indexToCharA :: Int -> Char
indexToCharA = \n -> indexToChar n alphabet

-- Residuales, no se usan

selectChar :: Int -> Char
selectChar (n) = "ABCDEFGHIJKLMNOPQRSTUVWXYZ" !! (n-1)

{-
 la función "findPosition a" busca el índice de la lista al que
 está asociada la entrada a.
-}

findPosition :: Eq a => a -> [a] -> Int
findPosition a = (\(Just i) -> i) . findIndex (== a)

-- fin residuales no se usan---

                             {- FIN DE FUNCIONES DE MANEJO DEL ALFABETO    -}


{-                               FUNCIÓN DE DESPLAZAMIENTO EN EL ALFABETO     -}

nextInAlphabet :: Char -> Char 
nextInAlphabet c = indexToCharA(((charToIndexA(c)+1) `mod` 26))

{-
                                 FUNCIONES DE ROTACIÓN
-}

rotateLevAux :: String -> [String]
rotateLevAux xs = take len $ map (take len) $ tails $ cycle xs
  where
    len = length xs

--- rotateLev gira n posiciones en sentido levógiro el string xs
rotateLev :: Int ->  String -> String
rotateLev n xs = (rotateLevAux xs) !! n

-- gira una posición en el sentido levógiro el string xs
rotateLevOne :: String -> String
rotateLevOne xs = rotateLev 1 xs


{-
 rotateDes gira un número entero de posiciones un string en sentido
 destrógiro
-}

rotateDes :: Int -> String -> String
rotateDes 0 xs = xs
rotateDes n xs = rotateDes (n-1) (last xs : init xs)

-- gira el rotor una posición en el sentido destrógiro
rotateDesOne :: String -> String
rotateDesOne xs = rotateDes 1 xs

{-
                                 FIN DE FUNCIONES DE ROTACIÓN
-}

                                {- FUNCIONES EXPERIMENTALES DE VIAJE D/I -}
{-
 "td rgs c" calcula por qué posición absoluta (letra del alfabeto) sale la 
 señal que entra en el rotor por la posición absoluta del carácter "c" y en
 el sentido directo. Es una función de prueba, no se usa en el proyecto final.
-}

td :: RotorGS -> Char -> Char
td rgs c = alphabet !! (((charToIndexA (wiring !! (charToIndexA c))) - gs+rs) `mod` 26)
  where
        walze  = extractRotorFromRotorGS rgs
        wiring = extractWiring walze
        rs     = 1 + extractRSW walze
        gs     = charToIndexA (extractCharFromRotorGS rgs)

{-
 "ti rgs c" calcula por qué posición absoluta (letra del alfabeto) sale la 
 señal que entra en el rotor por la posición absoluta del carácter "c" y en
 el sentido inverso. Es una función de prueba, no se usa en el proyecto final.
-}

ti :: RotorGS -> Char -> Char
ti rgs c = alphabet !! (((charToIndexA (iwiring !! (charToIndexA c))) - gs+rs) `mod` 26)
  where
        walze  = extractRotorFromRotorGS rgs
        iwiring = extractIWiring walze
        rs     = 1 + extractRSW walze
        gs     = charToIndexA (extractCharFromRotorGS rgs)


{-
 En el código de t, wiring debe ser entendido como un cableado (el directo o el inverso)
 de un rotor. El parámetro rs es la parte del Ringstellung que atañe al rotor y gs
 es la parte del Grunstellung para ese rotor, convertido en entero. Es decir:

 where
        walze  = extractRotorFromRotorGS rgs
        wiring = extractWiring walze
        rs     = 1 + extractRSW walze
        gs     = charToIndexA (extractCharFromRotorGS rgs) 
-}

t :: (String,Int,Int) -> Char -> Char
t (wiring,rs,gs) c = alphabet !! (((charToIndexA (wiring !! (charToIndexA c))) - gs+rs) `mod` 26)

                           {-FIN DE FUNCIONES EXPERIMENTALES-}

{-
                                     CIFRADO
-}

isInPositionToCJump :: RotorGS -> Bool
isInPositionToCJump (RotorGS r c) = c  `elem` (extractNotch r)

rotateRotorOne :: RotorGS -> RotorGS
rotateRotorOne (RotorGS (Rotor rr n r w iw) c) = RotorGS (Rotor (rotateLevOne rr) n r (rotateLevOne w) (rotateLevOne iw)) d
                where
                  d = nextInAlphabet c

{-
  stepForward ordena el avance de un set de rotores para proceder al cifrado de
  un caracter entrante.
-}

stepForward :: RotorSet -> RotorSet
stepForward (RotorSet r r3 r2 r1)
  | (not i) && (not ii)   = RotorSet r r3 r2 (rotateRotorOne r1)
  | (not i) && ii         = RotorSet r (rotateRotorOne r3) (rotateRotorOne r2) (rotateRotorOne r1)
  |      i  && (not ii)   = RotorSet r r3 (rotateRotorOne r2) (rotateRotorOne r1)
  |      i  && ii         = RotorSet r (rotateRotorOne r3) (rotateRotorOne r2) (rotateRotorOne r1)
           where
             i   = isInPositionToCJump r1
             ii  = isInPositionToCJump r2

{-
                             FUNCIONES PARA EL CIFRADO CON PLUGBOARD

-}

processAChar :: Pb -> RotorSet -> Char -> Char
processAChar pb rs c = equivalentChar (foldr t m [(iw1,rs1,gs1),(iw2,rs2,gs2),(iw3,rs3,gs3),(r,0,0),(w3,rs3,gs3),(w2,rs2,gs2),(w1,rs1,gs1)]) pb
  where
    m   = equivalentChar c pb
    w1  = extractWiring.extractRotorFromRotorGS.extractRGS1RotorSet $ rs
    a1  = extractRSW.extractRotorFromRotorGS.extractRGS1RotorSet $ rs
    rs1 = 1 + a1
    gs1 = charToIndexA.extractCharFromRotorGS.extractRGS1RotorSet $ rs
    w2  = extractWiring.extractRotorFromRotorGS.extractRGS2RotorSet $ rs
    a2  = extractRSW.extractRotorFromRotorGS.extractRGS2RotorSet $ rs
    rs2 = 1 + a2
    gs2 = charToIndexA.extractCharFromRotorGS.extractRGS2RotorSet $ rs    
    w3  = extractWiring.extractRotorFromRotorGS.extractRGS3RotorSet $ rs
    a3  = extractRSW.extractRotorFromRotorGS.extractRGS3RotorSet $ rs
    rs3 = 1 + a3
    gs3 = charToIndexA.extractCharFromRotorGS.extractRGS3RotorSet $ rs    
    r   = extractWiringRef.extractRefRotorSet $ rs
    iw3 = extractIWiring.extractRotorFromRotorGS.extractRGS3RotorSet $ rs
    iw2 = extractIWiring.extractRotorFromRotorGS.extractRGS2RotorSet $ rs
    iw1 = extractIWiring.extractRotorFromRotorGS.extractRGS1RotorSet $ rs

encodeTextEnigmaM3 :: RotorSet -> Pb -> String -> String
encodeTextEnigmaM3 rs pb str = zipWith (processAChar pb) (iterate stepForward nrsSf) str
                    where
                      nrsSf   = stepForward.norm $ rs
