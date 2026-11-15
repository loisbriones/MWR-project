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
4. **Ghidra no ejecuta nada.** Importar, decompilar, renombrar o dejar que la IA lea el
   binario por GhidraMCP es análisis **estático**: la muestra nunca corre. Ghidra trabaja sobre
   una copia dentro de su proyecto; el `.bin` original queda en solo-lectura
   (ver `analisis/manual-sin-riesgo.md`).
5. **Los proyectos de Ghidra no se suben** (`*.gpr`, `*.rep/` están en el `.gitignore` raíz),
   porque contienen la muestra importada.

## Lo que se hizo en la demo final
Las dos partes (manual y con Claude Code + GhidraMCP) son **solo estáticas** sobre la misma
muestra de WannaCry. **No se ejecutó la muestra** en ningún momento; las únicas cosas que se
ejecutaron fueron las pruebas de las reglas YARA (`yara-python`) sobre ficheros.
