// ============================================================
//  SCRIPT / HANDOUT  (ENGLISH)  --  compile:  typst compile guion_en.typ guion_en.pdf
//  Support document for studying the topic and speaking on each slide.
//  For EACH slide there are two SEPARATE blocks:
//    [WHAT TO SAY]            -> what you say aloud
//    [DEEP DIVE & REFERENCES] -> technical explanation + figures + cited references
// ============================================================

#set document(title: "Script — AI-Assisted Malware Disassembly & Remediation")
#set page(
  paper: "a4",
  margin: (x: 2.2cm, y: 2.2cm),
  numbering: "1",
  header: context {
    if counter(page).get().first() > 1 [
      #set text(size: 8pt, fill: gray)
      Script — AI-Assisted Malware Disassembly & Remediation
      #h(1fr) Master's in Cybersecurity · Malware
      #line(length: 100%, stroke: 0.4pt + gray)
    ]
  },
)
#set text(font: ("Libertinus Serif", "DejaVu Serif"), size: 10.5pt, lang: "en")
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

// ---- Helpers: the two block types ----
#let say(body) = block(width: 100%, fill: rgb("#eef5f6"), inset: 10pt, radius: 4pt,
  stroke: (left: 3pt + rgb("#23373b")))[
  #text(weight: "bold", fill: rgb("#23373b"))[🎤 WHAT TO SAY] \
  #body
]
#let deepdive(body) = block(width: 100%, fill: rgb("#fdf1e3"), inset: 10pt, radius: 4pt,
  stroke: (left: 3pt + rgb("#eb811b")), above: 0.6em)[
  #text(weight: "bold", fill: rgb("#eb811b"))[📚 DEEP DIVE & REFERENCES] \
  #body
]

// =================== COVER ===================
#align(center + horizon)[
  #text(size: 22pt, weight: "bold", fill: rgb("#23373b"))[Presentation Script]
  #v(0.3em)
  #text(size: 15pt)[Generative AI-Assisted Malware Disassembly and Remediation]
  #v(0.2em)
  #text(size: 11pt, fill: gray)[Master's in Cybersecurity — Malware Analysis · 3 authors · ≈20 min]
  #v(1em)
  #text(size: 10pt)[Slides in English · script in English. \
  Each section = one slide, with both blocks (what to say / deep dive).]
]
#pagebreak()

#outline(title: [Slide Index], depth: 1, indent: 1em)
#pagebreak()

// =================== HOW TO USE ===================
= How to use this script

#text(size: 10pt)[
Read the *🎤 What to say* block first for each slide: it is the core speech (3–6 sentences), written to be easy to deliver aloud alongside the English slides (having the slides in English → extra credit from the professor). The *📚 Deep dive & references* block is so you truly *understand* the topic and can answer questions: it provides the exact figures, nuances, and references. You do not need to say everything in the deep dive aloud.

*Suggested split (3 speakers):* Author 1 → slides 1–8 · Author 2 → slides 9–16 · Author 3 → slides 17–19.
*Pacing:* ≈1 min per content slide + ≈7 min for the video demo (can be paused or have segments skipped). Agenda dividers are 5–10 s transitions ("we've covered X, now let's move to Y").

*Numbering:* the number of each section in this script is the PDF slide number *+1* (the title slide has no number in the footer). That is why each section also indicates "(footer: N)" when needed.
]

// =================== SLIDE 1 ===================
= Slide 1 — Title Slide

#say[
"Good morning. We are [names], and our presentation is about *generative AI applied to malware disassembly and remediation*: how large language models help perform reverse engineering and propose patches faster, and also where they still fail. The subtitle sums it up: they accelerate the work, but they do not replace the analyst."
]
#deepdive[
Topic context (assignment prompt): LLMs help the analyst *interpret decompiled code* (e.g., Ghidra's pseudo-C), *identify the exploited vulnerability*, and *propose mitigations/patches*. We will contrast the manual workflow with the AI-augmented one by evaluating *speed, accuracy, and hallucination risk*, and we close with a recorded demo. Keep the framing honest from the start: "co-pilot", not "autopilot".
]

// =================== SLIDE 2 ===================
= Slide 2 — Agenda

#say[
"Here is our roadmap: first, the *context* and why this matters; then the *toolchain* that is used; next we compare the *manual workflow with the AI-augmented one*; we review the *evidence* (speed, accuracy, and hallucinations); we walk through a *demo*; and we wrap up with *takeaways*."
]
#deepdive[
The agenda is repeated at every section transition highlighting where we are (the professor's organization requirement → counts toward "Presentation and Organization"). There are 6 sections. State the transition in one sentence and move on quickly.
]

// =================== SECTION 1 ===================
= Slide 3 — Divider: Context & Motivation

#say[
"Let's start by setting up the problem: why do we need to speed this up?"
]
#deepdive[Transition. Do not linger here.]

= Slide 4 — Reverse engineering is slow, scarce and expensive

#say[
"Malware reverse engineering is a bottleneck: disassembling, decompiling, and dynamically analyzing a sample can take *hours or days*, and it depends on scarce experts. At the same time, *hundreds of thousands* of new samples appear every day, and there is a *huge backlog of unpatched CVEs*. Reading assembly or noisy pseudo-code is hard and error-prone. The question is: can generative AI shrink the time-to-understanding and time-to-patch without lying to us?"
]
#deepdive[
- *CVEs per year chart*: shows the explosion of reported vulnerabilities (exacerbated by the use of AI in bug generation and discovery), pushing the volume of pending patches to unsustainable levels for human teams.
- Volume: AV-TEST records on the order of *450,000+ new malware/PUA samples per day* (see #link("https://www.av-test.org/en/statistics/malware/")[AV-TEST malware statistics]). Use "hundreds of thousands/day" to stay on the safe side.
- "Without lying to us" foreshadows the central thread: hallucinations (slide 16 of this script).
- *Decompilation vs. disassembly*: disassembling = turning bytes into assembly instructions; decompiling = reconstructing higher-level pseudo-C. The decompiler *guesses* types and control flow → an approximate output, without original names or comments. That is the noisy input we feed to the LLM.
]

= Slide 5 — The promise of LLMs

#say[
"What does an LLM bring to the table here? Three things: *explaining* pseudo-code in plain English, *renaming* functions and variables to recover the code's intent, and *proposing* a hypothesis for the bug along with a draft mitigation or patch. But —and this is key throughout the whole talk— the LLM is an *accelerator and co-pilot*, not a replacement for the analyst: everything it outputs must be *verified against the binary*."
]
#deepdive[
This is the *honest framing* required for high-quality technical work and it protects us against tough questions. The LLM's value lies primarily in *comprehension and triage*, not in guaranteeing correctness. It connects directly to the evidence later on: big gains for non-experts, small gains for experts.
]

// =================== SECTION 2 ===================
= Slide 6 — Divider: The Toolchain

#say["To make sure we're on the same page, let's quickly review the tools involved."]
#deepdive[5-second transition.]

= Slide 7 — The classic RE stack

#say[
"Our starting point is the classic stack, split into two columns. Under *static analysis* (reading the binary without running it): decompilers like *Ghidra* —free, from the NSA—, IDA Pro, or Binary Ninja, plus utilities like `strings` and inspecting PE/ELF headers and imports. Under *dynamic analysis* (running it and observing): debuggers like x64dbg or GDB, and sandboxes like Cuckoo/CAPE inside isolated virtual machines. One crucial idea: *pseudo-code is not source code*; the decompiler guesses types and control flow. That noisy text is precisely what we then ask the AI to interpret."
]
#deepdive[
- *Ghidra*: NSA's open-source RE suite (#link("https://ghidra-sre.org/")[ghidra-sre.org]); its decompiler generates pseudo-C. It is the free standard and the one used by most LLM bridges.
- *Sandbox*: controlled execution to observe behavior (network, files, registry) without reading code. Complements static analysis.
- Emphasize the pseudo-code point because it explains why the LLM sometimes hallucinates: it is working from an imperfect reconstruction.
]

= Slide 8 — The LLM-augmented stack (diagram)

#say[
"The key idea is that the LLM isn't used via copy-and-paste: it is *wired directly into* the tool. The diagram shows the flow: from the *binary* to *Ghidra*, and through an *MCP bridge* the model accesses Ghidra's API. The best-known example is *GhidraMCP*, by LaurieWired, which exposes actions like listing and decompiling functions, renaming symbols, or inspecting cross-references. Although bridges also exist for *dynamic* tools (debuggers or sandbox logs), our presentation —and most current literature— focuses on the *static* decompilation-and-patching loop, reserving dynamic execution for *verification*. That way the agent *iterates* —decompile, explain, rename, re-read, propose a patch— always with a *human in the loop*."
]
#deepdive[
- *MCP (Model Context Protocol)*: standard protocol for giving an LLM access to tools and data. *GhidraMCP* (#link("https://github.com/LaurieWired/GhidraMCP")[github.com/LaurieWired/GhidraMCP]) = Ghidra plugin + bridge server; allows Claude/Cline/etc. to request decompilations and rename symbols automatically. Alternatives exist (e.g., `suidpit/ghidra-mcp`).
- *Why static here, and what about dynamic?* An LLM is not limited to static analysis: MCP bridges also exist for debuggers (GDB/x64dbg) or for analyzing sandbox traces. However, the bulk of disassembly/remediation research (and the scope of this talk) operates on the static decompiler (Ghidra) and uses the dynamic side (execution/tests/sandbox) as a verification step.
- The idea of "iterating with a human in the loop" is what separates the modern workflow from simply "pasting code into a chat". It is also what we see in part 2 of the demo (Claude Code + GhidraMCP).
]

// =================== SECTION 3 ===================
= Slide 9 — Divider: Manual vs. AI-Augmented Workflow

#say["Now that the tools are in place, let's compare the two workflows."]
#deepdive[Transition.]

= Slide 10 — Two lanes, same destination

#say[
"On the left, the *manual* workflow: load the binary, map out functions by hand, read pseudo-code line by line, deduce intent, reproduce behavior in a sandbox, and finally pinpoint the bug and design a mitigation. That takes hours or days, and its depth depends on the expert's skill. On the right, the *AI-augmented* workflow: the agent decompiles (via Ghidra) and summarizes functions in bulk, the LLM explains and renames, the analyst steers with targeted questions, the AI drafts IOCs, YARA rules, or a patch… and the analyst *verifies against the binary*. Triage drops to minutes, but the verification step remains mandatory."
]
#deepdive[
The message of these two lanes: AI *does not eliminate* critical steps, it *reorders* them. Human effort shifts from *reading* to *verifying*. Useful when answering "so is the analyst redundant?": no, their role shifts toward validation and judgment.
]

= Slide 11 — Comedic relief: The human factor (Diamonds meme)

#say[
"This image captures with a bit of humor what happens in practice during manual analysis: after hours of combing through assembly and noisy pseudo-code, cognitive fatigue takes its toll and the analyst may give up or overlook the critical detail —the vulnerability, the kill-switch, or the key IOC— just inches away from finding it. AI's value here is acting as a co-pilot to prevent that burnout and make sure we don't leave diamonds unmined."
]
#deepdive[
Visual and comedic breather (the classic miner meme giving up inches before hitting diamonds). Connects to the real problem in manual triage: human fatigue and exhaustion-driven mistakes across hundreds of functions. Bridges into the WannaCry example later on (finding the kill-switch under pressure) and leads naturally into the comparison table.
]

= Slide 12 — Comparison table

#say[
"Summarized in one table: AI clearly wins on *first-pass triage speed*, on *comprehension for non-experts*, and on code *coverage*. The manual workflow wins on one decisive point: the *correctness guarantee*, because it is analyst-verified. And the major risk on the AI lane is *hallucinations*: errors stated with complete confidence. In one sentence: AI shifts effort from reading to verifying."
]
#deepdive[
The rows are designed so that each one has a different "winner" → avoids overselling AI as better at everything (which is what the professor rewards as honest technical quality). "Needs verification" and "Hallucinations" connect directly to the evidence section.
]

// =================== SECTION 4 ===================
= Slide 13 — Divider: Evidence — Speed, Accuracy & Hallucinations

#say["So what does the data say? Let's look at the evidence."]
#deepdive[Transition.]

= Slide 14 — Speed & comprehension

#say[
"On speed and comprehension, the *Decompiling the Synergy* study from Arizona State University and EURECOM, with 48 participants doing reverse engineering (NDSS 2026), gives very revealing numbers: *novice* comprehension improved by roughly *98%*, *artifact recovery* —such as variable names, data types, and comments— rose by *at least 66%*, and functions implementing *known algorithms* were triaged up to *2.4 times faster*. But —and this caveat is crucial— *expert analysts gained barely any speed*, and at times the LLM produced *harmful hallucinations* and red herrings. Bottom line: AI's real, reliable impact is *taking over the tedious plumbing work* and *lowering the barrier to entry*, not replacing expert judgment."
]
#deepdive[
Study: "Decompiling the Synergy: An Empirical Study of Human–LLM Teaming in Software Reverse Engineering" (ASU / Univ. of Padua / EURECOM, NDSS 2026) — #link("https://www.eurecom.edu/en/node/4899620")[record].
- *Rigorous methodology*: 48 participants (24 novices and 24 experts) analyzing CTF-style binaries representative of real-world software over more than 109 hours of instrumented activity.
- *Key figures and findings*:
  + *Novice comprehension*: +≈98%, nearly closing the initial comprehension gap compared to experts.
  + *Artifact recovery*: ≥66% ("at least 66%") in reconstructing symbols, meaningful variable/function names, data types, and comments from plain Ghidra pseudo-code.
  + *Known-algorithm triage*: up to 2.4× faster when recognizing standard patterns (cryptography, hashing, compression).
- *Why it helps with tedious work and does not replace expert analysts*: manually renaming dozens of anonymous variables (`local_18`, `uVar2`), typing structures, and understanding standard routines is the heaviest, most repetitive, and most fatiguing part of reverse engineering. AI automates that "plumbing", freeing up cognitive load. However, experts already infer these patterns almost immediately; for them, the LLM brings little net speedup and introduces friction when it produces subtle hallucinations that force them to audit the code under a microscope. High-level analysis, intuition, and security judgment still depend entirely on the human analyst.
]

= Slide 15 — Remediation & patching (footer: 14)

#say[
"Moving from *understanding* code to *fixing* it, the picture gets tougher. The *PatchEval* benchmark, from 2025, collects *1,000 real vulnerabilities* (CVEs between 2015 and 2025). For *230* of them there is also an execution environment where you can genuinely verify whether the patch works. Result: the best model or agent fixes only *23%* (53 out of 230). Interestingly, different models fix different bugs: if we pool them all together, at least one fixes 98, or *43%*. Another 2026 study examines *how the system is built*. A fixed step-by-step pipeline is cheap, but breaks as soon as something fails. General coding agents, like Claude Code, fix the most bugs, though they take longer and burn more tokens. And what matters most is not the model itself, but whether the system can *test the patch and retry*. The practical takeaway: AI *proposes* the patch, and a human together with tests *validates* it."
]
#deepdive[
*PatchEval*: "PATCHEVAL: A New Benchmark for Evaluating LLMs on Patching Real-World Vulnerabilities" (arXiv 2511.11019, Nov. 2025), #link("https://arxiv.org/abs/2511.11019")[link].
- *Dataset*: 1,000 vulnerabilities from CVEs published between 2015 and 2025, across 65 CWE types. A subset of *230 CVEs* has an *execution sandbox* (compiles and passes tests/PoC), and that is where true success is measured.
- *Exact figures* (verified in the PDF): the best standalone LLM reaches *22.6%* and the best agent reaches *23.0%* (53/230, SWE-Agent with Gemini 2.5). That is why the slide states "best model/agent ≈23%".
- *Complementarity* (Finding 5 of the paper): *98* CVEs are fixed by at least one model (≈42.6%), whereas *only 5* are fixed by all of them. That 43% is an *upper bound* ("oracle": if we knew in advance which model to pick for each case), not a system that already exists. If asked, clarify that nuance.
- Most successes are *small patches* (1–5 lines); on complex bugs the success rate drops sharply.
- PatchEval *does not measure wall-clock time*.

*Architecture study*: "A Systematic Study of LLM-Based Architectures for Automated Patching" (Xu, Sheng, Chen, Huang; arXiv 2603.01257, Mar. 2026), #link("https://arxiv.org/abs/2603.01257")[link]. Compares 4 paradigms by measuring patch correctness, failure modes, *tokens*, and *execution time*:
  + *Fixed workflow (pipeline)*: code-defined preset steps (localize → generate patch → compile/test). Efficient and cheap, but *brittle*: if one step fails, it cannot recover.
  + *Single agent*: an LLM in a loop (tool-use / ReAct) deciding which tool to invoke and iterating on errors. Balances flexibility and cost.
  + *Multi-agent*: multiple roles (localizer, patch developer, reviewer). Generalizes better, but adds significant *overhead* and risk of reasoning "drift" on complex tasks.
  + *General coding agents* (SWE-agent, OpenHands, Claude Code...): *best overall*.
  Paper's core message: *architecture design and iteration depth* matter more than the model itself.
- *Link to the demo*: we use precisely a general coding agent (Claude Code) connected to Ghidra.
- If asked about "patching times": these benchmarks do not report a reliable wall-clock figure. Our time reference is the demo (≈10 min for the complete report).
]

= Slide 16 — The hallucination problem (footer: 15)

#say[
"The biggest problem is *hallucinations*. Three typical forms. First, *invented logic*: plausible-sounding but false explanations. Second, *misleading renaming*: a function named `decrypt_payload` that decrypts nothing at all. Third, *low recompilability*: in DecLLM's pilot study, a standalone LLM could only get *25%* of decompiled code to compile again (classic rule-based methods got 9%). It took a *verification loop* (compile, run, and fix) to reach around *70%*. These failure modes explain why AI alone is unreliable for *malware classification*: the model only reads static text and does not execute the binary, so obfuscation and hallucinations lead to wrong labels. The mitigation? *Verify against binary ground truth*: recompile, diff behavior, symbolic execution, and tests."
]
#deepdive[
- *DecLLM*: "LLM-Augmented Recompilable Decompilation..." (Wong et al., HKUST + Tencent Keen Lab, ISSTA 2025), #link("https://daoyuan14.github.io/papers/ISSTA25_DecLLM.pdf")[PDF].
  - *Pilot study*: rule-based methods recompile *9%*; an LLM given the entire program as context reaches *25%*, still insufficient. Observed failures: *attention degradation* (with long inputs it "forgets" instructions), *shortcuts* (overuses casts just to make it compile), and *hallucination*.
  - *DecLLM* adds an iterative loop with *static recompilation + dynamic execution feedback* and reaches *≈70%* on average (74% with GPT-3.5 and 78.3% with GPT-4 on its main dataset). Reduces hallucinations by 31%.
  - *Moral*: the gain comes from the *verification loop*, not the standalone LLM. That is the exact message of this talk.
- *D-LiFT / D-Score* (arXiv 2506.10125), #link("https://arxiv.org/abs/2506.10125")[link]: prior pipelines introduce new syntactic/semantic errors; they propose *scoring* accuracy with the compiler (syntax) and symbolic execution (semantics).
- *Misleading renaming*: `decrypt_payload` is a made-up example, not a real function. A wrong name is worse than `FUN_00401a30`, because at least the generic name doesn't mislead you. Ties into the demo: Claude renames 31 functions and leaves a comment and address on each so it can be checked.
- *Malware classification*: the model only sees static code, and malware uses obfuscation. If it hallucinates what the code does, the *label* (family, benign/malicious) inherits that error. That is why verification against the binary is non-negotiable.
]

// =================== SECTION 5 ===================
= Slide 17 — Divider: Live Demo (footer: 16)

#say[
"So far we have looked at figures from papers. Now let's see it with our own eyes: a *manual* analysis versus an *AI-assisted* one, on the *exact same real sample*."
]
#deepdive[
5–10 s transition. The title says "Live", but it is a *recording that you narrate live*. State that clearly so you don't give a false impression: "we recorded it so we wouldn't depend on the network or model latency, and I'll walk you through it live".
]

= Slide 18 — ▶ Demo: manual vs. AI-assisted (footer: 17)

#text(size: 9.5pt, fill: gray)[The "Demo: before / after" slide was removed from the PDF because it took up more space than it added. Its content is delivered *spoken aloud*, right here, just before hitting play. The video `VIDEOS/VIDEO_FINAL.mp4` lasts ≈7 min and has no voiceover: you narrate it and pause wherever needed.]

#say[
"First, the *before*. On May 12, 2017, WannaCry infected hundreds of thousands of machines within hours. About *7 hours* after the outbreak began, a researcher registered a bizarre domain the malware was querying, and its spread halted. But *why* it halted (that it was a *kill-switch*) was confirmed afterward by reading the code by hand under pressure.

The *after* is our demo, using the *same sample*: WannaCry's worm component. Two lanes. One: *manual* analysis in Ghidra, with unnamed functions, noisy pseudo-C, and scattered clues in the strings. Two: the *same binary* with *Claude Code connected to Ghidra via MCP* and a single neutral prompt that doesn't say what it is. In about 10 real-world minutes, it identifies it as WannaCry and produces a report with addresses, IOCs, and four YARA rules tested with zero false positives. It also renames 31 functions in Ghidra. And then comes the most important part: we *verify* its claims against the binary. Let's roll the demo."
]
#deepdive[
*WannaCry timeline* (details and sources in `demo/analisis/tiempos-2017-vs-ia.md`):
- Mar 14, 2017: Microsoft releases *MS17-010* (SMBv1 patch), *59 days before* the attack.
- Apr 14, 2017: Shadow Brokers leak *EternalBlue*.
- May 12, 07:44 UTC: first infections (T = 0).
- May 12, 15:03 UTC: Marcus Hutchins (MalwareTech) registers the domain, *≈7 h* later.
  - He registered it after seeing it in traffic, as standard practice to monitor malware. The fact that it was a kill-switch was confirmed *later*, by analyzing the code.
  - It was partly *accidental*, and other researchers were involved (Darien Huss). Say "≈7 h", not an exact timestamp.
- The real bottleneck in 2017 was *deploying* a patch that already existed. AI does *not* shorten that; if asked, acknowledge it openly.

*Data from our demo* (all measured; report in `pruebas/informe_wannacry_mssecsvc.md`):
- Sample: `wannacry_mssecsvc.exe.bin`, SHA256 `24d004a1...1022c`, PE32 x86.
- *4 YARA rules* tested with yara-python 4.5.4: they detect the sample and yield *0 false positives across 2,985 legitimate executables*.
- *31 renamed functions* + comments in Ghidra.
- Agent runtime: *≈10 min 35 s* (indicated by Claude Code upon completion, "Brewed for 10m 35s").
- In an earlier dry run (Nov 9), with a different prompt, we measured: kill-switch located in *36 s* and full report in *≈5 min 20 s*. Use this if asked "how long does it take to find the kill-switch?".

*Honest comparison*: it is not the same task as in 2017. We already had the sample, no crisis pressure, and the model *knows WannaCry* from its training data, plus the strings are in plaintext. That is why every claim in the report includes *its address* and we verify it.

*Addresses to verify* (in case they ask you to show it in Ghidra):
- Kill-switch: `0x408140` (URL at `0x4313d0`, checked via *References to*).
- Port 445 = constant `0x1bd` at `0x407480`.
- Resource `R`/1831 (`0x727`) = encryptor `tasksche.exe`.
]

#deepdive[
*Segment-by-segment narration* (video timestamps; full script in `demo/demo-plan.md`):
#table(columns: (auto, 1fr), inset: 5pt, stroke: 0.4pt + gray,
  [*0:00–1:48* \ Manual], [
    - Shown: Ghidra imports the binary; unnamed `entry` decompilation; list of `FUN_...` functions; *Defined Strings*, first runtime noise and then `mssecsvc2.0`, `tasksche.exe`, `\\%s\IPC$` and the kill-switch URL.
    - You say: "This is how an analyst starts: hundreds of unnamed functions. The strings give clues, but I still don't know *what* each part does or *where*. Tracing this by hand takes hours."
  ],
  [*1:48–2:37* \ Prompt], [
    - Shown: Claude Code alongside Ghidra. Neutral prompt: "PE binary, I don't know what it is, contains malware; report, IOCs with their addresses, YARA rules, rename and comment in Ghidra; verify against the binary".
    - You say: "Same binary. The prompt *doesn't say what it is*. Notice that it asks for evidence with addresses."
  ],
  [*2:37–3:38* \ ×10], [
    - Shown: segment sped up ×10. Claude calls Ghidra, renames (32 calls), adds comments, and writes and *tests* the YARA rules.
    - You say: "This is about 10 real-world minutes. It doesn't just answer: it *uses Ghidra* and *tests* what it writes."
  ],
  [*3:38–≈5:00* \ Results], [
    - Shown: final summary, WannaCry (worm component), kill-switch, service installation, SMB/445 propagation; IOCs, 4 YARA rules, 0 false positives; report opened in the editor.
    - You say: "Every claim carries its address: that is what allows me to *verify*."
  ],
  [*≈5:00–7:05* \ Ghidra], [
    - Shown: *Symbol Tree* with readable names (`WinMain_KillSwitchCheck`, `SMB_ExploitEternalBlue`...). Follow-up question about the function at the cursor: renames it to `WinMainCRTStartup` and explains it is standard MSVC startup code.
    - You say: "What used to be hours of manual renaming is done and reviewable. And I can keep asking function by function."
  ],
)
*Closing line*: "Manual: hours just to get your bearings. With AI: minutes for a full report. *But* it recognizes it quickly partly because of the plaintext strings and because WannaCry is well known. With an obfuscated sample it would be slower and more prone to hallucinate, which is why the step we *never* skip is verification."

*If running short on time*: skip the 5:00–7:05 segment or trim the manual part to 1 min.
]

// =================== SECTION 6 ===================
= Slide 19 — Divider: Takeaways (footer: 18)

#say["We've seen the context, the data, and the demo. Let's close with the key takeaways we want you to remember."]
#deepdive[5-second transition.]

= Slide 20 — Takeaways (footer: 19)

#say[
"Four key takeaways.
- *One*: LLMs *accelerate* reverse engineering by taking over the *tedious work* (recovering names, types, and known patterns) and *lowering the barrier to entry* for non-experts. You saw it in the demo: 31 renamed functions and a report in minutes.
- *Two*: they do *not* replace the expert analyst. Experts barely gain speed, autonomous patching succeeds around *23%* of the time, and *hallucinations* are real.
- *Three*: the discipline that makes it work is *keeping a human in the loop* and *verifying every output against the binary*.
- *Four*: that is why static AI alone is still *unreliable for classifying malware*: without observing execution, obfuscation and hallucinations lead to wrong labels."
]
#deepdive[
Each takeaway with its backing evidence:
1. *Tedious work & non-experts*: NDSS 2026 study (novices +≈98% comprehension; artifact recovery ≥66%; known algorithms up to 2.4× faster). In the demo: 31 renamed functions, IOCs, and 4 tested YARA rules in ≈10 min.
2. *Limits*: marginal gains for experts (NDSS 2026); PatchEval 23% (53/230); DecLLM, where a standalone LLM leaves 75% of code failing to recompile.
3. *Verification*: the binary is the single source of truth (recompile, tests, dynamic execution, checking the addresses cited by the AI). DecLLM reaches ≈70% precisely thanks to that loop.
4. *Malware classification*: without dynamic execution, static family or maliciousness labels are vulnerable to obfuscation and hallucinations. In our demo it gets it right, aided by plaintext strings and a very well-known family.
]

= Slide 21 — References (footer: 20)

#say[
"Here are the main references for the studies, benchmarks, and tools we cited during the presentation."
]
#deepdive[
Bibliography and reference slide backing all numbers in the talk. The complete annotated list with links is in the final section of this script.
]

= Slide 22 — Thank you / Q&A

#say[
"Thank you. Any questions?"
]
#deepdive[
Likely questions (tied to the takeaways) and short answers:
- *"Where does AI help most when analyzing malware?"* → In the *heavy, repetitive work*: renaming functions and variables, summarizing code, and recognizing known algorithms. That gets the analyst to what matters sooner.
- *"Can AI replace the analyst?"* → No. Experts gain barely any speed, automated patching succeeds only ≈23% of the time, and it sometimes makes things up. The analyst shifts from *reading* code to *reviewing* what the AI says.
- *"Who benefits more, novices or experts?"* → *Novices*: their comprehension jumps ≈98%. For an expert the improvement is small, because they already recognize those patterns on their own.
- *"How do you know what the AI says is true?"* → We don't trust it blindly: we ask for the *address* of every claim and check it in Ghidra. If it's code or a patch, it gets compiled and tested.
- *"Why isn't AI alone enough to classify malware?"* → Because it only *reads* the code, it doesn't *execute* it. If the malware is obfuscated or novel, it can assign the wrong label with complete confidence.
- *"Would you use it in a real case?"* → Yes, as an *assistant*: for initial triage and offloading tedious work. But always with a human reviewing the output before taking action.
]

#pagebreak()
// ============================================================
//  BIBLIOGRAPHY & FURTHER READING
// ============================================================
= Bibliography and further reading

#text(size: 9.5pt)[
*Verified* sources (arXiv/NDSS/real repos) to populate and defend the slides.
Each entry indicates which *slide* it supports. If you only have time to read 2–3, start with the *SoK/surveys* (section E): they give the big picture and link to the rest.
]

== A) LLM-assisted reverse engineering / decompilation  → slides 5, 8, 14, 16

#text(size: 9.5pt)[
- *Decompiling the Synergy: Human–LLM Teaming in RE* (NDSS 2026, Eurecom / ASU) — #link("https://www.eurecom.edu/en/node/4899620")[record]. Study with 48 participants (24 novices, 24 experts); novices +≈98% comprehension, ≥66% artifact recovery (symbols, types, comments), up to 2.4× on known algorithms; marginal gains for experts and presence of harmful hallucinations. Establishes that the real value lies in mitigating tedious work and democratizing triage. [Slides 14, 20]
- *LLM4Decompile: Decompiling Binary Code with LLMs* (arXiv 2403.05286, EMNLP 2024) — #link("https://arxiv.org/abs/2403.05286")[abs] · #link("https://github.com/albertan017/LLM4Decompile")[code]. Open models (1.3B–33B) for decompilation; *Decompile-Eval* benchmark (recompilability/re-executability instead of tokens alone); the *-Ref* variant refines Ghidra output. [Slides 5, 8]
- *DeGPT: Optimizing Decompiler Output with LLM* (NDSS 2024) — #link("https://www.ndss-symposium.org/ndss-paper/degpt-optimizing-decompiler-output-with-llm/")[paper] · #link("https://github.com/PeiweiHu/DeGPT")[code]. Improves the *readability* of Ghidra output (−24.4% cognitive load; 62.9% of comments with useful semantics); uses 3 LLM roles + MSSC filter to preserve semantics. *Concrete example of "explain/rename".* [Slides 8, 14]
- *DecLLM* (ISSTA 2025) — #link("https://daoyuan14.github.io/papers/ISSTA25_DecLLM.pdf")[PDF]. Pilot: rules 9% → full-context LLM 25%; with DecLLM's iterative compile+execute loop ≈70% (74% GPT-3.5 / 78.3% GPT-4). Failure modes: attention degradation, shortcuts, hallucination. [Slide 16]
]

== B) LLM-based remediation / automated program repair (APR)  → slide 15

#text(size: 9.5pt)[
- *PatchEval* (arXiv 2511.11019, 2025) — #link("https://arxiv.org/abs/2511.11019")[abs]. 1,000 real CVEs (230 with sandbox); best LLM 22.6% / best agent 23.0% (53/230); 98/230 fixable by at least one model, only 5 by all. [Slide 15]
- *A Systematic Study of LLM-Based Architectures for Automated Patching* (arXiv 2603.01257, 2026) — #link("https://arxiv.org/abs/2603.01257")[abs]. Compares fixed workflow / 1 agent / multi-agent / coding agents; measures correctness, *time*, and *tokens*. Useful if asked about cost/time. [Slide 15]
- *A Survey of LLM-based Automated Program Repair* (arXiv 2506.23749, 2025) — #link("https://arxiv.org/abs/2506.23749")[abs]. Classifies 63 systems into 4 paradigms (fine-tuning, prompting, procedural, agentic). *Good map of the patching field.* [Slide 15]
- *LLM-based APR — Systematic Literature Review* (arXiv 2405.01466) — #link("https://arxiv.org/abs/2405.01466")[abs]. 189 papers (2020–2025), 20 bug types including security vulnerabilities. [Slide 15]
- *SEC-bench* (security benchmark; via survey 2510.09721) — reported rates ≈18% (PoC) and ≈34% (patching). Cite with caution (secondary figure) to reinforce that "autonomous patching is hard". [Slide 15]
]

== C) Hallucinations, verification, and limits  → slide 16

#text(size: 9.5pt)[
- *D-LiFT / D-Score* (arXiv 2506.10125) — #link("https://arxiv.org/abs/2506.10125")[abs]. Pipelines introduce new syntactic/semantic errors; they propose *scoring* accuracy (compiler) and semantics (symbolic execution). *The "verify against the binary" idea.* [Slide 16]
- Link to *malware classification*: if the model hallucinates what the code does, the label (family/benign-malicious) inherits that error → that is why verification is non-negotiable. Closing argument. [Slides 16, 20]
]

== D) Tools and bridges (Ghidra, MCP)  → slides 7, 8 & demo

#text(size: 9.5pt)[
- *Ghidra* (NSA, open-source) — #link("https://ghidra-sre.org/")[ghidra-sre.org] · #link("https://github.com/NationalSecurityAgency/ghidra")[GitHub]. Standard free decompiler. [Slide 7]
- *GhidraMCP* (LaurieWired) — #link("https://github.com/LaurieWired/GhidraMCP")[GitHub]. Ghidra↔LLM bridge via MCP: list/decompile functions, rename, cross-refs. [Slide 8, demo]
- *Model Context Protocol (MCP)* — #link("https://modelcontextprotocol.io/")[modelcontextprotocol.io]. Standard for exposing tools/data to an LLM. [Slide 8]
- Alternative: *suidpit/ghidra-mcp* — #link("https://github.com/suidpit/ghidra-mcp")[GitHub]. Another MCP plugin for Ghidra. [Slide 8]
]

== E) Broad overview (SoK / surveys) — start here

#text(size: 9.5pt)[
- *Potential and Challenges of Large Language Models for Reverse Engineering* (arXiv 2509.21821, 2025; v1 was titled "SoK: Potentials and Challenges…") — #link("https://arxiv.org/abs/2509.21821")[abs]. Reviews ≈48 studies, 6-dimension taxonomy, *dual-use* risks. *Best starting point.* [Cross-cutting]
- *LLM for Software Security: Code/Malware Analysis & RE* (Jelodar et al., arXiv 2504.07137, 2025) — #link("https://arxiv.org/abs/2504.07137")[abs]. Survey focused on malware; datasets and models. [Cross-cutting]
]

== F) Malware context and case studies  → slides 4, 18 (demo, spoken) & 21 (References)

#text(size: 9.5pt)[
- *AV-TEST — Malware Statistics* — #link("https://www.av-test.org/en/statistics/malware/")[link]. Volume figures (hundreds of thousands of new samples/day). [Slide 4]
- *WannaCry ransomware attack* — #link("https://en.wikipedia.org/wiki/WannaCry_ransomware_attack")[Wikipedia]. Kill-switch case (May 12, 2017, M. Hutchins, ≈7 h after outbreak start). Caveat: partly accidental discovery, multiple researchers. Times: first infections 07:44 UTC → domain registered 15:03 UTC (≈7 h 19 min). Full timeline in `demo/analisis/tiempos-2017-vs-ia.md`. [Slide 18 spoken; slide 21 References]
- *MalwareTech: "How to Accidentally Stop a Global Cyber Attacks"* (M. Hutchins, May 2017) — #link("https://www.malwaretech.com/2017/05/how-to-accidentally-stop-a-global-cyber-attacks.html")[blog]. First-hand account: registered the domain after seeing it in sandbox traffic and later verified it was a kill-switch. Source for "≈7 h" alongside Wikipedia. [Slide 18 spoken; slide 21 References]
- *MITRE ATT&CK* — #link("https://attack.mitre.org/")[attack.mitre.org]. Framework of techniques to describe malware behavior (useful for IOCs/mitigation in the demo). [Demo]
- *CWE* (Common Weakness Enumeration) — #link("https://cwe.mitre.org/")[cwe.mitre.org]. Catalog of weakness types (PatchEval covers 65 CWEs). [Slide 15]
]

== G) Where to keep searching (search engines and venues)

#text(size: 9.5pt)[
- *arXiv cs.CR* (security) — #link("https://arxiv.org/list/cs.CR/recent")[arxiv.org/list/cs.CR/recent] · *cs.SE* (software) — #link("https://arxiv.org/list/cs.SE/recent")[arxiv.org/list/cs.SE/recent].
- *Google Scholar* — #link("https://scholar.google.com/")[scholar.google.com] (search: "LLM decompilation", "LLM vulnerability repair", "LLM malware analysis").
- *Papers with Code* — #link("https://paperswithcode.com/")[paperswithcode.com] (benchmarks and associated code).
- *Top venues* publishing this work: *NDSS*, *USENIX Security*, *IEEE S&P (Oakland)*, *ACM CCS* (security); *ISSTA*, *ICSE*, *FSE*, *ASE* (software engineering/APR).
- *MalwareBazaar* (abuse.ch) — #link("https://bazaar.abuse.ch/")[bazaar.abuse.ch]. Samples for research (use carefully; see `demo/safety.md`).
]

#v(0.5em)
#text(size: 8.5pt, fill: gray)[Note: some benchmark numbers come from abstracts; if you are going to put them on a slide as an exact figure, open and confirm them in the original PDF (especially PatchEval, DecLLM, and the NDSS 2026 study).]
