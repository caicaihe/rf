FROM cargo-regression-a.caicloudprivatetest.com/library/jenkins:2.101-alpine-enhanced
USER root
RUN apk update && apk add --no-cache ansible sshpass
USER jenkins
EXPOSE 8080
EXPOSE 50000
