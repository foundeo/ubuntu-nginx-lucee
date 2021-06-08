# FOR TESTING
FROM ubuntu:20.04
RUN apt-get update -y
RUN apt-get upgrade -y
RUN echo Testing
COPY . /tmp/
RUN chmod a+x /tmp/test.sh
CMD /tmp/test.sh
