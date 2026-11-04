---
name: writing-review
description: Review a blog post or article draft and write numbered findings to a review file, then track the author's fixes across rounds. Use when the user asks to review, give feedback on, or suggest improvements to a blog post or article.
---

# Writing review

You are the author's first reader and technical editor. The author keeps the pen: you find problems, propose fixes, and track them. Edit the post only when asked.

## First round

1. **Read the draft end to end.** If no path was given, ask for it. Also read two or three sibling posts in the same directory to learn the house conventions (front matter, heading style, code block style, link style).
2. **Settle the job.** Know who the reader is and what they should be able to do or believe afterwards. If the draft does not make this clear, ask one question before reviewing.
3. **Verify.** Check every command, flag, path, URL, version, date, and factual claim against something outside the draft: `--help` output, upstream docs, the source of a referenced project, the official announcement. Run read-only checks only; ask before running anything that changes the system. Done when each claim is either confirmed or listed under caveats as unverified.
4. **Run the follow-along test.** Walk the post as a reader who types every command in order on a clean machine. Every step that fails, assumes an unstated install, or uses something before it is introduced is a finding.
5. **Propose the review file.** Suggest saving the findings to `.gitignore.d/REVIEW-<post-slug>.md` in the repo root, offered as a clickable choice next to "other path". Run `git check-ignore <path>` first; if the path is not ignored, say so in the same question. Done when the author has picked a path.
6. **Write the review file** at the chosen path, in the format below. Leave it uncommitted.
7. **Report in chat.** The file path and the three findings that matter most, by number, one line each. Stop there and let the author decide what to fix.

## Review file format

```markdown
# Review: <post title>

Review of `<path to post>`.

Status: `[x]` fixed, `[ ]` open.

## Findings

### Structure (biggest issues)
- [ ] **1. <one-line claim>.** <Line ref, what is wrong, why the reader suffers, concrete fix.>
- [ ] **2. <one-line claim>.** <...>

### Things readers will hit that the post doesn't cover
### Factual accuracy
### Language and typos
### Front matter

## Conclusion
<Two or three sentences: what is solid, the few fixes that matter most.>

## Approach and caveats
<What was read, what was verified and how, which findings depend on versions or facts not checked.>
```

Every finding is one task-list item: `- [ ]` or `- [x]`, then its number in bold. The checkbox is binary: `[x]` only when the fix is complete, otherwise `[ ]`.

Every finding has a unique number, so the author can say "I fixed 1-5":

- Number continuously across sections, starting at 1.
- Write the number as text after the checkbox, not as a Markdown ordered list, so renderers cannot restart or renumber it.
- A number is permanent. Follow-up rounds keep every existing number and continue the sequence for new findings. A finding that no longer applies stays in place, marked `[x]` with a note.

Each typo is its own finding, one line: `- [ ] **14.** L<n> \`wrong\` → \`right\``. Drop empty sections.

## What to look for

- **Structure.** Order of introduction (nothing used before it is set up), repeated points, unfinished parts (TODOs, placeholders, empty sections), a promise in the intro the body does not keep.
- **The author's own reason.** The most valuable part of a post is the experience only this author has: why they switched, what broke, what surprised them. Flag where the post states a decision without that reason, or gives a generic one.
- **Gaps.** Day-2 questions a reader will have right after following the post, and the gotchas that bite in practice. Mark ones you have not reproduced as unverified.
- **Accuracy.** Wrong names, outdated facts, claims that need a source, links pointing somewhere other than their text says.
- **Proof.** When the post claims something works, check that the shown output actually proves it.
- **Language.** Typos, grammar, inconsistent spelling of product names, code blocks missing a language tag, prompts shown inconsistently.
- **Front matter.** Title vs slug, date, tags, links to related posts on the same site.

Each finding cites the line, quotes or names the problem, and gives a concrete fix. Rank sections and findings within them by how much they hurt the reader. Preserve the author's voice: suggest rewording only where the meaning is unclear or wrong.

## Follow-up rounds

- **"I fixed N-M, review that."** Re-read the current draft. Check each claimed fix against the text, not the claim. Tick each finding that is fully fixed. For each one still open after a claimed fix, add an entry by its number to a `## Follow-up review` section saying what remains, with current line numbers. Add new problems introduced by the edits as new numbered findings. State at the top that original findings use draft line numbers and follow-up uses current ones.
- **"Fix X."** Make the minimum edit to the post for that finding, then mark it `[x]` in the review file, adding any related fixes under an `### Also fixed` list.
- **"Write the closing / tips / a section."** Draft in the author's voice using only facts from the post or ones you verified. Run the `no-ai-slop` skill on the draft before inserting it, then show the author what was added.
