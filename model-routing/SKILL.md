---
name: model-routing
description: Use this skill to choose an agent tool or model based on task type, risk, complexity, cost, speed, and required context, and to log the routing rationale.
---

# Model Routing

## Purpose

Select the most appropriate agent tool or model for each task while recording a short, auditable rationale.

## Routing Dimensions

- Task type: development, specification, review, operations, skill-development.
- Risk: low, medium, high, security-critical, data-sensitive.
- Complexity: trivial, simple, moderate, complex, architectural.
- Cost sensitivity: low-cost preferred, balanced, quality-first.
- Speed requirement: immediate, normal, background, deep-analysis.
- Tool fit: opencode, codex, GitHub Copilot, GPT models, GitLab/OpenProject CLIs.

## Baseline Rules

- Use fast/low-cost tools for low-risk mechanical edits, search, formatting, and simple scripts.
- Use stronger GPT/Codex-class reasoning for architecture, complex debugging, refactors, security-sensitive changes, and high-impact decisions.
- Use GitHub Copilot where IDE-local completion or small implementation assistance is the best fit.
- Use opencode for repository-aware local automation when available.
- Escalate to human review before externally visible actions.

## Routing Record

Each routing decision should include:

```json
{
  "task_id": "task-...",
  "selected_tool": "opencode|codex|copilot|gpt|manual",
  "selected_model": "TODO",
  "risk": "low|medium|high|critical",
  "complexity": "trivial|simple|moderate|complex|architectural",
  "cost_mode": "low-cost|balanced|quality-first",
  "rationale": "Short reason."
}
```

## Outputs

- Selected tool/model.
- Short routing rationale.
- Registry event for audit.
