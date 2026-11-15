// ============================================================
//  GUION / HANDOUT  (ESPAÑOL)  --  compilar:  typst compile guion.typ guion.pdf
//  Documento de apoyo para estudiar el tema y para hablar en cada diapositiva.
//  Para CADA diapositiva hay dos bloques SEPARADOS:
//    [HABLAR]        -> lo que dices en voz alta (fácil de traducir al inglés)
//    [PROFUNDIZAR]   -> explicación técnica + cifras + referencias citadas
// ============================================================

#set document(title: "Guion — AI-Assisted Malware Disassembly & Remediation")
#set page(
  paper: "a4",
  margin: (x: 2.2cm, y: 2.2cm),
  numbering: "1",
  header: context {
    if counter(page).get().first() > 1 [
      #set text(size: 8pt, fill: gray)
      Guion — AI-Assisted Malware Disassembly & Remediation
      #h(1fr) Máster en Ciberseguridad · Malware
      #line(length: 100%, stroke: 0.4pt + gray)
    ]
  },
)
#set text(font: ("Libertinus Serif", "DejaVu Serif"), size: 10.5pt, lang: "es")
#set par(justify: true, leading: 0.62em)
#show heading.where(level: 1): it => block(above: 1.1em, below: 0.6em)[
  #set text(size: 15pt, fill: rgb("#23373b"))
  #it.body
]
#show heading.where(level: 2): it => block(above: 1.0em, below: 0.45em)[
  #set text(size: 12pt, fill: rgb("#eb811b"))
  #it.body
]
#show link: it => text(fill: rgb("#1a5fb4"))[#underline(it)]

// ---- Helpers: los dos tipos de bloque ----
#let hablar(body) = block(width: 100%, fill: rgb("#eef5f6"), inset: 10pt, radius: 4pt,
  stroke: (left: 3pt + rgb("#23373b")))[
  #text(weight: "bold", fill: rgb("#23373b"))[🎤 QUÉ DECIR] \
  #body
]
#let profundizar(body) = block(width: 100%, fill: rgb("#fdf1e3"), inset: 10pt, radius: 4pt,
  stroke: (left: 3pt + rgb("#eb811b")), above: 0.6em)[
  #text(weight: "bold", fill: rgb("#eb811b"))[📚 PROFUNDIZACIÓN Y REFERENCIAS] \
  #body
]

// =================== PORTADA ===================
#align(center + horizon)[
  #text(size: 22pt, weight: "bold", fill: rgb("#23373b"))[Guion de la presentación]
  #v(0.3em)
  #text(size: 15pt)[Generative AI-Assisted Malware Disassembly and Remediation]
  #v(0.2em)
  #text(size: 11pt, fill: gray)[Máster en Ciberseguridad — Análisis de Malware · 3 autores · ≈20 min]
  #v(1em)
  #text(size: 10pt)[Diapositivas en inglés · guion en español. \
  Cada apartado = una diapositiva, con los dos bloques (qué decir / profundizar).]
]
#pagebreak()

#outline(title: [Índice de diapositivas], depth: 1, indent: 1em)
#pagebreak()

// =================== CÓMO USAR ===================
= Cómo usar este guion

#text(size: 10pt)[
Lee primero el bloque *🎤 Qué decir* para cada diapositiva: es el discurso base (3–6 frases), pensado para traducir fácil al inglés al hablar (las slides ya están en inglés → punto extra del profesor). El bloque *📚 Profundización* es para que *entiendas* de verdad el tema y puedas responder preguntas: trae las cifras exactas, sus matices y las referencias. No hace falta decir todo lo de profundización en voz alta.

*Reparto sugerido (3 ponentes):* Autor 1 → slides 1–8 · Autor 2 → slides 9–16 · Autor 3 → slides 17–19.
*Ritmo:* ≈1 min por slide de contenido + ≈7 min de vídeo-demo (se puede pausar o saltar tramos). Los divisores de agenda son transiciones de 5–10 s ("ya hemos visto X, ahora vamos a Y").

*Numeración:* el número de cada apartado de este guion es el del PDF *+1* (la portada no lleva número en el pie). Por eso cada apartado indica también "(pie: N)" cuando hace falta.
]

// =================== SLIDE 1 ===================
= Slide 1 — Portada (Title)

#hablar[
"Buenos días. Somos [nombres] y nuestra presentación trata sobre *IA generativa aplicada al desensamblado y la remediación de malware*: cómo los grandes modelos de lenguaje ayudan a hacer ingeniería inversa y a proponer parches más rápido, y también dónde siguen fallando. El subtítulo lo resume: aceleran el trabajo, pero no sustituyen al analista."
]
#profundizar[
Contexto del tema (enunciado): los LLM ayudan al analista a *interpretar código decompilado* (p. ej. el pseudo-C de Ghidra), *identificar la vulnerabilidad explotada* y *proponer mitigaciones/parches*. Vamos a contrastar el flujo manual con el aumentado por IA evaluando *velocidad, precisión y riesgo de alucinaciones*, y cerramos con una demo grabada. Mantén el marco honesto desde el inicio: "co-piloto", no "piloto automático".
]

// =================== SLIDE 2 ===================
= Slide 2 — Agenda

#hablar[
"Esta es la hoja de ruta: primero el *contexto* y por qué esto importa; luego las *herramientas* que se usan; después comparamos el *flujo manual con el aumentado por IA*; repasamos la *evidencia* (velocidad, precisión y alucinaciones); hacemos una *demo*; y cerramos con *conclusiones*."
]
#profundizar[
La agenda se repite en cada cambio de sección resaltando dónde estamos (requisito de organización del profesor → puntúa en "Presentación y Organización"). Son 6 secciones. Di la transición en una frase y pasa rápido.
]

// =================== SECCIÓN 1 ===================
= Slide 3 — Divisor: Context & Motivation

#hablar[
"Empecemos situando el problema: ¿por qué necesitamos acelerar esto?"
]
#profundizar[Transición. No te detengas.]

= Slide 4 — Reverse engineering is slow, scarce and expensive

#hablar[
"La ingeniería inversa de malware es un cuello de botella: desensamblar, decompilar y analizar dinámicamente una muestra puede llevar *horas o días*, y depende de expertos escasos. Al mismo tiempo aparecen *cientos de miles* de muestras nuevas al día y hay un *backlog enorme de CVEs sin parchear*. Leer ensamblador o pseudocódigo ruidoso es difícil y propenso a errores. La pregunta es: ¿puede la IA generativa reducir el tiempo hasta entender y hasta parchear, sin mentirnos?"
]
#profundizar[
- *Gráfica CVEs por año*: muestra la explosión de vulnerabilidades reportadas (agravada por el uso de IA en la generación y descubrimiento de fallos), llevando el volumen de parches pendientes a niveles insostenibles para equipos humanos.
- Volumen: AV-TEST registra del orden de *450.000+ nuevas muestras de malware/PUA al día* (ver #link("https://www.av-test.org/en/statistics/malware/")[AV-TEST malware statistics]). Usa "cientos de miles/día" para ir sobre seguro.
- "Sin mentirnos" anticipa el hilo conductor: las alucinaciones (slide 16 del guion).
- *Decompilación vs. desensamblado*: desensamblar = pasar bytes a instrucciones de ensamblador; decompilar = reconstruir pseudo-C de más alto nivel. El decompilador *adivina* tipos y flujo → salida aproximada, sin nombres ni comentarios originales. Esa es la entrada ruidosa que damos al LLM.
]

= Slide 5 — The promise of LLMs

#hablar[
"¿Qué aporta un LLM aquí? Tres cosas: *explicar* el pseudocódigo en lenguaje natural, *renombrar* funciones y variables para recuperar la intención del código, y *proponer* una hipótesis del fallo y un borrador de mitigación o parche. Pero —y esto es clave en toda la charla— el LLM es un *acelerador y co-piloto*, no un sustituto del analista: todo lo que diga hay que *verificarlo contra el binario*."
]
#profundizar[
Este es el *framing honesto* que pide un trabajo de calidad y que nos cubre ante preguntas. El valor del LLM es sobre todo de *comprensión y triaje*, no de garantía de corrección. Enlaza con la evidencia posterior: gran mejora para no-expertos, mejora pequeña para expertos.
]

// =================== SECCIÓN 2 ===================
= Slide 6 — Divisor: The Toolchain

#hablar["Para entendernos, situemos rápido las herramientas que se usan."]
#profundizar[Transición de 5 s.]

= Slide 7 — The classic RE stack

#hablar[
"El punto de partida es el stack clásico, en dos columnas. En *análisis estático* (leer el binario sin ejecutarlo): decompiladores como *Ghidra* —gratuito, de la NSA—, IDA Pro o Binary Ninja, más utilidades como `strings` y la lectura de cabeceras PE/ELF e imports. En *análisis dinámico* (ejecutarlo y observar): depuradores como x64dbg o GDB, y sandboxes como Cuckoo/CAPE en máquinas virtuales aisladas. Una idea importante: el *pseudocódigo no es el código fuente*; el decompilador adivina tipos y flujo. Ese es precisamente el texto ruidoso que luego le pedimos interpretar a la IA."
]
#profundizar[
- *Ghidra*: suite de RE de la NSA, open-source (#link("https://ghidra-sre.org/")[ghidra-sre.org]); su decompilador genera pseudo-C. Es el estándar gratuito y el que usa la mayoría de puentes con LLM.
- *Sandbox*: ejecución controlada para observar comportamiento (red, ficheros, registro) sin leer código. Complementa el estático.
- Recalca el punto del pseudocódigo porque justifica por qué el LLM a veces alucina: trabaja sobre una reconstrucción imperfecta.
]

= Slide 8 — The LLM-augmented stack (diagrama)

#hablar[
"La clave es que el LLM no se usa copiando y pegando: se *conecta* a la herramienta. El diagrama muestra el flujo: del *binario* a *Ghidra*, y a través de un *puente MCP* el modelo accede a la API de Ghidra. El ejemplo más conocido es *GhidraMCP*, de LaurieWired, que expone funciones como listar y decompilar funciones, renombrar o mirar referencias cruzadas. Aunque también existen puentes para herramientas *dinámicas* (depuradores o logs de sandbox), nuestra presentación —y la mayor parte de la literatura actual— se centra en el bucle *estático* de decompilación y parcheo, dejando la ejecución dinámica para *verificar*. Así el agente *itera* —decompila, explica, renombra, vuelve a leer, propone parche— siempre con un *humano en el bucle*."
]
#profundizar[
- *MCP (Model Context Protocol)*: protocolo estándar para dar herramientas/datos a un LLM. *GhidraMCP* (#link("https://github.com/LaurieWired/GhidraMCP")[github.com/LaurieWired/GhidraMCP]) = plugin de Ghidra + servidor puente; permite a Claude/Cline/etc. pedir decompilaciones y renombrar automáticamente. Hay alternativas (p. ej. `suidpit/ghidra-mcp`).
- *¿Por qué estático aquí y qué pasa con el dinámico?* Un LLM no está limitado a análisis estático: también hay puentes MCP para depuradores (GDB/x64dbg) o para analizar trazas de sandbox. Sin embargo, el grueso de los trabajos de desensamblado/remediación (y el encuadre de esta charla) trabaja sobre el decompilador estático (Ghidra) y usa la parte dinámica (ejecución/tests/sandbox) como paso de verificación.
- La idea de "iterar con humano en el bucle" es lo que diferencia el flujo moderno del simple "pega el código en un chat". Es también lo que se ve en la parte 2 de la demo (Claude Code + GhidraMCP).
]

// =================== SECCIÓN 3 ===================
= Slide 9 — Divisor: Manual vs. AI-Augmented Workflow

#hablar["Con las herramientas situadas, comparemos los dos flujos de trabajo."]
#profundizar[Transición.]

= Slide 10 — Two lanes, same destination

#hablar[
"A la izquierda, el flujo *manual*: cargar el binario, mapear funciones a mano, leer el pseudocódigo línea a línea, deducir la intención, reproducir el comportamiento en sandbox y finalmente localizar el fallo y diseñar la mitigación. Horas o días, y la profundidad depende de la pericia del experto. A la derecha, el flujo *aumentado*: el agente decompila (vía Ghidra) y resume funciones en bloque, el LLM explica y renombra, el analista dirige con preguntas, la IA redacta IOCs, reglas YARA o un parche… y el analista *verifica contra el binario*. El triaje baja a minutos, pero el paso de verificación sigue siendo obligatorio."
]
#profundizar[
El mensaje de este par de carriles: la IA *no elimina* pasos críticos, los *reordena*. El esfuerzo humano se desplaza de *leer* a *verificar*. Útil para responder "¿entonces sobra el analista?": no, cambia su rol hacia validación y criterio.
]

= Slide 11 — Comedic relief: The human factor (Diamonds meme)

#hablar[
"Esta imagen resume con humor lo que ocurre en la práctica en el análisis manual: tras horas revisando ensamblador y pseudocódigo ruidoso, la fatiga cognitiva pasa factura y el analista puede rendirse o pasar por alto el detalle crítico —la vulnerabilidad, el kill-switch o el IOC clave— a escasos centímetros de encontrarlo. El valor de la IA aquí es actuar como co-piloto para evitar ese desgaste y asegurar que no dejamos diamantes sin picar."
]
#profundizar[
Pausa cómica y visual (el clásico meme del minero que se rinde a centímetros de los diamantes). Conecta con el problema real del triaje manual: la fatiga humana y los errores por agotamiento ante cientos de funciones. Enlaza con el ejemplo posterior de WannaCry (encontrar el kill-switch bajo presión) y da paso natural a la tabla comparativa.
]

= Slide 12 — Comparison table

#hablar[
"Resumido en una tabla: la IA gana claramente en *velocidad de triaje*, en *comprensión para no-expertos* y en *cobertura* del código. El flujo manual gana en una cosa decisiva: la *garantía de corrección*, porque está verificado por el analista. Y el gran riesgo del carril de IA son las *alucinaciones*: errores dichos con total confianza. En una frase: la IA desplaza el esfuerzo de leer a verificar."
]
#profundizar[
Las filas están pensadas para que cada una tenga un "ganador" distinto → evita vender la IA como superior en todo (eso es lo que el profesor premia como calidad técnica honesta). "Needs verification" y "Hallucinations" conectan directamente con la sección de evidencia.
]

// =================== SECCIÓN 4 ===================
= Slide 13 — Divisor: Evidence — Speed, Accuracy & Hallucinations

#hablar["¿Y qué dicen los datos? Vamos a la evidencia."]
#profundizar[Transición.]

= Slide 14 — Speed & comprehension

#hablar[
"Sobre velocidad y comprensión, el estudio *Decompiling the Synergy* de Arizona State University y EURECOM, con 48 participantes haciendo ingeniería inversa (NDSS 2026), arroja datos muy reveladores: la comprensión de los *novatos* mejoró alrededor de un *98%*, la *recuperación de artefactos* —como nombres de variables, tipos de datos y comentarios— subió *al menos un 66%*, y las funciones con *algoritmos conocidos* se triaron hasta *2,4 veces más rápido*. Pero —y este matiz es crucial— los *analistas expertos apenas ganaron velocidad*, y en ocasiones el LLM generó *alucinaciones dañinas* y pistas falsas. En definitiva: el impacto real y fiable de la IA es *asumir el trabajo tedioso* de fontanería y *bajar la barrera de entrada*, no reemplazar el juicio del experto."
]
#profundizar[
Estudio: "Decompiling the Synergy: An Empirical Study of Human–LLM Teaming in Software Reverse Engineering" (ASU / Univ. Padua / EURECOM, NDSS 2026) — #link("https://www.eurecom.edu/en/node/4899620")[ficha].
- *Metodología rigurosa*: 48 participantes (24 novatos y 24 expertos) analizando binarios estilo CTF representativos de software real durante más de 109 horas de actividad instrumentada.
- *Cifras y hallazgos clave*:
  + *Comprensión de novatos*: +≈98%, recortando casi por completo la brecha de comprensión inicial respecto a los expertos.
  + *Recuperación de artefactos (artifact recovery)*: ≥66% ("at least 66%") en reconstrucción de símbolos, nombres significativos de variables/funciones, tipos de datos y comentarios a partir del pseudocódigo plano de Ghidra.
  + *Triage de algoritmos conocidos*: hasta 2,4× más rápido reconociendo patrones estándar (criptografía, hashing, compresión).
- *Por qué ayuda en lo tedioso y no sustituye al analista experto*: renombrar manualmente decenas de variables anónimas (`local_18`, `uVar2`), tipar estructuras y entender rutinas estándar es el trabajo más pesado, repetitivo y fatigante de la ingeniería inversa. La IA automatiza esa "fontanería", liberando carga cognitiva. Sin embargo, los expertos ya infieren estos patrones casi de inmediato; para ellos, el LLM aporta poca aceleración neta e introduce fricción cuando produce alucinaciones sutiles que obligan a auditar el código con lupa. El análisis de alto nivel, la intuición y el juicio de seguridad siguen dependiendo enteramente del analista humano.
]

= Slide 15 — Remediation & patching (pie: 14)

#hablar[
"Pasamos de *entender* el código a *arreglarlo*, y aquí la foto es más dura. El benchmark *PatchEval*, de 2025, reúne *1.000 vulnerabilidades reales* (CVEs entre 2015 y 2025). En *230* de ellas hay además un entorno de ejecución donde se puede comprobar de verdad si el parche funciona. Resultado: el mejor modelo o agente solo arregla un *23%* (53 de 230). Lo interesante es que distintos modelos arreglan fallos distintos: si juntamos todos, al menos uno arregla 98, un *43%*. Otro estudio de 2026 mira *cómo se monta* el sistema. Un flujo fijo, paso a paso, es barato pero se rompe en cuanto algo falla. Los agentes de código generales, como Claude Code, son los que más fallos arreglan, pero tardan más y gastan más tokens. Y lo que más pesa no es el modelo, sino que el sistema pueda *probar el parche y reintentar*. La conclusión práctica: la IA *propone* el parche, y un humano junto con los tests *lo valida*."
]
#profundizar[
*PatchEval*: "PATCHEVAL: A New Benchmark for Evaluating LLMs on Patching Real-World Vulnerabilities" (arXiv 2511.11019, nov. 2025), #link("https://arxiv.org/abs/2511.11019")[enlace].
- *Dataset*: 1.000 vulnerabilidades de CVEs publicados entre 2015 y 2025, de 65 tipos de CWE. Un subconjunto de *230 CVEs* tiene *sandbox de ejecución* (compila y pasa tests/PoC), y es ahí donde se mide el éxito real.
- *Cifras exactas* (comprobadas en el PDF): el mejor LLM solo llega al *22,6%* y el mejor agente al *23,0%* (53/230, SWE-Agent con Gemini 2.5). Por eso la slide dice "best model/agent ≈23%".
- *Complementariedad* (Finding 5 del paper): *98* CVEs los arregla al menos un modelo (≈42,6%), pero *solo 5* los arreglan todos. Ese 43% es una *cota superior* ("oráculo": si supiéramos qué modelo usar en cada caso), no un sistema que ya exista. Si preguntan, matízalo así.
- La mayoría de los éxitos son *parches pequeños* (1–5 líneas); con fallos complejos la tasa cae mucho.
- PatchEval *no mide tiempo de reloj*.

*Estudio de arquitecturas*: "A Systematic Study of LLM-Based Architectures for Automated Patching" (Xu, Sheng, Chen, Huang; arXiv 2603.01257, mar. 2026), #link("https://arxiv.org/abs/2603.01257")[enlace]. Compara 4 paradigmas midiendo corrección del parche, tipos de fallo, *tokens* y *tiempo de ejecución*:
  + *Flujo fijo (pipeline)*: pasos predefinidos por código (localizar → generar parche → compilar/testear). Es eficiente y barato, pero *frágil*: si un paso falla, no se recupera.
  + *Un agente (single-agent)*: un LLM en bucle (tool-use / ReAct) que decide qué herramienta usar e itera con los errores. Equilibra flexibilidad y coste.
  + *Multi-agente*: varios roles (localizador, desarrollador del parche, revisor). Generaliza mejor, pero añade mucho *overhead* y riesgo de que el razonamiento "derive" en tareas complejas.
  + *Agentes de código generales* (SWE-agent, OpenHands, Claude Code...): *los mejores en conjunto*.
  Mensaje del paper: pesan más el *diseño de la arquitectura y la profundidad de iteración* que el modelo en sí.
- *Enlace con la demo*: nosotros usamos justo un agente de código general (Claude Code) conectado a Ghidra.
- Si preguntan por "tiempos de parcheo": estos benchmarks no dan una cifra fiable de reloj. Nuestra referencia de tiempo es la demo (≈10 min para el informe completo).
]

= Slide 16 — The hallucination problem (pie: 15)

#hablar[
"El gran problema son las *alucinaciones*. Tres formas típicas. La primera, *lógica inventada*: explicaciones plausibles pero falsas. La segunda, *renombrados engañosos*: una función llamada `decrypt_payload` que no descifra nada. La tercera, *baja recompilabilidad*: en el estudio piloto de DecLLM, un LLM por sí solo solo conseguía que el *25%* del código decompilado volviera a compilar (las reglas clásicas, un 9%). Hizo falta un *bucle de verificación* (compilar, ejecutar y corregir) para llegar a cerca del *70%*. Estos fallos explican por qué la IA sola es poco fiable para *clasificar malware*: el modelo solo lee texto estático y no ejecuta el binario, así que la ofuscación y las alucinaciones llevan a etiquetas erróneas. ¿La mitigación? *Verificar contra la verdad del binario*: recompilar, comparar comportamiento, ejecución simbólica y tests."
]
#profundizar[
- *DecLLM*: "LLM-Augmented Recompilable Decompilation..." (Wong et al., HKUST + Tencent Keen Lab, ISSTA 2025), #link("https://daoyuan14.github.io/papers/ISSTA25_DecLLM.pdf")[PDF].
  - *Estudio piloto*: con reglas se recompila el *9%*; con un LLM al que se le da todo el programa como contexto, el *25%*, que aún es insuficiente. Fallos observados: *attention degradation* (con entradas largas "olvida" instrucciones), *shortcuts* (abusa de casts para que compile) y *hallucination*.
  - *DecLLM* añade un bucle iterativo con *recompilación estática + feedback de ejecución dinámica* y alcanza *≈70%* de media (74% con GPT-3.5 y 78,3% con GPT-4 en su dataset principal). Reduce las alucinaciones un 31%.
  - *Moraleja*: la mejora viene del *bucle de verificación*, no del LLM solo. Es exactamente el mensaje de la charla.
- *D-LiFT / D-Score* (arXiv 2506.10125), #link("https://arxiv.org/abs/2506.10125")[enlace]: los pipelines previos introducen errores sintácticos/semánticos nuevos; proponen *puntuar* la precisión con el compilador (sintaxis) y con ejecución simbólica (semántica).
- *Renombrados engañosos*: `decrypt_payload` es un ejemplo inventado, no una función real. Un nombre erróneo es peor que `FUN_00401a30`, porque el genérico al menos no engaña. Enlaza con la demo: Claude renombra 31 funciones y deja comentario y dirección en cada una para poder comprobarlo.
- *Clasificación de malware*: el modelo solo ve código estático y el malware usa ofuscación. Si alucina sobre lo que hace el código, la *etiqueta* (familia, benigno/malicioso) hereda ese error. Por eso la verificación contra el binario es innegociable.
]

// =================== SECCIÓN 5 ===================
= Slide 17 — Divisor: Live Demo (pie: 16)

#hablar[
"Hasta ahora hemos visto cifras de artículos. Ahora vamos a verlo con nuestros propios ojos: un análisis *manual* frente a uno *asistido por IA*, sobre la *misma muestra real*."
]
#profundizar[
Transición de 5–10 s. El título dice "Live", pero es una *grabación que narras en directo*. Dilo claro para no dar una impresión falsa: "lo hemos grabado para no depender de la red ni de que el modelo tarde, pero os lo voy comentando en directo".
]

= Slide 18 — ▶ Demo: manual vs. AI-assisted (pie: 17)

#text(size: 9.5pt, fill: gray)[La diapositiva "Demo: before / after" se ha quitado del PDF porque ocupaba más de lo que aportaba. Su contenido se dice *en voz*, aquí, justo antes de darle al play. El vídeo `VIDEOS/VIDEO_FINAL.mp4` dura ≈7 min y no tiene voz: lo narras tú y lo pausas donde haga falta.]

#hablar[
"Primero, el *antes*. El 12 de mayo de 2017, WannaCry infectó cientos de miles de equipos en pocas horas. Unas *7 horas* después del inicio, un investigador registró un dominio rarísimo que el malware consultaba, y la propagación se frenó. Pero *por qué* la frenó (que era un *kill-switch*) se confirmó después, leyendo el código a mano y bajo presión.

El *después* es nuestra demo, con la *misma muestra*: el componente gusano de WannaCry. Dos carriles. Uno: análisis *manual* en Ghidra, con funciones sin nombre, pseudo-C ruidoso y pistas sueltas en las strings. Dos: el *mismo binario* con *Claude Code conectado a Ghidra por MCP* y un único prompt neutro que no dice qué es. En unos 10 minutos reales lo identifica como WannaCry y hace un informe con direcciones, IOCs y cuatro reglas YARA probadas sin falsos positivos. Además, renombra 31 funciones en Ghidra. Y luego viene lo más importante: *comprobamos* sus afirmaciones contra el binario. Vamos con la demo.»
]
#profundizar[
*Cronología de WannaCry* (detalle y fuentes en `demo/analisis/tiempos-2017-vs-ia.md`):
- 14-mar-2017: Microsoft publica *MS17-010* (parche SMBv1), *59 días antes* del ataque.
- 14-abr-2017: Shadow Brokers filtran *EternalBlue*.
- 12-may 07:44 UTC: primeras infecciones (T = 0).
- 12-may 15:03 UTC: Marcus Hutchins (MalwareTech) registra el dominio, *≈7 h* después.
  - Lo registró al verlo en el tráfico, como práctica habitual para monitorizar malware. Que era un kill-switch se confirmó *después*, analizando el código.
  - Fue en parte *accidental* y hubo más investigadores (Darien Huss). Di "≈7 h", no una hora exacta.
- El cuello de botella real de 2017 fue *desplegar* un parche que ya existía. La IA *no* acorta eso; si preguntan, reconócelo.

*Datos de nuestra demo* (todos medidos; informe en `pruebas/informe_wannacry_mssecsvc.md`):
- Muestra: `wannacry_mssecsvc.exe.bin`, SHA256 `24d004a1...1022c`, PE32 x86.
- *4 reglas YARA* probadas con yara-python 4.5.4: detectan la muestra y dan *0 falsos positivos en 2.985 ejecutables legítimos*.
- *31 funciones renombradas* + comentarios en Ghidra.
- Tiempo del agente: *≈10 min 35 s* (lo indica Claude Code al terminar, "Brewed for 10m 35s").
- En un ensayo anterior (9-nov), con otro prompt, se midió: kill-switch localizado en *36 s* e informe completo en *≈5 min 20 s*. Úsalo si preguntan "¿cuánto tarda en encontrar el kill-switch?".

*Comparación honesta*: no es la misma tarea que en 2017. Teníamos la muestra, sin presión, y el modelo *conoce WannaCry* por su entrenamiento, además de que las strings están en claro. Por eso cada afirmación del informe lleva *su dirección* y la verificamos.

*Direcciones para verificar* (por si te piden enseñarlo en Ghidra):
- Kill-switch: `0x408140` (URL en `0x4313d0`, se comprueba con *References to*).
- Puerto 445 = constante `0x1bd` en `0x407480`.
- Recurso `R`/1831 (`0x727`) = cifrador `tasksche.exe`.
]

#profundizar[
*Narración por tramos* (minutos del vídeo; guion completo en `demo/demo-plan.md`):
#table(columns: (auto, 1fr), inset: 5pt, stroke: 0.4pt + gray,
  [*0:00–1:48* \ Manual], [
    - Se ve: Ghidra importa el binario; decompilado de `entry` sin nombres; lista de funciones `FUN_...`; *Defined Strings*, primero ruido del runtime y luego `mssecsvc2.0`, `tasksche.exe`, `\\%s\IPC$` y la URL del kill-switch.
    - Dices: "Así empieza un analista: cientos de funciones sin nombre. Las strings dan pistas, pero aún no sé *qué hace* cada cosa ni *dónde*. Seguir esto a mano son horas."
  ],
  [*1:48–2:37* \ Prompt], [
    - Se ve: Claude Code junto a Ghidra. Prompt neutro: "binario PE, no sé qué es, contiene malware; informe, IOCs con su dirección, reglas YARA, renombra y comenta en Ghidra; verifica contra el binario".
    - Dices: "Mismo binario. El prompt *no dice qué es*. Fijaos en que pide evidencias con dirección."
  ],
  [*2:37–3:38* \ ×10], [
    - Se ve: tramo acelerado ×10. Claude llama a Ghidra, renombra (32 llamadas), comenta y escribe y *prueba* las reglas YARA.
    - Dices: "Esto son unos 10 minutos reales. No solo contesta: *usa Ghidra* y *prueba* lo que escribe."
  ],
  [*3:38–≈5:00* \ Resultado], [
    - Se ve: resumen final, WannaCry (componente gusano), kill-switch, instalación como servicio, propagación por SMB/445; IOCs, 4 reglas YARA, 0 falsos positivos; informe abierto en el editor.
    - Dices: "Cada afirmación lleva su dirección: eso es lo que me permite *verificar*."
  ],
  [*≈5:00–7:05* \ Ghidra], [
    - Se ve: *Symbol Tree* con nombres legibles (`WinMain_KillSwitchCheck`, `SMB_ExploitEternalBlue`...). Pregunta de seguimiento sobre la función del cursor: la renombra a `WinMainCRTStartup` y explica que es el arranque estándar de MSVC.
    - Dices: "Lo que a mano eran horas de renombrar está hecho y es revisable. Y puedo seguir preguntándole función a función."
  ],
)
*Frase de cierre*: "Manual: horas para orientarse. Con IA: minutos para un informe completo. *Pero* lo reconoce rápido en parte por las strings en claro y porque WannaCry es muy conocido. Con una muestra ofuscada sería más lento y más propenso a alucinar, y por eso el paso que *no* quitamos es la verificación."

*Si vas mal de tiempo*: salta el tramo 5:00–7:05 o reduce la parte manual a 1 min.
]

// =================== SECCIÓN 6 ===================
= Slide 19 — Divisor: Takeaways (pie: 18)

#hablar["Hemos visto el contexto, los datos y la demo. Cerremos con las ideas que queremos que os llevéis."]
#profundizar[Transición de 5 s.]

= Slide 20 — Takeaways (pie: 19)

#hablar[
"Cuatro ideas para llevarse.
- *Uno*: los LLM *aceleran* la ingeniería inversa asumiendo el *trabajo tedioso* (recuperar nombres, tipos y patrones conocidos) y *bajan la barrera de entrada* para no-expertos. Lo habéis visto en la demo: 31 funciones renombradas e informe en minutos.
- *Dos*: *no* sustituyen al analista experto. Los expertos apenas ganan velocidad, el parcheo autónomo funciona en torno al *23%* y las *alucinaciones* son reales.
- *Tres*: la disciplina que hace que funcione es *mantener un humano en el bucle* y *verificar cada salida contra el binario*.
- *Cuatro*: por eso la IA estática todavía *no es fiable para clasificar malware sola*: sin ver la ejecución, la ofuscación y las alucinaciones llevan a etiquetas erróneas.»
]
#profundizar[
Cada idea, con su respaldo:
1. *Tedioso y no-expertos*: estudio NDSS 2026 (novatos +≈98% de comprensión; recuperación de artefactos ≥66%; algoritmos conocidos hasta 2,4× más rápido). En la demo: 31 funciones renombradas, IOCs y 4 reglas YARA probadas en ≈10 min.
2. *Límites*: expertos con ganancia marginal (NDSS 2026); PatchEval 23% (53/230); DecLLM, donde un LLM solo deja el 75% del código sin recompilar.
3. *Verificación*: el binario es la única fuente de verdad (recompilar, tests, ejecución dinámica, revisar las direcciones que cita la IA). DecLLM llega al ≈70% precisamente gracias a ese bucle.
4. *Clasificación de malware*: sin ejecución dinámica, las etiquetas estáticas de familia o maliciosidad son vulnerables a ofuscación y alucinaciones. En nuestra demo acierta, pero ayudado por strings en claro y una familia muy conocida.
]

= Slide 21 — References (pie: 20)

#hablar[
"Aquí tenéis las referencias principales de los estudios, benchmarks y herramientas que hemos citado durante la presentación."
]
#profundizar[
Diapositiva de fuentes y referencias bibliográficas para respaldar todas las cifras de la charla. El listado completo y comentado con enlaces está en la sección final de este guion.
]

= Slide 22 — Thank you / Q&A

#hablar[
"Gracias. ¿Preguntas?"
]
#profundizar[
Preguntas probables (ligadas a los takeaways) y respuesta corta:
- *"¿En qué ayuda más la IA al analizar malware?"* → En el trabajo *pesado y repetitivo*: renombrar funciones y variables, resumir código y reconocer algoritmos conocidos. Así el analista llega antes a lo importante.
- *"¿Puede la IA sustituir al analista?"* → No. Los expertos apenas ganan velocidad, el parcheo automático solo acierta ≈23% y a veces se inventa cosas. El analista pasa de *leer* código a *revisar* lo que dice la IA.
- *"¿A quién le sirve más, a novatos o a expertos?"* → A los *novatos*: su comprensión sube ≈98%. Para un experto la mejora es pequeña, porque ya reconoce esos patrones solo.
- *"¿Cómo sabéis que lo que dice la IA es verdad?"* → No nos fiamos a ciegas: le pedimos la *dirección* de cada afirmación y la comprobamos en Ghidra. Si es código o un parche, se compila y se prueba.
- *"¿Por qué la IA sola no basta para clasificar malware?"* → Porque solo *lee* el código, no lo *ejecuta*. Si el malware está ofuscado o es nuevo, puede poner una etiqueta equivocada con total seguridad.
- *"¿La usaríais en un caso real?"* → Sí, como *asistente*: para el primer triaje y para quitarse trabajo tedioso. Pero siempre con una persona revisando el resultado antes de actuar.
]

#pagebreak()
// ============================================================
//  BIBLIOGRAFÍA Y DÓNDE AMPLIAR
// ============================================================
= Bibliografía y dónde ampliar información

#text(size: 9.5pt)[
Fuentes *verificadas* (arXiv/NDSS/repos reales) para rellenar y defender las diapositivas.
Cada entrada indica a qué *slide* da soporte. Si solo vas a leer 2–3, empieza por los *SoK/surveys* (apartado E): dan el panorama y enlazan al resto.
]

== A) Ingeniería inversa / decompilación asistida por LLM  → slides 5, 8, 14, 16

#text(size: 9.5pt)[
- *Decompiling the Synergy: Human–LLM Teaming in RE* (NDSS 2026, Eurecom / ASU) — #link("https://www.eurecom.edu/en/node/4899620")[ficha]. Estudio con 48 personas (24 novatos, 24 expertos); novatos +≈98% comprensión, ≥66% en recuperación de artefactos (símbolos, tipos, comentarios), hasta 2,4× en algoritmos conocidos; expertos con mejora marginal y presencia de alucinaciones dañinas. Fundamenta que el valor real está en mitigar el trabajo tedioso y democratizar el triaje. [Slides 14, 20]
- *LLM4Decompile: Decompiling Binary Code with LLMs* (arXiv 2403.05286, EMNLP 2024) — #link("https://arxiv.org/abs/2403.05286")[abs] · #link("https://github.com/albertan017/LLM4Decompile")[código]. Modelos abiertos (1.3B–33B) para decompilar; benchmark *Decompile-Eval* (recompilabilidad/re-ejecutabilidad en vez de solo tokens); la variante *-Ref* refina la salida de Ghidra. [Slides 5, 8]
- *DeGPT: Optimizing Decompiler Output with LLM* (NDSS 2024) — #link("https://www.ndss-symposium.org/ndss-paper/degpt-optimizing-decompiler-output-with-llm/")[paper] · #link("https://github.com/PeiweiHu/DeGPT")[código]. Mejora la *legibilidad* de la salida de Ghidra (−24,4% carga cognitiva; 62,9% de comentarios con semántica útil); usa 3 roles LLM + filtro MSSC para no cambiar la semántica. *Ejemplo concreto de "explicar/renombrar".* [Slides 8, 14]
- *DecLLM* (ISSTA 2025) — #link("https://daoyuan14.github.io/papers/ISSTA25_DecLLM.pdf")[PDF]. Piloto: reglas 9% → LLM con contexto completo 25%; con el bucle iterativo compilar+ejecutar de DecLLM ≈70% (74% GPT-3.5 / 78,3% GPT-4). Fallos: attention degradation, shortcuts, hallucination. [Slide 16]
]

== B) Remediación / parcheo automático (APR) con LLM  → slide 15

#text(size: 9.5pt)[
- *PatchEval* (arXiv 2511.11019, 2025) — #link("https://arxiv.org/abs/2511.11019")[abs]. 1.000 CVEs reales (230 con sandbox); mejor LLM 22,6% / mejor agente 23,0% (53/230); 98/230 arreglables por al menos un modelo, solo 5 por todos. [Slide 15]
- *A Systematic Study of LLM-Based Architectures for Automated Patching* (arXiv 2603.01257, 2026) — #link("https://arxiv.org/abs/2603.01257")[abs]. Compara workflow fijo / 1 agente / multi-agente / agentes de código; mide correctitud, *tiempo* y *tokens*. Útil si te preguntan por coste/tiempo. [Slide 15]
- *A Survey of LLM-based Automated Program Repair* (arXiv 2506.23749, 2025) — #link("https://arxiv.org/abs/2506.23749")[abs]. Clasifica 63 sistemas en 4 paradigmas (fine-tuning, prompting, procedural, agentic). *Buen mapa del área de parcheo.* [Slide 15]
- *LLM-based APR — Systematic Literature Review* (arXiv 2405.01466) — #link("https://arxiv.org/abs/2405.01466")[abs]. 189 trabajos (2020–2025), 20 tipos de bug incluyendo vulnerabilidades de seguridad. [Slide 15]
- *SEC-bench* (benchmark de seguridad; vía survey 2510.09721) — tasas reportadas ≈18% (PoC) y ≈34% (patching). Cítalo con cautela (dato secundario) como refuerzo de "el parcheo autónomo es difícil". [Slide 15]
]

== C) Alucinaciones, verificación y límites  → slide 16

#text(size: 9.5pt)[
- *D-LiFT / D-Score* (arXiv 2506.10125) — #link("https://arxiv.org/abs/2506.10125")[abs]. Los pipelines introducen errores sintácticos/semánticos nuevos; proponen *puntuar* precisión (compilador) y semántica (ejecución simbólica). *La idea "verifica contra el binario".* [Slide 16]
- Conexión con *clasificación de malware*: si el modelo alucina qué hace el código, la etiqueta (familia/benigno-malicioso) hereda el error → por eso la verificación es innegociable. Argumento de cierre. [Slides 16, 20]
]

== D) Herramientas y puentes (Ghidra, MCP)  → slides 7, 8 y demo

#text(size: 9.5pt)[
- *Ghidra* (NSA, open-source) — #link("https://ghidra-sre.org/")[ghidra-sre.org] · #link("https://github.com/NationalSecurityAgency/ghidra")[GitHub]. Decompilador estándar gratuito. [Slide 7]
- *GhidraMCP* (LaurieWired) — #link("https://github.com/LaurieWired/GhidraMCP")[GitHub]. Puente Ghidra↔LLM vía MCP: listar/decompilar funciones, renombrar, cross-refs. [Slide 8, demo]
- *Model Context Protocol (MCP)* — #link("https://modelcontextprotocol.io/")[modelcontextprotocol.io]. Estándar para dar herramientas/datos a un LLM. [Slide 8]
- Alternativa: *suidpit/ghidra-mcp* — #link("https://github.com/suidpit/ghidra-mcp")[GitHub]. Otro plugin MCP para Ghidra. [Slide 8]
]

== E) Panorama general (SoK / surveys) — empieza por aquí

#text(size: 9.5pt)[
- *Potential and Challenges of Large Language Models for Reverse Engineering* (arXiv 2509.21821, 2025; la v1 se titulaba "SoK: Potentials and Challenges…") — #link("https://arxiv.org/abs/2509.21821")[abs]. Revisa ≈48 estudios, taxonomía de 6 dimensiones, riesgos *dual-use*. *El mejor punto de partida.* [Transversal]
- *LLM for Software Security: Code/Malware Analysis & RE* (Jelodar et al., arXiv 2504.07137, 2025) — #link("https://arxiv.org/abs/2504.07137")[abs]. Survey centrado en malware; datasets y modelos. [Transversal]
]

== F) Contexto de malware y casos  → slides 4, 18 (demo, en voz) y 21 (References)

#text(size: 9.5pt)[
- *AV-TEST — Malware Statistics* — #link("https://www.av-test.org/en/statistics/malware/")[enlace]. Cifras de volumen (cientos de miles de muestras nuevas/día). [Slide 4]
- *WannaCry ransomware attack* — #link("https://en.wikipedia.org/wiki/WannaCry_ransomware_attack")[Wikipedia]. Caso del kill-switch (12-may-2017, M. Hutchins, ≈7 h tras el inicio). Matiz: hallazgo en parte accidental, varios investigadores. Horas: primeras infecciones 07:44 UTC → dominio registrado 15:03 UTC (≈7 h 19 min). Cronología completa en `demo/analisis/tiempos-2017-vs-ia.md`. [Slide 18 en voz; slide 21 References]
- *MalwareTech: "How to Accidentally Stop a Global Cyber Attacks"* (M. Hutchins, mayo 2017) — #link("https://www.malwaretech.com/2017/05/how-to-accidentally-stop-a-global-cyber-attacks.html")[blog]. Relato de primera mano: registró el dominio al verlo en el tráfico de la sandbox y después comprobó que era un kill-switch. Fuente del "≈7 h" junto con Wikipedia. [Slide 18 en voz; slide 21 References]
- *MITRE ATT&CK* — #link("https://attack.mitre.org/")[attack.mitre.org]. Marco de técnicas para describir comportamiento del malware (útil para IOCs/mitigación de la demo). [Demo]
- *CWE* (Common Weakness Enumeration) — #link("https://cwe.mitre.org/")[cwe.mitre.org]. Catálogo de tipos de fallo (PatchEval cubre 65 CWE). [Slide 15]
]

== G) Dónde seguir buscando (buscadores y venues)

#text(size: 9.5pt)[
- *arXiv cs.CR* (seguridad) — #link("https://arxiv.org/list/cs.CR/recent")[arxiv.org/list/cs.CR/recent] · *cs.SE* (software) — #link("https://arxiv.org/list/cs.SE/recent")[arxiv.org/list/cs.SE/recent].
- *Google Scholar* — #link("https://scholar.google.com/")[scholar.google.com] (busca: "LLM decompilation", "LLM vulnerability repair", "LLM malware analysis").
- *Papers with Code* — #link("https://paperswithcode.com/")[paperswithcode.com] (benchmarks y código asociado).
- *Venues top* donde publican estos trabajos: *NDSS*, *USENIX Security*, *IEEE S&P (Oakland)*, *ACM CCS* (seguridad); *ISSTA*, *ICSE*, *FSE*, *ASE* (ingeniería de software/APR).
- *MalwareBazaar* (abuse.ch) — #link("https://bazaar.abuse.ch/")[bazaar.abuse.ch]. Muestras para investigación (usar con cuidado; ver `demo/safety.md`).
]

#v(0.5em)
#text(size: 8.5pt, fill: gray)[Nota: algunas cifras de benchmarks provienen de los abstracts; si vas a ponerlas en una diapositiva como dato exacto, ábrelas y confírmalas en el PDF original (sobre todo PatchEval, DecLLM y el estudio NDSS 2026).]
