FROM cargo-regression-a.caicloudprivatetest.com/library/python:3.6.5-alpine3.6
ADD compass/devops/ /app
WORKDIR /app
RUN pwd
RUN ls
RUN pip3 install -r requirements.txt
CMD tail -f /dev/null
