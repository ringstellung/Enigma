<meta http-equiv='Content-Type' content='text/html; charset=utf-8' />

# Implementaciones de la Máquina Enigma 

Contiene un código en `Haskell` que implementa diversos modelos de la
Máquina Enigma: `Enigma I`, `M3`, `M4` y la comercial, en sus modelos `D` y `K`.

No está implementado el reflector D configurable (UKW-D), que no tiene que ver
con el modelo comercial D, aunque esperamos incorporarlo pronto.

## Quién usaba cada máquina

| Máquina | Quién la usaba |
|---|---|
| Enigma I | Ejército de tierra (Heer) y Aviación (Luftwaffe) |
| M3 | Marina (Kriegsmarine), desde 1940 |
| M4 | Marina: submarinos y acorazados, desde febrero de 1942; el resto de la marina siguió con la M3 |

Es fácil tomar la M3 por la máquina de tierra, porque nació de ella: la marina
adoptó la Enigma I en 1934, y M1 (1934), M2 (1938) y M3 (1940) son en lo esencial
la misma máquina, con pequeñas diferencias de fabricación. Esos nombres se
refieren a los procedimientos de clave, no al aparato.

La M3 es «functionally identical» a la Enigma I, según Crypto Museum: los rotores
I a V son los mismos, y los VI a VIII eran solo de la marina. Por eso `EnigmaM3`
puede simular `EnigmaI`, aunque aquí se conserva cada una como modelo propio. La
Enigma I tuvo además el reflector A, que también está en `nucleo/Rotors.hs`.

Fuentes: Crypto Museum,
<https://www.cryptomuseum.com/crypto/enigma/i/index.htm> y
<https://www.cryptomuseum.com/crypto/enigma/m3/index.htm>.

La historia de los modelos está resumida en [`historia.md`](historia.md).

## Organización

* `nucleo/EnigmaNucleo.hs`: la máquina, común a todos los modelos.
* `nucleo/Rotors.hs`: los rotores y reflectores históricos.
* `M3/EnigmaM3.hs`, `M4/EnigmaM4.hs` y `Enigma_I/EnigmaI.hs`: módulos finos,
  con los nombres de siempre (`rotorSetup`, `encodeTextEnigmaM3`...).
* `Enigma_C/EnigmaComercial.hs`: la Enigma comercial, modelos D y K.
* `pruebas/`: mensajes reales, vectores de otra implementación y propiedades.

La versión anterior a esta organización tiene la etiqueta `v2017`.

## Primeros pasos

Hace falta [GHC](https://www.haskell.org/ghcup/) (probado con la versión 9.14.1). No
hay un programa que se ejecute: las máquinas se usan desde `ghci`. Este ejemplo descifra
un mensaje del manual de Rijmenants con la M3:

	$ cd M3
	$ ghci EnigmaM3
	> let rotores = W rotor_01 rotor_02 rotor_05
	> let anillos = RS (CharacterI 'F') (CharacterI 'V') (CharacterI 'N')
	> let clavijas = createPbSet "PO ML IU KJ NH YT GB VF RE DC"
	> let maquina = rotorSetup rotores anillos (GS 'X' 'W' 'B') reflector_B
	> encodeTextEnigmaM3 maquina clavijas "QBLTWLDAHHYEOEFPTWYBLENDPMKOXLDFAMUDWIJDXRJZ"
	"DERFUEHRERISTTODXDERKAMPFGEHTWEITERXDOENITZX"

Cifrar y descifrar son la misma orden, con la misma clave. `W` son los rotores, de
izquierda a derecha; `RS`, los anillos; `GS`, la posición de partida.

Hay más ejemplos, con mensajes reales, en `M3_ejemplo_uso/` (en inglés y en español),
`Enigma_I/`, `M4/` y `Enigma_C/`.

## La M3 y la M4 como Enigma I

Las tres máquinas descifran los mismos mensajes si se configuran así:

| Si la Enigma I tiene | En la M3 | En la M4 |
|---|---|---|
| reflector B | `reflector_B` | `reflector_B_Thin` y griego `beta` |
| reflector C | `reflector_C` | `reflector_C_Thin` y griego `gamma` |
| rotores I a V | los mismos, `rotor_01` a `rotor_05` | los mismos, tras el griego |
| anillos | los mismos | `A` en el griego, y después los mismos |
| posición | la misma | `A` en el griego, y después la misma |
| clavijas | las mismas | las mismas |

El griego va el primero, a la izquierda, y no avanza. Así, para la clave del ejemplo
anterior, la Enigma I, la M3 y la M4 se montan de esta forma:

	-- Enigma I, en Enigma_I (ghci EnigmaI)
	rotorSetup (W rotor_01 rotor_02 rotor_05) (RS (CharacterI 'F') (CharacterI 'V') (CharacterI 'N'))
	           (GS 'X' 'W' 'B') reflector_B

	-- M3, en M3 (ghci EnigmaM3): la misma orden

	-- M4, en M4 (ghci EnigmaM4)
	rotorSetup (W beta rotor_01 rotor_02 rotor_05)
	           (RS (CharacterI 'A') (CharacterI 'F') (CharacterI 'V') (CharacterI 'N'))
	           (GS 'A' 'X' 'W' 'B') reflector_B_Thin

Después se cifra con `encodeTextEnigmaI`, `encodeTextEnigmaM3` o `encodeTextEnigmaM4`.
Con el reflector C, en la M4 se cambian `beta` por `gamma` y `reflector_B_Thin` por
`reflector_C_Thin`. El griego solo equivale a no estar con el anillo y la posición en
`A`: con otra letra, la máquina ya es otra. Los reflectores A y los rotores VI a VIII no
tienen equivalente en esta tabla: el A no tiene versión fina, y los VI a VIII no
existían en la Enigma I. `make pruebas` comprueba la tabla con los reflectores B y C.

## Uso

Desde `M3`, `M4`, `Enigma_I` o `Enigma_C`, basta `ghci EnigmaM3` (o
`EnigmaM4`, `EnigmaI`, `EnigmaComercial`), porque el fichero `.ghci` de cada
carpeta añade `../nucleo`.

Para compilar y comprobar, desde la raíz:

	make pruebas
	make velocidad

Las máquinas admiten minúsculas en el texto, los anillos y las posiciones,
y hasta 13 clavijas. `createPbSet` aborta si el clavijero no es válido;
`crearPb` devuelve el error. Cualquier carácter del texto que no sea una letra
del alfabeto latino sin tildes aborta con un mensaje claro.

Para cifrar volúmenes grandes, `cifrarBytes` trabaja directamente sobre
`ByteString`.

## Velocidad

Cifrar un millón de letras con la M3, medido con GHC 9.14.1 y `-O2`:

| Versión | Tiempo |
|---|---|
| `v2017`, cadenas | 2,98 s |
| Núcleo, cadenas (`encodeTextEnigmaM3`) | 0,12 s |
| Núcleo, bytes (`cifrarBytes`) | 0,005 s |

La cifra de bytes es la media al cifrar 100 millones de letras (0,53 s).
