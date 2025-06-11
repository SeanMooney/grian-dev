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

"""Quick development environment setup script for grian-ui."""

set -e

echo "Setting up Grian-UI development environment..."

# Check if we're in the right directory
if [ ! -d "grian-ui" ]; then
    echo "Error: grian-ui directory not found. Run from repository root."
    exit 1
fi

cd grian-ui

# Create virtual environment if it doesn't exist
if [ ! -d ".venv" ]; then
    echo "Creating Python virtual environment..."
    python3 -m venv .venv
else
    echo "Virtual environment already exists."
fi

# Activate virtual environment
echo "Activating virtual environment..."
source .venv/bin/activate

# Install development dependencies
echo "Installing development dependencies..."
python3 -m pip install --upgrade pip
python3 -m pip install pre-commit tox git-review

# Install pre-commit hooks
echo "Installing pre-commit hooks..."
pre-commit install --install-hooks

echo ""
echo "✅ Grian-UI development environment ready!"
echo ""
echo "To activate the environment:"
echo "  cd grian-ui && source .venv/bin/activate"
echo ""
echo "Common commands:"
echo "  tox -e unit      # Run unit tests"
echo "  tox -e pep8      # Style checks"
echo "  tox -e runserver # Development server"
echo ""