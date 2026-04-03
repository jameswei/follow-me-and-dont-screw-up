#!/bin/bash
# setup-java.sh - Java 环境初始化脚本 (使用 jenv + maven)

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}☕ Java 环境初始化 (使用 jenv + maven)${NC}"
echo "=============================="

# 检测包管理器
if command -v brew &> /dev/null; then
    PKG_MGR="brew"
    INSTALL_CMD="brew install"
elif command -v apt-get &> /dev/null; then
    PKG_MGR="apt"
    INSTALL_CMD="sudo apt-get install -y"
else
    echo -e "${YELLOW}⚠️ 未检测到支持的包管理器 (brew/apt)${NC}"
    echo "请手动安装所需工具"
    exit 1
fi

echo -e "${BLUE}📦 使用包管理器: $PKG_MGR${NC}"

# 1. 检查/安装 jenv
if ! command -v jenv &> /dev/null; then
    echo -e "${YELLOW}⚠️ jenv 未安装，正在安装...${NC}"
    $INSTALL_CMD jenv
    
    # 配置 jenv
    echo 'export PATH="$HOME/.jenv/bin:$PATH"' >> ~/.zshrc
    echo 'eval "$(jenv init -)"' >> ~/.zshrc
    export PATH="$HOME/.jenv/bin:$PATH"
    eval "$(jenv init -)"
    
    echo -e "${GREEN}✅ jenv 安装成功${NC}"
else
    echo -e "${GREEN}✅ jenv 已安装${NC}"
fi

# 确保 jenv 已加载
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)" 2>/dev/null || true

# 2. 安装 JDK
JDK_VERSION="${JDK_VERSION:-17}"
echo -e "${BLUE}📥 安装 OpenJDK $JDK_VERSION...${NC}"

if [ "$PKG_MGR" = "brew" ]; then
    $INSTALL_CMD "openjdk@$JDK_VERSION"
    
    # 链接到 jenv
    JDK_PATH="/usr/local/opt/openjdk@$JDK_VERSION"
    if [ -d "$JDK_PATH" ]; then
        jenv add "$JDK_PATH" 2>/dev/null || echo "JDK 已添加到 jenv"
    fi
else
    $INSTALL_CMD "openjdk-$JDK_VERSION-jdk"
fi

# 设置全局 JDK
jenv global "$JDK_VERSION" 2>/dev/null || echo "请手动设置: jenv global $JDK_VERSION"
echo -e "${GREEN}✅ OpenJDK $JDK_VERSION 已安装${NC}"

# 3. 安装 Maven
if ! command -v mvn &> /dev/null; then
    echo -e "${BLUE}📥 安装 Maven...${NC}"
    $INSTALL_CMD maven
    echo -e "${GREEN}✅ Maven 已安装: $(mvn --version | head -1)${NC}"
else
    echo -e "${GREEN}✅ Maven 已安装: $(mvn --version | head -1)${NC}"
fi

# 4. 可选: 安装 Gradle
if ! command -v gradle &> /dev/null; then
    read -p "是否安装 Gradle? (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        $INSTALL_CMD gradle
        echo -e "${GREEN}✅ Gradle 已安装${NC}"
    fi
else
    echo -e "${GREEN}✅ Gradle 已安装${NC}"
fi

# 5. 初始化项目
if [ ! -f "pom.xml" ] && [ ! -f "build.gradle" ]; then
    echo -e "${YELLOW}⚠️ 未找到 pom.xml 或 build.gradle${NC}"
    read -p "是否创建默认 Maven 项目? (Y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
        # 创建目录结构
        mkdir -p src/main/java/com/example
        mkdir -p src/main/resources
        mkdir -p src/test/java/com/example
        mkdir -p src/test/resources
        
        # 创建 pom.xml
        cat > pom.xml << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 
                             http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    
    <groupId>com.example</groupId>
    <artifactId>my-project</artifactId>
    <version>1.0-SNAPSHOT</version>
    <packaging>jar</packaging>
    
    <properties>
        <maven.compiler.source>17</maven.compiler.source>
        <maven.compiler.target>17</maven.compiler.target>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <junit.jupiter.version>5.10.0</junit.jupiter.version>
    </properties>
    
    <dependencies>
        <dependency>
            <groupId>org.junit.jupiter</groupId>
            <artifactId>junit-jupiter</artifactId>
            <version>${junit.jupiter.version}</version>
            <scope>test</scope>
        </dependency>
        <dependency>
            <groupId>org.assertj</groupId>
            <artifactId>assertj-core</artifactId>
            <version>3.24.2</version>
            <scope>test</scope>
        </dependency>
    </dependencies>
    
    <build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-compiler-plugin</artifactId>
                <version>3.11.0</version>
                <configuration>
                    <release>17</release>
                </configuration>
            </plugin>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-surefire-plugin</artifactId>
                <version>3.1.2</version>
            </plugin>
            <plugin>
                <groupId>org.jacoco</groupId>
                <artifactId>jacoco-maven-plugin</artifactId>
                <version>0.8.11</version>
                <executions>
                    <execution>
                        <goals>
                            <goal>prepare-agent</goal>
                        </goals>
                    </execution>
                    <execution>
                        <id>report</id>
                        <phase>test</phase>
                        <goals>
                            <goal>report</goal>
                        </goals>
                    </execution>
                </executions>
            </plugin>
        </plugins>
    </build>
</project>
EOF
        
        # 创建示例 Java 文件
        cat > src/main/java/com/example/App.java << 'EOF'
package com.example;

public class App {
    public static void main(String[] args) {
        System.out.println("Hello, Java!");
    }
    
    public String greet(String name) {
        return "Hello, " + name + "!";
    }
}
EOF
        
        cat > src/test/java/com/example/AppTest.java << 'EOF'
package com.example;

import org.junit.jupiter.api.Test;
import static org.assertj.core.api.Assertions.assertThat;

class AppTest {
    @Test
    void shouldGreetWithName() {
        App app = new App();
        assertThat(app.greet("Java")).isEqualTo("Hello, Java!");
    }
}
EOF
        
        echo -e "${GREEN}✅ 已创建默认 Maven 项目结构${NC}"
    fi
fi

# 6. 验证安装
echo ""
echo -e "${BLUE}🔍 验证安装...${NC}"
echo "Java: $(java --version | head -1)"
echo "Maven: $(mvn --version | head -1)"
if command -v jenv &> /dev/null; then
    echo ""
    echo "jenv 管理的 JDK:"
    jenv versions
fi

echo ""
echo "=============================="
echo -e "${GREEN}✅ Java 环境初始化完成！${NC}"
echo "=============================="
echo ""
echo "使用命令:"
echo "  mvn compile    # 编译"
echo "  mvn test       # 运行测试"
echo "  mvn package    # 打包"
echo "  mvn clean      # 清理"
echo "  make validate  # 完整验证"
