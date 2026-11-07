# La Enigma comercial

`EnigmaComercial.hs` reproduce los modelos comerciales D (1926) y K (1927).
La C de la carpeta es la de «comercial»: no es la Enigma C de 1925, cuyo
cableado no se conoce.

Las dos máquinas tienen:

* tres rotores de cableado comercial, `rotor_K1`, `rotor_K2` y `rotor_K3`;
* disco de entrada en orden QWERTZ: la tecla Q entra por el contacto A, la W
  por el B...;
* reflector que se ajusta a mano en 26 posiciones y que no se mueve al cifrar;
* ningún clavijero.

Se diferencian en la muesca. En la K va unida al anillo de letras, y los
rotores I, II y III saltan siempre al pasar de Y, E y N. En la D va unida al
cuerpo del rotor: el salto se produce al pasar de la letra anterior a la del
anillo, la misma para los tres rotores.

## Uso

Desde esta carpeta, `ghci EnigmaComercial`:

	let m = rotorSetup EnigmaK (W rotor_K1 rotor_K2 rotor_K3) (RS (IntegerI 4) (IntegerI 21) (IntegerI 18)) (GS 'E' 'R' 'K') 'L'
	encodeTextEnigmaComercial m "hola"

La última letra de `rotorSetup` es la posición del reflector. El resultado es
`"VGBX"`.

## Comprobación

No hemos encontrado ningún mensaje histórico con su clave ni otro vector
publicado de estos modelos. Por eso, `make pruebas` contrasta las máquinas con
un simulador aparte (`pruebas/genera_comercial.py`) y comprueba a mano los saltos
de los rotores y que el cifrado es involutivo. Esto vale para la programación,
pero no para la interpretación de las fuentes. En particular, ninguna fuente
consultada dice en qué sentido cuenta las letras el reflector: aquí se gira como
un rotor con el anillo en A.

## Fuentes

Cableado, muescas y diferencias entre modelos: Crypto Museum,
<https://www.cryptomuseum.com/crypto/enigma/wiring.htm>,
<https://www.cryptomuseum.com/crypto/enigma/d/index.htm> y
<https://www.cryptomuseum.com/crypto/enigma/k/index.htm>.

`ejemplo_fallido.txt` son notas de trabajo de 2016 con la Enigma militar.
