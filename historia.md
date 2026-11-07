# Una breve historia de la Enigma

Este texto sitúa los modelos que implementa el repositorio. Está escrito para quien
llega al código sin conocer la máquina. Las fechas proceden de las fuentes del final, y
cuando estas no coinciden, seguimos al Crypto Museum.

## Por qué aparecen las máquinas de rotores

Un cifrado polialfabético a mano se rompe porque repite sus alfabetos con un periodo
corto. Un rotor es un disco que aplica una permutación del alfabeto, y si gira después de
cada letra, la sustitución cambia con cada tecla. Con varios rotores en serie, el
periodo crece hasta miles de letras sin que el operador tenga que hacer ninguna cuenta.

La idea surgió casi a la vez en varios países. En 1915, dos oficiales neerlandeses, Theo
van Hengel y Rudolf Spengler, construyeron máquinas de rotores. Entre 1917 y 1919
trabajaron en lo mismo, cada uno por su cuenta, Edward Hebern en Estados Unidos, Arvid
Damm en Suecia, Hugo Koch en los Países Bajos y Arthur Scherbius en Alemania.

## De la oficina al ejército

| Año | Hecho |
|---|---|
| 1918 | Patente de Scherbius (23 de febrero) |
| 1923 | Aparece el nombre Enigma, en una máquina impresora para empresas |
| 1924 | Enigma A, la primera con lámparas |
| 1925 | Enigma C, con 26 teclas y 26 lámparas |
| 1926 | Enigma D, con teclado QWERTZ. La Marina alemana compra la Funkschlüssel C |
| 1927 | Enigma K, la principal máquina comercial |
| 1930 | La Enigma I entra en servicio en el Ejército (1 de junio) |
| 1931 | Enigma G, que acabará usando sobre todo la Abwehr |
| 1932 | Marian Rejewski reconstruye en Polonia el cableado de la Enigma I |
| 1934 | La Marina adopta la M1 |
| 1938 | Marina: M2. En diciembre, el Ejército añade los rotores IV y V |
| 1940 | Marina: M3 |
| 1942 | Desde el 1 de febrero, la M4 en los submarinos |
| 1944 | La Luftwaffe introduce el Uhr (julio) |

Dos cambios explican casi todo lo demás. Antes de 1926, Willi Korn, colega de Scherbius,
propuso el **reflector**: la corriente atraviesa los rotores, rebota y vuelve por otro
camino. La máquina se hace más compacta y cifrar y descifrar pasan a ser la misma
operación, pero ninguna letra puede cifrarse en sí misma. Y el Ejército añadió
el **clavijero**, que intercambia letras por parejas antes y después de los rotores.

## Las máquinas de este repositorio

| Modelo | Rotores | Reflector | Clavijero | Carpeta |
|---|---|---|---|---|
| Enigma D (1926) | 3 comerciales | ajustable en 26 posiciones | no | `Enigma_C` |
| Enigma K (1927) | 3 comerciales | ajustable en 26 posiciones | no | `Enigma_C` |
| Enigma I (1930) | 3 de 5 | A, B o C | sí | `Enigma_I` |
| M3 (1940) | 3 de 8 | B o C | sí | `M3` |
| M4 (1942) | 3 de 8, y Beta o Gamma | B o C finos | sí | `M4` |

**La D y la K.** La D fue la primera con el teclado en orden de máquina de escribir. En
ella, la muesca va unida al cuerpo del rotor, de modo que el anillo no aporta seguridad;
los modelos posteriores lo corrigieron. Con sus variantes se cifró en muchos sitios: las
comunicaciones navales españolas e italianas se rompieron en 1937.

**La Enigma I.** Es la máquina del Ejército y de la Luftwaffe. Empezó con tres rotores
y con el reflector A; el B fue el habitual durante la guerra, y el C se usó poco tiempo.
Solía llevar diez cables en el clavijero.

**La M3.** La Marina empezó con la M1 en 1934, y la M2 y la M3 siguieron la misma línea.
Es, en lo esencial, la misma máquina que la Enigma I, con tres rotores más, del VI al
VIII, y por eso aquí comparten núcleo.

**La M4.** Lleva un cuarto rotor, Beta o Gamma, que no avanza, y que cabe porque el
reflector se hizo más delgado. Bletchley Park llamaba SHARK a ese tráfico y tardó unos nueve
meses en volver a leerlo. Se diseñó para poder hablar con las máquinas de tres rotores:
con el griego en `A`, Beta y el reflector B fino equivalen al reflector B, y Gamma y el
C fino, al C. El readme principal explica cómo montarla así.

## Lo que no está implementado

* **La Enigma G.** La usó sobre todo la Abwehr. Avanzaba con engranajes, sin el doble
  avance de las demás, y sus rotores tenían muchas muescas: 17, 15 y 11.
* **El reflector D (UKW-D).** Se podía recablear con 12 cables, y el par BO era fijo.
* **El Uhr.** Sustituía los cables del clavijero por un conmutador de 40 posiciones.
  Salvo en la 00, que equivalía a los cables, el intercambio dejaba de ser recíproco.

## Una rareza que importa al programar

Salvo en la G, el rotor central avanza cuando el derecho pasa por su muesca, y también
cuando él mismo está en la suya. Ese **doble avance** no es un error del simulador,
sino del mecanismo. Por eso el periodo no es 26³ = 17 576, sino 16 900.

## Fuentes

* Crypto Museum, [historia de la Enigma](https://www.cryptomuseum.com/crypto/enigma/hist.htm)
  y fichas de los modelos [D](https://www.cryptomuseum.com/crypto/enigma/d/index.htm),
  [G](https://www.cryptomuseum.com/crypto/enigma/g/index.htm),
  [I](https://www.cryptomuseum.com/crypto/enigma/i/index.htm),
  [M4](https://www.cryptomuseum.com/crypto/enigma/m4/index.htm),
  [UKW-D](https://www.cryptomuseum.com/crypto/enigma/ukwd/index.htm) y
  [Uhr](https://www.cryptomuseum.com/crypto/enigma/uhr/index.htm).
* Dirk Rijmenants, [Cipher Machines and Cryptology](https://www.ciphermachinesandcryptology.com/en/enigma.htm).
* Consultados el 7 de noviembre de 2026.
