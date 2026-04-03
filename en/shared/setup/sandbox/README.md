# 沙盒环境使用指南

## 快速开始

### 1. 使用 Docker Compose

```bash
# 启动特定语言的开发环境
docker-compose -f sandbox/docker-compose.yml up -d python-dev
docker-compose -f sandbox/docker-compose.yml up -d typescript-dev
docker-compose -f sandbox/docker-compose.yml up -d java-dev
docker-compose -f sandbox/docker-compose.yml up -d go-dev

# 或者启动通用多语言环境
docker-compose -f sandbox/docker-compose.yml up -d dev

# 进入容器
docker-compose -f sandbox/docker-compose.yml exec python-dev bash
docker-compose -f sandbox/docker-compose.yml exec dev bash

# 停止环境
docker-compose -f sandbox/docker-compose.yml down
```

### 2. 使用 VS Code Dev Container

1. 安装 VS Code 插件: `ms-vscode-remote.remote-containers`
2. 复制 `sandbox/devcontainer.json` 到 `.devcontainer/devcontainer.json`
3. 按 `F1` → `Remote-Containers: Reopen in Container`

### 3. 直接使用 Docker

```bash
# 构建镜像
docker build -f sandbox/Dockerfile.python -t myproject-python .
docker build -f sandbox/Dockerfile -t myproject-dev .

# 运行容器
docker run -it -v $(pwd):/workspace myproject-python
docker run -it -v $(pwd):/workspace -v /var/run/docker.sock:/var/run/docker.sock myproject-dev
```

## 沙盒类型对比

| 类型 | 适用场景 | 优点 | 缺点 |
|------|---------|------|------|
| 单语言 Dockerfile | 专注单一语言 | 轻量、快速 | 不支持多语言 |
| 通用 Dockerfile | 多语言项目 | 一站式 | 镜像较大 |
| Docker Compose | 多服务开发 | 服务编排 | 资源占用 |
| Dev Container | VS Code 用户 | 集成度高 | 依赖 VS Code |

## 持久化数据

Docker Compose 使用命名卷持久化：
- `python-venv`: Python 虚拟环境
- `uv-cache`: uv 缓存
- `node-modules`: Node 依赖
- `maven-cache`: Maven 仓库
- `go-cache`: Go 模块缓存

## 自定义配置

复制并修改模板：

```bash
# 1. 复制到项目根目录
cp sandbox/Dockerfile.python Dockerfile
cp sandbox/docker-compose.yml docker-compose.yml

# 2. 根据项目需求修改
vim Dockerfile
vim docker-compose.yml

# 3. 构建并运行
docker-compose up -d
```
