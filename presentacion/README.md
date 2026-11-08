# Presentación — Generative AI-Assisted Malware Disassembly and Remediation

Diapositivas en **inglés** hechas con **Typst + Touying (tema Metropolis)**.

## Compilar a PDF
```bash
typst compile slides.typ slides.pdf
```
La primera vez descarga el paquete `touying` del registro de Typst (necesita red una vez).

## Estructura
- `slides.typ` — fuente de la presentación.
- `assets/` — imágenes/diagramas si se añaden.
- 22 diapositivas (título + agenda + 6 divisores de sección con índice resaltado + contenido + cierre), pensadas para ~20 min con demo.

## Notas
- El índice se repite en cada cambio de tema resaltando la sección actual (función `agenda()` en `slides.typ`).
- Rellenar `Author 1/2/3` con los nombres reales en la portada y en la diapositiva de créditos.
