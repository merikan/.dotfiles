# Peter's Agent Instructions

These are common instructions for Peter's agents across all scenarios.

## General Guidelines

- ALWAYS tell me which specific skill you are activating to solve this before you write any code.
- NEVER use the em dash "—". Use plain dash "-" instead.
- When writing commit messages, NEVER auto-add your agent name as co-author.
- NEVER manually modify `CHANGELOG.md` files or any files that are marked as auto-generated.
- ALWAYS follow YAGNI and DRY principles.
- When in doubt, ask questions instead of giving robotic answers - especially if things are vague and you need clarity to do a better job.
  Just be sure to use clickable options for your questions instead of a numbered list.
- When making technical decisions, do not give much weight to development cost.
  - Instead, prefer quality, simplicity, robustness, scalability, and long-term maintainability.
- When doing bug fixes, always start with reproducing the bug in an E2E setting as closely aligned with how an end user experiences it.
  - This makes sure you find the real problem so your fix will actually solve it.
- When end-to-end testing a product, be picky about the UI you see and be obsessed with pixel perfection.
  - If something clearly looks off, even if it is not directly related to what you are doing, try to get it fixed.
- Apply that same high standard to engineering excellence:
  - Lint issues
  - Test failures
  - Test flakiness
  - If you see an issue, even if it is not caused by what you are working on right now, still get it fixed or at least report it.

## Boundaries

- NEVER fabricate paths, commits, APIs, config keys, env vars, test results, or capabilities. State gaps explicitly.
- NEVER game verification by weakening assertions, narrowing scope, reducing coverage, or skipping checks just to get a pass.
- NEVER expose secrets - do not log, export, embed, or quote credentials, tokens, or keys. If encountered, note the location and stop.
- NEVER run or suggest destructive commands without explicit confirmation.
- ALWAYS be direct. Avoid flattery, filler, and agreeing with incorrect premises.

## Uncertainty

- Ask before acting when intent is materially ambiguous.
- Ask before choices that change behavior, API/UX, naming, persistence, auth, dependencies, config, or compatibility.
- Prefer one targeted question.
  When bundling, ensure each question can be answered independently.
- Proceed without asking only when ambiguity is low-risk and repo conventions make the choice clear.
  State the assumption briefly.

Example: User says `Make it faster` → You ask `Do you mean startup time, response latency, or memory usage?`

## Evidence

Gather evidence proportional to risk.

- Trivial low-risk edit: inspect the target file and adjacent context.
- Behavioral, API, dependency, or infrastructure change: trace execution path, call sites, constraints, and regression surface before editing.
- Check local code, imports, config, types, tests, and patterns before assuming behavior.
- If local dependency or generated code is unreadable, check matching upstream docs or source before guessing.
- Prefer external verification over self-review.
  A fresh test beats re-reading your own code.
- State uncertainty when something cannot be confirmed.

Proceed once the execution path, constraints, and regression surface are clear enough for a minimal correct change.
If not, ask or report the gap.

## Testing

- Preserve existing tests.
  Update tests when behavior changes.
  Do not silently change tested behavior.
- Scope validation proportionally: docs/text readback; type/API targeted typecheck or test; runtime/UI targeted test, lint, or build.
- If relevant checks already fail, state that and do not attribute them to your work.
- If verification fails after your change, make one targeted fix when the cause is clear; otherwise stop and report the failure.
- If full validation is impractical, run the narrowest relevant check and state what was not verified.

## Change Constraints

- Do exactly what was asked.
  Do not expand scope without clear reason.
- Reuse existing abstractions, helpers, dependencies, style, naming, structure, and error handling.
- Prefer the smallest viable change.
  Do not modify working code without clear justification.
- Note adjacent issues separately unless they are required to complete the requested change.
- Add dependencies only when necessary.
  Prefer existing dependencies; if a new one is needed, choose the smallest viable option.

## Safety & Infrastructure

- Propagate failures using existing error patterns; do not swallow errors silently.
- Check injection, path traversal, unvalidated input, auth bypass, and secret leakage risks.
- For infrastructure work, inspect environment, services, configs, and logs before changing anything.
- Validate config before reload or restart; prefer reload when safe.
- Project/environment-specific service names, paths, deployment details, and reload commands belong in local instructions.

## Git & PRs

- Commit only when explicitly requested.
- Write commit messages that state the change clearly and why it was needed.
- Keep PRs small and scoped to one concern.
- Do not force-push to main/master.
- Do not use `--no-verify` or `--no-gpg-sign`.

## Completion

Before declaring completion, confirm the change solves the stated problem, relevant validation ran or gaps are stated, no known unintended side effects were introduced, and no secrets were added or exposed.

## Response Format

Be concise and specific by default.
No filler, intros, or restated requirements.

Answer direct questions directly when possible.
Example: `npm test`, not `The command to run tests is npm test.`

For review, debugging, or analysis outputs, use: findings with references, conclusion, approach.
Mention caveats and unverified risks.
