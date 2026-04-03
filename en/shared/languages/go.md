# Go Code Standards
# Reference: Effective Go + Uber Go Style Guide

## Format & Style

### Mandatory gofmt

```bash
# All code must pass gofmt
gofmt -w .

# Or use goimports (automatic import management)
goimports -w .
```

### Line Length
- Soft limit: 80 characters
- Hard limit: 100 characters (must wrap beyond this)

## Naming Conventions

### Package Names
- Lowercase, no underscores
- Short but meaningful
- Avoid `util`, `common`, `helper`

```go
// Good
package user
package orderrepository

// Bad
package userUtils
package common
```

### Variables & Functions

| Scenario | Convention | Example |
|----------|------------|---------|
| Exported | PascalCase | `GetUser`, `ProcessOrder` |
| Unexported | camelCase | `getUser`, `processOrder` |
| Acronyms | All uppercase or all lowercase | `URL` or `url`, `HTTP` or `http` |
| Interfaces | Verb+er or noun | `Reader`, `Writer`, `UserRepository` |
| Single Letter | Only in small scopes | `i`, `v` in loops |

```go
// Good
func NewUserService(repo UserRepository) *UserService
func (s *UserService) GetUserByID(ctx context.Context, id string) (*User, error)

// Bad
func new_user_service(repo user_repository) *user_service
func (this *UserService) GetUserById(ctx context.Context, Id string) (*User, Error)
```

### Error Variables

```go
// Predefined errors
var ErrUserNotFound = errors.New("user not found")
var ErrInvalidInput = errors.New("invalid input")

// Usage
if err == ErrUserNotFound {
    // Handle
}
```

## Error Handling

### Explicit Checks

```go
// Go philosophy: explicit over implicit
f, err := os.Open("file.txt")
if err != nil {
    return fmt.Errorf("open file: %w", err)
}
defer f.Close()

// Don't ignore errors
_ = doSomething()  // Bad: unless you explicitly know it's safe
```

### Error Wrapping

```go
// Use fmt.Errorf to add context
if err != nil {
    return fmt.Errorf("failed to process order %s: %w", orderID, err)
}

// Check specific errors
if errors.Is(err, ErrUserNotFound) {
    // Handle not found
}

// Check error types
var notFound *NotFoundError
if errors.As(err, &notFound) {
    // Handle specific type
}
```

### Custom Error Types

```go
type NotFoundError struct {
    Resource string
    ID       string
}

func (e *NotFoundError) Error() string {
    return fmt.Sprintf("%s not found: %s", e.Resource, e.ID)
}

// Usage
return &NotFoundError{Resource: "user", ID: id}
```

## Interface Design

### Small Interfaces Over Large Ones

```go
// Good: Small interfaces, single responsibility
type Reader interface {
    Read(p []byte) (n int, err error)
}

type Writer interface {
    Write(p []byte) (n int, err error)
}

// Compose
type ReadWriter interface {
    Reader
    Writer
}

// Bad: Large interface, hard to implement
type Storage interface {
    Read(p []byte) (n int, err error)
    Write(p []byte) (n int, err error)
    Seek(offset int64, whence int) (int64, error)
    Close() error
    // ... more methods
}
```

### Define Interfaces at Consumer

```go
// Don't define interfaces upfront, define when needed

// Producer: Just implement
type UserRepository struct {
    db *sql.DB
}

func (r *UserRepository) GetUser(ctx context.Context, id string) (*User, error) {
    // ...
}

// Consumer: Define what you need
type UserGetter interface {
    GetUser(ctx context.Context, id string) (*User, error)
}

func ProcessUser(getter UserGetter, id string) error {
    user, err := getter.GetUser(context.Background(), id)
    // ...
}
```

## Concurrency

### Use context for Cancellation

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

// Usage
ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
defer cancel()

user, err := fetchUser(ctx, "123")
```

### Use errgroup for Concurrency

```go
import "golang.org/x/sync/errgroup"

func fetchUsers(ctx context.Context, ids []string) ([]*User, error) {
    g, ctx := errgroup.WithContext(ctx)
    users := make([]*User, len(ids))
    
    for i, id := range ids {
        i, id := i, id  // Capture for closure
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

### Channel Best Practices

```go
// Producer closes channel
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

// Consumer uses range
for v := range produce() {
    fmt.Println(v)
}

// Or select for multiple channels
select {
case v := <-ch1:
    // ...
case v := <-ch2:
    // ...
case <-ctx.Done():
    return ctx.Err()
}
```

## Testing

### Table-Driven Tests

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

### Parallel Tests

```go
func TestParallel(t *testing.T) {
    tests := []struct{ ... }{ ... }
    
    for _, tt := range tests {
        tt := tt  // Capture range variable
        t.Run(tt.name, func(t *testing.T) {
            t.Parallel()  // Mark as parallelizable
            // Test logic
        })
    }
}
```

### Use testify

```go
import (
    "github.com/stretchr/testify/assert"
    "github.com/stretchr/testify/require"
)

func TestUserService(t *testing.T) {
    user, err := service.GetUser(ctx, "123")
    
    require.NoError(t, err)  // Stop on error
    assert.Equal(t, "John", user.Name)  // Continue on error
    assert.NotNil(t, user.Email)
}
```

### Mock Interfaces

```go
// Define interface
type UserRepository interface {
    GetUser(ctx context.Context, id string) (*User, error)
}

// Generate mock (use mockgen)
//go:generate mockgen -source=user.go -destination=mocks/mock_user.go

// Or hand-written mock
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

## Structs & Embedding

### Composition Over Inheritance

```go
// Good: Composition
type UserService struct {
    repo UserRepository
    log  *slog.Logger
}

// Embedding (use sparingly)
type CustomReader struct {
    io.Reader  // Embed interface
    limit      int64
}
```

### Constructors

```go
// Return concrete types, not interfaces (unless hiding implementation)
func NewUserService(repo UserRepository, log *slog.Logger) *UserService {
    return &UserService{
        repo: repo,
        log:  log,
    }
}

// Or use functional options pattern
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

// Usage
server := NewServer(WithAddress(":3000"))
```

## Logging

### Use Standard Library slog

```go
import "log/slog"

// Create logger
logger := slog.New(slog.NewJSONHandler(os.Stdout, &slog.HandlerOptions{
    Level: slog.LevelInfo,
}))

// Usage
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

### Add Context

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

## Project Structure

```
myproject/
├── cmd/
│   ├── server/          # Executable entry point
│   │   └── main.go
│   └── worker/
│       └── main.go
├── internal/            # Private code
│   ├── domain/          # Domain models
│   │   ├── user.go
│   │   └── order.go
│   ├── service/         # Business logic
│   │   └── user_service.go
│   ├── repository/      # Data access
│   │   └── user_repository.go
│   └── api/             # HTTP/gRPC handlers
│       └── handler.go
├── pkg/                 # Public libraries (importable)
│   └── utils/
├── api/                 # API definitions
│   ├── proto/
│   └── openapi/
├── configs/             # Configuration files
├── scripts/             # Scripts
├── tests/               # Integration tests
├── go.mod
├── go.sum
└── Makefile
```

## Common Patterns

### Functional Options Pattern

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

### Resource Cleanup (defer)

```go
func processFile(path string) error {
    f, err := os.Open(path)
    if err != nil {
        return err
    }
    defer f.Close()  // Defer immediately, executes on return
    
    // Process file
    return nil
}
```

### Null Object Pattern

```go
var ErrUserNotFound = errors.New("user not found")

func (r *UserRepository) GetUser(ctx context.Context, id string) (*User, error) {
    // Use sql.NullString etc. for nullable fields
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
        Name: name.String,  // Returns "" if null
    }, nil
}
```
