# ARCHITECTURE: [Project Name]

## 1. Architecture Overview
### 1.1 Architecture Style
[Monolithic/Microservices/Event-driven/Layered/Hexagonal]

### 1.2 Tech Stack
| Layer | Technology | Rationale |
|-------|------------|-----------|
| Language | [Java/Python/TS/Go] | [Reason] |
| Framework | [Name] | [Reason] |
| Storage | [Database] | [Reason] |
| Deployment | [Method] | [Reason] |

## 2. System Architecture Diagram
```
[Use Mermaid or ASCII]
```

## 3. Component Design
### 3.1 Component List
| Component | Responsibility | Dependencies |
|-----------|---------------|--------------|
| [Name] | [Single responsibility] | [Dependencies] |

### 3.2 Component Interactions
```
[Sequence diagram or flow]
```

## 4. Data Design
### 4.1 Data Model
```
[ER diagram or entity definitions]
```

### 4.2 Data Flow
[How data flows through the system]

## 5. Interface Design
### 5.1 Internal Interfaces
| Interface | Input | Output | Error Handling |
|-----------|-------|--------|----------------|
| [Name] | [Type] | [Type] | [Strategy] |

### 5.2 External Interfaces (if applicable)
| Interface | Protocol | Auth | Rate Limit |
|-----------|----------|------|------------|
| [API endpoint] | REST/gRPC | [Method] | [Strategy] |

## 6. Quality Attributes
### 6.1 Scalability
[Horizontal/vertical scaling approach]

### 6.2 Reliability
- Failure detection: [Mechanism]
- Failure recovery: [Mechanism]
- Degradation strategy: [Strategy]

### 6.3 Observability
- Logging: [Standards]
- Metrics: [Key metrics]
- Tracing: [Solution]

### 6.4 Security
- Authentication: [Solution]
- Authorization: [Solution]
- Data protection: [Solution]

## 7. Decision Records (ADR)
| Decision | Options | Choice | Rationale |
|----------|---------|--------|-----------|
| [Decision point] | [Option A/B] | [Choice] | [Trade-off analysis] |
