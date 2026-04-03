# Dockerfile for Go Development

FROM golang:1.21-alpine

# 安装系统依赖
RUN apk add --no-cache \
    git \
    curl \
    bash \
    make \
    gcc \
    musl-dev

# 安装 golangci-lint
RUN curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b /usr/local/bin v1.55.2

# 可选：安装 goenv
RUN git clone https://github.com/go-nv/goenv.git ~/.goenv
ENV PATH="/root/.goenv/bin:${PATH}"
RUN echo 'eval "$(goenv init -)"' >> /root/.bashrc

# 设置 Go 环境变量
ENV GOPATH=/go
ENV PATH="${GOPATH}/bin:/usr/local/go/bin:${PATH}"

# 设置工作目录
WORKDIR /workspace

# 复制 go.mod 和 go.sum
COPY go.mod go.sum ./

# 下载依赖
RUN go mod download

# 默认命令
CMD ["/bin/bash"]
