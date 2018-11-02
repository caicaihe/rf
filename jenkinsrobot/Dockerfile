FROM cargo-regression-a.caicloudprivatetest.com/library/jenkins:2.101-alpine-enhanced
USER root
RUN apk update && apk add --no-cache ansible sshpass
RUN sed -i 's/#host_key_checking/host_key_checking/g' /etc/ansible/ansible.cfg
USER jenkins
