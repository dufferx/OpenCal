#!/usr/bin/env python3
"""
OpenCal AutoDev — Task Marker
Moves a completed task from Todo/In Progress to Done in AUTOBACKLOG.md.
Usage: python3 scripts/mark_task_done.py <backlog_file> "<task description>"
"""

import sys

def mark_task_done(filepath, task_description):
    with open(filepath, "r", encoding="utf-8") as f:
        lines = f.readlines()

    # Find the line index that contains this task
    target_idx = None
    for i, line in enumerate(lines):
        if line.startswith("- [ ]") and task_description in line:
            target_idx = i
            break

    if target_idx is None:
        print(f"Task not found or already done: {task_description}")
        return False

    # Mark the line as done
    lines[target_idx] = lines[target_idx].replace("- [ ]", "- [x]", 1)

    # Find the Done section and insert after its header
    done_header_idx = None
    for i, line in enumerate(lines):
        if line.strip().lower().startswith("##") and "done" in line.lower():
            done_header_idx = i
            break

    if done_header_idx is None:
        # Append Done section at end
        lines.append("\n## ✅ Done\n")
        lines.append(lines[target_idx])
        # Remove from original position
        del lines[target_idx]
    else:
        # Insert after Done header
        lines.insert(done_header_idx + 1, lines[target_idx])
        # Remove from original position (now shifted by +1)
        if target_idx > done_header_idx:
            del lines[target_idx + 1]
        else:
            del lines[target_idx]

    with open(filepath, "w", encoding="utf-8") as f:
        f.writelines(lines)

    print(f"Marked done: {task_description}")
    return True

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python3 scripts/mark_task_done.py <backlog_file> '<task>'")
        sys.exit(1)
    success = mark_task_done(sys.argv[1], sys.argv[2])
    sys.exit(0 if success else 1)
