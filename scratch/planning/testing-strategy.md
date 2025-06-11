# Pragmatic Testing Strategy for Grian-UI Development

*A balanced approach to testing that works with gating CI where every commit must pass*

## Philosophy: Pragmatic Test-Driven Development with Gating CI

### Core Principles
1. **Every commit must pass all tests** (Gating CI requirement)
2. **Test-First**: When requirements are clear and behavior is well-defined
3. **Test-With**: When exploring design space - tests evolve alongside code
4. **Bug reproducer pattern**: Assert current (incorrect) behavior, then fix atomically
5. **Test-Smart**: Focus testing effort where it provides maximum value

### Gating CI Adaptations
- **No failing tests in commits**: Use FIXME pattern for bug reproducers
- **Atomic feature commits**: Include both code and tests for new functionality
- **Incremental testing**: Each commit adds value and maintains green build

## Bug Fix Workflow: FIXME Pattern for Gating CI

### Standard Bug Fix Process
1. **Write reproducer test** that asserts current (incorrect) behavior
2. **Add FIXME comment** explaining why test asserts wrong behavior
3. **Comment out correct assertion** for future fix
4. **Commit reproducer** - all tests pass, bug is documented
5. **Fix the code** and update test atomically
6. **Remove FIXME, uncomment correct assertion** in same commit

### Example Bug Fix Workflow
```python
# Commit 1: Add bug reproducer (all tests pass)
class ChartRenderingBugTests(test.TestCase):
    def test_chart_handles_empty_data(self):
        """Test for issue #123: Chart fails with no data"""
        with mock.patch('grian_ui.api.telemetry.get_metrics', return_value=[]):
            response = self.client.get('/project/telemetry/metrics/')

            # FIXME(smooney): Currently fails with JS error when no data
            # Bug reproducer - assert current incorrect behavior
            self.assertContains(response, 'JavaScript error')

            # TODO: After fix, should show empty state message
            # self.assertContains(response, 'No data available')
            # self.assertNotContains(response, 'JavaScript error')

# Commit 2: Fix bug and update test atomically
class ChartRenderingBugTests(test.TestCase):
    def test_chart_handles_empty_data(self):
        """Test for issue #123: Chart fails with no data - RESOLVED"""
        with mock.patch('grian_ui.api.telemetry.get_metrics', return_value=[]):
            response = self.client.get('/project/telemetry/metrics/')

            # Fixed: Now shows appropriate empty state
            self.assertContains(response, 'No data available')
            self.assertNotContains(response, 'JavaScript error')
```

## Testing Strategy by Development Phase

### Phase 1: Core Structure & Exploration
**Approach**: **Test-With** (Incremental Development)

**Workflow**:
1. **Basic implementation + smoke test** in same commit
2. **Iterate with tests** as design evolves
3. **Each commit passes tests** but adds incremental value

**Example Commit Sequence**:
```python
# Commit: "Add basic metrics panel with smoke test"
class MetricsPanel(horizon.Panel):
    name = "Metrics"
    slug = "metrics"

class MetricsPanelSmokeTest(test.TestCase):
    def test_panel_loads_without_error(self):
        """Basic smoke test - panel is accessible"""
        response = self.client.get('/project/telemetry/metrics/')
        self.assertEqual(response.status_code, 200)

# Commit: "Add basic metrics view with template rendering test"
class MetricsView(views.HorizonTemplateView):
    template_name = 'metrics/index.html'

class MetricsViewTests(test.TestCase):
    def test_metrics_view_renders_template(self):
        """Verify template renders correctly"""
        response = self.client.get('/project/telemetry/metrics/')
        self.assertTemplateUsed(response, 'metrics/index.html')
        self.assertContains(response, 'Telemetry Metrics')
```

### Phase 2: Data Integration & Chart Rendering
**Approach**: **Test-First** for API contracts, **Test-With** for UI

**API Development Workflow**:
```python
# Commit: "Add telemetry API interface with contract tests"
class TelemetryAPITests(test.TestCase):
    def test_get_metrics_returns_expected_structure(self):
        """Define API contract - using fake implementation initially"""
        result = get_metrics(self.request, 'cpu.usage', '1h')

        # Test against initial fake implementation
        self.assertIn('timestamps', result)
        self.assertIn('values', result)
        self.assertIn('metadata', result)

def get_metrics(request, metric_name, time_range):
    """Fake implementation for initial contract testing"""
    return {
        'timestamps': [1234567890],
        'values': [10.5],
        'metadata': {'unit': 'percentage'}
    }

# Commit: "Implement Prometheus backend for telemetry API"
def get_metrics(request, metric_name, time_range):
    """Real Prometheus implementation"""
    client = get_prometheus_client(request)
    # Real implementation

class TelemetryAPITests(test.TestCase):
    def test_get_metrics_prometheus_integration(self):
        """Test real Prometheus integration"""
        with mock.patch('grian_ui.api.telemetry.prometheus_client') as mock_client:
            mock_client.query_range.return_value = self.sample_data
            result = get_metrics(self.request, 'cpu.usage', '1h')
            self.assertEqual(len(result['values']), 2)
```

### Phase 3: Advanced Features & Optimization
**Approach**: **Test-First** for new features, **Test-With** for optimizations

**Feature Development Example**:
```python
# Commit: "Add time range selection feature with tests"
class TimeRangeSelectionTests(test.TestCase):
    def test_time_range_parameter_affects_data_query(self):
        """Test new time range functionality"""
        with mock.patch('grian_ui.api.telemetry.get_metrics') as mock_get:
            self.client.get('/project/telemetry/metrics/', {'time_range': '24h'})
            mock_get.assert_called_with(mock.ANY, mock.ANY, '24h')

    def test_invalid_time_range_uses_default(self):
        """Test error handling for invalid time ranges"""
        with mock.patch('grian_ui.api.telemetry.get_metrics') as mock_get:
            self.client.get('/project/telemetry/metrics/', {'time_range': 'invalid'})
            mock_get.assert_called_with(mock.ANY, mock.ANY, '1h')  # default

# Implementation included in same commit
class MetricsView(views.HorizonTemplateView):
    def get_context_data(self, **kwargs):
        time_range = self.request.GET.get('time_range', '1h')
        if time_range not in ['1h', '6h', '24h', '7d']:
            time_range = '1h'  # default

        context = super().get_context_data(**kwargs)
        context['metrics_data'] = get_metrics(self.request, 'cpu.usage', time_range)
        return context
```

## Testing Patterns by Component Type

### 1. Plugin Registration & Configuration
**Strategy**: **Test-With** (Implementation + smoke test)

```python
# Single commit: implementation + test
class PluginRegistrationTests(test.TestCase):
    def test_telemetry_panel_group_registered(self):
        """Verify plugin registration works"""
        from horizon import dashboard
        project_dashboard = dashboard.get_dashboard('project')
        panel_groups = [pg.slug for pg in project_dashboard.get_panel_groups()]
        self.assertIn('telemetry', panel_groups)

    def test_metrics_panel_registered_in_telemetry_group(self):
        """Verify panel appears in correct group"""
        from horizon import dashboard
        project_dashboard = dashboard.get_dashboard('project')
        telemetry_group = project_dashboard.get_panel_group('telemetry')
        panel_slugs = [p.slug for p in telemetry_group.get_panels()]
        self.assertIn('metrics', panel_slugs)
```

### 2. API Layer Error Handling
**Strategy**: **Test-First** for error scenarios

```python
# Commit: "Add telemetry API error handling with tests"
class TelemetryAPIErrorTests(test.TestCase):
    def test_service_unavailable_handled_gracefully(self):
        """Test service unavailable scenario"""
        with mock.patch('grian_ui.api.telemetry.prometheus_client',
                       side_effect=ConnectionError("Service unavailable")):
            result = get_metrics(self.request, 'cpu.usage', '1h')
            # Should return empty data structure, not raise exception
            self.assertEqual(result['values'], [])
            self.assertEqual(result['error'], 'Service unavailable')

    def test_invalid_metric_name_handled(self):
        """Test invalid metric name scenario"""
        with mock.patch('grian_ui.api.telemetry.prometheus_client') as mock_client:
            mock_client.query_range.return_value = {'data': {'result': []}}
            result = get_metrics(self.request, 'invalid.metric', '1h')
            self.assertEqual(result['values'], [])

# Implementation in same commit
def get_metrics(request, metric_name, time_range):
    """Telemetry API with error handling"""
    try:
        client = get_prometheus_client(request)
        data = client.query_range(metric_name, time_range)
        return transform_prometheus_data(data)
    except ConnectionError as e:
        return {'values': [], 'timestamps': [], 'error': str(e)}
    except Exception as e:
        LOG.exception("Unexpected error in get_metrics")
        return {'values': [], 'timestamps': [], 'error': 'Internal error'}
```

### 3. HTMX Dynamic Updates
**Strategy**: **Test-With** (Explore interaction, then test behavior)

```python
# Commit: "Add HTMX chart updates with interaction tests"
class HTMXChartUpdateTests(test.TestCase):
    def test_chart_data_endpoint_returns_partial_html(self):
        """Test HTMX partial update endpoint"""
        response = self.client.get('/project/telemetry/metrics/chart_data/',
                                   {'time_range': '6h'},
                                   HTTP_HX_REQUEST='true')
        self.assertEqual(response.status_code, 200)
        # Should return partial template, not full page
        self.assertTemplateUsed(response, 'metrics/partials/chart.html')
        self.assertContains(response, 'data-chart-values')

    def test_non_htmx_request_redirects_to_main_page(self):
        """Test regular requests are handled appropriately"""
        response = self.client.get('/project/telemetry/metrics/chart_data/')
        self.assertEqual(response.status_code, 302)  # Redirect to main view

# Implementation in same commit
def chart_data_view(request):
    """HTMX endpoint for chart updates"""
    if not request.headers.get('HX-Request'):
        return redirect('horizon:project:metrics:index')

    time_range = request.GET.get('time_range', '1h')
    chart_data = get_metrics(request, 'cpu.usage', time_range)

    return render(request, 'metrics/partials/chart.html', {
        'chart_data': chart_data
    })
```

## Commit Message Patterns

### Feature Development
```bash
# Single commit with implementation + tests
git commit -m "Add time range selection for metrics charts

- Add time range dropdown with 1h, 6h, 24h, 7d options
- Implement HTMX partial updates for chart data
- Add validation for time range parameters
- Include tests for time range functionality and HTMX updates

Closes-Bug: #124"
```

### Bug Fixes
```bash
# Commit 1: Document bug with reproducer
git commit -m "Add reproducer test for chart rendering with empty data

Documents issue #123 where chart fails to render when no metrics
are available. Test currently asserts incorrect behavior with
FIXME comment indicating expected fix.

Related-Bug: #123"

# Commit 2: Fix bug atomically
git commit -m "Fix chart rendering when no telemetry data available

- Handle empty metrics data gracefully in chart component
- Show 'No data available' message instead of JavaScript error
- Update test to assert correct behavior
- Add additional edge case tests for empty data scenarios

Closes-Bug: #123"
```

### Exploration/Refactoring
```bash
git commit -m "Refactor telemetry API for better testability

- Extract prometheus client creation to separate method
- Add dependency injection for easier mocking
- Maintain existing API contract and behavior
- All existing tests continue to pass unchanged"
```

## Development Workflow Integration

### Daily Development with Gating CI
1. **Feature branch work**: Develop with incremental, passing commits
2. **Local test runs**: Ensure tests pass before each commit
3. **Atomic changes**: Each commit includes relevant tests
4. **Code review ready**: Every commit in PR is independently valid

### Pre-commit Checklist
```bash
# Before every commit:
cd grian-ui
source .venv/bin/activate

# Run relevant test subset quickly
tox -e unit -- tests/relevant_module/

# Run style checks
tox -e pep8

# Quick integration test if UI changes
tox -e integration -- tests/dashboards/test_metrics.py

# Full test run before pushing (optional but recommended)
tox -e unit
```

### Merge Request Strategy
- **Each commit tells a story**: Readable commit history
- **CI passes on every commit**: No "fix tests" commits
- **Incremental value**: Each commit adds working functionality
- **Bisectable history**: Can identify issues at any commit

## Conclusion

This approach enables:
- **Confident continuous integration** with gating CI
- **Pragmatic testing** that serves development needs
- **Maintainable test suite** with clear patterns
- **Atomic bug fixes** with proper documentation
- **Incremental feature development** with built-in quality

The key insight is that tests should always pass, but they can initially assert current (incorrect) behavior when documenting bugs, then be atomically updated when fixing the issue.
