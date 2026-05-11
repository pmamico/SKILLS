---
name: remote-agent-orchestrator
description: Use this skill to coordinate the local remote-agent workflow registry, task lifecycle, queues, logs, review points, and agent/tool selection.
---

# Remote Agent Orchestrator

## Purpose

Coordinate multiple agent tasks from a local registry. This skill owns the shared task lifecycle, queue discipline, review gates, log conventions, and routing handoff to task-specific skills.

## When To Use

- Creating, scheduling, pausing, resuming, reviewing, or closing agent tasks.
- Choosing which workflow skill should handle a request.
- Inspecting task status, logs, milestones, or pending review points.
- Deciding whether repeated manual work should become a helper script or a new skill.

## Inputs

- Short task request.
- Optional task type: development, specification, skill-development, operations.
- Optional GitLab project URL or path.
- Optional OpenProject work package id.
- Optional priority, due date, assignee, and preferred agent tool.

## Workflow

1. Classify the request by type, risk, complexity, expected cost, and urgency.
2. Load or create a task record in `~/.agents/registry/state.json`.
3. Route to the most specific workflow skill.
4. Require interview before execution if requirements are incomplete.
5. Require a checkbox plan before autonomous execution.
6. Store decisions, routing rationale, milestones, and review requests as events.
7. Run only explicit, auditable commands through helper scripts.
8. Ask for review at milestone or completion gates.
9. Close the task only after review, MR/document acceptance, and optional worklog handling.

## Safety Rules

- Do not invent GitLab, OpenProject, SSH, or model credentials.
- Treat API tokens and SSH targets as TODO values unless present in config.
- Do not modify unrelated local registry records.
- Prefer append-only events for auditability.
- Escalate to human review before merge requests, release actions, destructive git commands, or worklog submission.

## Outputs

- Updated task state.
- Append-only event log entries.
- Routing decision with short rationale.
- Review request when a gate is reached.
