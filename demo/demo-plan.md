# Guion de la DEMO — 2 partes: manual vs. asistido por IA

**Formato:** grabación de pantalla **sin locución** (`VIDEOS/VIDEO_FINAL.mp4`, ≈7 min) que el
ponente **pausa y narra en directo**. Se lanza desde la slide 17 ("▶ Demo: manual vs. AI-assisted").
Antes de darle al play se cuenta en voz el "antes" de 2017 (kill-switch registrado ≈7 h
después del inicio del brote; fuentes en la slide de References) y el "después" (las dos
partes). Texto completo en `guion/guion.typ`, apartado "Slide 18".

> Enfoque **defensivo** y **solo estático**: la muestra se abre en Ghidra, **nunca se ejecuta** y
> no se distribuye. Ver `safety.md`.

**Muestra:** componente gusano de WannaCry (`mssecsvc.exe`), fichero `wannacry_mssecsvc.exe.bin`
SHA256 `24d004a104d4d54034dbcffc2a4b19a11f39008a575aa614ea04703480b1022c`
(guardada fuera del repo, en `wannacry-lab/`).

---

## Montaje del vídeo (según `VIDEOS/VIDEO_FINAL.kdenlive`)

| Tramo en el vídeo | Clip de origen | Qué se ve |
|---|---|---|
| 0:00 – 1:48 | `EjemploAnalisisManual.mp4` | **Parte 1: análisis manual** en Ghidra |
| 1:48 – 2:37 | `wannacry_MCP.mp4` (velocidad real) | Parte 2: prompt a Claude Code + primeras llamadas a GhidraMCP |
| 2:37 – 3:38 | `wannacry_MCP.mp4` **acelerado ×10** | Claude trabajando (≈10 min reales comprimidos en ≈1 min) |
| 3:38 – 7:05 | `wannacry_MCP.mp4` (velocidad real) | Resultados: resumen, informe, YARA, funciones renombradas en Ghidra, pregunta de seguimiento |

---

## Parte 1 — Análisis manual en Ghidra (≈1:50)

- **Qué se ve:**
  1. Se importa el binario en un proyecto limpio (`WannaCryManual`) y salta el aviso de análisis (falta el PDB, normal).
  2. Decompilado de `entry`: código de arranque del compilador, variables `uVar1`, `local_70`, `DAT_...`, llamadas a `FUN_00408140`. **Nada tiene nombre**.
  3. *Symbol Tree → Functions*: una lista de `FUN_0040xxxx` sin pistas.
  4. *Window → Defined Strings* (361 cadenas): primero ruido del runtime (días, meses, errores `R60xx`) y, bajando, cosas raras: `\\%s\IPC$`, `mssecsvc2.0`, `Microsoft Security Center (2.0) Service`, `tasksche.exe`, `C:\%s\qeriuwjhrf` y la **URL del kill-switch** en `0x004313d0`.
- **Qué narras:**
  - "Así empieza un analista: binario sin símbolos, cientos de funciones `FUN_...` y pseudo-C sin nombres."
  - "La vía rápida son las *strings*: aquí aparece una URL rarísima, un servicio que se hace pasar por Microsoft y un `tasksche.exe`. Son pistas, pero todavía no sé **qué hace** cada cosa ni **dónde**."
  - "A partir de aquí habría que seguir referencias, función a función, renombrando a mano. Eso son **horas**: es la fatiga del meme del minero."

## Parte 2 — El mismo binario con Claude Code + GhidraMCP (≈5 min de vídeo, ≈10 min reales)

- **Montaje:** Ghidra con el binario (proyecto `WannaCryAuto`) + Claude Code conectado a Ghidra por **GhidraMCP**. El modelo es Opus en Claude Code, en el directorio `pruebas/`.
- **Prompt usado (neutro: no dice que es WannaCry):**
  > Tengo un binario PE abierto en Ghidra (conectado por GhidraMCP). No sé qué es pero contiene
  > un malware. Quiero que:
  > 1. Lo analices y me hagas un informe de lo que hace (comportamiento y propósito).
  > 2. Me des las evidencias para detectarlo: indicadores de host, fichero y red (IOCs), y
  >    cites la dirección o cadena del binario donde encontraste cada uno, para poder verificarlo.
  > 3. Con los indicadores que recojas, escribas una o varias reglas YARA para detectar esta
  >    muestra (y su familia si es posible).
  > 4. Renombres las funciones relevantes y añadas comentarios cortos en Ghidra para reflejar su
  >    intención, y así poder revisar tu análisis después.
  >
  > Trabaja solo a partir del binario y verifica tus afirmaciones contra él.
- **Qué se ve (en orden):**
  1. Claude llama a Ghidra por MCP (`list_strings`, `list_imports`, `decompile_function`...).
  2. Tramo acelerado: "Análisis principal completo", "Ahora renombro las funciones" (32 llamadas), "Comentarios añadidos" y "Ahora escribo las reglas YARA". Prueba las reglas con `yara-python` en un entorno temporal.
  3. Resumen final: es **WannaCry (WanaCrypt0r 2.0), componente gusano `mssecsvc.exe`**, identificado "por el código, no por el nombre del fichero". Contiene:
     - **Kill-switch** en `0x408140` (URL en `0x4313d0`): si la URL responde, sale.
     - **Instalación**: servicio `mssecsvc2.0` y suelta el cifrador `tasksche.exe` (recurso `R`/1831).
     - **Gusano**: 1 hilo LAN + 128 hilos a IPs aleatorias, TCP/445, comprobación MS17-010, DoublePulsar, EternalBlue.
     - **IOCs** en tablas, cada uno con su dirección.
     - **4 reglas YARA** probadas: detectan la muestra y dan **0 falsos positivos en 2.985 ejecutables legítimos**.
     - **31 funciones renombradas** con comentarios en Ghidra.
  4. Informe abierto en el editor (`pruebas/informe_wannacry_mssecsvc.md`) y la regla (`pruebas/wannacry_mssecsvc.yar`).
  5. En Ghidra, el *Symbol Tree* ya tiene nombres legibles (`WinMain_KillSwitchCheck`, `SMB_CheckVulnMS17_010`, `SMB_ExploitEternalBlue`, `Worm_LanHostThread`...).
  6. Pregunta de seguimiento sobre la función en la que está el cursor (`entry`). Claude explica que es el arranque estándar de MSVC 6, la renombra a `WinMainCRTStartup` y añade un comentario.
  7. Siguiente pregunta: "ahora analiza la función 0x408140", el kill-switch.
- **Qué narras:**
  - "Mismo binario, pero ahora con la IA conectada a Ghidra. El prompt **no dice qué es**: le pido informe, IOCs con su dirección, YARA y que renombre."
  - (acelerado) "Esto son unos 10 minutos reales. Fijaos en que no solo responde: **usa Ghidra**, renombra y comenta, y **prueba** sus reglas YARA."
  - (resultados) "Lo identifica como WannaCry, explica el kill-switch, la instalación y la propagación por SMB, y cada afirmación lleva **su dirección** para que yo la compruebe."
  - (Ghidra renombrado) "Lo que a mano eran horas de renombrar, aquí está hecho, y puedo revisarlo."
  - **Nota honesta:** "Lo reconoce muy rápido **en parte por las strings en claro** y porque WannaCry es muy conocido. Con una muestra ofuscada o nueva sería más lento y más propenso a alucinar. Por eso **verificamos**."

## Verificación (lo que comprobamos contra el binario)
- La URL en `0x004313d0`: *References to* → solo la usa `0x408140` (kill-switch).
- El puerto 445 aparece como constante `0x1bd` en la comprobación de puerto (`0x407480`).
- El recurso `R` / id `0x727` (1831) es el cifrador que se escribe como `tasksche.exe`.
- Las reglas YARA disparan sobre la muestra y no sobre ejecutables legítimos.
- **Limitaciones que el propio informe reconoce:**
  - el cifrador y las DLL solo se identifican por cadenas, imports y hashes;
  - el exploit EternalBlue se describe por su estructura, sin decompilarlo paquete a paquete;
  - no hay validación dinámica.

## Cierre (vuelta a las slides)
"Manual: horas para orientarse. Con IA: minutos para un informe completo. Pero el paso que **no**
quitamos es la **verificación contra el binario**." → slides 18/19 (Takeaways).

## Material
- Vídeos: `VIDEOS/EjemploAnalisisManual.mp4`, `VIDEOS/wannacry_MCP.mp4`, montaje final `VIDEOS/VIDEO_FINAL.mp4`.
- Resultado del análisis con IA: `pruebas/informe_wannacry_mssecsvc.md`, `pruebas/wannacry_mssecsvc.yar`.
- Análisis previo verificado y tiempos 2017 vs. IA: `analisis/informe-wannacry.md`, `analisis/wannacry_killswitch.yar`, `analisis/tiempos-2017-vs-ia.md`.
- Cómo hacer el análisis manual sin tocar la muestra: `analisis/manual-sin-riesgo.md`.

## Checklist antes de presentar
- [ ] `VIDEO_FINAL.mp4` **en local** (no depender de internet) y probado en el portátil de la presentación.
- [ ] Saber en qué segundo pausar: 1:48 (fin de la parte manual), 3:38 (resultados), ≈5:45 (Ghidra renombrado).
- [ ] No mostrar rutas personales ni el binario descargable.
