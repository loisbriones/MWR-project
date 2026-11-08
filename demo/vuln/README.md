# vuln/ — binario vulnerable de juguete (demo, Acto B)

**Educativo e inofensivo.** Programa en C con un desbordamiento de buffer clásico
(CWE-120/CWE-787) para que el LLM lo detecte en Ghidra y proponga el parche.

- `licensecheck.c` — versión **vulnerable** (usa `strcpy` a un buffer de 32 bytes).
- `licensecheck_patched.c` — **parche de referencia** (copia acotada con `snprintf` + rechazo
  de entradas largas). Úsalo para comparar con lo que proponga la IA.
- `Makefile` — targets: `make` (compila la vulnerable), `make patched`, `make crash`,
  `make clean`.

> Flags del Makefile desactivan protecciones (`-fno-stack-protector`, `-no-pie`,
> `_FORTIFY_SOURCE=0`) **solo** para que el overflow sea visible en el laboratorio.

## Flujo de la demo
```bash
make                                             # compila la versión vulnerable
./licensecheck "MWR-2026-DEMO"                   # [OK] licencia valida
./licensecheck $(python3 -c 'print("A"*200)')    # crash (SIGSEGV) por el overflow
# -> decompilar en Ghidra, el LLM diagnostica (CWE-120) y propone parche
# -> aplicar el parche sobre licensecheck.c (o usar licensecheck_patched.c) y recompilar
make clean && make
./licensecheck $(python3 -c 'print("A"*200)')    # ahora: rechazo controlado, sin crash
```

> No se ha compilado nada al preparar este material; ejecútalo tú cuando montes la demo.
