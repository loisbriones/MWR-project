# Guion de la DEMO (grabada, ~4 min) — cronometrada

Objetivo: mostrar, con **cronómetro en pantalla**, cómo el flujo con IA acelera
(a) la **comprensión** de una muestra y (b) la **remediación** de un fallo, dejando claro
que **siempre se verifica**. Enfoque **defensivo**: IOCs/YARA/mitigación y parcheo de un
binario **propio**. Nada de distribuir malware. Ver `safety.md` antes.

> ❗ Durante la preparación de este material **no se instaló ni descargó nada**. Abajo tienes
> qué instalar, enlaces y comandos para montarlo tú cuando quieras.

---

## 0) Qué instalar (una vez, con calma)

| Pieza | Para qué | Enlace |
|------|----------|--------|
| **Ghidra** | Decompilar a pseudo-C | https://ghidra-sre.org/ · https://github.com/NationalSecurityAgency/ghidra |
| **JDK 21+** | Requisito de Ghidra | (OpenJDK) |
| **GhidraMCP** | Puente Ghidra ↔ LLM (MCP) | https://github.com/LaurieWired/GhidraMCP |
| **Cliente LLM con MCP** | El "cerebro" (Claude Desktop / Cline / Claude Code…) | según preferencia |
| **gcc + gdb** | Compilar/ejecutar el binario vulnerable propio | paquetes del sistema |
| **(opcional) grabador** | OBS Studio para el vídeo + overlay de cronómetro | https://obsproject.com |

Instalación de GhidraMCP (resumen de su README): instalar el plugin `.zip` desde el
*Extension Manager* de Ghidra, reiniciar, activarlo en *File → Configure*, y lanzar el
servidor puente (SSE, por defecto `localhost:8080`); configurar el cliente LLM para que
apunte a ese servidor MCP.

---

## ACTO A — Comprensión acelerada (muestra documentada, en VM aislada) · ~1:30

> Si preferís cero riesgo, saltad el Acto A (ver `safety.md`, alternativa sin muestra real).

**Antes/después (narrativa):** "En 2017, frenar WannaCry fue un analista leyendo el código
a mano para hallar el kill-switch. Veamos cuánto tardamos hoy, con verificación."

1. **[Cronómetro ON]** En la VM, abrir en Ghidra una función ya decompilada de la muestra
   (p. ej. la rutina que comprueba el dominio "kill-switch", o la lógica de propagación).
2. Pedir al LLM (vía GhidraMCP), con prompts como:
   - *"Explain what this function does in plain English."*
   - *"Rename variables/functions to reflect intent and list suspicious API calls."*
   - *"What host/network indicators (IOCs) would detect this? Draft a YARA rule."*
3. **Verificar** rápido 1–2 afirmaciones del LLM contra el binario (cross-refs, strings) →
   recalca que no nos lo creemos a ciegas.
4. **Salida defensiva en pantalla:** resumen de comportamiento + IOCs + **regla YARA** +
   mitigación (deshabilitar **SMBv1** / aplicar **MS17-010**). **[Cronómetro OFF]**

**Mensaje:** triaje + artefactos defensivos en *minutos*, no horas — *con verificación*.

---

## ACTO B — Remediación end-to-end (binario vulnerable PROPIO) · ~2:00

Material en `vuln/` (código fuente + Makefile; **no compilado** aquí).

1. **Mostrar el fallo [Cronómetro ON].**
   ```bash
   cd vuln && make
   ./licensecheck $(python3 -c 'print("A"*200)')   # desbordamiento -> crash (SIGSEGV)
   ```
   Enseña el crash (o con `gdb ./licensecheck` el PC sobrescrito).
2. **Decompilar** `licensecheck` en Ghidra → abrir la función `check_license`.
3. **Pedir el diagnóstico y el parche al LLM** (vía GhidraMCP) con prompts:
   - *"Here is the decompiled function. What is the vulnerability and the exact CWE?"*
     (esperado: **CWE-120/CWE-787**, buffer overflow por `strcpy` a un buffer fijo)
   - *"Propose a minimal, safe patch for the original C source."*
     (esperado: usar `strncpy`/`snprintf` con tamaño, o validar longitud; evitar `gets`)
4. **Aplicar el parche** (editar `licensecheck.c` según la propuesta) y **recompilar**:
   ```bash
   make clean && make
   ./licensecheck $(python3 -c 'print("A"*200)')   # ahora: rechazo controlado, sin crash
   ```
5. **[Cronómetro OFF]** Comparar el tiempo total con la estimación manual.

**Mensaje:** la IA **propuso** el parche; nosotros lo **verificamos** recompilando y
reprobando el exploit. Ciclo completo detectar → remediar → confirmar.

---

## Cierre (en el vídeo)
Una frase sobre el cronómetro: "Lo que a mano lleva bastante más, aquí son minutos — pero el
paso que no quitamos es la **verificación**." Enlaza con la slide de conclusiones.

## Checklist de grabación
- [ ] Snapshot de la VM + sin red (Acto A).
- [ ] Overlay de cronómetro visible (OBS).
- [ ] Capturas de respaldo por si falla algo en directo.
- [ ] No mostrar rutas/datos sensibles ni el binario malicioso descargable.
- [ ] Duración total ≈ 4 min.
