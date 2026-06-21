# Architecture: Orientate+

## Overview

Mobile-first vocational guidance platform using Hexagonal Architecture + DDD. Supports offline capability, future web/AI extensions.

## Module Responsibilities

### Domain (Core Business Logic)

| Module | Entities | Value Objects | Purpose |
|--------|----------|---------------|---------|
| `career_core` | Job, Skill, Category | SkillLevel, SalaryRange | Career taxonomy & relationships |
| `learner` | Student, Goal, Interest, Profile | SkillAssessment, PrivacyPrefs | Student profiles & progress tracking |
| `content` | Course, Module, Question | Locale, Version | Educational content & assessment |
| `recommendation` | PreferenceSet, FeatureVector | OutcomeScore, ConfidenceLevel | ML-driven career/path suggestions |
| `gamification` | Quest, Reward, Badge | Points, AchievementStatus | Engagement mechanics |
| `location` | Region, Country, State, City | Geolocation, RadiusFilter | Geographic filtering |
| `analytics` | Event, Session, Metric | Timestamp, OutcomeMetric | Telemetry & model tuning |

### Application (Use Cases & Orchestration)

| Module | Services | Ports | Purpose |
|--------|----------|-------|---------|
| `services` | CareerService, LearningService, UserService, ContentService, RecommendationService, GamificationService, AnalyticsService | Internal orchestration only | Thin use-case coordinators |
| `ports` | CareerPort, LearnerPort, ContentPort, RecommendationPort, GamificationPort, LocationPort, AnalyticsPort | — | Outbound interfaces (hexagonal) |
| `dtos` | CareerDTO, LearnerDTO, QuizDTO, RecommendationDTO | — | Cross-layer data contracts |

### Infrastructure (External Adapters)

| Module | Adapters | Purpose |
|--------|----------|---------|
| `adapters` | SupabaseAdapter, PythonMLAdapter, NotificationAdapter, CacheAdapter, GeoAdapter | Implementation of ports |
| `persistence` | UserPrefs, OfflineCache, DatabaseMigrator | Framework-specific integrations |

### Presentation (UI)

| Module | Components | Purpose |
|--------|-----------|---------|
| `ui` | Screens, Widgets, Pages | Platform-agnostic UI primitives |
| `bloc` | CareerBloc, LearnerBloc, QuizBloc, RecommendationBloc | State management (BLoC/Cubit) |
| `managers` | SessionManager, ConnectivityManager, SyncManager | Cross-screen concerns |

## Dependency Rules (Onion Model)

```
presentation → application → domain
     ↓              ↓           ↑
infrastructure —————→↑
```

- **Domain**: Zero dependencies on outer layers. Pure Dart.
- **Application**: Depends only on domain. No Flutter imports.
- **Infrastructure**: Implements domain/application ports.
- **Presentation**: Depends on application layer only (via ports).

## Offline Strategy

1. **Local cache**: Hive (mobile) / Redis (server) via CacheAdapter.
2. **Sync queue**: Pending changes stored in `infrastructure/persistence/offline_queue.dart`.
3. **Conflict resolution**: Last-write-wins + domain-level reconciliation.

## Future Extensions

| Capability | Hook Point | Implementation Path |
|------------|------------|---------------------|
| Web frontend | Presentation layer | Add `presentation/web` with Render-SDK abstraction. |
| AI features | RecommendationPort | New adapter (e.g., VertexAIAdapter). |
| Recommendation engines | Recommendation aggregate | Add new scoring algorithms. |

## Notes

- This document is a living spec. Update as modules evolve.
- Strict TDD enforced: unit-test coverage ≥80% for domain.