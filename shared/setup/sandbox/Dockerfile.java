# Dockerfile for Java Development
# 使用 Maven 构建工具

FROM eclipse-temurin:17-jdk-alpine

# 安装系统依赖
RUN apk add --no-cache \
    git \
    curl \
    bash \
    maven

# 可选：安装 jenv（用于多版本管理）
RUN curl -L -s get.jenv.io | bash
ENV PATH="/root/.jenv/bin:${PATH}"
RUN echo 'eval "$(jenv init -)"' >> /root/.bashrc

# 设置工作目录
WORKDIR /workspace

# 复制 Maven 配置
COPY pom.xml ./

# 下载依赖（利用 Docker 缓存层）
RUN mvn dependency:go-offline -B

# 默认命令
CMD ["/bin/bash"]
