#!/usr/bin/env python3
"""Vectores de la Enigma comercial.

Simulador aparte, sin tablas: sigue la corriente contacto a contacto con la
convención de Crypto Museum. Comprueba la programación del núcleo; no sustituye
a un mensaje histórico, que no se ha encontrado.

Uso, desde la raíz:  python3 pruebas/genera_comercial.py
Cada línea: modelo rotores anillos posiciones reflector texto cifrado
"""
import random
import string

A = string.ascii_uppercase
ETW = "QWERTZUIOASDFGHJKPYXCVBNML"
UKW = "IMETCGFRAYSQBZXWLHKDVUPOJN"
W = {"1": "LPGSZMHAEOQKVXRFYBUTNICJDW",
     "2": "SLVGBTFXJQOHEWIRZYAMKPCNDU",
     "3": "CJGDPSHKTURAWZXFMYNQOBVLIE"}
SALTO_K = {"1": "Y", "2": "E", "3": "N"}


def atraviesa(cable, contacto, giro, sentido):
    """Contacto fijo de entrada y salida para un disco girado `giro` pasos."""
    propio = (contacto + giro) % 26
    if sentido == 1:
        salida = A.index(cable[propio])
    else:
        salida = cable.index(A[propio])
    return (salida - giro) % 26


def cifra(modelo, rotores, anillos, pos, ukw, texto):
    pos = [A.index(c) for c in pos]
    ani = [A.index(c) for c in anillos]
    if modelo == "K":
        salto = [A.index(SALTO_K[r]) for r in rotores]
    else:
        salto = [(a - 1) % 26 for a in ani]
    sal = []
    for t in texto:
        dobla = pos[1] == salto[1]
        lleva = pos[2] == salto[2]
        if dobla:
            pos[0] = (pos[0] + 1) % 26
        if dobla or lleva:
            pos[1] = (pos[1] + 1) % 26
        pos[2] = (pos[2] + 1) % 26
        c = ETW.index(t)
        for i in (2, 1, 0):
            c = atraviesa(W[rotores[i]], c, pos[i] - ani[i], 1)
        c = atraviesa(UKW, c, A.index(ukw), 1)
        for i in (0, 1, 2):
            c = atraviesa(W[rotores[i]], c, pos[i] - ani[i], -1)
        sal.append(ETW[c])
    return "".join(sal)


azar = random.Random(1927)
with open("pruebas/comercial.txt", "w") as f:
    for _ in range(3000):
        modelo = azar.choice("DK")
        rot = "".join(azar.sample("123", 3))
        ani = "".join(azar.choice(A) for _ in range(3))
        pos = "".join(azar.choice(A) for _ in range(3))
        ukw = azar.choice(A)
        texto = "".join(azar.choice(A) for _ in range(azar.randint(1, 120)))
        print(modelo, rot, ani, pos, ukw, texto,
              cifra(modelo, rot, ani, pos, ukw, texto), file=f)
