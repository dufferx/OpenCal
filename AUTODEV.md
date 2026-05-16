# OpenCal AutoDev System

> A human-in-the-loop autonomous agent pipeline for building OpenCal with Kimi CLI.

---

## Overview

This directory contains a lightweight multi-agent orchestration system that lets Kimi CLI work on OpenCal semi-autonomously. You kick off a task, Kimi spawns Planner → Implementer → Reviewer subagents, and you verify the Xcode build at the end.

**Autonomy level:** Agents write all Swift/SwiftUI code. You verify builds and merge.

---

## Files

| File | Purpose |
|---|---|
| `AUTOBACKLOG.md` | The agent-facing backlog. Agents read this to know what to build next. |
| `AGENT_PROMPT.md` | The system prompt / golden rules injected to every agent. Based on `CLAUDE.md`. |
| `ORCHESTRATOR_PROMPT.md` | The **copy-paste prompt** you paste into Kimi CLI to start a task. |
| `run_autodev.sh` | Bash helper: picks next task, creates git branch, prints instructions. |
| `scripts/pick_next_task.py` | Reads `AUTOBACKLOG.md` and returns the next active task. |
| `scripts/mark_task_done.py` | Moves a completed task from In Progress/Todo to Done. |

---

## Quick Start

### 1. Start a task

```bash
./run_autodev.sh
```

This will:
- Read `AUTOBACKLOG.md`
- Pick the next task (currently: **User Profile**)
- Create and checkout a git branch `auto/user-profile`
- Print instructions

### 2. Run the orchestrator in Kimi CLI

Copy the **entire contents** of `ORCHESTRATOR_PROMPT.md` and paste it into your Kimi CLI session.

Kimi will then:
1. Read all context documents (`CLAUDE.md`, `AGENT_PROMPT.md`, etc.)
2. Spawn an **Architect** subagent to write `PLAN.md`
3. Spawn an **Implementer** subagent to write the code
4. Spawn a **Reviewer** subagent to verify quality
5. Deliver a final report

### 3. Verify in Xcode

- Open `OpenCal.xcodeproj`
- Build (`Cmd+B`)
- Test on simulator or device
- If issues found, tell Kimi in the same session: `"Fix build errors: <paste errors>"`

### 4. Mark done and continue

```bash
./run_autodev.sh done
```

This moves the task to `## ✅ Done` in `AUTOBACKLOG.md`.

Then run again for the next task:
```bash
./run_autodev.sh
```

---

## Workflow Diagram

```
You                              Kimi CLI                          Git
│                                    │                              │
│── ./run_autodev.sh ─────────────▶│                              │
│                                    │── create branch auto/xxx ───▶│
│                                    │                              │
│── paste ORCHESTRATOR_PROMPT.md ─▶│                              │
│                                    │                              │
│                                    │── Spawn Architect ──────────▶│
│                                    │    writes PLAN.md            │
│                                    │                              │
│                                    │── Spawn Implementer ────────▶│
│                                    │    writes code + commits     │
│                                    │                              │
│                                    │── Spawn Reviewer ───────────▶│
│                                    │    writes REVIEW.md          │
│                                    │                              │
│◀── "TASK COMPLETE" ───────────────│                              │
│                                    │                              │
│── Xcode build + test ────────────▶│                              │
│◀── verify ────────────────────────│                              │
│                                    │                              │
│── ./run_autodev.sh done ────────▶│                              │
│                                    │── commit backlog update ────▶│
```

---

## Adding New Tasks

Edit `AUTOBACKLOG.md` directly:

```markdown
- [ ] **My New Feature** — Short description. Must follow UserProfileRepositoryProtocol. Tag: `swiftui-only`.
```

Keep descriptions actionable and scoped. One screen, one API, one flow — not "rewrite the app."

---

## Agent Safety Rules (Enforced)

Agents are **forbidden** from modifying:
- `*.pbxproj`
- `Info.plist`
- `*.entitlements`
- Existing SwiftData `@Model` properties (migrations break)
- `KeychainHelper.swift`

Agents **must**:
- Use protocols for all cross-layer access
- Use `@Observable`, never `ObservableObject`
- Use `async/await`, never callbacks
- Output the `=== AGENT REPORT ===` block on completion

See `AGENT_PROMPT.md` for the full rule set.

---

## Tips for Best Results

1. **Scope tasks small.** "Implement ProfileView" is better than "Implement Profile + Settings + iCloud Sync."
2. **Reuse existing patterns.** The onboarding steps are a goldmine of reusable components (`FormRow`, `FitnessGoalPickerView`, etc.).
3. **Don't skip Xcode build.** Agents can't compile SwiftUI. You are the build gate.
4. **Keep sessions alive.** If Kimi CLI times out, you can resume the same branch and say `"Continue from PLAN.md"`.
5. **Commit often.** The script already creates branches. Commit within Kimi sessions keeps history clean.

---

## Troubleshooting

| Problem | Fix |
|---|---|
| Kimi says "I cannot spawn subagents" | Make sure you are using the `Agent` tool explicitly in your prompt, or just let Kimi execute inline — it still works, just slower. |
| PLAN.md is vague | Tell the Architect subagent: "Be specific: list exact file paths and function signatures." |
| Reviewer keeps failing | The task may be too large. Break it into smaller tasks in `AUTOBACKLOG.md`. |
| Xcode build fails after agent | Paste the exact compiler error into Kimi and say `"Fix these build errors on branch auto/xxx"`. |
| Agent modified `.pbxproj` | Revert that file: `git checkout -- OpenCal.xcodeproj/project.pbxproj`. Add a stricter rule to `AGENT_PROMPT.md`. |

---

*Happy autonomous coding. 🚀*
