FROM node:alpine3.22

# 1. 改用专用的 /app 目录（不会被 Kubernetes 自动覆盖）
WORKDIR /app

# 2. 复制项目文件到 /app 目录
COPY index.js index.html package.json ./

# 3. 安装系统依赖和 npm 模块
RUN apk update && apk upgrade && \
    apk add --no-cache openssl curl gcompat iproute2 coreutils bash && \
    chmod +x index.js && \
    npm install

# 4. 做一个软链接到 /tmp（防呆：即使平台强制去 /tmp 找 index.js 也能找到）
RUN ln -sf /app/index.js /tmp/index.js

# 5. 暴露端口
EXPOSE 3000/tcp

# 6. 指定启动命令
CMD ["node", "/app/index.js"]
