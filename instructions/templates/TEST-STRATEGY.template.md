# TEST STRATEGY: [Project Name]

## 1. Test Layers
| Layer | Scope | Tools | Coverage Target |
|-------|-------|-------|-----------------|
| Unit | Single function/class | [Framework] | ≥80% |
| Integration | Component interactions | [Framework] | Critical paths |
| E2E | Complete user flows | [Tools] | P0 scenarios |

## 2. Unit Test Standards
- Every public function must have tests
- Naming: `Test[FunctionName]_[Scenario]_[ExpectedResult]`
- Must include: happy path, boundary conditions, error paths
- Mock external dependencies

## 3. Integration Test Standards
- Test component contracts
- Use test databases/containers
- Verify transaction behavior

## 4. Test Data
- Use factory pattern for test data
- No shared mutable test state
