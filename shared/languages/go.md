# Go 代码规范
# 参考: Effective Go + Uber Go Style Guide

## 格式与风格

### 强制使用 gofmt

```bash
# 所有代码必须通过 gofmt
gofmt -w .

# 或使用 goimports（自动管理导入）
goimports -w .
```

### 行长
- 软限制: 80 字符
- 硬限制: 100 字符（超过必须换行）

## 命名规范

### 包名
- 小写，无下划线
- 简短但有意义
- 避免 `util`, `common`, `helper`

```go
// Good
package user
package orderrepository

// Bad
package userUtils
package common
```

### 变量与函数

| 场景 | 规范 | 示例 |
|------|------|------|
| 导出 | PascalCase | `GetUser`, `ProcessOrder` |
| 未导出 | camelCase | `getUser`, `processOrder` |
| 缩写 | 全部大写或全部小写 | `URL` 或 `url`, `HTTP` 或 `http` |
| 接口 | 动词+er 或名词 | `Reader`, `Writer`, `UserRepository` |
| 单字母 | 只在作用域小时使用 | `i`, `v` 在循环中 |

```go
// Good
func NewUserService(repo UserRepository) *UserService
func (s *UserService) GetUserByID(ctx context.Context, id string) (*User, error)

// Bad
func new_user_service(repo user_repository) *user_service
func (this *UserService) GetUserById(ctx context.Context, Id string) (*User, Error)
```

### 错误变量

```go
// 预定义错误
var ErrUserNotFound = errors.New("user not found")
var ErrInvalidInput = errors.New("invalid input")

// 使用
if err == ErrUserNotFound {
    // 处理
}
```

## 错误处理

### 显式检查

```go
// Go 的哲学: 显式优于隐式
f, err := os.Open("file.txt")
if err != nil {
    return fmt.Errorf("open file: %w", err)
}
defer f.Close()

// 不要忽略错误
_ = doSomething()  // Bad: 除非明确知道可以忽略
```

### 错误包装

```go
// 使用 fmt.Errorf 添加上下文
if err != nil {
    return fmt.Errorf("failed to process order %s: %w", orderID, err)
}

// 检查特定错误
if errors.Is(err, ErrUserNotFound) {
    // 处理未找到
}

// 检查错误类型
var notFound *NotFoundError
if errors.As(err, &notFound) {
    // 处理特定类型
}
```

### 自定义错误类型

```go
type NotFoundError struct {
    Resource string
    ID       string
}

func (e *NotFoundError) Error() string {
    return fmt.Sprintf("%s not found: %s", e.Resource, e.ID)
}

// 使用
return &NotFoundError{Resource: "user", ID: id}
```

## 接口设计

### 小接口优于大接口

```go
// Good: 小接口，单一职责
type Reader interface {
    Read(p []byte) (n int, err error)
}

type Writer interface {
    Write(p []byte) (n int, err error)
}

// 组合使用
type ReadWriter interface {
    Reader
    Writer
}

// Bad: 大接口，难以实现
type Storage interface {
    Read(p []byte) (n int, err error)
    Write(p []byte) (n int, err error)
    Seek(offset int64, whence int) (int64, error)
    Close() error
    // ... 更多方法
}
```

### 接口在消费者处定义

```go
// 不要提前定义接口，等需要时再定义

// 生产者: 直接实现
type UserRepository struct {
    db *sql.DB
}

func (r *UserRepository) GetUser(ctx context.Context, id string) (*User, error) {
    // ...
}

// 消费者: 定义自己需要的接口
type UserGetter interface {
    GetUser(ctx context.Context, id string) (*User, error)
}

func ProcessUser(getter UserGetter, id string) error {
    user, err := getter.GetUser(context.Background(), id)
    // ...
}
```

## 并发

### 使用 context 传递取消信号

```go
func fetchUser(ctx context.Context, id string) (*User, error) {
    req, err := http.NewRequestWithContext(ctx, "GET", url, nil)
    if err != nil {
        return nil, err
    }
    
    resp, err := http.DefaultClient.Do(req)
    if err != nil {
        return nil, err
    }
    defer resp.Body.Close()
    
    // ...
}

// 使用
ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
defer cancel()

user, err := fetchUser(ctx, "123")
```

### 使用 errgroup 管理并发

```go
import "golang.org/x/sync/errgroup"

func fetchUsers(ctx context.Context, ids []string) ([]*User, error) {
    g, ctx := errgroup.WithContext(ctx)
    users := make([]*User, len(ids))
    
    for i, id := range ids {
        i, id := i, id  // 闭包捕获
        g.Go(func() error {
            user, err := fetchUser(ctx, id)
            if err != nil {
                return err
            }
            users[i] = user
            return nil
        })
    }
    
    if err := g.Wait(); err != nil {
        return nil, err
    }
    return users, nil
}
```

### 使用 channel 注意点

```go
// 生产者关闭 channel
func produce() <-chan int {
    out := make(chan int)
    go func() {
        defer close(out)
        for i := 0; i < 10; i++ {
            out <- i
        }
    }()
    return out
}

// 消费者使用 range
for v := range produce() {
    fmt.Println(v)
}

// 或 select 处理多个 channel
select {
case v := <-ch1:
    // ...
case v := <-ch2:
    // ...
case <-ctx.Done():
    return ctx.Err()
}
```

## 测试

### 表格驱动测试

```go
func TestCalculateDiscount(t *testing.T) {
    tests := []struct {
        name     string
        price    float64
        rate     float64
        expected float64
        wantErr  bool
    }{
        {
            name:     "normal case",
            price:    100,
            rate:     0.1,
            expected: 90,
            wantErr:  false,
        },
        {
            name:    "negative price",
            price:   -10,
            rate:    0.1,
            wantErr: true,
        },
        {
            name:    "invalid rate",
            price:   100,
            rate:    1.5,
            wantErr: true,
        },
    }
    
    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            got, err := CalculateDiscount(tt.price, tt.rate)
            if (err != nil) != tt.wantErr {
                t.Errorf("CalculateDiscount() error = %v, wantErr %v", err, tt.wantErr)
                return
            }
            if !tt.wantErr && got != tt.expected {
                t.Errorf("CalculateDiscount() = %v, want %v", got, tt.expected)
            }
        })
    }
}
```

### 并行测试

```go
func TestParallel(t *testing.T) {
    tests := []struct{ ... }{ ... }
    
    for _, tt := range tests {
        tt := tt  // 捕获范围变量
        t.Run(tt.name, func(t *testing.T) {
            t.Parallel()  // 标记可并行
            // 测试逻辑
        })
    }
}
```

### 使用 testify

```go
import (
    "github.com/stretchr/testify/assert"
    "github.com/stretchr/testify/require"
)

func TestUserService(t *testing.T) {
    user, err := service.GetUser(ctx, "123")
    
    require.NoError(t, err)  // 出错立即停止
    assert.Equal(t, "John", user.Name)  // 出错继续
    assert.NotNil(t, user.Email)
}
```

### Mock 接口

```go
// 定义接口
type UserRepository interface {
    GetUser(ctx context.Context, id string) (*User, error)
}

// 生成 mock (使用 mockgen)
//go:generate mockgen -source=user.go -destination=mocks/mock_user.go

// 或手写 mock
type mockUserRepository struct {
    users map[string]*User
}

func (m *mockUserRepository) GetUser(ctx context.Context, id string) (*User, error) {
    user, ok := m.users[id]
    if !ok {
        return nil, ErrUserNotFound
    }
    return user, nil
}
```

## 结构体与嵌入

### 使用组合而非继承

```go
// Good: 组合
type UserService struct {
    repo UserRepository
    log  *slog.Logger
}

// 嵌入（谨慎使用）
type CustomReader struct {
    io.Reader  // 嵌入接口
    limit      int64
}
```

### 构造函数

```go
// 返回具体类型，不返回接口（除非需要隐藏实现）
func NewUserService(repo UserRepository, log *slog.Logger) *UserService {
    return &UserService{
        repo: repo,
        log:  log,
    }
}

// 或使用函数选项模式
func NewServer(opts ...Option) *Server {
    s := &Server{
        addr: ":8080",
    }
    for _, opt := range opts {
        opt(s)
    }
    return s
}

type Option func(*Server)

func WithAddress(addr string) Option {
    return func(s *Server) {
        s.addr = addr
    }
}

// 使用
server := NewServer(WithAddress(":3000"))
```

## 日志

### 使用标准库 slog

```go
import "log/slog"

// 创建 logger
logger := slog.New(slog.NewJSONHandler(os.Stdout, &slog.HandlerOptions{
    Level: slog.LevelInfo,
}))

// 使用
logger.Info("user created",
    slog.String("user_id", user.ID),
    slog.String("email", user.Email),
    slog.Duration("duration", time.Since(start)),
)

logger.Error("failed to process order",
    slog.String("order_id", orderID),
    slog.Any("error", err),
)
```

### 添加上下文

```go
type contextKey string

const loggerKey contextKey = "logger"

func WithLogger(ctx context.Context, logger *slog.Logger) context.Context {
    return context.WithValue(ctx, loggerKey, logger)
}

func LoggerFromContext(ctx context.Context) *slog.Logger {
    if logger, ok := ctx.Value(loggerKey).(*slog.Logger); ok {
        return logger
    }
    return slog.Default()
}
```

## 项目结构

```
myproject/
├── cmd/
│   ├── server/          # 可执行程序入口
│   │   └── main.go
│   └── worker/
│       └── main.go
├── internal/            # 私有代码
│   ├── domain/          # 领域模型
│   │   ├── user.go
│   │   └── order.go
│   ├── service/         # 业务逻辑
│   │   └── user_service.go
│   ├── repository/      # 数据访问
│   │   └── user_repository.go
│   └── api/             # HTTP/gRPC 处理
│       └── handler.go
├── pkg/                 # 公共库（可被外部导入）
│   └── utils/
├── api/                 # API 定义
│   ├── proto/
│   └── openapi/
├── configs/             # 配置文件
├── scripts/             # 脚本
├── tests/               # 集成测试
├── go.mod
├── go.sum
└── Makefile
```

## 常用模式

### 函数选项模式

```go
type Server struct {
    addr     string
    timeout  time.Duration
    maxConns int
}

type Option func(*Server)

func WithAddress(addr string) Option {
    return func(s *Server) { s.addr = addr }
}

func WithTimeout(d time.Duration) Option {
    return func(s *Server) { s.timeout = d }
}

func NewServer(opts ...Option) *Server {
    s := &Server{
        addr:     ":8080",
        timeout:  30 * time.Second,
        maxConns: 100,
    }
    for _, opt := range opts {
        opt(s)
    }
    return s
}
```

### 资源清理 (defer)

```go
func processFile(path string) error {
    f, err := os.Open(path)
    if err != nil {
        return err
    }
    defer f.Close()  // 立即 defer，在 return 时执行
    
    // 处理文件
    return nil
}
```

### 空对象模式

```go
var ErrUserNotFound = errors.New("user not found")

func (r *UserRepository) GetUser(ctx context.Context, id string) (*User, error) {
    // 使用 sql.NullString 等处理 nullable 字段
    var name sql.NullString
    err := r.db.QueryRowContext(ctx, "SELECT name FROM users WHERE id = ?", id).Scan(&name)
    if err == sql.ErrNoRows {
        return nil, ErrUserNotFound
    }
    if err != nil {
        return nil, err
    }
    
    return &User{
        ID:   id,
        Name: name.String,  // 空值时返回 ""
    }, nil
}
```
