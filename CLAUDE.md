# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Structure

This is a pseudo-monorepo development setup for **Grian-UI**, an OpenStack Horizon dashboard plugin for telemetry visualization. The repository structure:

- **grian-ui/** - Main project: Modern OpenStack Horizon plugin for telemetry dashboards (cloned to root)
- **refernce/** - Reference directory containing related OpenStack projects and resources

### Reference Directory Contents
- **openstack-ai-style-guide/** - **CRITICAL**: AI coding standards for OpenStack projects
- **grian-horizon-plugin/** - Simple prototype of grian-ui (reference implementation)
- **manila-ui/** - Established Horizon plugin (reference for patterns)
- **octavia-dashboard/** - Established Horizon plugin (reference for patterns)
- **horizon/** - Core Horizon framework (reference for integration)

## **MANDATORY: AI Style Guide Compliance**

⚠️ **CRITICAL**: ALL code changes MUST follow the OpenStack AI Style Guide located at `refernce/openstack-ai-style-guide/docs/quick-rules.md`

### Required Reading
- **Primary**: `refernce/openstack-ai-style-guide/docs/quick-rules.md` - Essential rules (optimized for token efficiency)
- **Secondary**: `refernce/openstack-ai-style-guide/docs/comprehensive-guide.md` - Detailed context when needed

### Key Requirements
- Apache 2.0 license headers in all files
- 79 character line limit (strict)
- No bare except statements
- autospec=True in all mock.patch decorators
- Delayed logging (no f-strings in log messages)
- Proper import ordering (stdlib, third-party, local)
- AI attribution in commit messages (`Generated-By: claude-code`)

## Modern Development Approach for Grian-UI

Grian-UI is designed as a **modern Horizon plugin** with these architectural principles:

### Technology Choices
- **NO AngularJS** or large JavaScript frameworks
- **Server-side rendering** with Django templates
- **HTMX** for dynamic client-side interactivity
- **Modern Python patterns** (prefer over legacy approaches in reference plugins)

### Reference Usage Strategy
- **grian-horizon-plugin/**: Simple prototype to replicate in grian-ui
- **manila-ui/** & **octavia-dashboard/**: Established patterns for Horizon integration
- **horizon/**: Core framework understanding

## Primary Development

The main development work happens in the **grian-ui/** directory. This directory has its own CLAUDE.md with detailed instructions for:

- Environment setup and dependencies
- Testing (unit, functional, style checks)
- Development server setup
- Documentation building

### Quick Start for grian-ui
```bash
cd grian-ui
python3 -m venv .venv
. .venv/bin/activate
python3 -m pip install pre-commit tox git-review
pre-commit install --install-hooks
```

### Common Development Tasks
- **Workspace overview**: `./scripts/workspace-status.sh`
- **Setup environment**: `./scripts/setup-dev.sh`
- **Run all tests**: `./scripts/run-tests.sh`
- **Style compliance**: `./scripts/style-check.sh`
- **Development server**: `cd grian-ui && tox -e runserver`
- **Quick unit tests**: `cd grian-ui && tox -e unit`

### AI Workflow Integration
- **Context files**: Always read `scratch/planning/current-task.md` first
- **Progress tracking**: Update task files as work progresses
- **Reference analysis**: Document findings in `scratch/analysis/`
- **Style compliance**: Mandatory check against OpenStack AI style guide

## Architecture Context

Grian-UI is built as a Django application that integrates with OpenStack Horizon. Key architectural concepts:

- **Pluggable Design**: Uses OpenStack's standard plugin architecture for Horizon
- **Datasource Abstraction**: Supports multiple telemetry backends (fake for testing, prometheus for production)
- **Testing Strategy**: Separate unit tests (isolated) and functional tests (with Horizon integration)
- **Modern UI Approach**: Server-side rendering with HTMX instead of heavy JavaScript frameworks

## Workspace Organization

### Scratch Directory Usage
- **scratch/planning/current-task.md** - Always check/update this for context
- **scratch/analysis/** - Store code analysis and reference reviews
- **scratch/prototypes/** - Quick experiments and proof-of-concepts
- **scratch/todos/** - Task tracking and work coordination

### Before Starting Work
1. Check `scratch/planning/current-task.md` for context
2. Review `refernce/openstack-ai-style-guide/docs/quick-rules.md`
3. Update `scratch/todos/current-sprint.md` with progress
4. Run `./scripts/workspace-status.sh` for overview

### Development Scripts
- **scripts/setup-dev.sh** - Quick environment setup
- **scripts/style-check.sh** - Style guide compliance check
- **scripts/run-tests.sh** - Flexible test runner (unit/functional/style/all)
- **scripts/workspace-status.sh** - Development workspace overview

## Development Flow

1. **Workspace check**: Run `./scripts/workspace-status.sh` to understand current state
2. **Style compliance**: Always check `refernce/openstack-ai-style-guide/docs/quick-rules.md` before coding
3. **Primary work**: Focus on grian-ui/ directory
4. **Reference lookup**: Use refernce/ projects for implementation patterns
5. **Prototype reference**: Check grian-horizon-plugin/ for simple implementation examples
6. **Modern patterns**: Favor server-side rendering and HTMX over complex JavaScript
7. **Progress tracking**: Update scratch/todos/ and scratch/planning/ as work progresses