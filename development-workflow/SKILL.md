---
name: development-workflow
description: Use this skill for GitLab-backed development tasks that require interview, planning, branch creation, autonomous execution, monitoring, review, merge request creation, and optional OpenProject worklog handling.
---

# Development Workflow

## Purpose

Drive a software development task from a short request to a reviewed GitLab merge request while keeping local state, plan, logs, branch choices, and review gates explicit.

## Required Context

- GitLab project path or URL.
- Short business goal.
- OpenProject work package id or permission to create one.
- Target environment assumptions.

## Workflow

1. Inspect project metadata and relevant repository state.
2. Select base branch: `develop`, otherwise `main`, otherwise `master`.
3. Update the base branch before creating work branch.
4. Create or link an OpenProject task.
5. Run a professional and technical interview from the short request.
6. Produce an execution plan with many checkboxes.
7. Store the plan in the local registry.
8. Start autonomous execution only after plan acceptance or explicit start.
9. Keep logs, milestones, and blockers in the registry.
10. Request human review at milestone and completion gates.
11. Continue with new instructions after review if needed.
12. Create a GitLab merge request at the end.
13. Optionally record work hours after approval.

## Branch Rules

- Work on a dedicated branch per task.
- Branch names should include task id and short slug.
- Do not push, merge, or close remote resources unless explicitly requested.

## Integration TODOs

- TODO: GitLab API token or authenticated `glab` session.
- TODO: OpenProject API token and base URL.
- TODO: SSH target for M1 remote agent host.

## Outputs

- Interview notes.
- Checkbox execution plan.
- Branch and MR metadata.
- Review requests and review outcomes.
- Optional worklog proposal.
