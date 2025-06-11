# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Octavia Dashboard is a Horizon plugin providing a web interface for managing OpenStack Octavia Load Balancers. It's a Django application with AngularJS frontend components.

## Architecture

**Backend**: Django-based Horizon panel plugin
- Main code: `octavia_dashboard/`
- REST API: `octavia_dashboard/api/rest/lbaasv2.py`
- Panel integration: `octavia_dashboard/dashboards/project/load_balancer/panel.py`

**Frontend**: AngularJS 1.x modular structure
- Location: `octavia_dashboard/static/dashboard/project/lbaasv2/`
- Main module: `horizon.dashboard.project.lbaasv2`
- Components: loadbalancers, listeners, pools, members, healthmonitors, l7policies, l7rules

**Resource Hierarchy**: Load Balancer → Listeners → Pools → Members, with Health Monitors and L7 Policies/Rules

## Common Commands

### Testing & Linting
```bash
tox -e py3                 # Run Python unit tests
tox -e pep8                # Python code style check
tox -e karma               # Run JavaScript unit tests
tox -e eslint              # JavaScript linting
npm test                   # Run Karma tests
npm run lint               # Run ESLint
```

### Documentation
```bash
tox -e docs                # Build Sphinx documentation
tox -e releasenotes        # Build release notes
```

## Development Notes

- **Integration**: Install as Horizon plugin via enabled files
- **API Communication**: Uses OpenStack SDK (openstacksdk) for Octavia service calls
- **Testing**: 100% test coverage requirement enforced
- **Frontend**: Pure ES5 AngularJS, no transpilation needed
- **Wizards**: Multi-step workflows in `octavia_dashboard/static/dashboard/project/lbaasv2/workflow/`
