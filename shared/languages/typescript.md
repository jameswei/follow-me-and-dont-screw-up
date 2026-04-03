# TypeScript 代码规范
# 参考: Google TypeScript Style Guide + TypeScript Deep Dive

## 格式与风格

### 工具链
```bash
# 格式化: Prettier
npx prettier --write .

# Lint: ESLint + typescript-eslint
npx eslint .

# 类型检查
npx tsc --noEmit
```

### 配置 (tsconfig.json)

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

## 命名规范

| 类型 | 规范 | 示例 |
|------|------|------|
| 接口 | PascalCase | `UserRepository`, `OrderService` |
| 类型别名 | PascalCase | `UserId`, `Result<T>` |
| 类 | PascalCase | `UserService`, `OrderProcessor` |
| 函数/方法 | camelCase | `getUser()`, `processOrder()` |
| 变量 | camelCase | `userName`, `orderCount` |
| 常量 | UPPER_SNAKE_CASE | `MAX_RETRY_COUNT` |
| 枚举 | PascalCase | `OrderStatus` |
| 枚举成员 | PascalCase | `Pending`, `Completed` |
| 私有成员 | _leadingUnderscore | `_internalMethod()` |

## 类型系统

### 严格模式

```typescript
// tsconfig.json: "strict": true

// 必须处理 null/undefined
function findUser(id: string): User | undefined {
  // ...
}

const user = findUser("123");
// Error: Object is possibly 'undefined'
console.log(user.name);

// 必须显式处理
if (user) {
  console.log(user.name);
}
// 或使用可选链
console.log(user?.name);
```

### 禁止 any

```typescript
// Bad
function process(data: any): any {
  return data.value;
}

// Good: 使用 unknown + 类型守卫
function process(data: unknown): string {
  if (typeof data === "object" && data !== null && "value" in data) {
    return String((data as Record<string, unknown>).value);
  }
  throw new Error("Invalid data");
}

// Better: 使用自定义类型守卫
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

### 使用 interface 定义对象形状

```typescript
// 优先使用 interface（可扩展）
interface User {
  id: string;
  name: string;
  email: string;
}

// 使用 type 定义联合类型、元组等
type Status = "pending" | "active" | "inactive";
type Result<T> = { ok: true; value: T } | { ok: false; error: string };
```

### 使用 satisfies 运算符

```typescript
const config = {
  host: "localhost",
  port: 3000,
} satisfies { host: string; port: number };

// config 保持具体类型，但检查是否符合约束
```

## 函数设计

### 参数对象模式（多参数时）

```typescript
// Bad: 参数过多
function createUser(
  firstName: string,
  lastName: string,
  email: string,
  age: number,
  role: string
): User {
  // ...
}

// Good: 使用配置对象
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

// 使用
createUser({
  firstName: "John",
  lastName: "Doe",
  email: "john@example.com",
});
```

### 使用 Result 类型替代抛出异常

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

// 使用
const result = await fetchUser("123");
if (result.success) {
  console.log(result.data.name);
} else {
  console.error(result.error.message);
}
```

## 错误处理

### 自定义错误类

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

### 异步错误处理

```typescript
// 使用 try/catch 或 Result 类型
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
      // 处理未找到
      return;
    }
    if (error instanceof PaymentError) {
      // 处理支付失败
      await orderRepository.updateStatus(orderId, "payment_failed");
      return;
    }
    throw error; // 未知错误，向上传播
  }
}
```

## 类与面向对象

### 依赖注入

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

### 使用 readonly

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

## 异步编程

### 使用 async/await

```typescript
// Good
async function fetchUsers(ids: string[]): Promise<User[]> {
  const users = await Promise.all(
    ids.map(id => userRepository.findById(id))
  );
  return users.filter((user): user is User => user !== null);
}

// Bad: Promise 链
function fetchUsers(ids: string[]): Promise<User[]> {
  return Promise.all(ids.map(id => userRepository.findById(id)))
    .then(users => users.filter(user => user !== null) as User[]);
}
```

### 取消操作

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

## 测试

### 使用 Vitest

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

## 工具类型

```typescript
// 常用工具类型

// 从类型中提取部分属性
type UserPreview = Pick<User, "id" | "name">;

// 排除某些属性
type UserUpdate = Omit<User, "id" | "createdAt">;

// 所有属性变为可选
type PartialUser = Partial<User>;

// 所有属性变为必需
type RequiredUser = Required<User>;

// 所有属性变为只读
type ReadonlyUser = Readonly<User>;

// 提取函数返回类型
type UserResult = ReturnType<typeof fetchUser>;

// 提取函数参数类型
type CreateUserParams = Parameters<typeof createUser>[0];

// 非空数组
type NonEmptyArray<T> = [T, ...T[]];

// 深度只读
type DeepReadonly<T> = {
  readonly [P in keyof T]: T[P] extends object ? DeepReadonly<T[P]> : T[P];
};
```
