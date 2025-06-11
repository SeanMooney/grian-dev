# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

OpenStack Horizon is the official web-based dashboard for OpenStack cloud management. The project consists of two main components:

- **`horizon/`** - Core reusable Django framework providing dashboards, panels, tables, and workflow components
- **`openstack_dashboard/`** - Reference implementation that uses the horizon framework to create the actual OpenStack dashboard

## Development Commands

### Python Testing and Development
```bash
# Start development server
tox -e runserver

# Run Python unit tests
tox -e py3

# Run specific test
tox -e py3 -- openstack_dashboard.test.unit.api.test_nova

# Code linting and style checks
tox -e pep8

# Test coverage analysis
tox -e cover

# Django management commands
tox -e manage -- <command>
tox -e manage -- makemigrations
tox -e manage -- migrate
```

### JavaScript/Frontend Testing
```bash
# JavaScript tests with Karma/Jasmine
tox -e npm
npm test

# JavaScript linting
npm run lint
```

### Browser/Integration Testing
```bash
# Selenium tests (requires browser)
tox -e selenium

# Headless browser tests
tox -e selenium-headless

# Integration tests
tox -e integration
```

### Documentation
```bash
# Build documentation
tox -e docs

# Build release notes
tox -e releasenotes

# Extract/compile translations
tox -e translations
```

## Architecture Overview

### Dashboard/Panel Registration System
Horizon uses a pluggable architecture where dashboards and panels are registered through files in `openstack_dashboard/enabled/`. Each file follows the pattern `_XXXX_name.py` where XXXX determines loading order.

Example enabled file structure:
- `_1000_project.py` - Registers the Project dashboard
- `_1030_project_instances_panel.py` - Registers the Instances panel
- `_2000_admin.py` - Registers the Admin dashboard

### Panel Structure Pattern
Each panel follows a consistent Django app structure:
```
panel_name/
├── panel.py         # Panel registration and configuration
├── views.py         # Django views and form handling
├── tables.py        # Data table definitions with actions
├── forms.py         # Django forms for create/edit operations
├── workflows.py     # Multi-step workflows (optional)
├── urls.py          # URL routing patterns
├── tests.py         # Unit tests
└── templates/       # HTML templates
```

### API Integration Layer
The `openstack_dashboard/api/` directory contains service-specific API wrappers:
- `nova.py` - Compute (instances, flavors, etc.)
- `neutron.py` - Networking (networks, security groups, etc.)
- `cinder.py` - Block storage (volumes, snapshots, etc.)
- `glance.py` - Image service
- `keystone.py` - Identity service

### Theme and Customization
- Themes located in `openstack_dashboard/themes/`
- Custom branding via settings and template overrides
- SCSS/CSS customization through Django's static file system

## Key Configuration Files

### Django Settings
- `openstack_dashboard/settings.py` - Main Django configuration
- `openstack_dashboard/local/local_settings.py.example` - Local development template
- `openstack_dashboard/test/settings.py` - Test-specific settings

### Development Setup
Copy the example local settings file:
```bash
cp openstack_dashboard/local/local_settings.py.example \
   openstack_dashboard/local/local_settings.py
```

### Panel Management Commands
```bash
# Create new dashboard
python manage.py startdash <dashboard_name>

# Create new panel
python manage.py startpanel <panel_name>
```

## Testing Framework

- **Python**: Uses pytest with Django test framework, coverage analysis, and testtools
- **JavaScript**: Karma test runner with Jasmine framework for AngularJS components
- **Integration**: Selenium WebDriver for full browser testing
- **Linting**: flake8 for Python, ESLint for JavaScript

## API Integration Patterns

When working with OpenStack APIs:
1. Use the service-specific wrappers in `openstack_dashboard/api/`
2. Handle microversions appropriately for API evolution
3. Implement proper error handling and user messaging
4. Follow the established patterns for pagination and filtering

## Internationalization

- Extract messages: `tox -e manage -- extract_messages`
- Compile messages: `tox -e manage -- compilemessages`
- Custom Babel extractor handles AngularJS templates
- Translation files in `locale/` directories

## Common Development Patterns

- Use Django's class-based views with Horizon's mixins
- Implement tables with actions using `horizon.tables`
- Create multi-step forms using `horizon.workflows`
- Follow OpenStack API client patterns for service integration
- Use consistent error handling and messaging patterns
