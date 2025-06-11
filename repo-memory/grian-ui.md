# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Grian-UI is an OpenStack Horizon dashboard plugin for telemetry visualization. It's designed to integrate with OpenStack's Horizon web interface to provide telemetry dashboards and monitoring capabilities.

## Architecture

- **Django-based Horizon Plugin**: Built as a Django application that integrates with OpenStack Horizon
- **Pluggable Datasource Architecture**: Supports multiple datasources (fake, prometheus) via `src/grian_ui/datasource/`
- **Development vs Production**: Uses `dev_settings.py` for standalone development, integrates with Horizon settings in production
- **DevStack Integration**: Includes devstack plugin for development environment setup

### Key Components

- `src/grian_ui/datasource/`: Pluggable datasource implementations (fake for testing, prometheus for real data)
- `src/grian_ui/local/`: Horizon integration files (enabled panels, local settings)
- `src/grian_ui/dev_settings.py`: Standalone Django settings for development
- `devstack/`: DevStack plugin for development environment setup

## Development Commands

### Environment Setup
```bash
python3 -m venv .venv
. .venv/bin/activate
python3 -m pip install pre-commit tox git-review
pre-commit install --install-hooks
```

### Testing
- **Unit tests**: `tox -e unit` or `tox -e py3`
- **Functional tests**: `tox -e functional`
- **Style/lint checks**: `tox -e pep8` or `tox -e lint` or `pre-commit run -a`

### Development Server
- **Run with Horizon**: `tox -e runserver`
- **Manual run**: `tox -e venv -- ./manage.py runserver`

### Documentation
- **Build docs**: `tox -e docs`
- **Build PDF docs**: `tox -e pdf-docs`
- **Release notes**: `tox -e releasenotes`
- **Add release note**: `tox -e venv -- reno new your-note-name-here`

### Virtual Environment
- **Access venv with all deps**: `tox -e venv -- <command>`

## Configuration

- **Datasource selection**: Set via `GRIAN_DATA_SOURCE` environment variable (defaults to "fake")
- **Django settings**: Uses `grian_ui.dev_settings` for development
- **Horizon integration**: Configuration files in `src/grian_ui/local/` are copied to Horizon during devstack setup

## DevStack Integration

The project includes a devstack plugin that:
1. Installs the plugin in development mode
2. Copies enabled panels to Horizon's enabled directory
3. Copies local settings to Horizon's local_settings.d directory

## Testing Framework

- **Unit tests**: Located in `tests/grian_ui_tests/unit/`, use Django settings for isolated testing
- **Functional tests**: Located in `tests/grian_ui_tests/functional/`, test with full Horizon integration
- **Test runner**: Uses `stestr` for test execution and reporting
