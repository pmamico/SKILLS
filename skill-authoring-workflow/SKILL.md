---
name: skill-authoring-workflow
description: Use this skill to create or refine standard ChatGPT Skill directories with SKILL.md plus optional scripts, references, and assets through interview, plan, implementation, and review.
---

# Skill Authoring Workflow

## Purpose

Create and maintain standard ChatGPT Skill format directories in `~/.agents/skills/` while preserving existing structure and keeping skill behavior auditable.

## Standard Structure

```text
skill-name/
  SKILL.md
  scripts/      # optional executable helpers
  references/   # optional supporting docs
  assets/       # optional binary/static assets
```

## Workflow

1. Interview the user about trigger conditions, inputs, expected behavior, constraints, and examples.
2. Produce a plan for the skill contract and supporting files.
3. Implement or refine `SKILL.md` first.
4. Add scripts only when repeated operational behavior is clear.
5. Preserve all existing directories and files when refining a skill.
6. Review for trigger accuracy, safety, reproducibility, and overreach.
7. Record improvement opportunities for future automation.

## Rules

- Every skill must include `SKILL.md`.
- Do not remove `scripts/`, `references/`, or `assets/` from an existing skill.
- Avoid hidden dependencies; document required tools and tokens.
- Prefer small, composable helper scripts.

## Outputs

- Standard skill directory.
- Review notes.
- Optional helper scripts and references.
