/* licensecheck_patched.c  --  VERSIÓN PARCHEADA DE REFERENCIA
 *
 * Parche esperado que el LLM debería proponer: copiar con límite de tamaño
 * (snprintf / strncpy + terminador) y/o rechazar entradas demasiado largas.
 * CWE-120/CWE-787 mitigada.
 */
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int check_license(const char *input) {
    char key[32];
    /* Parche: copia acotada al tamaño del buffer y terminación garantizada. */
    if (strlen(input) >= sizeof(key)) {
        return 0;  /* entrada demasiado larga -> rechazo controlado, sin overflow */
    }
    snprintf(key, sizeof(key), "%s", input);
    return strcmp(key, "MWR-2026-DEMO") == 0;
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
