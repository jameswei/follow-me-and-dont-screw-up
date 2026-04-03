# Python Code Standards
# Reference: PEP 8 + Google Python Style Guide

## Format & Style

### Indentation & Line Length
- Use 4 spaces for indentation (no tabs)
- Maximum line length: 88 characters (Black default) or 100

### Toolchain
```bash
# Formatting: Black
black .

# Import sorting: isort
isort .

# Type checking: mypy
mypy .

# Linting: ruff
ruff check .
```

## Naming Conventions

| Type | Convention | Example |
|------|------------|---------|
| Modules | snake_case | `user_service.py` |
| Classes | PascalCase | `UserService`, `OrderRepository` |
| Functions/Methods | snake_case | `get_user()`, `process_order()` |
| Variables | snake_case | `user_name`, `order_count` |
| Constants | UPPER_SNAKE_CASE | `MAX_RETRY_COUNT` |
| Private | _leading_underscore | `_internal_method()` |
| Strongly Private | __double_underscore | `__very_private` |

## Type Annotations

### Mandatory Requirements

```python
from typing import Optional, List, Dict, Union

def find_user(user_id: str) -> Optional[User]:
    """Find user by ID."""
    ...

def process_orders(
    orders: List[Order],
    config: Dict[str, Union[str, int]]
) -> ProcessingResult:
    """Process multiple orders."""
    ...
```

### Use dataclasses or Pydantic

```python
from dataclasses import dataclass
from typing import Optional
from datetime import datetime

@dataclass(frozen=True)
class User:
    """User entity."""
    id: str
    name: str
    email: str
    created_at: datetime
    updated_at: Optional[datetime] = None

# Or use Pydantic (recommended for APIs/config)
from pydantic import BaseModel, EmailStr, Field

class UserCreate(BaseModel):
    """User creation request."""
    name: str = Field(..., min_length=1, max_length=100)
    email: EmailStr
    age: Optional[int] = Field(None, ge=0, le=150)
```

## Function Design

### Parameter Handling

```python
from typing import Protocol

class DatabaseConnection(Protocol):
    """Protocol for database connections."""
    def execute(self, query: str) -> list: ...

def process_users(
    conn: DatabaseConnection,
    batch_size: int = 100,
    *,  # Force keyword-only arguments
    skip_inactive: bool = True,
    dry_run: bool = False
) -> ProcessingResult:
    """Process users in batches.
    
    Args:
        conn: Database connection
        batch_size: Number of users per batch
        skip_inactive: Skip inactive users
        dry_run: Don't actually modify data
    
    Returns:
        Processing statistics
    """
    if batch_size <= 0:
        raise ValueError(f"batch_size must be positive, got {batch_size}")
    
    # Implementation
```

### Use Result Pattern (Alternative to Exceptions for Control Flow)

```python
from dataclasses import dataclass
from typing import Generic, TypeVar, Union

T = TypeVar('T')
E = TypeVar('E')

@dataclass(frozen=True)
class Ok(Generic[T]):
    value: T

@dataclass(frozen=True)
class Err(Generic[E]):
    error: E

Result = Union[Ok[T], Err[E]]

def divide(a: float, b: float) -> Result[float, str]:
    if b == 0:
        return Err("Division by zero")
    return Ok(a / b)

# Usage
result = divide(10, 0)
match result:
    case Ok(value):
        print(f"Result: {value}")
    case Err(error):
        print(f"Error: {error}")
```

## Exception Handling

### Custom Exception Hierarchy

```python
class ApplicationError(Exception):
    """Base application error."""
    pass

class NotFoundError(ApplicationError):
    """Resource not found."""
    def __init__(self, resource_type: str, resource_id: str):
        self.resource_type = resource_type
        self.resource_id = resource_id
        super().__init__(f"{resource_type} not found: {resource_id}")

class ValidationError(ApplicationError):
    """Input validation failed."""
    def __init__(self, field: str, message: str):
        self.field = field
        self.message = message
        super().__init__(f"Validation error for {field}: {message}")
```

### Exception Handling Best Practices

```python
# Good: Specific exceptions, add context
try:
    user = repository.find_by_id(user_id)
except DatabaseError as e:
    raise ServiceError(f"Failed to fetch user {user_id}") from e

# Bad: Catch-all exceptions
try:
    user = repository.find_by_id(user_id)
except Exception:  # Too broad
    return None
```

## Concurrency

### Use asyncio

```python
import asyncio
from typing import AsyncIterator

async def fetch_users(user_ids: list[str]) -> AsyncIterator[User]:
    """Fetch users concurrently."""
    semaphore = asyncio.Semaphore(10)  # Limit concurrency
    
    async def fetch_one(user_id: str) -> User:
        async with semaphore:
            return await api.get_user(user_id)
    
    tasks = [fetch_one(uid) for uid in user_ids]
    for completed in asyncio.as_completed(tasks):
        yield await completed

# Usage
async for user in fetch_users(user_ids):
    process(user)
```

## Testing

### Use pytest

```python
import pytest
from unittest.mock import Mock, patch

class TestUserService:
    """UserService tests."""
    
    @pytest.fixture
    def repository(self):
        return Mock()
    
    @pytest.fixture
    def service(self, repository):
        return UserService(repository)
    
    def test_find_user_returns_user_when_found(self, service, repository):
        # Arrange
        user_id = "123"
        expected_user = User(id=user_id, name="John")
        repository.find_by_id.return_value = expected_user
        
        # Act
        result = service.find_by_id(user_id)
        
        # Assert
        assert result == expected_user
        repository.find_by_id.assert_called_once_with(user_id)
    
    def test_find_user_raises_when_not_found(self, service, repository):
        # Arrange
        user_id = "unknown"
        repository.find_by_id.return_value = None
        
        # Act/Assert
        with pytest.raises(NotFoundError) as exc_info:
            service.find_by_id(user_id)
        
        assert user_id in str(exc_info.value)
    
    @pytest.mark.parametrize("age,is_valid", [
        (0, True),
        (150, True),
        (-1, False),
        (151, False),
    ])
    def test_age_validation(self, age, is_valid):
        # Test logic
        pass
```

### Test Data Factories

```python
import factory
from datetime import datetime

class UserFactory(factory.Factory):
    """User test data factory."""
    class Meta:
        model = User
    
    id = factory.Sequence(lambda n: f"user-{n}")
    name = factory.Faker("name")
    email = factory.Faker("email")
    created_at = factory.LazyFunction(datetime.utcnow)

# Usage
user = UserFactory()  # Default data
user = UserFactory(name="Custom Name")  # Override fields
```

## Dependency Management

### Use pyproject.toml

```toml
[project]
name = "my-project"
version = "0.1.0"
description = "Project description"
requires-python = ">=3.11"
dependencies = [
    "pydantic>=2.0",
    "httpx>=0.24",
]

[project.optional-dependencies]
dev = [
    "pytest>=7.0",
    "pytest-asyncio",
    "black",
    "isort",
    "mypy",
    "ruff",
]

[tool.black]
line-length = 88

[tool.isort]
profile = "black"

[tool.mypy]
strict = true
warn_return_any = true
warn_unused_configs = true

[tool.ruff]
line-length = 88
select = ["E", "F", "I", "N", "W", "UP"]
```

## Logging

```python
import logging
from contextvars import ContextVar

request_id: ContextVar[str] = ContextVar('request_id')

class ContextFilter(logging.Filter):
    """Add request ID to log records."""
    def filter(self, record: logging.LogRecord) -> bool:
        record.request_id = request_id.get('unknown')
        return True

# Configuration
logger = logging.getLogger(__name__)
logger.addFilter(ContextFilter())

# Usage
logger.info("Processing user", extra={"user_id": user_id})
```
