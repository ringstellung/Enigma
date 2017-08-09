# Enigma M3

## Content
				       
In this file we provide some examples. With these examples and
comments in the files (Spanish) should be enough to understand the
project.

## A Real Message (example) Given by Mr. DIRK RIJMENANTS

The settings recovered by the CSG codebreakers:

	Maschine: Wehrmacht Enigma I
	UKW: B
	Walzenlage: 2 4 5
	Ringstellung: BUL
	Stecker: AV BS CG DL FU HZ IN KM OW RX

	Befordert am: 07.07.1941 1925 Uhr Durch:

	Funkspruch Nr.:20 Von/An: f8v/bz2

	Absendende Stelle : SS-T Div Kdr An: LVI A.K.

	fuer m7g 1840 - 2tl 1t 179 - WXC KCH –

	RFUGZ EDPUD NRGYS ZRCXN
	UYTPO MRMBO FKTBZ REZKM
	LXLVE FGUEY SIOZV EQMIK
	UBPMM YLKLT TDEIS MDICA
	GYKUA CTCDO MOHWX MUUIA
	UBSTS LRNBZ SZWNR FXWFY
	SSXJZ VIJHI DISHP RKLKA
	YUPAD TXQSP INQMA TLPIF
	SVKDA SCTAC DPBOP VHJK

	2tl 155 - CRS YPJ -

	FNJAU SFBWD NJUSE GQOBH
	KRTAR EEZMW KPPRB XOHDR
	OEQGB BGTQV PGVKB VVGBI
	MHUSZ YDAJQ IROAX SSSNR
	EHYGG RPISE ZBOVM QIEMM
	ZCYSG QDGRE RVBIL EKXYQ
	IRGIR QNRDN VRXCY YTNJR

## Solutions Givens by Mr. DIRK RIJMENANTS

First enciphered block

	RFUGZ EDPUD NRGYS ZRCXN
	UYTPO MRMBO FKTBZ REZKM
	LXLVE FGUEY SIOZV EQMIK
	UBPMM YLKLT TDEIS MDICA
	GYKUA CTCDO MOHWX MUUIA
	UBSTS LRNBZ SZWNR FXWFY
	SSXJZ VIJHI DISHP RKLKA
	YUPAD TXQSP INQMA TLPIF
	SVKDA SCTAC DPBOP VHJK


	EDPUDNRGYSZRCXNUYTPOMRMBOFKTBZREZKMLXLVEFGUEYSIOZVEQMIKUBPMMYLKLTTDEISMDICAGYKUACTCDOMOHWXMUUIAUBSTSLRNBZSZWNRFXWFYSSXJZVIJHIDISHPRKLKAYUPADTXQSPINQMATLPIFSVKDASCTACDPBOPVHJK

First decoded block

	AUFKL XABTE ILUNG XVONX
	KURTI NOWAX KURTI NOWAX
	NORDW ESTLX SEBEZ XSEBE
	ZXUAF FLIEG ERSTR ASZER
	IQTUN GXDUB ROWKI XDUBR
	OWKIX OPOTS CHKAX OPOTS
	CHKAX UMXEI NSAQT DREIN
	ULLXU HRANG ETRET ENXAN
	GRIFF XINFX RGTX

	AUFKLXABTEILUNGXVONXKURTINOWAXKURTINOWAXNORDWESTLXSEBEZXSEBEZXUAFFLIEGERSTRASZERIQTUNGXDUBROWKIXDUBROWKIXOPOTSCHKAXOPOTSCHKAXUMXEINSAQTDREINULLXUHRANGETRETENXANGRIFFXINFXRGTX

Second block ciphered

	FNJAU SFBWD NJUSE GQOBH
	KRTAR EEZMW KPPRB XOHDR
	OEQGB BGTQV PGVKB VVGBI
	MHUSZ YDAJQ IROAX SSSNR
	EHYGG RPISE ZBOVM QIEMM
	ZCYSG QDGRE RVBIL EKXYQ
	IRGIR QNRDN VRXCY YTNJR

	SFBWDNJUSEGQOBHKRTAREEZMWKPPRBXOHDROEQGBBGTQVPGVKBVVGBIMHUSZYDAJQIROAXSSSNREHYGGRPISEZBOVMQIEMMZCYSGQDGRERVBILEKXYQIRGIRQNRDNVRXCYYTNJR

Second decoded block

	DREIG EHTLA NGSAM ABERS
	IQERV ORWAE RTSXE INSSI
	EBENN ULLSE QSXUH RXROE
	MXEIN SXINF RGTXD REIXA
	UFFLI EGERS TRASZ EMITA
	NFANG XEINS SEQSX KMXKM
	XOSTW XKAME NECXK

	DREIGEHTLANGSAMABERSIQERVORWAERTSXEINSSIEBENNULLSEQSXUHRXROEMXEINSXINFRGTXDREIXAUFFLIEGERSTRASZEMITANFANGXEINSSEQSXKMXKMXOSTWXKAMENECXK


## Our Functions in Action

For the first part:

	iMac-de-User:EnigmaM3 fmgo$ ghci EnigmaM3
	GHCi, version 7.8.3: http://www.haskell.org/ghc/  :? for help
	Loading package ghc-prim ... linking ... done.
	Loading package integer-gmp ... linking ... done.
	Loading package base ... linking ... done.
	[1 of 5] Compiling Auxiliars        ( Auxiliars.hs, interpreted )
	[3 of 5] Compiling Types            ( Types.hs, interpreted )
	[4 of 5] Compiling Rotors           ( Rotors.hs, interpreted )
	[5 of 5] Compiling EnigmaM3         ( EnigmaM3.hs, interpreted )
	Ok, modules loaded: EnigmaM3, Auxiliars, Types, Rotors.
	*EnigmaM3> let walzenlage31 = W rotor_02 rotor_04 rotor_05
	Loading package array-0.5.0.0 ... linking ... done.
	Loading package deepseq-1.3.0.2 ... linking ... done.
	Loading package containers-0.5.5.1 ... linking ... done.
	*EnigmaM3> let ringstellung31 = RS (CharacterI 'B') (CharacterI 'U') (CharacterI 'L')
	*EnigmaM3> let pb31 = createPbSet "AV BS CG DL FU HZ IN KM OW RX"
	*EnigmaM3> let grundstellung31 = GS 'W' 'X' 'C'
	*EnigmaM3> let rotorSet31 = rotorSetup walzenlage31 ringstellung31 grundstellung31 reflector_B
	*EnigmaM3> encodeTextEnigmaM3 rotorSet31 pb31 "KCH"
	"BLA"
	*EnigmaM3> let grundstellungMes = GS 'B' 'L' 'A'
	*EnigmaM3> let rotorSetMes = resetGrundstellung rotorSet31 grundstellungMes
	*EnigmaM3> let ciphertext = "EDPUDNRGYSZRCXNUYTPOMRMBOFKTBZREZKMLXLVEFGUEYSIOZVEQMIKUBPMMYLKLTTDEISMDICAGYKUACTCDOMOHWXMUUIAUBSTSLRNBZSZWNRFXWFYSSXJZVIJHIDISHPRKLKAYUPADTXQSPINQMATLPIFSVKDASCTACDPBOPVHJK"
	*EnigmaM3> encodeTextEnigmaM3 rotorSetMes pb31 ciphertext
	"AUFKLXABTEILUNGXVONXKURTINOWAXKURTINOWAXNORDWESTLXSEBEZXSEBEZXUAFFLIEGERSTRASZERIQTUNGXDUBROWKIXDUBROWKIXOPOTSCHKAXOPOTSCHKAXUMXEINSAQTDREINULLXUHRANGETRETENXANGRIFFXINFXRGTX"
	*EnigmaM3> let plaintextDRijmenants = "AUFKLXABTEILUNGXVONXKURTINOWAXKURTINOWAXNORDWESTLXSEBEZXSEBEZXUAFFLIEGERSTRASZERIQTUNGXDUBROWKIXDUBROWKIXOPOTSCHKAXOPOTSCHKAXUMXEINSAQTDREINULLXUHRANGETRETENXANGRIFFXINFXRGTX"
	*EnigmaM3> plaintextDRijmenants == encodeTextEnigmaM3 rotorSetMes pb31 ciphertext
	True
	*EnigmaM3> 

For the second part:

	iMac-de-User:EnigmaM3 fmgo$ ghci EnigmaM3
	GHCi, version 7.8.3: http://www.haskell.org/ghc/  :? for help
	Loading package ghc-prim ... linking ... done.
	Loading package integer-gmp ... linking ... done.
	Loading package base ... linking ... done.
	[1 of 5] Compiling Auxiliars        ( Auxiliars.hs, interpreted )
	[3 of 5] Compiling Types            ( Types.hs, interpreted )
	[4 of 5] Compiling Rotors           ( Rotors.hs, interpreted )
	[5 of 5] Compiling EnigmaM3         ( EnigmaM3.hs, interpreted )
	Ok, modules loaded: EnigmaM3, Auxiliars, Types, Rotors.
	*EnigmaM3> let walzenlage32 = W rotor_02 rotor_04 rotor_05
	Loading package array-0.5.0.0 ... linking ... done.
	Loading package deepseq-1.3.0.2 ... linking ... done.
	Loading package containers-0.5.5.1 ... linking ... done.
	*EnigmaM3> let ringstellung32 = RS (CharacterI 'B') (CharacterI 'U') (CharacterI 'L')
	*EnigmaM3> let pb32 = createPbSet "AV BS CG DL FU HZ IN KM OW RX"
	*EnigmaM3> let grundstellung32 = GS 'C' 'R' 'S'
	*EnigmaM3> let rotorSet32 = rotorSetup walzenlage32 ringstellung32 grundstellung32 reflector_B
	*EnigmaM3> encodeTextEnigmaM3 rotorSet32 pb32 "YPJ"
	"LSD"
	*EnigmaM3> let grundstellungMes = GS 'L' 'S' 'D'
	*EnigmaM3> let rotorSetMes = resetGrundstellung rotorSet32 grundstellungMes
	*EnigmaM3> let ciphertext = "SFBWDNJUSEGQOBHKRTAREEZMWKPPRBXOHDROEQGBBGTQVPGVKBVVGBIMHUSZYDAJQIROAXSSSNREHYGGRPISEZBOVMQIEMMZCYSGQDGRERVBILEKXYQIRGIRQNRDNVRXCYYTNJR"
	*EnigmaM3> encodeTextEnigmaM3 rotorSetMes pb32 ciphertext
	"DREIGEHTLANGSAMABERSIQERVORWAERTSXEINSSIEBENNULLSEQSXUHRXROEMXEINSXINFRGTXDREIXAUFFLIEGERSTRASZEMITANFANGXEINSSEQSXKMXKMXOSTWXKAMENECXK"
	*EnigmaM3> let plaintextDRijmenants = "DREIGEHTLANGSAMABERSIQERVORWAERTSXEINSSIEBENNULLSEQSXUHRXROEMXEINSXINFRGTXDREIXAUFFLIEGERSTRASZEMITANFANGXEINSSEQSXKMXKMXOSTWXKAMENECXK"
	*EnigmaM3> plaintextDRijmenants == encodeTextEnigmaM3 rotorSetMes pb32 ciphertext
	True
	*EnigmaM3> 
