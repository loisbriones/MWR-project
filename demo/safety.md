# Reglas de laboratorio (leer antes de grabar la demo)

> ⚠️ Nada de esto se instaló ni ejecutó automáticamente. Es documentación para que
> decidáis cómo montar el laboratorio con calma.

## Principios
1. **Muestra real SOLO en VM aislada.** Usa una VM (VirtualBox/VMware/KVM) con:
   - Red en modo *host-only* o directamente **sin red** (NAT desconectado).
   - **Snapshot** limpio antes de empezar; restaurar al terminar.
   - Carpetas compartidas **deshabilitadas** mientras la muestra esté presente.
2. **Solo lectura/análisis estático** de la muestra real. No la ejecutes si no es
   imprescindible; para la demo basta con abrir su decompilación en Ghidra.
3. **No distribuir binarios maliciosos.** No subáis la muestra al repo ni al PDF; en el
   vídeo mostrad solo pseudocódigo/indicadores. Descargad la muestra de un repositorio de
   investigación reconocido (p. ej. MalwareBazaar) y con contraseña, bajo vuestra
   responsabilidad y la normativa de la universidad.
4. **El binario vulnerable propio (`vuln/`) es inofensivo**: es un programa de juguete que
   escribimos nosotros; se puede compilar y ejecutar en el host sin riesgo.

## Alternativa 100% sin muestra real
Si preferís cero riesgo, **omitid el Acto A con WannaCry** y basad toda la demo en el
binario vulnerable propio (Acto B). Sigue demostrando el ciclo completo
decompilar → la IA detecta el fallo → propone parche → recompilar → arreglado.
