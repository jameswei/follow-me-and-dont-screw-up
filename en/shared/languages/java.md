# Java Code Standards
# Reference: Google Java Style Guide + Effective Java

## Format & Style

### Indentation & Braces
- Use 2 spaces for indentation (no tabs)
- Opening brace on same line
- Column limit: 100 characters

```java
// Good
public class Example {
  public void doSomething() {
    if (condition) {
      doWork();
    }
  }
}

// Bad
public class Example
{
  public void doSomething()
  {
    if (condition)
    {
      doWork();
    }
  }
}
```

### Imports
- No wildcard imports
- Import order: java, javax, org, com, project-internal

```java
import java.util.List;
import java.util.Optional;
// Not: import java.util.*;
```

## Naming Conventions

| Type | Convention | Example |
|------|------------|---------|
| Classes | PascalCase, nouns | `UserService`, `OrderRepository` |
| Interfaces | PascalCase, adjectives/nouns | `Comparable`, `UserRepository` |
| Methods | camelCase, verb-first | `getUser()`, `processOrder()` |
| Variables | camelCase | `userName`, `orderCount` |
| Constants | UPPER_SNAKE_CASE | `MAX_RETRY_COUNT` |
| Type Parameters | Single uppercase letter | `T`, `E`, `K`, `V` |

## Type System

### Use final

```java
// Non-inheritable classes
public final class UserService { }

// Non-overridable methods
public class BaseService {
  public final void initialize() { }
}

// Immutable variables
public void process(final String input) {
  final int count = calculateCount();
}
```

### Prefer Optional

```java
// Good
public Optional<User> findById(String id) {
  // ...
}

// Caller handles
User user = findById(id)
    .orElseThrow(() -> new NotFoundException("User not found: " + id));

// Bad
public User findById(String id) {
  // May return null
}
```

### Avoid Raw Types

```java
// Good
List<String> names = new ArrayList<>();

// Bad
List names = new ArrayList(); // Raw type
```

## Method Design

### Parameter Validation

```java
public void transferMoney(Account from, Account to, Money amount) {
  requireNonNull(from, "Source account must not be null");
  requireNonNull(to, "Destination account must not be null");
  requireNonNull(amount, "Amount must not be null");
  
  if (amount.isNegativeOrZero()) {
    throw new IllegalArgumentException("Amount must be positive");
  }
  
  // ...
}
```

### Use Builder Pattern (for many parameters)

```java
// Good
User user = User.builder()
    .id("123")
    .name("John")
    .email("john@example.com")
    .build();

// Bad (too many parameters)
User user = new User("123", "John", "john@example.com", ...);
```

## Exception Handling

### Checked vs Unchecked Exceptions

```java
// Checked: caller can reasonably recover
public class InsufficientFundsException extends Exception {
  public InsufficientFundsException(String message) {
    super(message);
  }
}

// Unchecked: programming errors
public class InvalidStateException extends RuntimeException {
  public InvalidStateException(String message) {
    super(message);
  }
}
```

### Exception Translation

```java
try {
  externalApi.call();
} catch (ExternalApiException e) {
  throw new DomainException("Failed to process payment", e);
}
```

## Concurrency

### Use java.util.concurrent

```java
// Good
ExecutorService executor = Executors.newFixedThreadPool(4);
Future<Result> future = executor.submit(task);

// Use CompletableFuture
CompletableFuture.supplyAsync(this::fetchData)
    .thenApply(this::transform)
    .thenAccept(this::save);
```

### Thread Safety Annotations

```java
@ThreadSafe
public class ConcurrentCache {
  private final ConcurrentHashMap<String, Object> cache = 
      new ConcurrentHashMap<>();
}

@NotThreadSafe
public class SimpleCounter {
  private int count = 0;
}
```

## Testing

### Use JUnit 5 + AssertJ

```java
@DisplayName("UserService")
class UserServiceTest {
  
  @Test
  @DisplayName("should return user when found")
  void shouldReturnUserWhenFound() {
    // Given
    String userId = "123";
    when(repository.findById(userId)).thenReturn(Optional.of(user));
    
    // When
    User result = service.findById(userId);
    
    // Then
    assertThat(result).isNotNull();
    assertThat(result.getId()).isEqualTo(userId);
  }
  
  @Test
  @DisplayName("should throw exception when user not found")
  void shouldThrowExceptionWhenUserNotFound() {
    // Given
    String userId = "unknown";
    when(repository.findById(userId)).thenReturn(Optional.empty());
    
    // When/Then
    assertThatThrownBy(() -> service.findById(userId))
        .isInstanceOf(NotFoundException.class)
        .hasMessageContaining(userId);
  }
}
```

## Dependency Injection

```java
// Use constructor injection
@Service
public class UserService {
  private final UserRepository repository;
  private final EventPublisher publisher;
  
  public UserService(UserRepository repository, EventPublisher publisher) {
    this.repository = repository;
    this.publisher = publisher;
  }
}
```

## Logging

```java
private static final Logger logger = LoggerFactory.getLogger(UserService.class);

public void process() {
  logger.debug("Processing user: {}", userId);
  
  try {
    // ...
  } catch (Exception e) {
    logger.error("Failed to process user: {}", userId, e);
  }
}
```
