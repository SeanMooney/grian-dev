# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Manila UI is a Django-based OpenStack Horizon plugin that provides a web interface for managing Manila (OpenStack's Shared File Systems service). It extends the Horizon dashboard with panels for managing shares, share networks, security services, and related resources.

## Common Development Commands

### Testing
- `tox -e py3` - Run unit tests
- `tox -e pep8` - Run linting and style checks
- `tox -e cover` - Generate test coverage reports
- `./run_tests.sh` - Run all tests including PEP8
- `./run_tests.sh -N --no-pep8` - Run unit tests only
- `./run_tests.sh -p` - Run only PEP8 checks

### Documentation
- `tox -e docs` - Build documentation
- `tox -e releasenotes` - Build release notes

### Integration Testing
- `tox -e integration` - Run integration tests (requires OpenStack environment)
- `./run_tests.sh --integration` - Alternative integration test command

## Architecture Overview

### Horizon Plugin System
Manila UI integrates with OpenStack Horizon through a plugin architecture:
- **Plugin Registration**: Files in `manila_ui/local/enabled/` register panels with Horizon
- **Numbered Loading**: Plugin files use numeric prefixes (e.g., `_80_`, `_9010_`) to control load order
- **Panel Groups**: Creates "Share" panel groups in both Project and Admin dashboards

### Dashboard Structure
```
manila_ui/dashboards/
├── admin/          # Admin-level panels (system-wide management)
├── project/        # Project-level panels (tenant-specific)
└── identity/       # Identity-related extensions
```

Each dashboard contains:
- **panels/** - Individual UI sections
- **tables.py** - Data tables with actions
- **forms.py** - User input forms
- **views.py** - Django view classes
- **tabs.py** - Multi-tab detail views
- **templates/** - HTML templates

### Key Components

**API Integration** (`manila_ui/api/manila.py`):
- Wraps python-manilaclient
- Uses Manila API version 2.51
- Handles OpenStack authentication and service discovery

**Feature Configuration** (`manila_ui/local/local_settings.d/_90_manila_shares.py`):
- Controls which Manila features are enabled in the UI
- Feature flags like `enable_share_groups`, `enable_replication`, etc.

**Policy Integration** (`manila_ui/conf/`):
- YAML policy files define access permissions
- Integrates with OpenStack policy system

### Testing Architecture
- **Unit Tests**: Located in `manila_ui/tests/` mirroring source structure
- **Integration Tests**: Selenium-based tests in `manila_ui/tests/integration/`
- **Test Data**: Mock objects and fixtures in `manila_ui/tests/test_data/`

## Development Patterns

### Adding New Features
1. Create panel in appropriate dashboard directory (`admin/` or `project/`)
2. Add table, form, and view classes
3. Create templates in `templates/` subdirectory
4. Register panel via plugin file in `manila_ui/local/enabled/`
5. Add corresponding unit tests

### Panel Structure
Each panel typically contains:
- `panel.py` - Panel configuration and registration
- `tables.py` - DataTable definitions with row actions
- `forms.py` - Form definitions for create/edit operations
- `views.py` - Django view classes
- `urls.py` - URL routing
- `templates/` - HTML templates

### API Usage
- Always use the wrapper functions in `manila_ui/api/manila.py`
- Handle exceptions appropriately for user-facing operations
- Use microversion negotiation for API compatibility

## Dependencies
- **Horizon**: Core OpenStack dashboard framework
- **python-manilaclient**: Manila API client library
- **Django**: Web framework (version determined by Horizon)
- **oslo.utils**: OpenStack common utilities
