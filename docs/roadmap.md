# Grian-UI Development Roadmap

## Phase 1: Foundation (Current)
- [x] Development environment setup
- [x] Pseudo-monorepo structure
- [x] AI style guide integration
- [ ] Basic plugin structure replication from prototype
- [ ] Core datasource abstraction layer
- [ ] Initial UI framework with HTMX

## Phase 2: Core Features
- [ ] Dashboard framework implementation
- [ ] Prometheus datasource integration
- [ ] Basic metric visualization
- [ ] Horizon plugin integration
- [ ] Authentication integration

## Phase 3: Advanced Features
- [ ] Real-time metric updates via HTMX
- [ ] Configurable dashboards
- [ ] Multiple datasource support
- [ ] Performance optimization

## Phase 4: Production Readiness
- [ ] Comprehensive testing suite
- [ ] Documentation completion
- [ ] DevStack integration testing
- [ ] Performance benchmarking

## Decision Points
- **UI Library Choice**: Stick with Bootstrap (Horizon standard) vs modern alternatives
- **Metric Storage**: Direct Prometheus queries vs caching layer
- **Real-time Updates**: HTMX polling vs WebSocket integration