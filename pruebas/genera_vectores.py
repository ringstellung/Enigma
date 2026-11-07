"""Genera los vectores de prueba con la Enigma en Python de los apuntes de SPSI.

Uso:  python3 genera_vectores.py RUTA_A_codigo/enigma
"""
import os, random, sys
sys.path.insert(0, sys.argv[1])
os.chdir(sys.argv[1])
from nucleo import *
from mensajes import REALES, u534
AQUI = sys.argv[2]

ROTORES = ["I", "II", "III", "IV", "V", "VI", "VII", "VIII"]
L = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

def texto(n, semilla):
    return "".join(L[(i * 7 + i * i * 3 + semilla) % 26] for i in range(n))

def suma(t):
    h = 0
    for c in t:
        h = (h * 131 + ord(c)) % 2147483647
    return h

with open(os.path.join(AQUI, "mensajes.txt"), "w") as fh:
    for m in REALES + u534():
        rs = m["rotores"]
        ref = m.get("ref", "Bf" if len(rs) == 4 else "B")
        par = m["pares"]
        sal = cifra(ref, rs, m["anillos"], m["pos"], par, m["cifrado"])
        assert sal == m["claro"], m.get("nombre", m.get("id"))
        fh.write("\t".join([ref, " ".join(rs), m["anillos"], m["pos"], par, m["cifrado"], m["claro"]]) + "\n")

random.seed(1944)
with open(os.path.join(AQUI, "azar.txt"), "w") as fh:
    for k in range(3000):
        cuatro = k % 2 == 1
        rs = random.sample(ROTORES, 3)
        if cuatro:
            rs = [random.choice(["beta", "gamma"])] + rs
            ref = random.choice(["Bf", "Cf"])
        else:
            ref = random.choice(["A", "B", "C"])
        an = "".join(random.choice(L) for _ in rs)
        pos = "".join(random.choice(L) for _ in rs)
        ls = random.sample(L, 2 * random.randint(0, 13))
        par = " ".join(ls[i] + ls[i + 1] for i in range(0, len(ls), 2))
        n = random.randint(1, 2500)
        sem = random.randint(0, 10 ** 6)
        fh.write("\t".join([ref, " ".join(rs), an, pos, par, str(n), str(sem),
                            str(suma(cifra(ref, rs, an, pos, par, texto(n, sem))))]) + "\n")
