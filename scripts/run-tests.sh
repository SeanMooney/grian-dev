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

"""Cross-project test runner for grian-ui development."""

set -e

echo "🧪 Running Grian-UI test suite..."
echo ""

# Check if we're in the right directory
if [ ! -d "grian-ui" ]; then
    echo "Error: grian-ui directory not found. Run from repository root."
    exit 1
fi

cd grian-ui

# Parse command line arguments
TEST_TYPE="${1:-all}"

case "$TEST_TYPE" in
    "unit"|"u")
        echo "Running unit tests..."
        tox -e unit
        ;;
    "functional"|"f")
        echo "Running functional tests..."
        tox -e functional
        ;;
    "style"|"s"|"pep8")
        echo "Running style checks..."
        tox -e pep8
        ;;
    "all"|"")
        echo "Running all test types..."
        echo ""
        echo "1/3 - Unit tests..."
        tox -e unit
        echo ""
        echo "2/3 - Functional tests..."
        tox -e functional
        echo ""
        echo "3/3 - Style checks..."
        tox -e pep8
        ;;
    "help"|"-h"|"--help")
        echo "Usage: $0 [test-type]"
        echo ""
        echo "Test types:"
        echo "  unit, u        Run unit tests only"
        echo "  functional, f  Run functional tests only"
        echo "  style, s, pep8 Run style checks only"
        echo "  all            Run all tests (default)"
        echo "  help           Show this message"
        echo ""
        exit 0
        ;;
    *)
        echo "Unknown test type: $TEST_TYPE"
        echo "Use '$0 help' for usage information."
        exit 1
        ;;
esac

echo ""
echo "✅ Test run complete!"
echo ""
