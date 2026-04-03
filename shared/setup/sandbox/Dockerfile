# 通用开发环境 Dockerfile
# 支持 Python、TypeScript、Java、Go 多语言

FROM ubuntu:22.04

# 避免交互式配置提示
ENV DEBIAN_FRONTEND=noninteractive

# 安装基础工具
RUN apt-get update && apt-get install -y \
    git \
    curl \
    wget \
    vim \
    make \
    build-essential \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release \
    && rm -rf /var/lib/apt/lists/*

# ================================
# Python + uv
# ================================
RUN curl -LsSf https://astral.sh/uv/install.sh | sh
ENV PATH="/root/.cargo/bin:${PATH}"
RUN uv python install 3.11

# ================================
# Node.js + nvm
# ================================
ENV NVM_DIR=/root/.nvm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
RUN . "$NVM_DIR/nvm.sh" && \
    nvm install 20 && \
    nvm use 20 && \
    nvm alias default 20
ENV PATH="${NVM_DIR}/versions/node/v20.0.0/bin:${PATH}"

# 安装 bun
RUN curl -fsSL https://bun.sh/install | bash
ENV PATH="/root/.bun/bin:${PATH}"

# ================================
# Java (OpenJDK 17 + Maven)
# ================================
RUN apt-get update && apt-get install -y \
    openjdk-17-jdk \
    maven \
    && rm -rf /var/lib/apt/lists/*

# 安装 jenv
RUN git clone https://github.com/jenv/jenv.git ~/.jenv
ENV PATH="/root/.jenv/bin:${PATH}"
RUN echo 'eval "$(jenv init -)"' >> /root/.bashrc

# ================================
# Go
# ================================
RUN curl -Lo go.tar.gz https://go.dev/dl/go1.21.0.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go.tar.gz && \
    rm go.tar.gz
ENV PATH="/usr/local/go/bin:${PATH}"
ENV GOPATH=/go
ENV PATH="${GOPATH}/bin:${PATH}"

# 安装 golangci-lint
RUN curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b /usr/local/bin v1.55.2

# 安装 goenv
RUN git clone https://github.com/go-nv/goenv.git ~/.goenv
ENV PATH="/root/.goenv/bin:${PATH}"
RUN echo 'eval "$(goenv init -)"' >> /root/.bashrc

# ================================
# Docker (Docker in Docker)
# ================================
RUN curl -fsSL https://get.docker.com | sh

# ================================
# 工作目录
# ================================
WORKDIR /workspace

# 默认命令
CMD ["/bin/bash"]
