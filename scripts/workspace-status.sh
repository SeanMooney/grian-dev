#!/bin/bash
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.

# Workspace status overview for grian-ui development

echo "📊 Grian-UI Development Workspace Status"
echo "========================================"
echo ""

# Check current task
if [ -f "scratch/planning/current-task.md" ]; then
    echo "📋 Current Task:"
    echo "---------------"
    head -n 3 scratch/planning/current-task.md | tail -n 1
    echo ""
fi

# Check git status
echo "🔄 Git Status:"
echo "-------------"
git status --short
if [ $? -ne 0 ]; then
    echo "❌ Not in a git repository"
fi
echo ""

# Check grian-ui git status
if [ -d "grian-ui/.git" ]; then
    echo "🔄 Grian-UI Git Status:"
    echo "----------------------"
    cd grian-ui
    git status --short
    if [ $? -eq 0 ] && [ -z "$(git status --porcelain)" ]; then
        echo "✅ Clean working directory"
    fi
    cd ..
    echo ""
fi

# Check virtual environment
if [ -d "grian-ui/.venv" ]; then
    echo "🐍 Python Environment: ✅ Virtual environment exists"
else
    echo "🐍 Python Environment: ❌ Virtual environment not found"
    echo "   Run: ./scripts/setup-dev.sh"
fi
echo ""

# Check for pending todos
if [ -f "scratch/todos/current-sprint.md" ]; then
    echo "📝 Current Sprint Progress:"
    echo "--------------------------"
    grep -E "^\s*- \[[ x]\]" scratch/todos/current-sprint.md | head -5
    echo ""
fi

# Quick file counts
echo "📁 Project Overview:"
echo "-------------------"
echo "Documentation files: $(find docs/ -name "*.md" 2>/dev/null | wc -l)"
echo "Scratch files: $(find scratch/ -name "*.md" 2>/dev/null | wc -l)"
echo "Scripts: $(find scripts/ -name "*.sh" 2>/dev/null | wc -l)"
echo ""

echo "💡 Quick Commands:"
echo "-----------------"
echo "  ./scripts/setup-dev.sh      # Setup development environment"
echo "  ./scripts/run-tests.sh       # Run all tests"
echo "  ./scripts/style-check.sh     # Check style compliance"
echo "  cat scratch/planning/current-task.md  # View current task details"
echo ""