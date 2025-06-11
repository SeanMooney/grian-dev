# Hello World POC Feature Plan

*A minimal proof-of-concept to test the pragmatic testing workflow*

## Objective

Create a simple "Hello World" feature in grian-ui to validate:
- Plugin registration patterns from reference analysis
- Pragmatic testing workflow with gating CI
- HTMX integration for dynamic updates
- OpenStack AI style guide compliance

## POC Scope (Minimal Viable Feature)

### What We'll Build (Phase 1 - Core Structure)
A basic telemetry dashboard panel that:
1. **Shows a greeting message** with current timestamp
2. **Displays fake metrics data** in a simple table
3. **Uses server-side rendering** with standard page refresh

### What We'll Defer (Phase 2 - Future)
- 🔄 HTMX refresh functionality
- 🔄 Error handling and recovery
- 🔄 Loading states and dynamic updates

### What We Won't Build (Keep It Simple)
- ❌ Real telemetry service integration
- ❌ Complex chart rendering
- ❌ Multiple data sources
- ❌ Advanced UI features
- ❌ User authentication/authorization

## Technical Implementation Plan

### Architecture Decision (Phase 1 Focus)
- **Panel registration**: Follow manila-ui hierarchical pattern
- **View pattern**: Simple HorizonTemplateView with server-side rendering
- **Page updates**: Standard Django page refresh (no HTMX yet)
- **Data source**: Simple fake implementation with static responses
- **Testing**: Test-with approach for exploration, atomic commits

### Directory Structure (Following Reference Analysis)
```
grian_ui/
├── enabled/
│   ├── _80_grian_telemetry_panel_group.py
│   └── _90_grian_hello_world_panel.py
├── dashboards/
│   └── project/
│       └── hello_world/
│           ├── __init__.py
│           ├── panel.py
│           ├── views.py
│           ├── urls.py
│           └── templates/
│               └── hello_world/
│                   └── index.html
├── api/
│   └── fake_telemetry.py
└── tests/
    ├── dashboards/
    │   └── project/
    │       └── test_hello_world.py
    └── api/
        └── test_fake_telemetry.py
```

## Feature Requirements

### Core Functionality
1. **Panel Registration**
   - Create "Telemetry" panel group in project dashboard
   - Add "Hello World" panel within telemetry group
   - Panel accessible at `/project/telemetry/hello_world/`

2. **Basic Display**
   - Page title: "Hello World - Telemetry"
   - Greeting: "Hello from Grian-UI!"
   - Current timestamp display (server-generated)
   - Simple table with 3-5 fake metrics entries
   - Standard browser refresh to update content

### User Interface Mockup (Simplified)
```
┌─────────────────────────────────────────┐
│ Project Dashboard > Telemetry > Hello World │
├─────────────────────────────────────────┤
│ Hello World - Telemetry                 │
│                                         │
│ Hello from Grian-UI!                    │
│ Page generated: 2024-01-15 14:30:25     │
│                                         │
│ ┌─── Fake Metrics ───────────────────┐  │
│ │ Metric Name    │ Value  │ Unit     │  │
│ │ CPU Usage      │ 45.2   │ %        │  │
│ │ Memory Usage   │ 2.1    │ GB       │  │
│ │ Disk I/O       │ 150    │ KB/s     │  │
│ │ Network Rx     │ 1.2    │ MB/s     │  │
│ └────────────────┴────────┴──────────┘  │
│                                         │
│ (Use browser refresh to update)         │
└─────────────────────────────────────────┘
```

## Implementation Phases

### Phase 1: Core Structure Only (3 commits)
**Goal**: Get minimal panel working with basic server-side rendering

**Commit 1**: "Add telemetry panel group registration with smoke test"
- Panel group registration file (`_80_grian_telemetry_panel_group.py`)
- Basic smoke test verifying panel group appears in dashboard

**Commit 2**: "Add hello world panel with basic view and template test"
- Panel registration file (`_90_grian_hello_world_panel.py`)
- Basic HorizonTemplateView class
- Simple template with greeting and static content
- Template rendering test

**Commit 3**: "Add fake telemetry API with metrics display and tests"
- Fake API implementation returning structured data
- Update view to use API and display metrics table
- Contract test for API data structure
- Integration test for view + API

### Phase 2: Dynamic Features (Future POC)
**Deferred to validate Phase 1 workflow first:**
- 🔄 HTMX refresh functionality
- 🔄 Error handling and service unavailable scenarios
- 🔄 Loading states and user feedback
- 🔄 Configuration and feature flags

## Testing Strategy (Simplified for Phase 1)

### Test-With Approach (Core Structure)
- **Panel registration**: Smoke tests after implementation to verify integration
- **Basic views**: Template rendering tests after UI design
- **Static display**: Content verification tests after template creation

### Test-First Approach (API Contract)
- **Fake API structure**: Define data contract before implementing view integration
- **Data transformation**: Test expected data format before template consumption

### Bug Fix Pattern (If Issues Arise)
- **FIXME pattern**: Assert current incorrect behavior with explanatory comment
- **Atomic fixes**: Update test and code in same commit to maintain green CI

## Success Criteria

### Functional Success (Phase 1)
- ✅ "Telemetry" panel group appears in Horizon project dashboard
- ✅ "Hello World" panel appears within telemetry group
- ✅ Page loads without errors at correct URL
- ✅ Greeting message and timestamp display correctly
- ✅ Fake metrics table renders with expected data
- ✅ All tests pass on every commit (gating CI requirement)

### Process Success
- ✅ Testing workflow followed correctly (test-with for exploration, test-first for contracts)
- ✅ OpenStack AI style guide compliance verified
- ✅ Reference patterns applied appropriately (manila-ui registration, grian-prototype simplicity)
- ✅ Commits are atomic and meaningful with proper commit messages
- ✅ Documentation reflects actual implementation

## Questions for Iteration

1. **Scope**: Is this simplified 3-commit approach the right level for testing our workflow?
2. **Testing**: Are the test-with vs test-first decisions appropriate for each component?
3. **UI**: Is the simplified mockup (no buttons, just static display) appropriate for POC?
4. **API Contract**: Should the fake API return more/less data for initial testing?
5. **File Structure**: Does the proposed directory structure follow reference patterns correctly?

## Next Steps

Once this simplified plan is approved:
1. Review and refine Phase 1 requirements (if needed)
2. Start implementation in grian-ui following 3-commit sequence
3. Apply testing workflow at each step (test-with for structure, test-first for API)
4. Validate that all tests pass on every commit (gating CI)
5. Document lessons learned from Phase 1
6. Plan Phase 2 (HTMX + error handling) based on Phase 1 experience

---

*This simplified POC focuses on core plugin architecture and testing workflow validation, deferring dynamic features to ensure we master the fundamentals first.*
