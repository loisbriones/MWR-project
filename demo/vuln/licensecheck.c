/* licensecheck.c  --  BINARIO DE JUGUETE PARA LA DEMO (vulnerable a propósito)
 *
 * Educativo: contiene un desbordamiento de buffer clásico (CWE-120 / CWE-787)
 * por copiar una entrada de longitud arbitraria con strcpy() a un buffer fijo.
 * Sirve para que el LLM lo detecte en el pseudocódigo de Ghidra y proponga el parche.
 *
 * NO es malware. Compilar y ejecutar en el host es seguro.
 *
 * Compilar:  make           (ver Makefile; se desactivan protecciones para que el
 *                            desbordamiento sea visible en la demo)
 * Probar:    ./licensecheck AAAA...(200 A's)   -> crash (SIGSEGV)
 */
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

/* "Valida" una clave de licencia copiándola a un buffer local (¡sin comprobar tamaño!). */
int check_license(const char *input) {
    char key[32];          /* buffer fijo */
    strcpy(key, input);    /* <-- VULNERABILIDAD: sin límite de longitud */
    if (strcmp(key, "MWR-2026-DEMO") == 0) {
        return 1;          /* licencia válida */
    }
    return 0;              /* licencia inválida */
}

int main(int argc, char **argv) {
    if (argc != 2) {
        fprintf(stderr, "Uso: %s <clave-de-licencia>\n", argv[0]);
        return 2;
    }
    if (check_license(argv[1])) {
        printf("[OK] Licencia valida. Bienvenido.\n");
        return 0;
    } else {
        printf("[X] Licencia invalida.\n");
        return 1;
    }
}
