# OpenStack Horizon Plugin System Technical Reference

This document provides a comprehensive technical reference for understanding and implementing OpenStack Horizon plugins, specifically for enhancing the grian-ui development workflow.

## Table of Contents

1. [Plugin Architecture Overview](#plugin-architecture-overview)
2. [Plugin Discovery and Loading](#plugin-discovery-and-loading)
3. [Component Registration Patterns](#component-registration-patterns)
4. [Static Content Management](#static-content-management)
5. [Settings Configuration](#settings-configuration)
6. [Plugin Development Patterns](#plugin-development-patterns)
7. [Grian-UI Development Recommendations](#grian-ui-development-recommendations)

## Plugin Architecture Overview

### Core Component Hierarchy

```
Site (Horizon)
└── Dashboard (Project, Admin, Identity)
    └── PanelGroup (Compute, Network, Storage, Telemetry)
        └── Panel (Instances, Volumes, Networks, Dashboards)
            └── Views (Index, Detail, Create, Update)
```

### Key Classes and Registry Pattern

| Class | Location | Purpose |
|-------|----------|---------|
| `Site` | `horizon/base.py:700-1021` | Top-level registry for dashboards |
| `Dashboard` | `horizon/base.py:384-672` | Registry for panels within a dashboard |
| `Panel` | `horizon/base.py:243-339` | Individual UI components |
| `PanelGroup` | `horizon/base.py:341-382` | Grouping mechanism for related panels |

## Plugin Discovery and Loading

### Discovery Process

1. **Automatic App Discovery**: Horizon scans `INSTALLED_APPS` for `dashboard.py` and `panel.py` modules
2. **Enabled File Processing**: Files in `enabled/` directories processed in alphabetical/numeric order
3. **Configuration Merging**: Plugin configurations merged with numeric prefixes determining precedence
4. **Panel Registration**: Panels registered with parent dashboards using Registry pattern

### Core Discovery Implementation

```python
# horizon/base.py:885-907
def _autodiscover(self):
    """Discovers modules to register with Horizon."""
    # Scan INSTALLED_APPS for dashboard and panel modules
    
# openstack_dashboard/utils/settings.py:92-222
def update_dashboards(dashboard_modules, horizon_config, installed_apps):
    """Updates HORIZON_CONFIG with plugin configurations."""
```

### Loading Order and Precedence

- **Enabled files**: Loaded in alphabetical order (numeric prefixes control precedence)
- **_XX_**: System files (00-79)
- **_8X_**: Panel groups (80-89)
- **_9X_**: Panels (90-99)
- **Local overrides**: `local/enabled/` files take precedence

## Component Registration Patterns

### Dashboard Registration

```python
# In dashboard.py
import horizon
from django.utils.translation import gettext_lazy as _

class MyDashboard(horizon.Dashboard):
    name = _("My Dashboard")
    slug = "mydash"
    panels = ('mypanel',)  # Optional explicit panel list
    default_panel = 'mypanel'  # Optional default panel

horizon.register(MyDashboard)
```

### Panel Group Creation

```python
# In enabled/_80_panel_group.py
PANEL_GROUP = 'telemetry'
PANEL_GROUP_NAME = 'Telemetry'
PANEL_GROUP_DASHBOARD = 'project'
ADD_INSTALLED_APPS = ['grian_ui']
AUTO_DISCOVER_STATIC_FILES = True
```

### Panel Registration

```python
# In enabled/_90_panel.py
PANEL = 'dashboard'
PANEL_DASHBOARD = 'project'
PANEL_GROUP = 'telemetry'
ADD_PANEL = 'grian_ui.content.dashboard.panel.Dashboard'

# In panel.py
import horizon
from django.utils.translation import gettext_lazy as _

class Dashboard(horizon.Panel):
    name = _("Dashboard")
    slug = 'dashboard'
    permissions = ('openstack.services.telemetry',)  # Optional
```

### URL and View Registration

```python
# In urls.py
from django.urls import re_path
from . import views

urlpatterns = [
    re_path(r'^$', views.IndexView.as_view(), name='index'),
    re_path(r'^create/$', views.CreateView.as_view(), name='create'),
]

# In views.py  
from horizon import tables
from django.views import generic

class IndexView(generic.TemplateView):
    template_name = "telemetry_dashboard/index.html"
    
    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        # Add plugin-specific context
        return context
```

## Static Content Management

### Automatic Static File Discovery

```python
# In enabled files
AUTO_DISCOVER_STATIC_FILES = True  # Enables automatic discovery

# Manual file specification (if needed)
ADD_JS_FILES = ['dashboard/custom.js']
ADD_SCSS_FILES = ['dashboard/custom.scss']
ADD_ANGULAR_MODULES = ['horizon.dashboard.project.custom']
```

### Static File Organization Patterns

#### Server-Side Rendering Approach (Recommended for Grian-UI)
```
static/
├── components/
│   ├── time_chart/
│   │   ├── chart.css
│   │   ├── chart.html
│   │   └── chart.js
│   └── toggle-switch/
│       ├── index.html
│       └── toggle-switch.css
└── css/
    └── dashboard.css
```

#### Angular/SPA Approach (Reference)
```
static/
├── app/core/openstack-service-api/
├── dashboard/project/lbaasv2/
│   ├── healthmonitors/
│   ├── listeners/
│   ├── loadbalancers/
│   └── workflow/
```

### Static File Processing

- **SCSS Compilation**: `horizon.utils.scss_filter.ScssFilter`
- **JS Compression**: Django-compressor integration
- **Static File Finder**: `horizon.contrib.staticfiles.finders.HorizonStaticFinder`

## Settings Configuration

### Core Plugin Loading Configuration

```python
# In settings.py
from openstack_dashboard.utils import settings as settings_utils

settings_utils.update_dashboards(
    [
        enabled,           # Core enabled files
        local_enabled,     # Local overrides
    ],
    HORIZON_CONFIG,
    INSTALLED_APPS,
)
```

### Development Settings Pattern

```python
# Essential development configuration
INSTALLED_APPS = list(INSTALLED_APPS)
INSTALLED_APPS.append('grian_ui')

# Plugin enabled files discovery
HORIZON_CONFIG['enabled_panels'] = [
    os.path.join(LOCAL_PATH, 'enabled'),
]

# Static files configuration
STATICFILES_DIRS = [
    os.path.join(LOCAL_PATH, 'static'),
]

# Template directories
TEMPLATES[0]['DIRS'].insert(0, os.path.join(LOCAL_PATH, 'templates'))
```

### Plugin-Specific Settings

```python
# In local_settings.d/_90_plugin_name.py
PLUGIN_CONFIG = {
    'feature_enabled': True,
    'datasource': 'prometheus',
    'refresh_interval': 30,
}

# Policy files (if needed)
POLICY_FILES.update({
    'telemetry': 'telemetry_policy.yaml',
})
```

## Plugin Development Patterns

### Modern Server-Side Pattern (Recommended)

**Advantages**:
- Simpler development and debugging
- Better SEO and accessibility
- Reduced JavaScript complexity
- Faster initial page loads

**Implementation**:
```python
# Use Django templates with HTMX for interactivity
class IndexView(generic.TemplateView):
    template_name = "telemetry/index.html"
    
    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context["data"] = json.dumps(self.get_telemetry_data())
        return context
```

### Angular/SPA Pattern (Legacy Reference)

**Use cases**: Complex interactive dashboards, real-time updates
**Complexity**: Higher development overhead, testing complexity

### Django Tables Pattern

```python
# For data listing views
class SharesView(tables.MultiTableView):
    table_classes = (SharesTable,)
    template_name = 'project/shares/index.html'
    
    def get_shares_data(self):
        # Fetch data from API
        pass
```

## Grian-UI Development Recommendations

### Directory Structure

```
grian_ui/
├── enabled/
│   ├── _80_project_telemetry_panel_group.py
│   └── _90_project_telemetry_dashboard_panel.py
├── content/
│   └── dashboard/
│       ├── panel.py
│       ├── urls.py
│       ├── views.py
│       └── templates/
│           └── dashboard/
│               └── index.html
├── api/
│   └── telemetry.py
├── static/
│   └── dashboard/
│       ├── components/
│       └── css/
├── local/
│   └── local_settings.d/
│       └── _90_grian_ui.py
└── templates/
    └── dashboard/
```

### Development Settings Configuration

**File**: `grian_ui/dev_settings.py`

```python
# Plugin discovery and loading
HORIZON_CONFIG = {
    'user_home': 'openstack_dashboard.views.get_user_home',
    'ajax_queue_limit': 10,
    'auto_fade_alerts': {
        'delay': 3000,
        'fade_duration': 1500,
        'types': ['alert-success', 'alert-info']
    },
    'help_url': "https://docs.openstack.org/horizon/",
    'exceptions': {'recoverable': exceptions.RECOVERABLE,
                   'not_found': exceptions.NOT_FOUND,
                   'unauthorized': exceptions.UNAUTHORIZED},
    'angular_modules': [],
    'js_files': [],
    'js_spec_files': [],
}

# Add grian_ui to installed apps
INSTALLED_APPS = list(INSTALLED_APPS)
INSTALLED_APPS.append('grian_ui')

# Configure plugin enabled files path
HORIZON_CONFIG['enabled_panels'] = [
    os.path.join(LOCAL_PATH, 'enabled'),
]

# Static files configuration for plugin
STATICFILES_DIRS = [
    os.path.join(LOCAL_PATH, 'static'),
]

# Template directories for plugin
TEMPLATES[0]['DIRS'].insert(0, os.path.join(LOCAL_PATH, 'templates'))

# Development-specific settings
ALLOWED_HOSTS = ["*", "localhost", "127.0.0.1"]
COMPRESS_ENABLED = False
COMPRESS_OFFLINE = False
```

### Required Enabled Files

**Panel Group**: `_80_grian_ui_panelgroup.py`
```python
#
# SPDX-License-Identifier: Apache-2.0

PANEL_GROUP = "telemetry"
PANEL_GROUP_NAME = "Telemetry"
PANEL_GROUP_DASHBOARD = "project"
ADD_INSTALLED_APPS = ["grian_ui"]
AUTO_DISCOVER_STATIC_FILES = True
```

**Panel**: `_90_grian_ui_dashboard_panel.py`
```python
#
# SPDX-License-Identifier: Apache-2.0

PANEL = "dashboard"
PANEL_GROUP = "telemetry"
PANEL_DASHBOARD = "project"
ADD_PANEL = "grian_ui.content.dashboard.panel.Dashboard"
```

### Plugin Loading Without Symlinking

**Method 1**: Development installation (Recommended)
```bash
cd grian-ui
pip install -e .
```

**Method 2**: Python path manipulation
```python
# In dev_settings.py
import sys
sys.path.insert(0, '/path/to/grian-ui/src')
```

**Method 3**: PYTHONPATH environment variable
```bash
export PYTHONPATH="/path/to/grian-ui/src:$PYTHONPATH"
```

### Testing the Configuration

```bash
cd grian-ui
tox -e runserver
# Visit http://localhost:8000
# Look for "Telemetry" panel group in Project dashboard
```

## Best Practices

### Code Organization
- Follow OpenStack AI Style Guide (`refernce/openstack-ai-style-guide/docs/quick-rules.md`)
- Use proper Apache 2.0 license headers
- Maintain 79-character line limits
- Use delayed logging patterns

### Plugin Architecture
- Prefer server-side rendering over complex JavaScript
- Use HTMX for dynamic interactions
- Implement proper error handling and user feedback
- Follow Django best practices for views and templates

### Development Workflow
- Use enabled files for proper plugin registration
- Leverage automatic static file discovery
- Implement comprehensive unit and functional tests
- Use tox for consistent development environment

### Security and Performance
- Implement proper permission checks
- Sanitize user input appropriately
- Optimize static file delivery
- Use caching where appropriate

## Plugin Testing Infrastructure

### Test Environment Configuration

Based on analysis of Horizon's test infrastructure, plugins should use specialized test configurations that properly isolate and validate plugin functionality.

#### PluginTestCase Base Class

```python
# Use Horizon's PluginTestCase for plugin testing
from openstack_dashboard.test import helpers

class GrianUIPluginTests(helpers.PluginTestCase):
    """Test case for Grian-UI plugin functionality."""
    
    def setUp(self):
        super().setUp()
        import grian_ui.enabled
        from openstack_dashboard.utils import settings
        settings.update_dashboards([grian_ui.enabled], 
                                 HORIZON_CONFIG, INSTALLED_APPS)
```

#### Test Settings Configuration

**File**: `grian_ui/tests/settings.py`

```python
from horizon.test.settings import *  # noqa
from openstack_dashboard.test.settings import *  # noqa

import grian_ui.enabled
import openstack_dashboard.enabled
from openstack_dashboard.utils import settings

# Clean deprecated settings to avoid warnings
HORIZON_CONFIG.pop('dashboards', None)
HORIZON_CONFIG.pop('default_dashboard', None)

# Load plugin configurations
GRIAN_UI_APPS = list(INSTALLED_APPS) + ['grian_ui']
settings.update_dashboards(
    [
        grian_ui.enabled,          # Plugin configs first
        openstack_dashboard.enabled,  # Core configs second
    ],
    HORIZON_CONFIG,
    GRIAN_UI_APPS,
)

# Ensure unique INSTALLED_APPS
INSTALLED_APPS = list(set(GRIAN_UI_APPS))

# Test-specific configurations
GRIAN_DATASOURCE = 'fake'  # Use fake datasource for testing
POLICY_CHECK_FUNCTION = None  # Disable policy checks in tests
```

#### Enabled File Validation Tests

```python
class GrianUIEnabledFileTests(helpers.PluginTestCase):
    """Test enabled file processing and validation."""
    
    def test_panel_registration(self):
        """Test that panels are properly registered."""
        dashboard = horizon.get_dashboard('project')
        panel = dashboard.get_panel('dashboard')
        self.assertIsNotNone(panel)
        self.assertEqual(panel.name, 'Dashboard')

    def test_static_resources_injection(self):
        """Test that static resources are properly injected."""
        # Verify JS files are added to configuration
        js_files = HORIZON_CONFIG.get('js_files', [])
        grian_js_files = [f for f in js_files if 'grian_ui' in f]
        self.assertGreater(len(grian_js_files), 0)
        
        # Verify SCSS files are added
        scss_files = HORIZON_CONFIG.get('scss_files', [])
        grian_scss_files = [f for f in scss_files if 'grian_ui' in f]
        self.assertGreater(len(grian_scss_files), 0)

    def test_panel_group_creation(self):
        """Test that custom panel groups are created."""
        dashboard = horizon.get_dashboard('project')
        panel_group = dashboard.get_panel_group('telemetry')
        self.assertIsNotNone(panel_group)
        self.assertEqual(panel_group.name, 'Telemetry')
```

#### Static File Discovery Testing

```python
def test_auto_discover_static_files(self):
    """Test AUTO_DISCOVER_STATIC_FILES functionality."""
    from horizon.utils import file_discovery
    
    # Mock the file structure
    with mock.patch('horizon.utils.file_discovery.discover_static_files') as mock_discover:
        mock_discover.return_value = (
            ['grian_ui/dashboard.js'],     # sources
            ['grian_ui/dashboard.mock.js'], # mocks  
            ['grian_ui/dashboard.spec.js'], # specs
            ['grian_ui/dashboard.html']     # templates
        )
        
        # Test the discovery mechanism
        horizon_config = {}
        file_discovery.populate_horizon_config(
            horizon_config, '/path/to/grian_ui/static/'
        )
        
        self.assertIn('grian_ui/dashboard.js', horizon_config['js_files'])
        self.assertIn('grian_ui/dashboard.spec.js', horizon_config['js_spec_files'])
```

#### Integration Testing Pattern

```python
class GrianUIPluginIntegrationTests(helpers.PluginTestCase):
    """End-to-end plugin integration tests."""
    
    urls = 'grian_ui.tests.urls'

    def test_panel_accessible(self):
        """Test that plugin panels are accessible via HTTP."""
        with self.settings(ROOT_URLCONF=self.urls):
            response = self.client.get('/project/dashboard/')
            self.assertEqual(response.status_code, 200)
            self.assertContains(response, 'Telemetry Dashboard')

    def test_static_files_served(self):
        """Test that static files are properly served."""
        # Test CSS files
        response = self.client.get('/static/grian_ui/css/dashboard.css')
        self.assertEqual(response.status_code, 200)
        
        # Test JS files
        response = self.client.get('/static/grian_ui/js/dashboard.js')
        self.assertEqual(response.status_code, 200)

    def test_enabled_file_completeness(self):
        """Test that enabled files have all required attributes."""
        import grian_ui.enabled._80_project_telemetry_panel_group as pg_config
        import grian_ui.enabled._90_project_dashboard_panel as panel_config
        
        # Test panel group configuration
        self.assertTrue(hasattr(pg_config, 'PANEL_GROUP'))
        self.assertTrue(hasattr(pg_config, 'PANEL_GROUP_NAME'))
        self.assertTrue(hasattr(pg_config, 'PANEL_GROUP_DASHBOARD'))
        
        # Test panel configuration
        self.assertTrue(hasattr(panel_config, 'PANEL'))
        self.assertTrue(hasattr(panel_config, 'PANEL_DASHBOARD'))
        self.assertTrue(hasattr(panel_config, 'ADD_PANEL'))
```

### Test Development Workflow

#### Test Configuration in dev_settings.py

```python
# Enhanced development settings for plugin testing
from openstack_dashboard.utils import settings as settings_utils

# Import enabled modules for plugin loading
import grian_ui.enabled
import openstack_dashboard.enabled

# Update dashboard configuration with plugin
settings_utils.update_dashboards(
    [
        grian_ui.enabled,          # Plugin enabled files first
        openstack_dashboard.enabled,  # Core enabled files second
    ],
    HORIZON_CONFIG,
    INSTALLED_APPS,
)

# Test-friendly static file configuration
STATICFILES_DIRS = [
    os.path.join(LOCAL_PATH, 'static'),
]

# Disable compression for development/testing
COMPRESS_ENABLED = False
COMPRESS_OFFLINE = False

# Enable debug for development
DEBUG = True
TEMPLATE_DEBUG = DEBUG
```

#### Running Plugin Tests

```bash
# Unit tests for plugin functionality
cd grian-ui
tox -e unit

# Functional tests with Horizon integration  
tox -e functional

# Test plugin loading specifically
python manage.py test grian_ui.tests.test_plugin_loading --settings=grian_ui.tests.settings

# Test enabled file processing
python manage.py test grian_ui.tests.test_enabled_files --settings=grian_ui.tests.settings
```

### Key Testing Insights from Horizon

1. **Use PluginTestCase**: Essential for proper plugin isolation and configuration backup/restore
2. **Test Static Resource Injection**: Verify that AUTO_DISCOVER_STATIC_FILES works correctly
3. **Validate Panel Registration**: Ensure panels and panel groups are properly registered
4. **Integration Testing**: Test HTTP accessibility and proper URL routing
5. **Configuration Completeness**: Verify enabled files have all required attributes
6. **Mock External Dependencies**: Use fake datasources and disable policy checks for testing
7. **Clean Test Environment**: Remove deprecated configuration to avoid warnings

## References

- **Core Horizon Framework**: `refernce/horizon/`
- **Plugin Examples**: `refernce/manila-ui/`, `refernce/octavia-dashboard/`
- **Simple Prototype**: `grian-horizon-plugin/`
- **Style Guide**: `refernce/openstack-ai-style-guide/docs/quick-rules.md`
- **Grian-UI Project**: `grian-ui/`
- **Test Infrastructure**: `refernce/horizon/horizon/test/`, `refernce/horizon/openstack_dashboard/test/`

This reference provides the foundation for implementing a robust, maintainable Horizon plugin development workflow that aligns with OpenStack standards and modern web development practices, including comprehensive testing strategies based on Horizon's proven testing patterns.