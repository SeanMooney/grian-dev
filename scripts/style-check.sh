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

"""Style guide compliance checker for OpenStack AI standards."""

set -e

echo "🔍 Checking OpenStack AI Style Guide compliance..."
echo ""

# Check if we're in the right directory
if [ ! -d "grian-ui" ]; then
    echo "Error: grian-ui directory not found. Run from repository root."
    exit 1
fi

# Reference the style guide
STYLE_GUIDE="refernce/openstack-ai-style-guide/docs/quick-rules.md"
if [ ! -f "$STYLE_GUIDE" ]; then
    echo "⚠️  Warning: Style guide not found at $STYLE_GUIDE"
else
    echo "📖 Using style guide: $STYLE_GUIDE"
fi

echo ""
echo "Running automated style checks..."

cd grian-ui

# Run tox pep8 checks
if command -v tox &> /dev/null; then
    echo "Running tox pep8 checks..."
    tox -e pep8
    echo "✅ Automated style checks complete"
else
    echo "❌ tox not found. Install with: pip install tox"
    exit 1
fi

echo ""
echo "📋 Manual compliance checklist:"
echo "  □ Apache 2.0 license headers in all new files"
echo "  □ 79 character line limit (strict)"
echo "  □ No bare except statements"
echo "  □ autospec=True in all mock.patch decorators"
echo "  □ Delayed logging (no f-strings in log messages)"
echo "  □ Proper import ordering (stdlib, third-party, local)"
echo "  □ AI attribution in commit messages"
echo ""
echo "📚 Review detailed guidelines: $STYLE_GUIDE"
echo ""
