# Grian-UI Architecture

## High-Level Design Decisions

### Technology Stack
- **Backend**: Django (OpenStack Horizon plugin architecture)
- **Frontend**: Server-side rendering with Django templates
- **Interactivity**: HTMX for dynamic updates (no AngularJS/large JS frameworks)
- **Styling**: Bootstrap (following Horizon conventions)

### Key Architectural Principles
1. **Modern Horizon Plugin**: Follow established plugin patterns but use modern approaches
2. **Datasource Abstraction**: Pluggable backends (fake for testing, prometheus for production)
3. **Server-Side First**: Minimize client-side complexity
4. **OpenStack Compliance**: Follow all OpenStack coding standards and AI style guide

### Integration Points
- **Horizon Framework**: Standard plugin integration via enabled files
- **OpenStack Services**: Keystone for auth, potential future service integrations
- **Telemetry Sources**: Prometheus (primary), extensible for other sources

### Reference Architecture
- **Simple Prototype**: `refernce/grian-horizon-plugin/` - basic implementation to replicate
- **Established Patterns**: `refernce/manila-ui/` and `refernce/octavia-dashboard/` for proven approaches
- **Core Framework**: `refernce/horizon/` for deep integration understanding