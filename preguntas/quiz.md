# Quiz questions — AI-Assisted Malware Disassembly & Remediation

Para enviar al profesor por email. 2 preguntas, 4 opciones cada una, **una sola correcta**
(marcada con ✅ y con `[CORRECT]`). English version first (coherente con las slides),
traducción al español debajo para repaso.

---

## Question 1

**When an LLM (e.g. via GhidraMCP) explains or renames functions in Ghidra's decompiled
pseudo-code, what is the single most important precaution before trusting its output?**

- A) None — modern LLMs reconstruct the original source code exactly.
- B) Run the LLM at a higher temperature so it is more creative.
- C) ✅ **Verify every claim against the binary (recompile, tests, dynamic/symbolic execution), because the model can hallucinate plausible-but-wrong logic.** `[CORRECT]`
- D) Trust it only if the decompiled function is longer than 100 lines.

> **ES:** Cuando un LLM explica o renombra funciones sobre el pseudocódigo decompilado de
> Ghidra, ¿cuál es la precaución más importante antes de fiarse? → **C) Verificar cada
> afirmación contra el binario (recompilar, tests, ejecución dinámica/simbólica), porque el
> modelo puede alucinar lógica plausible pero falsa.**

*Justificación:* las alucinaciones (lógica inventada, renombrados engañosos) son el riesgo
central; la mitigación es la verificación contra la verdad del binario (DecLLM, D-LiFT).

---

## Question 2

**Across recent studies, which statement best summarizes the current capability of LLMs for
malware reverse engineering and vulnerability patching?**

- A) They fully replace human analysts, autonomously patching essentially all vulnerabilities.
- B) ✅ **They mostly accelerate first-pass triage and help non-experts, but autonomous patch success is modest (best models fix only ~23% of real CVEs in PatchEval).** `[CORRECT]`
- C) They are useless: they provide no measurable speed-up for any user.
- D) They help experts a lot but provide no benefit at all to novices.

> **ES:** Según estudios recientes, ¿qué resume mejor la capacidad actual de los LLM en
> ingeniería inversa de malware y parcheo de vulnerabilidades? → **B) Sobre todo aceleran el
> triaje inicial y ayudan a no-expertos, pero el parcheo autónomo es modesto (los mejores
> modelos arreglan solo ~23% de CVEs reales en PatchEval).**

*Justificación:* el estudio human–LLM teaming (NDSS 2026) muestra gran mejora para novatos y
hasta 2,4× en triaje de algoritmos conocidos, con poca ganancia para expertos; PatchEval
(2025) reporta ~23% de éxito del mejor modelo. Ni inútiles (C) ni sustitutos totales (A);
D invierte el hallazgo real (ayudan más a novatos que a expertos).

---

### Referencias usadas en las preguntas
- Human–LLM teaming in RE (NDSS 2026): https://www.eurecom.edu/en/node/4899620
- PatchEval (arXiv 2511.11019): https://arxiv.org/abs/2511.11019
- DecLLM (ISSTA 2025): https://daoyuan14.github.io/papers/ISSTA25_DecLLM.pdf
- GhidraMCP: https://github.com/LaurieWired/GhidraMCP
