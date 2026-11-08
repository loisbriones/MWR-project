# Makefile para la demo. Desactivamos protecciones para que el desbordamiento
# sea observable (solo laboratorio; NO usar estos flags en código real).
CC      ?= gcc
CFLAGS  ?= -g -O0 -fno-stack-protector -no-pie -Wall
# Nota: en algunos sistemas 'strcpy' puede fortificarse; -D_FORTIFY_SOURCE=0 lo evita.
CFLAGS  += -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=0

all: licensecheck

licensecheck: licensecheck.c
	$(CC) $(CFLAGS) -o licensecheck licensecheck.c

patched: licensecheck_patched.c
	$(CC) -g -O0 -Wall -o licensecheck_patched licensecheck_patched.c

# Demostración del crash (entrada de 200 'A')
crash: licensecheck
	-./licensecheck $$(python3 -c 'print("A"*200)')

clean:
	rm -f licensecheck licensecheck_patched

.PHONY: all patched crash clean
