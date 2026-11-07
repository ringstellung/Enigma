SALIDA := $(shell mktemp -d -t enigma)
GHC := ghc -O2 -Wall -inucleo -iM3 -iM4 -outputdir $(SALIDA)

.PHONY: pruebas velocidad

pruebas:
	$(GHC) pruebas/Pruebas.hs -o $(SALIDA)/pruebas
	$(SALIDA)/pruebas

velocidad:
	$(GHC) pruebas/Velocidad.hs -o $(SALIDA)/velocidad
	$(SALIDA)/velocidad
