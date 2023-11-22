FROM python:3.7.0 As builder
COPY requirements.txt .
RUN pip install --upgrade pip==18.1 && pip install -i https://pypi.tuna.tsinghua.edu.cn/simple -r requirements.txt
FROM python:3.7.0-alpine3.7
COPY --from=builder /usr/local/lib/python3.7/site-packages /usr/local/lib/python3.7/site-packages

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
RUN apk add --no-cache tzdata bash
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN mkdir -p /devops/app && mkdir -p /devops/data/log/op-demo-api && chmod 775 -R /devops/

WORKDIR /devops/app/op-demo-api
COPY . .
CMD  python boot.py
