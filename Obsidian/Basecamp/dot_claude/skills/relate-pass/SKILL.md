---
name: relate-pass
description: Run the weekly Relate pass on the Basecamp vault — a read-only checklist of the week's Captured items, recurring unlinked mentions, stale + items, unparented atlas notes, and quiet efforts. Use when Jack asks for his relate pass, weekly review, or what needs linking.
---

# Relate pass

Produce a checklist for Jack's weekly Relate pass (see the ARC section of `Home.md`). Jack does the linking and moving himself; this skill only surfaces what needs attention.

## Hard rule: read-only

Never create, edit, move, rename, or delete anything in the vault, including cache or scratch files. If Jack asks you to act on an item afterwards, that's a separate request — confirm it first.

## Vault conventions

- Vault root is the current directory. Folders: `+/` (inbox), `atlas/` (knowledge, people, MOCs), `calendar/` (daily notes named `YYYY-MM-DD.md`), `efforts/` (projects), `x/` (templates, attachments, bases — ignore it).
- Daily notes have `## Log` (what happened) and `## Captured` (what occurred to him). A bullet that is just `-` with nothing after it is an empty template placeholder; ignore it.
- Atlas notes use `up:` frontmatter. Exceptions that should NOT have `up:`: person notes (`tags: person`) and MOCs (filename ends in ` MOC`).
- Efforts use `status:` (`complete` = done) and an optional `moc:`.
- Links are Obsidian wikilinks: `[[Name]]`, `[[Name|alias]]`, `[[Name#heading]]`.

## Windows

- **This week**: daily notes dated in the last 7 days, by filename date (not file timestamps).
- **Lookback**: daily notes dated in the last 42 days.
- If Jack gives a start date or a number of days, use that for "this week" and keep the lookback at least 42 days.

## Checks

Run these in order. Use `rg`/`grep`, `find`, and `stat` as needed.

1. **Captured this week.** Every non-empty bullet under `## Captured` in this week's daily notes, verbatim, tagged with its source note.
2. **Unlinked mentions of existing notes.** For each note basename in `atlas/` and `efforts/`, find occurrences of that name in lookback daily notes and `+/` files that are not inside `[[...]]`. Case-insensitive, whole-word. Report the name, then each line verbatim with its source. These usually just need a link added.
3. **Recurring things with no note.** Names, phrases, or topics appearing in 3 or more distinct lookback daily notes, spanning at least two different weeks, with no note of that name. Quote each occurrence with its source. Separately, if two or more Captured items look like the same unresolved idea in different words, list them together under "possibly the same thought" — mark it clearly as a guess.
4. **Stale inbox.** Files in `+/` created more than 14 days ago. Get the creation date the platform's way: on macOS `stat -f '%SB' -t '%F' <file>`; on Windows `(Get-Item <file>).CreationTime` in PowerShell; on Linux, where creation time is often unavailable, fall back to modification time and say so.
5. **Atlas notes missing `up`.** Atlas notes with no `up:` value, excluding person notes and MOCs.
6. **Quiet efforts.** Efforts with `status` not `complete` that are not linked from any daily note in the last 14 days. Also list efforts with no `status` at all.

## Output

A single markdown checklist in the terminal, sections in the order above, using `- [ ]` items and `[[wikilinks]]` for sources. Omit any section with nothing in it. End with one line of counts.

- Quote note content verbatim; don't summarize, interpret, or comment on what Jack wrote, especially personal or reflective material.
- No advice on how to link things unless he asks.
- If there are no daily notes in this week's window, say so in one plain line and still run the remaining checks. No commentary on the gap.
