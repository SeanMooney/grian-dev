# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is **grian-horizon-plugin**, an OpenStack Horizon dashboard plugin that provides real-time hypervisor metrics visualization. The plugin adds a "Metrics" panel to Horizon's Project dashboard with interactive charts showing CPU, RAM, and disk utilization across hypervisors.

## Development Commands

### Code Quality
```bash
# Run linter and formatter
ruff check .
ruff format .

# Run pre-commit hooks manually
pre-commit run --all-files
```

### Frontend Dependencies
```bash
# Update vendor libraries (Chart.js, HTMX)
cd grian_horizon_plugin/static/vendor
./get_vendor.sh
```

### Testing
```bash
# Run tests (pytest-based)
pytest

# Run with coverage
pytest --cov
```

## Architecture

### Plugin Structure
- **enabled/**: Horizon plugin registration files that create the Metrics panel group
- **api/**: REST endpoints serving Chart.js-compatible JSON data for metrics
- **content/**: Django views, URLs, and panel definitions
- **templates/**: Main dashboard and HTMX partial templates
- **static/**: Custom web components (`time-chart`, `toggle-switch`) and vendor libs

### Key Technical Patterns

**HTMX + Server-Side Rendering**: Uses HTMX for partial page updates every 5 seconds. API endpoints return both JSON data and rendered HTML partials for seamless updates.

**Custom Web Components**: The `<time-chart>` element encapsulates Chart.js functionality with Shadow DOM and Mutation Observer for automatic updates when data changes.

**Datasource Abstraction**: Metrics backend is pluggable via `api/datasource/` - currently only has "fake" implementation generating sample data.

**Horizon Plugin Integration**: Follows OpenStack conventions with proper panel registration, static file discovery, and Django app structure.

### Data Flow
1. Main template renders with initial metrics data
2. HTMX triggers refresh every 5 seconds via `hx-get` to API endpoints
3. API returns updated JSON data and HTML partials
4. Custom `<time-chart>` components automatically update charts when DOM changes
5. Toggle switches control refresh intervals (5s/5m/15m)

## Configuration

Settings are in `local/local_settings.d/_90_grian.py` for Horizon integration. The plugin auto-registers its static files and creates the Metrics panel in the Project dashboard.
