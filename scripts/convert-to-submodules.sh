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

# Convert existing directories to proper git submodules
# WARNING: This will backup and remove existing directories!

set -e

echo "🔄 Converting to Git Submodules"
echo "==============================="
echo ""
echo "⚠️  WARNING: This will:"
echo "   1. Backup existing directories"
echo "   2. Remove current grian-ui/ and refernce/ directories"
echo "   3. Add them as proper git submodules"
echo ""

read -p "Continue? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Conversion cancelled"
    exit 1
fi

# Create backup directory
BACKUP_DIR="submodule-conversion-backup-$(date +%Y%m%d-%H%M%S)"
echo "📦 Creating backup: $BACKUP_DIR"
mkdir -p "$BACKUP_DIR"

# Backup existing directories
if [ -d "grian-ui" ]; then
    echo "   Backing up grian-ui/"
    cp -r grian-ui "$BACKUP_DIR/"
fi

if [ -d "refernce" ]; then
    echo "   Backing up refernce/"
    cp -r refernce "$BACKUP_DIR/"
fi

# Remove from gitignore
echo "📝 Updating .gitignore"
sed -i '/# Submodule directories/,/refernce\//d' .gitignore

# Remove existing directories
echo "🗑️  Removing existing directories"
rm -rf grian-ui refernce

# Add submodules
echo "➕ Adding git submodules"

echo "   Adding grian-ui..."
git submodule add https://opendev.org/openstack/grian-ui grian-ui

echo "   Creating refernce directory..."
mkdir -p refernce

echo "   Adding refernce/grian-horizon-plugin..."
git submodule add https://github.com/SeanMooney/grian-horizon-plugin/ refernce/grian-horizon-plugin

echo "   Adding refernce/horizon..."
git submodule add https://opendev.org/openstack/horizon refernce/horizon

echo "   Adding refernce/manila-ui..."
git submodule add https://opendev.org/openstack/manila-ui/ refernce/manila-ui

echo "   Adding refernce/octavia-dashboard..."
git submodule add https://opendev.org/openstack/octavia-dashboard refernce/octavia-dashboard

echo "   Adding refernce/openstack-ai-style-guide..."
git submodule add https://github.com/SeanMooney/openstack-ai-style-guide refernce/openstack-ai-style-guide

# Initialize submodules
echo "🔧 Initializing submodules"
git submodule update --init --recursive

# Restore CLAUDE.md files
echo "📋 Restoring CLAUDE.md files"
if [ -f "$BACKUP_DIR/grian-ui/CLAUDE.md" ]; then
    cp "$BACKUP_DIR/grian-ui/CLAUDE.md" grian-ui/
    echo "   Restored grian-ui/CLAUDE.md"
fi

for project in grian-horizon-plugin horizon manila-ui octavia-dashboard openstack-ai-style-guide; do
    if [ -f "$BACKUP_DIR/refernce/$project/CLAUDE.md" ]; then
        cp "$BACKUP_DIR/refernce/$project/CLAUDE.md" "refernce/$project/"
        echo "   Restored refernce/$project/CLAUDE.md"
    fi
done

# Commit the conversion
echo "💾 Committing submodule conversion"
git add .gitmodules .gitignore
git commit -m "Convert to git submodules

- Added .gitmodules with proper remote URLs
- Converted grian-ui and refernce/ projects to submodules
- Preserved local CLAUDE.md files
- Backup created at: $BACKUP_DIR

Generated-By: claude-code"

echo ""
echo "✅ Conversion complete!"
echo ""
echo "📁 Backup available at: $BACKUP_DIR"
echo "🔍 Check status: git submodule status"
echo "📚 Update all: git submodule update --remote"
echo ""