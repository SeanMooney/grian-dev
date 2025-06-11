# Integration Notes

## Reference Project Analysis

### grian-horizon-plugin (Prototype)
- **Location**: `refernce/grian-horizon-plugin/`
- **Purpose**: Simple prototype to replicate in grian-ui
- **Key Components**:
  - Basic panel group and panel structure
  - Metrics API integration
  - Simple dashboard implementation

### manila-ui (Established Plugin)
- **Location**: `refernce/manila-ui/`
- **Patterns to Study**:
  - Plugin registration and enabled files
  - API client patterns
  - Table and form implementations
  - Testing structure

### octavia-dashboard (Modern Plugin)
- **Location**: `refernce/octavia-dashboard/`
- **Patterns to Study**:
  - Modern Django patterns
  - API abstraction layers
  - Dashboard organization
  - JavaScript integration (to avoid/replace with HTMX)

### horizon (Core Framework)
- **Location**: `refernce/horizon/`
- **Integration Points**:
  - Plugin loading mechanisms
  - Theme and template systems
  - Table, form, and workflow base classes
  - Authentication and policy integration

## Integration Strategy
1. Start with grian-horizon-plugin structure
2. Enhance with patterns from manila-ui and octavia-dashboard
3. Replace JavaScript components with HTMX equivalents
4. Follow horizon core patterns for deep integration