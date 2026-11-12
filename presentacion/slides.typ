#import "@preview/touying:0.6.1": *
#import themes.metropolis: *

// ===== Theme colors (Metropolis-style) =====
#let m-dark   = rgb("#23373b")
#let m-accent = rgb("#eb811b")
#let m-light  = rgb("#fafafa")
#let m-gray   = rgb("#8a8a8a")

#show: metropolis-theme.with(
  aspect-ratio: "16-9",
  footer: self => self.info.institution,
  // Disable the automatic section slide: we use our own agenda() divider.
  config-common(new-section-slide-fn: none),
  config-info(
    title: [Generative AI-Assisted Malware Disassembly and Remediation],
    subtitle: [How LLMs accelerate reverse engineering and patching (and where they still fail)],
    author: [Lois Briones · David Esperante · Héctor Aldao],
    date: datetime(year: 2026, month: 11, day: 16),
    institution: [MUniCS - Malware Analysis],
  ),
)

// ===== Recurring agenda / table of contents =====
// Re-shown on every topic change, highlighting where we are going next.
#let sections = (
  "Context & Motivation",
  "The Toolchain",
  "Manual vs. AI-Augmented Workflow",
  "Evidence: Speed, Accuracy & Hallucinations",
  "Live Demo",
  "Takeaways",
)

#let agenda(current: none) = {
  set page(footer: none) if false
  v(1fr)
  for (i, s) in sections.enumerate() {
    let active = (current == i + 1)
    block(
      inset: (y: 6pt),
      text(
        size: 20pt,
        fill: if active { m-accent } else { m-gray.lighten(10%) },
        weight: if active { "bold" } else { "regular" },
      )[
        #box(width: 1.4em)[#text(fill: if active { m-accent } else { m-gray })[#(i + 1).]]
        #s
      ],
    )
  }
  v(1fr)
}

// Small helper: a labelled "box" for pipeline diagrams
#let pbox(body, fill: m-dark, tcol: white) = box(
  fill: fill, inset: 8pt, radius: 4pt,
  text(fill: tcol, size: 14pt, weight: "bold")[#body],
)
#let arrow = text(size: 18pt, fill: m-accent)[ $arrow.r$ ]

// ========================= TITLE =========================
#title-slide()

// ========================= AGENDA =========================
#slide(title: "Agenda")[
  #agenda(current: none)
]

// ========================= 1. CONTEXT =========================
= Context & Motivation

#slide[
  #agenda(current: 1)
]

#slide(title: "Reverse engineering is slow, scarce and expensive")[
  #set text(size: 18pt)
  - Malware triage and patching are *bottlenecked by human experts*: disassembly, decompilation and dynamic analysis take *hours to days* per sample.
  - Volume keeps growing: *hundreds of thousands* of new samples per day, wich make a large *backlog of unpatched CVEs*.
  - Skills are rare: reading x86/ARM assembly and noisy decompiler pseudo-code is hard and error-prone.

  #v(0.5em)
  #block(fill: m-dark, inset: 10pt, radius: 4pt, width: 100%,
    //text(fill: white)[*The question:* can generative AI shrink the time-to-understanding and time-to-patch (without lying to us)?])
    text(fill: white)[Can generative AI shrink the time-to-understanding and time-to-patch (without lying to us)?])
]

#slide(title: "The promise of LLMs in this workflow")[
  #set text(size: 18pt)
  LLMs can act as a *force multiplier* on top of existing tools:
  - *Explain* decompiled pseudo-code in plain language.
  - *Rename* functions / variables and *annotate* structures to recover intent.
  - *Hypothesize* the exploited bug and *draft* a candidate mitigation or patch.

  #v(0.6em)
  An LLM is an *accelerator and co-pilot*, *not* an autonomous replacement for the analyst. Every output must be *verified against the binary*.
]

// ========================= 2. TOOLCHAIN =========================
= The Toolchain

#slide[
  #agenda(current: 2)
]

#slide(title: "The classic RE stack")[
  #set text(size: 17pt)
  #grid(columns: (1fr, 1fr), gutter: 16pt,
    [
      *Static analysis*
      - Disassemblers / decompilers: *Ghidra* (NSA, free), IDA Pro, Binary Ninja.
      - Decompiler output = *pseudo-C* reconstructed from machine code: approximate, no original names/comments.
      - `strings`, PE/ELF headers, imports.
    ],
    [
      *Dynamic analysis*
      - Debuggers: x64dbg, GDB.
      - Sandboxes: Cuckoo / CAPE, isolated VMs.
      - Network / behaviour capture.
    ],
  )
  #v(0.4em)
  #block(fill: m-light, inset: 8pt, radius: 4pt, width: 100%, text(size: 15pt)[*Pseudo-code $eq.not$ source code.* The decompiler guesses types and control flow, which is exactly the noisy input we ask an LLM to interpret.])
]

#slide(title: "The LLM-augmented stack")[
  #set text(size: 17pt)
  The LLM is *wired into* the analysis tool, not used by copy-paste:
  #v(0.5em)
  #align(center)[
    #pbox[Binary] #arrow #pbox[Ghidra\ (decompiler)] #arrow #pbox(fill: m-accent)[MCP bridge] #arrow #pbox[LLM] #arrow #pbox(fill: rgb("#2e7d32"))[Analyst]
  ]
  #v(0.5em)
  - *MCP (Model Context Protocol)* bridges, e.g. *GhidraMCP* (LaurieWired), expose Ghidra's API (list/decompile functions, rename, cross-refs) to an LLM agent.
  - *Static vs. dynamic:* bridges also exist for debuggers/sandboxes, but our focus (and most tooling) is *static decompilation & patching* (using dynamic runs to *verify*).
  - The agent *iterates* (decompile → explain → rename → re-read → propose patch) with a *human in the loop*.
]

// ========================= 3. WORKFLOW =========================
= Manual vs. AI-Augmented Workflow

#slide[
  #agenda(current: 3)
]

#slide(title: "Two lanes, same destination")[
  #set text(size: 15pt)
  #grid(columns: (1fr, 1fr), gutter: 14pt,
    block(fill: m-light, inset: 10pt, radius: 4pt, width: 100%)[
      *Manual (traditional)*
      + Load binary, map functions by hand.
      + Read assembly / pseudo-code line by line.
      + Guess intent, rename, take notes.
      + Reproduce behaviour in a sandbox.
      + Locate the bug, design a mitigation.
      #v(0.3em) _Hours-days, depth depends on expert skill._
    ],
    block(fill: m-accent.lighten(78%), inset: 10pt, radius: 4pt, width: 100%)[
      *AI-augmented*
      + Agent decompiles (via Ghidra) & summarizes functions.
      + LLM explains + renames in bulk.
      + Analyst steers questions ("what triggers this?").
      + LLM drafts IOCs / YARA / patch.
      + *Analyst verifies* against the binary.
      #v(0.3em) _Minutes for triage, verification still required._
    ],
  )
]

#slide(title: "The human factor: fatigue & mistakes")[
  #align(center)[
    #image("diamonds.jpg", height: 58%)
    #v(0.3em)
    #text(size: 15pt)[
      Hours of manual decompilation cause cognitive fatigue: \
      without AI assistance, analysts risk missing critical details or giving up inches before the breakthrough.
    ]
  ]
]

#slide(title: "Where the AI lane helps, and where it doesn't")[
  #set text(size: 15pt)
  #table(columns: (1.4fr, 1fr, 1fr), align: (left, center, center), inset: 7pt,
    stroke: 0.5pt + m-gray,
    table.header([*Dimension*], [*Manual*], [*AI-augmented*]),
    [Speed of first-pass triage], [Slow], [*Fast*],
    [Comprehension for non-experts], [Low], [*Much higher*],
    [Breadth / coverage of code], [Limited by time], [*Broad*],
    [Correctness guarantee], [*Analyst-verified*], [Needs verification],
    [Risk of confident errors], [Low], [*Hallucinations*],
  )
  #v(0.3em)
  #text(size: 14pt, fill: m-gray)[Net effect: AI moves effort from *reading* to *verifying*.]
]

// ========================= 4. EVIDENCE =========================
= Evidence: Speed, Accuracy & Hallucinations

#slide[
  #agenda(current: 4)
]

#slide(title: "Speed & comprehension: what studies show")[
  #set text(size: 16pt)
  - *Human-LLM teaming study* (Eurecom, NDSS 2026, 48 participants): novices' comprehension rose by *~98%*, functions implementing *known algorithms* were triaged up to *$2.4times$ faster*, and *artifact recovery* increased by *66%*.
  - *But*: experts gained little, and some outputs contained *harmful hallucinations* and misleading suggestions.
  #v(0.5em)
  #block(fill: m-dark, inset: 10pt, radius: 4pt, width: 100%,
    text(fill: white, size: 15pt)[Biggest, most reliable win: *lowering the barrier to entry* and speeding up *tedious work*, not replacing expert judgement.])
]

#slide(title: "Remediation & patching is still hard")[
  #set text(size: 16pt)
  - *PatchEval* (2025, 1,000 real CVEs, 230 in execution sandbox): the best single model fixed only *~23%* (53/230). Different models solve different bugs, and combining them reaches *~43%* (98/230).
  - *Architecture study* (arXiv:2603.01257, 2026) compares fixed-workflow vs. single-/multi-agent vs. general code agents, trading *accuracy vs. time & token cost*.
  #v(0.4em)
  //#alert[The LLM *proposes* a patch, a human (and a test-suite) *validates* it.]
  The LLM *proposes* a patch, a human (and a test-suite) *validates* it.
]

#slide(title: "The hallucination problem")[
  #set text(size: 16pt)
  Failure modes reported repeatedly in the literature:
  - *Invented logic*: plausible-sounding but wrong explanations.
  - *Misleading renaming*: a function named `decrypt_payload` that doesn't decrypt.
  - *Low recompilability*: DecLLM (ISSTA 2025) raised recompilable decompiled code from *9% → 25%*. I.e. most output still *doesn't even rebuild*.
  #v(0.3em)
  - *Why automated malware classification fails*: LLMs only read static text (without executing the binary), so obfuscation and hallucinated semantics lead to *wrong family/maliciousness labels*.
  - *Mitigation* #arrow *verify against ground truth:* recompile, diff behaviour, symbolic execution, unit tests.
]

// ========================= 5. DEMO =========================
= Live Demo

#slide[
  #agenda(current: 5)
]

#slide(title: "Demo: before / after")[
  #set text(size: 16pt)
  *The "before":* in 2017, stopping *WannaCry* meant an analyst reading the malware's code live during a global outbreak to find the *kill-switch domain*. Manual, under pressure, hours of work.
  #v(0.5em)
  *The "after" (our demo, stopwatch on screen):*
  + *Act A - Accelerated understanding:* Ghidra + LLM (via GhidraMCP) explains a documented sample in an *isolated VM* → behaviour summary, *IOCs* and a *YARA* rule + mitigation (disable SMBv1 / apply MS17-010).
  + *Act B - End-to-end remediation:* our *own* vulnerable toy binary → LLM spots the bug in the pseudo-code, *proposes the patch*, we recompile → the crash is gone.
]

#slide[
  #set align(center + horizon)
  #text(size: 28pt, fill: m-accent, weight: "bold")[▶ Play recorded demo]
  #v(0.5em)
  //#text(size: 16pt, fill: m-gray)[(Stopwatch overlay: manual estimate vs. AI-augmented time)]
]

// ========================= 6. TAKEAWAYS / REFERENCES =========================
= Takeaways

#slide[
  #agenda(current: 6)
]

#slide(title: "Takeaways")[
  #set text(size: 17.5pt)
  - LLMs *accelerate* reverse engineering by automating *tedious work* (artifact recovery, known patterns) and *lowering barriers for non-experts*.
  - They do *not* replace expert analysts: gains for experts are *marginal*, patch success is *modest* (~23%), and *hallucinations* are real.
  - The discipline that makes it work: *keep a human in the loop* and *verify every output against the binary*.
  - Pure LLM *malware classification* remains unreliable because static models *cannot see runtime behaviour*, where obfuscation and hallucinations lead to wrong labels without execution verification.
]

#slide(title: "References")[
  #set text(size: 13pt)
  - *Human-LLM teaming in RE:* _"Decompiling the Synergy: An Empirical Study of Human-LLM Teaming in Software Reverse Engineering"_, Eurecom, NDSS 2026.
  - *Decompiler refinement:* *DeGPT* (NDSS 2024), *LLM4Decompile* (EMNLP 2024, arXiv:2403.05286), *SoK: LLMs for RE* (arXiv:2509.21821, 2025).
  - *Recompilability & verification:* *DecLLM* (ISSTA 2025), *D-LiFT / D-Score* (arXiv:2506.10125, 2025).
  - *Automated patching:* *PatchEval* (arXiv:2511.11019, 2025), *LLM-Based Architectures for Automated Patching* (arXiv:2603.01257, 2026).
  - *Tooling & context:* *Ghidra* (NSA, ghidra-sre.org), *GhidraMCP* (LaurieWired, GitHub), *AV-TEST* Malware Statistics, *WannaCry* kill-switch analysis (2017).
]

#focus-slide[
  Thank you! \
  #text(size: 20pt)[Questions?]
]
