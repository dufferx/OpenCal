#!/usr/bin/env python3
"""
OpenCal AutoDev — Task Picker
Reads AUTOBACKLOG.md and returns the next unchecked task.
Usage: python3 scripts/pick_next_task.py <backlog_file>
"""

import sys

def pick_next_task(filepath):
    with open(filepath, "r", encoding="utf-8") as f:
        lines = f.readlines()

    in_progress_section = False
    todo_section = False

    for line in lines:
        stripped = line.strip()

        # Detect section headers
        if stripped.lower().startswith("##") and "in progress" in stripped.lower():
            in_progress_section = True
            todo_section = False
            continue
        if stripped.lower().startswith("##") and "todo" in stripped.lower():
            in_progress_section = False
            todo_section = True
            continue
        if stripped.lower().startswith("##") and "done" in stripped.lower():
            in_progress_section = False
            todo_section = False
            continue
        if stripped.lower().startswith("##"):
            in_progress_section = False
            todo_section = False
            continue

        # Look for unchecked task in In Progress
        if in_progress_section and stripped.startswith("- [ ]"):
            return stripped.replace("- [ ]", "").strip()

        # Look for unchecked task in Todo
        if todo_section and stripped.startswith("- [ ]"):
            return stripped.replace("- [ ]", "").strip()

    return "NO_TASKS"

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("NO_TASKS")
        sys.exit(0)
    print(pick_next_task(sys.argv[1]))
