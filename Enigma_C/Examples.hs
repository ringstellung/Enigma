module Examples (module Examples) where

import Dictionary
import Types


{-
 Ejemplos de RotorDay
-}

iii :: RotorDay
iii = RotorDay rotor_03 'X'

iii01 :: RotorDay
iii01 = RotorDay rotor_03 'V'

vi :: RotorDay
vi = RotorDay rotor_06 'M'

vi01 :: RotorDay
vi01 = RotorDay rotor_06 'Z'

vi02 :: RotorDay
vi02 = RotorDay rotor_06 'X'

{-
 Fin de ejemplos de RotorDay
-}

{-
 Ejemplos de RotorSet
-}

rotorSetupEnigmaco :: RotorSet
rotorSetupEnigmaco  = RotorSet reflector_B (RotorDay rotor_01 'H') (RotorDay rotor_02 'D') (RotorDay rotor_03 'X')

rotorSetup_26 :: RotorSet
rotorSetup_26 = RotorSet reflector_B (RotorDay rotor_04 'J') (RotorDay rotor_01 'Q') (RotorDay rotor_05 'A')

rotorSetup_p40_zbaqw :: RotorSet
rotorSetup_p40_zbaqw = RotorSet reflector_B (RotorDay rotor_01 'H') (RotorDay rotor_03 'J') (RotorDay rotor_05 'O')

rotorSetup_er :: RotorSet
rotorSetup_er = RotorSet reflector_B (RotorDay rotor_01 'E') (RotorDay rotor_02 'H') (RotorDay rotor_05 'Z')

rotorSetup_er_tbs :: RotorSet
rotorSetup_er_tbs = RotorSet reflector_B (RotorDay rotor_01 'T') (RotorDay rotor_02 'B') (RotorDay rotor_05 'S')

rotorSetup_er_tlu :: RotorSet
rotorSetup_er_tlu = RotorSet reflector_B (RotorDay rotor_01 'T') (RotorDay rotor_02 'L') (RotorDay rotor_05 'U')

rotorSetup_er_xwb :: RotorSet
rotorSetup_er_xwb = RotorSet reflector_B (RotorDay rotor_01 'X') (RotorDay rotor_02 'W') (RotorDay rotor_05 'B')

rotorSetup_rcr_wxc :: RotorSet
rotorSetup_rcr_wxc = RotorSet reflector_B (RotorDay rotor_02 'W') (RotorDay rotor_04 'X') (RotorDay rotor_05 'C')

rotorSetup_rcr_ldl :: RotorSet
rotorSetup_rcr_ldl = RotorSet reflector_B (RotorDay rotor_02 'L') (RotorDay rotor_04 'D') (RotorDay rotor_05 'L')

{-
 Fin de ejemplos de RotorSet
-}

pb_01101944 :: Pb
pb_01101944 =  listToDict ['A','L','B','W','M','U','F','P','T','O'] ['C','S','Q','N','Y','V','J','Z','R','K']

pb_26 :: Pb
pb_26 =  listToDict ['Y','G','O','W','F','S','L','R','M','B'] ['V','T','Q','N','I','K','D','P','Z','U']

pb_p40_zbaqw :: Pb
pb_p40_zbaqw =  listToDict ['A', 'B', 'C', 'D', 'G', 'J', 'M', 'N', 'O', 'S'] ['K', 'Z', 'E', 'X', 'L', 'Q', 'U', 'V', 'T', 'Y']

pb_er :: Pb
pb_er =  listToDict ['B', 'C', 'E', 'F', 'H', 'I', 'J', 'L', 'O', 'T'] ['G', 'D', 'R', 'V', 'N', 'U', 'K', 'M', 'P', 'Y']

pb_rcr :: Pb
pb_rcr =  listToDict ['A', 'B', 'C', 'D', 'F', 'H', 'I', 'K', 'O', 'R'] ['V', 'S', 'G', 'L', 'U', 'Z', 'N', 'M', 'W', 'X']

{-
  Ejemplos de texto
-}

--- https://enigma.hoerenberg.com/index.php?cat=Norrk%C3%B6ping%20messages&page=PAGE_40_ZBAQW
--- https://enigma.hoerenberg.com/index.php?cat=Welcome

cyphertext_p40_zbaqw = "OWTSBSTOLYMVABUFAAUWECRQYISIGZDZMCHECVVZGIZOYUJIDTFZUUOURDWVIMYOLXIOGNMKCYQQEYYTWITHHBYXAWAYXRTBUOOXXPNETERPZBI"

uncyphertext_p40_zbaqw_enigmaco = "PSKKRFJYBOFNTGXVPGCAYEGOGOZGTLMFIVWVKSTWXDQAQBROOZUFBAMPZIYFZBIMCFGTLMDGTFGXJRHGBUOZICBZLJYBQCVPEWKDQTJFKODHMYV"

uncyphertext_p40_zbaqw_nuestro =  "PSKKRFJYBOFNTGXVPGCAYEGOGOZGTLMFIVWVKSTWXDQAQBROOZUFBAMPZIYFZBIMCFGTLMDGTFGXJRHGBUOZICBZLJYBQCVPEWKDQTJFKODHMYV"

--- https://pypi.python.org/pypi/py-enigma/

uncyphertext_p40_zbaqw_pyenigma = "DGEZTTMTMSEBSYTKHJAMCTBNCKIAUQVASRJTRKOGDYNHCCDSTGHFKBIPHBXGMTMVMHSNJPVGYRUTUUQLDRWOEEPRMYYUWSMZKTFVMTEZXISONHE"

cyphertext_rcr = "EDPUDNRGYSZRCXNUYTPOMRMBOFKTBZREZKMLXLVEFGUEYSIOZVEQMIKUBPMMYLKLTTDEISMDICAGYKUACTCDOMOHWXMUUIAUBSTSLRNBZSZWNRFXWFYSSXJZVIJHIDISHPRKLKAYUPADTXQSPINQMATLPIFSVKDASCTACDPBOPVHJK"

uncyphertext_rcr_nuestro = "IXQJEIXNATGAYTPDOAFTUKCITDTMEHSRUFYGZSEPPCFHENBHFQMSQRYDKUEGFIZINCVZFEDVOTKEXHQXOLVIJTVKGBHDKMQAEMFGFUYRBCPKHEOCASMNYMIMNDLEMCVIPZBIVUUFPBSMNKTCVPGRJWDEYHQFCOIGPILNWQUMHCMPGA"

uncyphertext_rcr_enigmaco = "IXQJEIXNATGAYTPDOAFTUKCITDTMEHSRUFYGZSEPPCFHENBHFQMSQRYDKUEGFIZINCVZFEDVOTKEXHQXOLVIJTVKGBHDKMQAEMFGFUYRBCPKHEOCASMNYMIMNDLEMCVIPZBIVUUFPBSMNKTCVPGRJWDEYHQFCOIGPILNWQUMHCMPGA"
