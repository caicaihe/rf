FROM alpine

RUN echo "http://mirrors.aliyun.com/alpine/latest-stable/main/" > /etc/apk/repositories
RUN echo echo "http://mirrors.aliyun.com/alpine/latest-stable/community/" >> /etc/apk/repositories
RUN apk update \
    && apk add python3 
WORKDIR /app
ADD requirements.txt /app/
RUN pip3 install -r requirements.txt

