#使用基础镜像
FROM python:3.6.8 As builder

#指定工作工作目录
WORKDIR /xiaolige/app/ops-py-flask-api/

#拷贝pip依赖包文件并进行安装
COPY requirements.txt .
RUN pip install -i https://pypi.tuna.tsinghua.edu.cn/simple -r requirements.txt

#引入python:3.6.8-alpine3.8 精简版
FROM python:3.6.8-alpine3.8

#Dockerfile多阶段构建从Docker 17.05版本以后，新增了Dockerfile多阶段构建.
COPY --from=builder /usr/local/lib/python3.6/site-packages /usr/local/lib/python3.6/site-packages

# Set 阿里云软件更新源,安装时间和curl命令和目录调整
RUN   sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories && \
apk add --no-cache tzdata &&  apk add curl && \
ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
echo $TZ > /etc/timezone && mkdir -p /xiaolige/app && chmod 775 -R /xiaolige
#设置环境变量
ENV TZ=Asia/Shanghai LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8

#开放应用端口
EXPOSE 8080

#工作路径
WORKDIR /xiaolige/app/ops-py-flask-api/

#复制本地ops-py-flask-api 目录到容器工作目录
COPY boot.py .

#容器探活如果http状态码是200,退出代码将为0，容器将被标记为运行状况。 如果服务器响应任何错误，退出代码将为1，容器处于不健康状态。
#HEALTHCHECK有3个选项参数：--interval=DURATION (default 30) --timeout=DURATION (default 30s) --retries=N (default 3)
HEALTHCHECK --interval=5s --timeout=3s CMD curl http://localhost:8080/devops/ || exit 1

#执行容器启动运行flask应用命令
CMD ["python","boot.py"]
