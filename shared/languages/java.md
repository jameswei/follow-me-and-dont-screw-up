# Java 代码规范
# 参考: Google Java Style Guide + Effective Java

## 格式与风格

### 缩进与括号
- 使用 2 个空格缩进（非 Tab）
- 左大括号不换行
- 列限制: 100 字符

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

### 导入
- 不使用通配符导入
- 导入顺序: java, javax, org, com, 项目内部

```java
import java.util.List;
import java.util.Optional;
// 不是: import java.util.*;
```

## 命名规范

| 类型 | 规范 | 示例 |
|------|------|------|
| 类 | PascalCase, 名词 | `UserService`, `OrderRepository` |
| 接口 | PascalCase, 形容词/名词 | `Comparable`, `UserRepository` |
| 方法 | camelCase, 动词开头 | `getUser()`, `processOrder()` |
| 变量 | camelCase | `userName`, `orderCount` |
| 常量 | UPPER_SNAKE_CASE | `MAX_RETRY_COUNT` |
| 泛型参数 | 单个大写字母 | `T`, `E`, `K`, `V` |

## 类型系统

### 使用 final

```java
// 类不可继承
public final class UserService { }

// 方法不可重写
public class BaseService {
  public final void initialize() { }
}

// 变量不可变
public void process(final String input) {
  final int count = calculateCount();
}
```

### 优先使用 Optional

```java
// Good
public Optional<User> findById(String id) {
  // ...
}

// 调用方处理
User user = findById(id)
    .orElseThrow(() -> new NotFoundException("User not found: " + id));

// Bad
public User findById(String id) {
  // 可能返回 null
}
```

### 避免原始类型

```java
// Good
List<String> names = new ArrayList<>();

// Bad
List names = new ArrayList(); // 原始类型
```

## 方法设计

### 参数验证

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

### 使用 Builder 模式（多参数时）

```java
// Good
User user = User.builder()
    .id("123")
    .name("John")
    .email("john@example.com")
    .build();

// Bad（参数过多）
User user = new User("123", "John", "john@example.com", ...);
```

## 异常处理

### 使用受检异常 vs 运行时异常

```java
// 受检异常: 调用方可以合理恢复
public class InsufficientFundsException extends Exception {
  public InsufficientFundsException(String message) {
    super(message);
  }
}

// 运行时异常: 编程错误
public class InvalidStateException extends RuntimeException {
  public InvalidStateException(String message) {
    super(message);
  }
}
```

### 异常转换

```java
try {
  externalApi.call();
} catch (ExternalApiException e) {
  throw new DomainException("Failed to process payment", e);
}
```

## 并发

### 使用 java.util.concurrent

```java
// Good
ExecutorService executor = Executors.newFixedThreadPool(4);
Future<Result> future = executor.submit(task);

// 使用 CompletableFuture
CompletableFuture.supplyAsync(this::fetchData)
    .thenApply(this::transform)
    .thenAccept(this::save);
```

### 线程安全注解

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

## 测试

### 使用 JUnit 5 + AssertJ

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

## 依赖注入

```java
// 使用构造函数注入
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

## 日志

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
