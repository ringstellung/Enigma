<meta http-equiv='Content-Type' content='text/html; charset=utf-8' />

# Implementaciones de la Máquina Enigma 

Contiene un código en `Haskell` que implementa diversos modelos de la
Máquina Enigma: `Enigma I`, `M3` y `M4`.

No está implementado el reflector D configurable, aunque esperamos
incorporarlo pronto.

## Organización

* `nucleo/EnigmaNucleo.hs`: la máquina, común a todos los modelos.
* `nucleo/Rotors.hs`: los rotores y reflectores históricos.
* `M3/EnigmaM3.hs`, `M4/EnigmaM4.hs` y `Enigma_I/EnigmaI.hs`: módulos finos,
  con los nombres de siempre (`rotorSetup`, `encodeTextEnigmaM3`...).
* `pruebas/`: mensajes reales, vectores de otra implementación y propiedades.
* `Enigma_C/`: prototipo de 2016. No compila con el GHC actual y no usa el
  núcleo.

La versión anterior a esta organización tiene la etiqueta `v2017`.

## Uso

Desde `M3`, `M4` o `Enigma_I`, basta `ghci EnigmaM3` (o `EnigmaM4`,
`EnigmaI`), porque el fichero `.ghci` de cada carpeta añade `../nucleo`.

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
