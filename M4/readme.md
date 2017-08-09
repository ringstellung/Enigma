<meta http-equiv='Content-Type' content='text/html; charset=utf-8' />

# Uso de la M4 

## Glosario Básico (parcial)

1. Buchstabenkenngruppe: grupo de letras para la identificación de la
   clave al principio del mensaje, construido sobre el Kenngruppen.

1. Kenngruppen: agrupaciones de letras para que el receptor pueda
   identificar la clave.

1. Kriegmarine: marina de guerra

1. Grundstellung: posición básica de los rotores al inicio de la
   operación de cifrado. Se obtenía girando cada rotor sobre su eje
   una vez colocados los rotores en sus posiciones dentro de la
   máquina. Se podía hacer viendo a través de una ventanita para cada
   rotor.

1. Luftwaffe: ejército del aire

1. Ringstellung: configuración del rotor antes de insertarlo en la
   máquina

1. Schreibmax: pequeña impresora que en la M4 podía sustituir al panel
   de lámparas y que hacía innecesaria la colaboración de un segundo
   operario por imprimir las letras que iban a ser iluminadas.

1. Spruchschlüssel: clave aleatoria elegida libremente por el operador
   para cifrar el mensaje.
   
1. Steckerverbindungen: conexiones mediante clavijas en el zócalo de
   clavijas.

1. Steckerbrett: tablero frontal de clavijas, "plugboard" en inglés y
   nosotros lo hemos traducido por "tablero de clavijas" o "zócalo de
   clavijas"

1. Uhr: reloj

1. Umkehrwalze, abreviado UKW: reflector

1. Walzen: Rotor

1. Walzenlage: elección y ordenación de los rotores

1. Wehrmacht: fuerzas armadas, reune a la Heer (ejército) y la
   Luftwaffe.

1. Zusatzwalze: rotores adicional, conocido en inglés como "Greek
   rotor" y traducido por nosotros a "rotor griego".

## Ejemplos 

### Ejemplo Nº 1

El primer ejemplo esta tomado de los contenidos de
[Crypto Museum](http://www.cryptomuseum.com/crypto/enigma/msg/p1030681.htm#ref).

Fue enviado por el Gran Almirante Dönitz el 1 de mayo de 1945 a las
06:55, anunciando su nombramiento como sucesor de
Hitler. Supuestamente Hitler ya estaba muerto en este punto, desde el
30 de abril a las 15:30. Dönitz fue informado oficialmente de esto por
Reichsleiter Bormann el 30 de abril a las 18:35. Téngase en cuenta que
este mensaje fue enviado antes del anuncio oficial de de la muerte de
Hitler el 1 de mayo de 1945 a las 22:30. El mensaje fue roto por
Michael Hörenberg.

La imagen del formulario de mensaje tal como se encontró a bordo del
submarino hundido [U-534](http://www.cryptomuseum.com/crypto/enigma/msg/u534.htm) es
[ésta](http://www.cryptomuseum.com/crypto/enigma/msg/img/p1030681_DUHF_TETO_WS.jpg). Aunque
la hoja ha estado en el fondo del mar por un tiempo superior a 40, la mayor parte de ella todavía es legible. Sin
embargo, la decodificación de la escritura individual de cada operador
de Enigma puede ser un verdadero desafío por sí misma, como se puede
apreciar en este ejemplo.

Los ajustes son dados más abajo y revelan que el reflector C fue usado
en combinación con el Zusatzwalze (rueda griega) Beta en lugar de
Gamma. Aunque los mensajes de Enigma fueron escritos comúnmente en
grupos de 5 letras, la Marina utilizó grupos de 4 letras. Se
escribieron en formularios de mensajes especiales
(Schlüsselzettel/Funkspruch).

La configuración de la máquina es la siguiente:

* Enigma: M4
* Umkehrwalze (reflector): C
* Zusatzwalze (rueda griega/Greek wheel): Beta
* Walzenlage (orden de las ruedas): 568
* Ringstellung (ajuste de las ruedas): EPEL
* Grundstellung (posición de partida): NAEM
* Steckern (zócalo de clavijas): AE BF CM DQ HU JN LX PR SZ VW
* Clave del mensaje: se determinará configurando la máquina con la
  posición inical NAEM y procesando QEOB.

El texto cifrado es:

	DUHF TETO LANO TCTO UARB BFPM HPHG CZXT DYGA HGUF XGEW KBLK GJWL QXXT
	GPJJ AVTO CKZF SLPP QIHZ FXOE BWII EKFZ LCLO AQJU LJOY HSSM BBGW HZAN
	VOII PYRB RTDJ QDJJ OQKC XWDN BBTY VXLY TAPG VEAT XSON PNYN QFUD BBHH
	VWEP YEYD OHNL XKZD NWRH DUWU JUMW WVII WZXI VIUQ DRHY MNCY EFUA PNHO
	TKHK GDNP SAKN UAGH JZSM JBMH VTRE QEDG XHLZ WIFU SKDQ VELN MIMI THBH
	DBWV HDFY HJOQ IHOR TDJD BWXE MEAY XGYQ XOHF DMYU XXNO JAZR SGHP LWML
	RECW WUTL RTTV LBHY OORG LGOW UXNX HMHY FAAC QEKT HSJW DUHF TETO

del que hay que restar los primeros y últimos dos grupos, que
coinciden para advertir fallos de transmisión. Como resultado queda
entonces:

	          LANO TCTO UARB BFPM HPHG CZXT DYGA HGUF XGEW KBLK GJWL QXXT
	GPJJ AVTO CKZF SLPP QIHZ FXOE BWII EKFZ LCLO AQJU LJOY HSSM BBGW HZAN
	VOII PYRB RTDJ QDJJ OQKC XWDN BBTY VXLY TAPG VEAT XSON PNYN QFUD BBHH
	VWEP YEYD OHNL XKZD NWRH DUWU JUMW WVII WZXI VIUQ DRHY MNCY EFUA PNHO
	TKHK GDNP SAKN UAGH JZSM JBMH VTRE QEDG XHLZ WIFU SKDQ VELN MIMI THBH
	DBWV HDFY HJOQ IHOR TDJD BWXE MEAY XGYQ XOHF DMYU XXNO JAZR SGHP LWML
	RECW WUTL RTTV LBHY OORG LGOW UXNX HMHY FAAC QEKT HSJW

El procedimiento es el siguiente:

	iMac-de-User:M4 User$ ghci EnigmaM4.hs 
	GHCi, version 7.8.3: http://www.haskell.org/ghc/  :? for help
	Loading package ghc-prim ... linking ... done.
	Loading package integer-gmp ... linking ... done.
	Loading package base ... linking ... done.
	[1 of 4] Compiling Auxiliars        ( Auxiliars.hs, interpreted )
	[2 of 4] Compiling Types            ( Types.hs, interpreted )
	[3 of 4] Compiling Rotors           ( Rotors.hs, interpreted )
	[4 of 4] Compiling EnigmaM4         ( EnigmaM4.hs, interpreted )
	Ok, modules loaded: EnigmaM4, Auxiliars, Types, Examples.
	*EnigmaM4> let walzenlage = W beta rotor_05 rotor_06 rotor_08
	Loading package array-0.5.0.0 ... linking ... done.
	Loading package deepseq-1.3.0.2 ... linking ... done.
	Loading package containers-0.5.5.1 ... linking ... done.
	*EnigmaM4> let ringstellung = RS (CharacterI 'E') (CharacterI 'P') (CharacterI 'E') (CharacterI 'L')
	*EnigmaM4> let pb = createPbSet "AE BF CM DQ HU JN LX PR SZ VW"
	*EnigmaM4> let grundstellung = GS 'N' 'A' 'E' 'M'
	*EnigmaM4> let rotorSet = rotorSetup walzenlage ringstellung grundstellung reflector_C_Thin
	*EnigmaM4> encodeTextEnigmaM4 rotorSet pb "QEOB"
	"CDSZ"
	*EnigmaM4> let grundstellungMes = GS 'C' 'D' 'S' 'Z'
	*EnigmaM4> let rotorSetMes = resetGrundstellung rotorSet grundstellungMes
	*EnigmaM4> let ciphertext = "LANOTCTOUARBBFPMHPHGCZXTDYGAHGUFXGEWKBLKGJW
	LQXXTGPJJAVTOCKZFSLPPQIHZFXOEBWIIEKFZLCLOAQJULJOYHSSMBBGWHZANVOIIPYRBRTD
	JQDJJOQKCXWDNBBTYVXLYTAPGVEATXSONPNYNQFUDBBHHVWEPYEYDOHNLXKZDNWRHDUWUJUM
	WWVIIWZXIVIUQDRHYMNCYEFUAPNHOTKHKGDNPSAKNUAGHJZSMJBMHVTREQEDGXHLZWIFUSKD
	QVELNMIMITHBHDBWVHDFYHJOQIHORTDJDBWXEMEAYXGYQXOHFDMYUXXNOJAZRSGHPLWMLREC
	WWUTLRTTVLBHYOORGLGOWUXNXHMHYFAACQEKTHSJW"
	*EnigmaM4> encodeTextEnigmaM4 rotorSetMes pb ciphertext
	"KRKRALLEXXFOLGENDESISTSOFORTBEKANNTZUGEBENXXICHHABEFOLGELNBEBEFEHLERH
	ALTENXXJANSTERLEDESBISHERIGXNREICHSMARSCHALLSJGOERINGJSETZTDERFUEHRERS
	IEYHVRRGRZSSADMIRALYALSSEINENNACHFOLGEREINXSCHRIFTLSCHEVOLLMACHTUNTERW
	EGSXABSOFORTSOLLENSIESAEMTLICHEMASSNAHMENVERFUEGENYDIESICHAUSDERGEGENW
	AERTIGENLAGEERGEBENXGEZXREICHSLEITEIKKTULPEKKJBORMANNJXXOBXDXMMMDURNHF
	KSTXKOMXADMXUUUBOOIEXKP"
	*EnigmaM4> let plaintextCryptoMuseum = "KRKRALLEXXFOLGENDESISTSOFORTBE
	KANNTZUGEBENXXICHHABEFOLGELNBEBEFEHLERHALTENXXJANSTERLEDESBISHERIGXNRE
	ICHSMARSCHALLSJGOERINGJSETZTDERFUEHRERSIEYHVRRGRZSSADMIRALYALSSEINENNA
	CHFOLGEREINXSCHRIFTLSCHEVOLLMACHTUNTERWEGSXABSOFORTSOLLENSIESAEMTLICHE
	MASSNAHMENVERFUEGENYDIESICHAUSDERGEGENWAERTIGENLAGEERGEBENXGEZXREICHSL
	EITEIKKTULPEKKJBORMANNJXXOBXDXMMMDURNHFKSTXKOMXADMXUUUBOOIEXKP"
	*EnigmaM4> plaintextCryptoMuseum == encodeTextEnigmaM4 rotorSetMes pb ciphertext
    True
	*EnigmaM4>

Formateado el resultado da:

	KRKR ALLE XX
	FOLGENDES IST SOFORT BEKANNTZUGEBEN XX
	ICH HABE FOLGELNBE BEFEHL ERHALTEN XX
	J ANSTERLE DES BISHERIGXN REICHSMARSCHALLS J GOERING J SETZT DER
	FUEHRER SIE Y HVRR GRZSSADMIRAL Y
	ALS SEINEN NACHFOLGER EIN X SCHRIFTLSCHE VOLLMACHT UNTERWEGS X
	ABSOFORT SOLLEN SIE SAEMTLICHE MASSNAHMEN VERFUEGEN Y DIE SICH
	AUS DER GEGENWAERTIGEN LAGE ERGEBEN X
	GEZ X REICHSLEITEI KK TULPE KK J BORMANN J
	OB.D.MMM DURNH FKST.KOM.ADM.UUU BOOIE.KP

que llevado al alemán normal es:

	KRIEGSNOTMELDUNG [An] Alle:
	
	Folgendes ist sofort bekanntzugeben:
	Ich habe folgende Befehl erhalten:
	'Anstelle des bisherigen Reichsmarschalls 'Göring' setzt der Führer
	Sie, Herr Großadmiral, als seinen Nachfolger ein.
	Schriftlische Vollmacht unterwegs.
	Ab sofort sollen Sie sämtliche Maßnahmen verfügen,
	die sich aus die gegenwärtigen Lage ergeben.
	Gez. Reichsleiter (Tulpe) 'Bormann'
   
	[Von] Oberbefehlshaber der Marine,
	durch Funkstelle der Kommandierender Admiral der Unterseeboote.


y traducido al inglés es:

	WAR EMERGENCY MESSAGE [To] All:
	
	The following is to be announced immediately:
	I have received the following order: 'In place of former
	Reichsmarschall 'Göring', the Führer has appointed you,
	Herr Grossadmiral, as his successor.
	Written authorization [is] on the way.
	Effective immediately, you are to order all measures
	that are required by the present situation.
	Signed, Reichsleiter (Tulpe) 'Bormann':
	
	[From] Commander-in-Chief of the Navy,
	[sent] by way of the Radio Station
	of the Commanding Admiral of Submarines


### Ejemplo Nº 2

El segundo ejemplo ha sido tomado del excelente sitio de [Dirk
Rijmenants](http://users.telenet.be/d.rijmenants/en/m4project.htm)

El mensaje original ha sido desprovisto de su inicio
FCLC QRKN quedando:

	NCZW VUSX PNYM INHZ XMQX 
	SFWX WLKJ AHSH NMCO CCAK
	UQPM KCSM HKSE INJU SBLK
	IOSX CKUB HMLL XCSJ USRR
	DVKO HULX WCCB GVLI YXEO
	AHXR HKKF VDRE WEZL XOBA
	FGYU JQUK GRTV UKAM EURB
	VEKS UHHV OYHA BCJW MAKL
	FKLM YFVN RIZR VVRT KOFD
	ANJM OLBG FFLE OPRG TFLV
	RHOW OPBE KVWM UQFM PWPA
	RMFH AGKX IIBG 

y la posición inicial de los rotores para el mensaje ha sido
determinada, quedando la siguiente configuración:

* Enigma: Kriegsmarine M4
* Reflector: B
* Rotors: Beta - II - IV - I
* Stecker: AT BL DF GJ HM NW OP QY RZ VX
* Ringsettings: A-A-A-V
* Rotor startposition: V-J-N-A

El texto plano de Rijmenants es:

	VONV ONJL OOKS JHFF TTTE 
	INSE INSD REIZ WOYY QNNS
	NEUN INHA LTXX BEIA NGRI
	FFUN TERW ASSE RGED RUEC
	KTYW ABOS XLET ZTER GEGN
	ERST ANDN ULAC HTDR EINU
	LUHR MARQ UANT ONJO TANE
	UNAC HTSE YHSD REIY ZWOZ
	WONU LGRA DYAC HTSM YSTO
	SSEN ACHX EKNS VIER MBFA
	ELLT YNNN NNNO OOVI ERYS
	ICHT EINS NULL

Con nuestra implementación procederíamos así:

	iMac-de-User:M4 User$ ghci EnigmaM4.hs 
	GHCi, version 7.8.3: http://www.haskell.org/ghc/  :? for help
	Loading package ghc-prim ... linking ... done.
	Loading package integer-gmp ... linking ... done.
	Loading package base ... linking ... done.
	[1 of 4] Compiling Auxiliars        ( Auxiliars.hs, interpreted )
	[2 of 4] Compiling Types            ( Types.hs, interpreted )
	[3 of 4] Compiling Rotors           ( Rotors.hs, interpreted )
	[4 of 4] Compiling EnigmaM4         ( EnigmaM4.hs, interpreted )
	Ok, modules loaded: EnigmaM4, Auxiliars, Types, Rotors.
	*EnigmaM4> let walzenlage = W beta rotor_02 rotor_04 rotor_01
	Loading package array-0.5.0.0 ... linking ... done.
	Loading package deepseq-1.3.0.2 ... linking ... done.
	Loading package containers-0.5.5.1 ... linking ... done.
	*EnigmaM4> let ringstellung = RS (CharacterI 'A') (CharacterI 'A') (CharacterI 'A') (CharacterI 'V')
	*EnigmaM4> let pb = createPbSet "AT BL DF GJ HM NW OP QY RZ VX"
	*EnigmaM4> let grundstellung = GS 'V' 'J' 'N' 'A'
	*EnigmaM4> let ciphertext ="NCZWVUSXPNYMINHZXMQXSFWXWLKJAHSHNMCOCCAKUQP
	MKCSMHKSEINJUSBLKIOSXCKUBHMLLXCSJUSRRDVKOHULXWCCBGVLIYXEOAHXRHKKFVDREWE
	ZLXOBAFGYUJQUKGRTVUKAMEURBVEKSUHHVOYHABCJWMAKLFKLMYFVNRIZRVVRTKOFDANJMO
	LBGFFLEOPRGTFLVRHOWOPBEKVWMUQFMPWPARMFHAGKXIIBG"
	*EnigmaM4> let rotorSet = rotorSetup walzenlage ringstellung grundstellung reflector_B_Thin
	*EnigmaM4> encodeTextEnigmaM4 rotorSet pb ciphertext
	"VONVONJLOOKSJHFFTTTEINSEINSDREIZWOYYQNNSNEUNINHALTXXBEIANGRIFFUNTERWAS
	SERGEDRUECKTYWABOSXLETZTERGEGNERSTANDNULACHTDREINULUHRMARQUANTONJOTANEU
	NACHTSEYHSDREIYZWOZWONULGRADYACHTSMYSTOSSENACHXEKNSVIERMBFAELLTYNNNNNNO
	OOVIERYSICHTEINSNULL"
	*EnigmaM4> let plaintextdrijmenants ="VONVONJLOOKSJHFFTTTEINSEINSDREIZ
	WOYYQNNSNEUNINHALTXXBEIANGRIFFUNTERWASSERGEDRUECKTYWABOSXLETZTERGEGNER
	STANDNULACHTDREINULUHRMARQUANTONJOTANEUNACHTSEYHSDREIYZWOZWONULGRADYAC
	HTSMYSTOSSENACHXEKNSVIERMBFAELLTYNNNNNNOOOVIERYSICHTEINSNULL"
	*EnigmaM4> encodeTextEnigmaM4 rotorSet pb ciphertext == plaintextdrijmenants
	True
	*EnigmaM4>

### Ejemplo Nº 3

Consiste en el descifrado del mensaje
[P1030682](https://enigma.hoerenberg.com/index.php?cat=The%20U534%20messages&page=P1030682)

* Reflector: B 
* Greek: C                (por 4º rotor o rotor griego: Gamma)
* Wheels: 438 
* Wheel positions: MVYY   (Grunstellung)
* Rings: AACU             (Ringstellung)
* Plugs: CH EJ NV OU TY LG SZ PK DI QB
* Message indicator groups: FFUC MWYR

Texto cifrado sin indicador de grupo:

	PIARMJTBFRGMEBDSBOGCRVBCOXYOHRWDLQIXQYCXZSKFLQMSIMTQBNZDTXDQIVFUYGLIATLERQ
	YQKSIXMMZUKZTVFCJPPFVGZGOE

Texto llano:

	FFFDDDUUUMSTVINVONHAKFROENNELQAUFGGGZWONULZWONEUXUUBZWOVOMZWOACHTXVSERXXJH
	RCHTJHIERNICHTEINZELGUFENF

Interpretación preliminar:

	[An] F.d.U. Ost von [Haka Rønne:] Auf G2029 U2 vom 28.4: “Hecht” hier nicht [eingelaufen].

Traducción preliminar:

	[To] Comsubs East from [Port Captain Rønne:] Regarding [message] G2029 U2 of 28th April: “Hecht” has not [entered port] here.

Nota: “Haka” es una abreviatura de “Hafenkapitän” (“Port Captain”)

El diálogo es el siguiente:

	iMac-de-User:M4 User$ ghci EnigmaM4.hs 
	GHCi, version 7.8.3: http://www.haskell.org/ghc/  :? for help
	Loading package ghc-prim ... linking ... done.
	Loading package integer-gmp ... linking ... done.
	Loading package base ... linking ... done.
	[1 of 4] Compiling Auxiliars        ( Auxiliars.hs, interpreted )
	[2 of 4] Compiling Types            ( Types.hs, interpreted )
	[3 of 4] Compiling Rotors           ( Rotors.hs, interpreted )
	[4 of 4] Compiling EnigmaM4         ( EnigmaM4.hs, interpreted )
	Ok, modules loaded: EnigmaM4, Auxiliars, Types, Rotors.
	*EnigmaM4> let walzenlage = W gamma rotor_04 rotor_03 rotor_08
	Loading package array-0.5.0.0 ... linking ... done.
	Loading package deepseq-1.3.0.2 ... linking ... done.
	Loading package containers-0.5.5.1 ... linking ... done.
	*EnigmaM4> let ringstellung = RS (CharacterI 'A') (CharacterI 'A') (CharacterI 'C') (CharacterI 'U')
	*EnigmaM4> let pb = createPbSet "CH EJ NV OU TY LG SZ PK DI QB"
	*EnigmaM4> let grundstellung = GS 'M' 'V' 'Y' 'Y'
	*EnigmaM4> let rotorSet = rotorSetup walzenlage ringstellung grundstellung reflector_B_Thin
	*EnigmaM4> let ciphertext ="PIARMJTBFRGMEBDSBOGCRVBCOXYOHRWDLQIXQYCXZSKFLQMSIMTQBNZDTX
	DQIVFUYGLIATLERQYQKSIXMMZUKZTVFCJPPFVGZGOE"
	*EnigmaM4> encodeTextEnigmaM4 rotorSet pb ciphertext
	"FFFDDDUUUMSTVINVONHAKFROENNELQAUFGGGZWONULZWONEUXUUBZWOVOMZWOACHTXVSER
	XXJHRCHTJHIERNICHTEINZELGUFENF"
	*EnigmaM4> let plaintext_P1030682 ="FFFDDDUUUMSTVINVONHAKFROENNELQAUFG
	GGZWONULZWONEUXUUBZWOVOMZWOACHTXVSERXXJHRCHTJHIERNICHTEINZELGUFENF"
	*EnigmaM4> plaintext_P1030682 == encodeTextEnigmaM4 rotorSet pb ciphertext
	True
	*EnigmaM4> 

Finalmente haremos una demostración de la compatibilidad de la M4 con
la M3 y, por tanto, con la Enigma I. El diálogo es el siguiente:

	iMac-de-User:M4 User$ ghci EnigmaM4.hs 
	GHCi, version 7.8.3: http://www.haskell.org/ghc/  :? for help
	Loading package ghc-prim ... linking ... done.
	Loading package integer-gmp ... linking ... done.
	Loading package base ... linking ... done.
	[1 of 4] Compiling Auxiliars        ( Auxiliars.hs, interpreted )
	[2 of 4] Compiling Types            ( Types.hs, interpreted )
	[3 of 4] Compiling Rotors           ( Rotors.hs, interpreted )
	[4 of 4] Compiling EnigmaM4         ( EnigmaM4.hs, interpreted )
	Ok, modules loaded: EnigmaM4, Auxiliars, Types, Rotors.
	*EnigmaM4> let walzenlage31 = W beta rotor_02 rotor_04 rotor_05
	Loading package array-0.5.0.0 ... linking ... done.
	Loading package deepseq-1.3.0.2 ... linking ... done.
	Loading package containers-0.5.5.1 ... linking ... done.
	*EnigmaM4> let ringstellung31 = RS (CharacterI 'A') (CharacterI 'B') (CharacterI 'U') (CharacterI 'L')
	*EnigmaM4> let pb31 = createPbSet "AV BS CG DL FU HZ IN KM OW RX"
	*EnigmaM4> let grundstellung31 = GS 'A' 'W' 'X' 'C'
	*EnigmaM4> let rotorSet31 = rotorSetup walzenlage31 ringstellung31 grundstellung31 reflector_B_Thin
	*EnigmaM4> encodeTextEnigmaM4 rotorSet31 pb31 "KCH"
	"BLA"
	*EnigmaM4> let grundstellungMes = GS 'A' 'B' 'L' 'A'
	*EnigmaM4> let rotorSetMes = resetGrundstellung rotorSet31 grundstellungMes
	*EnigmaM4> let ciphertext ="EDPUDNRGYSZRCXNUYTPOMRMBOFKTBZREZKMLXLVEFGU
	EYSIOZVEQMIKUBPMMYLKLTTDEISMDICAGYKUACTCDOMOHWXMUUIAUBSTSLRNBZSZWNRFXWF
	YSSXJZVIJHIDISHPRKLKAYUPADTXQSPINQMATLPIFSVKDASCTACDPBOPVHJK"
	*EnigmaM4> encodeTextEnigmaM4 rotorSetMes pb31 ciphertext
	"AUFKLXABTEILUNGXVONXKURTINOWAXKURTINOWAXNORDWESTLXSEBEZXSEBEZXUAFFLIEG
	ERSTRASZERIQTUNGXDUBROWKIXDUBROWKIXOPOTSCHKAXOPOTSCHKAXUMXEINSAQTDREINU
	LLXUHRANGETRETENXANGRIFFXINFXRGTX"
	*EnigmaM4> let plaintextRijmenants31 ="AUFKLXABTEILUNGXVONXKURTINOWAXKUR
	TINOWAXNORDWESTLXSEBEZXSEBEZXUAFFLIEGERSTRASZERIQTUNGXDUBROWKIXDUBROWKI
	XOPOTSCHKAXOPOTSCHKAXUMXEINSAQTDREINULLXUHRANGETRETENXANGRIFFXINFXRGTX"
	*EnigmaM4> plaintextRijmenants31 == encodeTextEnigmaM4 rotorSetMes pb31 ciphertext
	True
	*EnigmaM4> 
	*EnigmaM4> 
	*EnigmaM4> 
	*EnigmaM4> let walzenlage32 = W beta rotor_02 rotor_04 rotor_05
	*EnigmaM4> let ringstellung32 = RS (CharacterI 'A') (CharacterI 'B') (CharacterI 'U') (CharacterI 'L')
	*EnigmaM4> let pb32 = createPbSet "AV BS CG DL FU HZ IN KM OW RX"
	*EnigmaM4> let grundstellung32 = GS 'A' 'C' 'R' 'S'
	*EnigmaM4> let rotorSet32 = rotorSetup walzenlage32 ringstellung32 grundstellung32 reflector_B_Thin
	*EnigmaM4> encodeTextEnigmaM4 rotorSet32 pb32 "YPJ"
	"LSD"
	*EnigmaM4> let grundstellungMes = GS 'A' 'L' 'S' 'D'
	*EnigmaM4> let rotorSetMes = resetGrundstellung rotorSet32 grundstellungMes
	*EnigmaM4> let ciphertext = "SFBWDNJUSEGQOBHKRTAREEZMWKPPRBXOHDROEQGBBGT
	QVPGVKBVVGBIMHUSZYDAJQIROAXSSSNREHYGGRPISEZBOVMQIEMMZCYSGQDGRERVBILEKXYQ
	IRGIRQNRDNVRXCYYTNJR"
	*EnigmaM4> encodeTextEnigmaM4 rotorSetMes pb32 ciphertext
	"DREIGEHTLANGSAMABERSIQERVORWAERTSXEINSSIEBENNULLSEQSXUHRXROEMXEINSXINFR
	GTXDREIXAUFFLIEGERSTRASZEMITANFANGXEINSSEQSXKMXKMXOSTWXKAMENECXK"
	*EnigmaM4> let plaintextDRijmenants32 = "DREIGEHTLANGSAMABERSIQERVORWAER
	TSXEINSSIEBENNULLSEQSXUHRXROEMXEINSXINFRGTXDREIXAUFFLIEGERSTRASZEMITANFA
	NGXEINSSEQSXKMXKMXOSTWXKAMENECXK"
	*EnigmaM4> plaintextDRijmenants32 == encodeTextEnigmaM4 rotorSetMes pb32 ciphertext
	True
	*EnigmaM4>

