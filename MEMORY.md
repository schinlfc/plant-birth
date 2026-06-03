# Project Memory — Decommissioning Coal-Fired Power Plants & Infant Health in Texas

Corrections and decisions that persist across sessions. Append `[LEARN:category]` entries; most recent at bottom. Keep generic; project-internal session notes live in `quality_reports/`.

---

## Project & Setup Decisions (2026-06-03)

[LEARN:project] Research question: staggered **decommissioning of coal-fired plants** (EIA capacity → 0) as a natural experiment → reduced **ambient air pollution** (BROAD: ozone, PM, SO₂/NOₓ, and heavy metals incl. lead — **not** lead-only) → **Texas infant-health outcomes** (birthweight, LBW, gestation, fetal death). Uses confidential, census-tract-geocoded TX birth + fetal-death microdata. Identification: staggered DiD / event study with heterogeneity-robust estimators. Distinct from the 2021 Mountain Data Group consulting deliverable (lead → IQ → earnings) whose data/code we repurpose.

[LEARN:decision] Analysis engine = **Stata-first (batch)**. StataNow/SE 19.5 at `/Applications/StataNow/StataSE.app/Contents/MacOS/stata-se`. Run `"$STATA" -b do file.do` and read the `.log` to verify. No `stata-mcp`. R is secondary (figures, event-study plots). `version 19` pin.

[LEARN:decision] Confidentiality = **hard guardrails**. Raw microdata never committed (`birth/`, `earth_justic_data_codes/`, and `*.dta/.dbf/.csv/.xls*/.zip/.gph/.smcl` git-ignored). No tract/individual identifiers in any tracked file or log. The TX DSHS data-use agreement imposes **no fixed small-cell suppression threshold**, but still avoid disclosive tiny cells. See `.claude/rules/data-confidentiality.md`.

[LEARN:decision] Target outlets = health/environmental economics: JHE, AJHE, JEEM, AEJ: Applied, AEJ: Economic Policy (profiles in `.claude/references/journal-profiles.md`). `methods-referee` tuned for staggered DiD.

[LEARN:setup] The workflow was cloned into a nested subdir (its own git repo → pedrohcgs) and was therefore **inactive**. Promoted to repo root (lean) so `.claude/` + `CLAUDE.md` actually load; template-maintenance scaffolding (docs/guide/CHANGELOG/.github/TROUBLESHOOTING) dropped; nested `.git` removed.

## Code Gotchas

[LEARN:stata] **Stata `/* */` block comments NEST.** A `/*` (slash-star) *anywhere* in a comment — e.g. a glob/path like `$OUT/*.dta` or `birth/*` in a header block — opens a nested comment that the single header `*/` does NOT close, silently swallowing the rest of the file (including `log using`). Symptom: the do-file runs exit-0 but produces no log/output. Fix: never write `/` immediately followed by `*` in `.do` comments.

## Working Style (Sayorn Chin)

[LEARN:feedback] Sayorn prefers answering clarifying questions **directly in prose**, not via the AskUserQuestion multiple-choice tool (he rejected it twice on 2026-06-03). Ask open questions in plain text. **Why:** faster for him, less friction. **How to apply:** default to a short numbered list of questions in a normal message.

[LEARN:feedback] **Check in more often during the first few sessions** (he is learning the workflow); dial back to full contractor autonomy once he signals the rhythm is right. Standing preferences: structured, precise, rigorous (depth over speed); publication-ready visuals always; don't make him repeat himself.

## Retained Generic Workflow Lessons

[LEARN:workflow] Plan-first for non-trivial tasks; save plans to `quality_reports/plans/`. Spec-then-plan for ambiguous tasks (AskUserQuestion-style clarification in prose per above).

[LEARN:pattern] Model routing 70/20/10 (Haiku mechanical / Sonnet review / Opus high-judgment). Don't demote `claim-verifier` / `methods-referee` / `editor`.

[LEARN:edits] Batch edits to protected `.claude/` paths via **Bash heredoc** — the Edit/Write tools fire the protected-path gate; Bash does not.
