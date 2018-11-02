FROM cargo-regression-a.caicloudprivatetest.com/library/python:3.6.5-alpine3.6
ADD compass/devops/requirements.txt /app/
RUN apk update && \
    apk add --no-cache openssh-server tzdata python && \
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    sed -i "s/#PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config && \
    ssh-keygen -t rsa -P "" -f /etc/ssh/ssh_host_rsa_key && \
    ssh-keygen -t ecdsa -P "" -f /etc/ssh/ssh_host_ecdsa_key && \
    ssh-keygen -t ed25519 -P "" -f /etc/ssh/ssh_host_ed25519_key && \
    echo "root:admin" | chpasswd
WORKDIR /app
RUN pip3 install -r requirements.txt
CMD /usr/sbin/sshd -D
