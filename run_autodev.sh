#!/bin/bash
# OpenCal AutoDev Loop — Preparation & Orchestration Script
# This script automates the bookkeeping (backlog, git branches, reporting).
# The actual AI agent execution happens inside Kimi CLI via copy-paste prompt.
#
# Usage:
#   ./run_autodev.sh            # Pick next task, create branch, print Kimi prompt
#   ./run_autodev.sh done       # Mark current in-progress task as done
#   ./run_autodev.sh status     # Show current task and branch

set -e

BACKLOG="AUTOBACKLOG.md"
AGENT_PROMPT="AGENT_PROMPT.md"
BRANCH_PREFIX="auto"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd "$SCRIPT_DIR"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

function print_header() {
    echo ""
    echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  🤖 OpenCal AutoDev Loop${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
    echo ""
}

function pick_task() {
    local task
    task=$(python3 scripts/pick_next_task.py "$BACKLOG")
    if [ "$task" == "NO_TASKS" ]; then
        echo -e "${GREEN}✅ All tasks complete! Nothing left in the backlog.${NC}"
        exit 0
    fi
    echo "$task"
}

function slugify() {
    echo "$1" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -cd '[:alnum:]-' | cut -c1-50
}

function ensure_git_clean() {
    if [ -n "$(git status --porcelain 2>/dev/null)" ]; then
        echo -e "${YELLOW}⚠️  Working directory has uncommitted changes.${NC}"
        echo "Please commit or stash them before starting the AutoDev loop."
        exit 1
    fi
}

function cmd_status() {
    print_header
    local task
    task=$(pick_task)
    if [ "$task" != "NO_TASKS" ]; then
        echo -e "${YELLOW}🟡 Next task:${NC} $task"
        echo ""
        echo -e "${BLUE}Suggested branch:${NC} ${BRANCH_PREFIX}/$(slugify "$task")"
    fi
    echo ""
    echo -e "${BLUE}Current git branch:${NC} $(git branch --show-current 2>/dev/null || echo 'N/A')"
}

function cmd_done() {
    print_header
    local task
    task=$(python3 scripts/pick_next_task.py "$BACKLOG")
    if [ "$task" == "NO_TASKS" ]; then
        echo -e "${YELLOW}No in-progress task found.${NC}"
        exit 0
    fi

    echo -e "${BLUE}Marking task as done:${NC} $task"
    python3 scripts/mark_task_done.py "$BACKLOG" "$task"

    # Optional: commit the backlog update
    git add "$BACKLOG" 2>/dev/null || true
    git commit -m "chore: mark '$task' as done in backlog" 2>/dev/null || true

    echo ""
    echo -e "${GREEN}✅ Task marked complete. Run ./run_autodev.sh to start the next one.${NC}"
}

function cmd_start() {
    print_header
    ensure_git_clean

    local task
    task=$(pick_task)

    echo -e "${YELLOW}🎯 Selected task:${NC}"
    echo "   $task"
    echo ""

    local branch_name
    branch_name="${BRANCH_PREFIX}/$(slugify "$task")"

    # Create and checkout branch
    if git show-ref --verify --quiet "refs/heads/$branch_name"; then
        echo -e "${YELLOW}Branch $branch_name already exists. Checking it out.${NC}"
        git checkout "$branch_name"
    else
        echo -e "${BLUE}Creating branch:${NC} $branch_name"
        git checkout -b "$branch_name"
    fi

    echo ""
    echo -e "${GREEN}═══════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}  ✅ Prep complete. Next: run the Kimi orchestrator${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "${BLUE}Copy and paste the prompt from ORCHESTRATOR_PROMPT.md into Kimi CLI.${NC}"
    echo -e "${BLUE}When Kimi finishes, verify the build in Xcode, then run:${NC}"
    echo ""
    echo "   ./run_autodev.sh done"
    echo ""
    echo -e "${BLUE}If the build fails or needs rework, fix in the same branch and re-run Kimi.${NC}"
}

# Main dispatch
case "${1:-start}" in
    status)
        cmd_status
        ;;
    done)
        cmd_done
        ;;
    start|"")
        cmd_start
        ;;
    *)
        echo "Usage: ./run_autodev.sh [start|done|status]"
        exit 1
        ;;
esac
