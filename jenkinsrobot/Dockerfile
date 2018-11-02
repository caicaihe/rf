FROM cargo-regression-a.caicloudprivatetest.com/library/jenkins
USER root
RUN apk update && apk install -y ansible && apk install -y sshpass
RUN sed -i 's/#host_key_checking/host_key_checking/g' /etc/ansible/ansible.cfg
USER jenkins
