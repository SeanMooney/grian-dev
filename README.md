# Grian-UI Development Repository

A pseudo-monorepo development setup for **Grian-UI**, a modern OpenStack Horizon dashboard plugin for telemetry visualization.

## Repository Structure

This repository contains:

- **grian-ui/** - Main project: Modern OpenStack Horizon plugin for telemetry dashboards
- **refernce/** - Reference directory with related OpenStack projects and resources
- **docs/** - Development documentation and architecture decisions
- **scratch/** - Working space for planning, analysis, and task coordination
- **scripts/** - Development automation scripts

## Quick Start

### Initial Setup
```bash
# Clone with submodules (when converted)
git clone --recursive <this-repo-url>

# Or if already cloned, initialize submodules
git submodule update --init --recursive

# Setup development environment
./scripts/setup-dev.sh
```

### Development Workflow
```bash
# Check workspace status
./scripts/workspace-status.sh

# Run tests
./scripts/run-tests.sh

# Check style compliance
./scripts/style-check.sh

# Development server
cd grian-ui && tox -e runserver
```

## Reference Projects

### Core References
- **refernce/grian-horizon-plugin/** - Simple prototype to replicate in grian-ui
- **refernce/manila-ui/** - Established Horizon plugin (reference patterns)
- **refernce/octavia-dashboard/** - Modern Horizon plugin (reference patterns)
- **refernce/horizon/** - Core Horizon framework (integration reference)

### Development Standards
- **refernce/openstack-ai-style-guide/** - **MANDATORY**: OpenStack coding standards for AI tools

## Development Approach

### Technology Stack
- **Backend**: Django (OpenStack Horizon plugin architecture)
- **Frontend**: Server-side rendering with Django templates
- **Interactivity**: HTMX for dynamic updates (NO AngularJS/large JS frameworks)
- **Styling**: Bootstrap (following Horizon conventions)

### AI Development Requirements
⚠️ **CRITICAL**: ALL code changes MUST follow the OpenStack AI Style Guide:
- Primary reference: `refernce/openstack-ai-style-guide/docs/quick-rules.md`
- Apache 2.0 license headers required
- 79 character line limit (strict)
- AI attribution in commit messages (`Generated-By: claude-code`)

## Project Organization

### Documentation
- **docs/architecture.md** - High-level design decisions
- **docs/roadmap.md** - Feature planning and development phases
- **docs/integration-notes.md** - Reference project analysis

### Planning & Coordination
- **scratch/planning/current-task.md** - Current development focus
- **scratch/todos/** - Task tracking and sprint management
- **scratch/analysis/** - Code analysis and reference reviews
- **scratch/prototypes/** - Quick experiments and proof-of-concepts

### Development Scripts
- **scripts/setup-dev.sh** - Quick environment setup
- **scripts/run-tests.sh** - Flexible test runner (unit/functional/style/all)
- **scripts/style-check.sh** - OpenStack AI style guide compliance
- **scripts/workspace-status.sh** - Development workspace overview

## Git Submodules

This repository uses git submodules to manage dependencies:

### Submodule Management
```bash
# Update all submodules to latest
git submodule update --remote

# Update specific submodule
git submodule update --remote refernce/horizon

# Check submodule status
git submodule status
```

### Submodule URLs
- **grian-ui**: https://opendev.org/openstack/grian-ui
- **grian-horizon-plugin**: https://github.com/SeanMooney/grian-horizon-plugin/
- **horizon**: https://opendev.org/openstack/horizon
- **manila-ui**: https://opendev.org/openstack/manila-ui/
- **octavia-dashboard**: https://opendev.org/openstack/octavia-dashboard
- **openstack-ai-style-guide**: https://github.com/SeanMooney/openstack-ai-style-guide

## Development Flow

1. **Workspace check**: `./scripts/workspace-status.sh`
2. **Style compliance**: Review `refernce/openstack-ai-style-guide/docs/quick-rules.md`
3. **Primary work**: Focus on grian-ui/ directory
4. **Reference lookup**: Use refernce/ projects for implementation patterns
5. **Progress tracking**: Update scratch/planning/ and scratch/todos/

## Architecture

### Key Principles
- **Modern Horizon Plugin**: Follow established patterns but use modern approaches
- **Datasource Abstraction**: Pluggable backends (fake for testing, prometheus for production)
- **Server-Side First**: Minimize client-side complexity
- **OpenStack Compliance**: Follow all OpenStack coding standards

### Integration Points
- **Horizon Framework**: Standard plugin integration
- **OpenStack Services**: Keystone for auth, extensible for other services
- **Telemetry Sources**: Prometheus (primary), extensible for other sources

## Contributing

### Before Making Changes
1. Check `scratch/planning/current-task.md` for context
2. Review OpenStack AI style guide requirements
3. Update progress in scratch/todos/
4. Run style compliance checks

### Code Standards
- Follow `refernce/openstack-ai-style-guide/docs/quick-rules.md`
- Include Apache 2.0 headers in all new files
- Use delayed logging (no f-strings in log messages)
- Include AI attribution in commit messages

### Testing
```bash
# All tests
./scripts/run-tests.sh

# Specific test types
./scripts/run-tests.sh unit
./scripts/run-tests.sh functional
./scripts/run-tests.sh style
```

## Local CLAUDE.md Files

Each submodule contains local CLAUDE.md files with project-specific guidance:
- These are intentionally not committed to preserve local development context
- They provide AI tools with project-specific patterns and requirements
- Update them as development patterns evolve

## Support

- **Issues**: Track in individual project repositories
- **Development Questions**: Use scratch/analysis/ for documentation
- **Style Guide**: Always reference OpenStack AI style guide first