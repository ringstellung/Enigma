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

## Organización

* `nucleo/EnigmaNucleo.hs`: la máquina, común a todos los modelos.
* `nucleo/Rotors.hs`: los rotores y reflectores históricos.
* `M3/EnigmaM3.hs`, `M4/EnigmaM4.hs` y `Enigma_I/EnigmaI.hs`: módulos finos,
  con los nombres de siempre (`rotorSetup`, `encodeTextEnigmaM3`...).
* `Enigma_C/EnigmaComercial.hs`: la Enigma comercial, modelos D y K.
* `pruebas/`: mensajes reales, vectores de otra implementación y propiedades.

La versión anterior a esta organización tiene la etiqueta `v2017`.

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
