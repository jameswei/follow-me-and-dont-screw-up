# TypeScript Code Standards
# Reference: Google TypeScript Style Guide + TypeScript Deep Dive

## Format & Style

### Toolchain
```bash
# Formatting: Prettier
npx prettier --write .

# Linting: ESLint + typescript-eslint
npx eslint .

# Type checking
npx tsc --noEmit
```

### Configuration (tsconfig.json)

```json
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "NodeNext",
    "moduleResolution": "NodeNext",
    "strict": true,
    "noImplicitAny": true,
    "strictNullChecks": true,
    "strictFunctionTypes": true,
    "noImplicitReturns": true,
    "noFallthroughCasesInSwitch": true,
    "noUncheckedIndexedAccess": true,
    "exactOptionalPropertyTypes": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true,
    "outDir": "./dist",
    "rootDir": "./src"
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist"]
}
```

## Naming Conventions

| Type | Convention | Example |
|------|------------|---------|
| Interfaces | PascalCase | `UserRepository`, `OrderService` |
| Type Aliases | PascalCase | `UserId`, `Result<T>` |
| Classes | PascalCase | `UserService`, `OrderProcessor` |
| Functions/Methods | camelCase | `getUser()`, `processOrder()` |
| Variables | camelCase | `userName`, `orderCount` |
| Constants | UPPER_SNAKE_CASE | `MAX_RETRY_COUNT` |
| Enums | PascalCase | `OrderStatus` |
| Enum Members | PascalCase | `Pending`, `Completed` |
| Private Members | _leadingUnderscore | `_internalMethod()` |

## Type System

### Strict Mode

```typescript
// tsconfig.json: "strict": true

// Must handle null/undefined
function findUser(id: string): User | undefined {
  // ...
}

const user = findUser("123");
// Error: Object is possibly 'undefined'
console.log(user.name);

// Must handle explicitly
if (user) {
  console.log(user.name);
}
// Or use optional chaining
console.log(user?.name);
```

### Prohibit any

```typescript
// Bad
function process(data: any): any {
  return data.value;
}

// Good: Use unknown + type guards
function process(data: unknown): string {
  if (typeof data === "object" && data !== null && "value" in data) {
    return String((data as Record<string, unknown>).value);
  }
  throw new Error("Invalid data");
}

// Better: Use custom type guard
interface DataWithValue {
  value: string;
}

function hasValue(data: unknown): data is DataWithValue {
  return (
    typeof data === "object" &&
    data !== null &&
    "value" in data &&
    typeof (data as DataWithValue).value === "string"
  );
}
```

### Use interface for Object Shapes

```typescript
// Prefer interface (extensible)
interface User {
  id: string;
  name: string;
  email: string;
}

// Use type for unions, tuples, etc.
type Status = "pending" | "active" | "inactive";
type Result<T> = { ok: true; value: T } | { ok: false; error: string };
```

### Use satisfies Operator

```typescript
const config = {
  host: "localhost",
  port: 3000,
} satisfies { host: string; port: number };

// config retains specific type but is checked against constraint
```

## Function Design

### Options Object Pattern (for many parameters)

```typescript
// Bad: Too many parameters
function createUser(
  firstName: string,
  lastName: string,
  email: string,
  age: number,
  role: string
): User {
  // ...
}

// Good: Use options object
interface CreateUserParams {
  firstName: string;
  lastName: string;
  email: string;
  age?: number;
  role?: "admin" | "user";
}

function createUser(params: CreateUserParams): User {
  const { firstName, lastName, email, age, role = "user" } = params;
  // ...
}

// Usage
createUser({
  firstName: "John",
  lastName: "Doe",
  email: "john@example.com",
});
```

### Use Result Type Instead of Throwing

```typescript
type Result<T, E = Error> =
  | { success: true; data: T }
  | { success: false; error: E };

async function fetchUser(id: string): Promise<Result<User>> {
  try {
    const response = await api.get(`/users/${id}`);
    return { success: true, data: response.data };
  } catch (error) {
    return { 
      success: false, 
      error: error instanceof Error ? error : new Error(String(error))
    };
  }
}

// Usage
const result = await fetchUser("123");
if (result.success) {
  console.log(result.data.name);
} else {
  console.error(result.error.message);
}
```

## Error Handling

### Custom Error Classes

```typescript
class ApplicationError extends Error {
  constructor(
    message: string,
    public readonly code: string,
    public readonly statusCode: number = 500
  ) {
    super(message);
    this.name = this.constructor.name;
    Error.captureStackTrace(this, this.constructor);
  }
}

class NotFoundError extends ApplicationError {
  constructor(resource: string, id: string) {
    super(`${resource} not found: ${id}`, "NOT_FOUND", 404);
  }
}

class ValidationError extends ApplicationError {
  constructor(message: string) {
    super(message, "VALIDATION_ERROR", 400);
  }
}
```

### Async Error Handling

```typescript
// Use try/catch or Result types
async function processOrder(orderId: string): Promise<void> {
  try {
    const order = await orderRepository.findById(orderId);
    if (!order) {
      throw new NotFoundError("Order", orderId);
    }
    
    await paymentService.charge(order.total);
    await orderRepository.updateStatus(orderId, "paid");
  } catch (error) {
    if (error instanceof NotFoundError) {
      // Handle not found
      return;
    }
    if (error instanceof PaymentError) {
      // Handle payment failure
      await orderRepository.updateStatus(orderId, "payment_failed");
      return;
    }
    throw error; // Unknown error, propagate up
  }
}
```

## Classes & OOP

### Dependency Injection

```typescript
interface UserRepository {
  findById(id: string): Promise<User | null>;
  save(user: User): Promise<void>;
}

class UserService {
  constructor(
    private readonly userRepository: UserRepository,
    private readonly eventBus: EventBus
  ) {}
  
  async createUser(data: CreateUserData): Promise<User> {
    const user = new User(data);
    await this.userRepository.save(user);
    this.eventBus.publish(new UserCreatedEvent(user));
    return user;
  }
}
```

### Use readonly

```typescript
class User {
  constructor(
    public readonly id: string,
    public readonly email: string,
    private _name: string
  ) {}
  
  get name(): string {
    return this._name;
  }
  
  rename(newName: string): User {
    return new User(this.id, this.email, newName);
  }
}
```

## Async Programming

### Use async/await

```typescript
// Good
async function fetchUsers(ids: string[]): Promise<User[]> {
  const users = await Promise.all(
    ids.map(id => userRepository.findById(id))
  );
  return users.filter((user): user is User => user !== null);
}

// Bad: Promise chains
function fetchUsers(ids: string[]): Promise<User[]> {
  return Promise.all(ids.map(id => userRepository.findById(id)))
    .then(users => users.filter(user => user !== null) as User[]);
}
```

### Cancellation

```typescript
import { AbortController } from "node:abort-controller";

async function fetchWithTimeout(
  url: string,
  timeoutMs: number
): Promise<Response> {
  const controller = new AbortController();
  const timeout = setTimeout(() => controller.abort(), timeoutMs);
  
  try {
    const response = await fetch(url, { signal: controller.signal });
    return response;
  } finally {
    clearTimeout(timeout);
  }
}
```

## Testing

### Use Vitest

```typescript
import { describe, it, expect, vi } from "vitest";
import { UserService } from "./user-service";

describe("UserService", () => {
  describe("createUser", () => {
    it("should create user with valid data", async () => {
      // Arrange
      const repository = {
        save: vi.fn().mockResolvedValue(undefined),
        findById: vi.fn(),
      };
      const eventBus = { publish: vi.fn() };
      const service = new UserService(repository, eventBus);
      
      // Act
      const user = await service.createUser({
        email: "john@example.com",
        name: "John",
      });
      
      // Assert
      expect(user.email).toBe("john@example.com");
      expect(repository.save).toHaveBeenCalledWith(user);
      expect(eventBus.publish).toHaveBeenCalled();
    });
    
    it("should throw for invalid email", async () => {
      const service = new UserService({} as any, {} as any);
      
      await expect(
        service.createUser({ email: "invalid", name: "John" })
      ).rejects.toThrow(ValidationError);
    });
  });
});
```

## Utility Types

```typescript
// Common utility types

// Extract subset of properties
type UserPreview = Pick<User, "id" | "name">;

// Exclude certain properties
type UserUpdate = Omit<User, "id" | "createdAt">;

// All properties optional
type PartialUser = Partial<User>;

// All properties required
type RequiredUser = Required<User>;

// All properties readonly
type ReadonlyUser = Readonly<User>;

// Extract function return type
type UserResult = ReturnType<typeof fetchUser>;

// Extract function parameter types
type CreateUserParams = Parameters<typeof createUser>[0];

// Non-empty array
type NonEmptyArray<T> = [T, ...T[]];

// Deep readonly
type DeepReadonly<T> = {
  readonly [P in keyof T]: T[P] extends object ? DeepReadonly<T[P]> : T[P];
};
```
