# FOR TESTING
FROM ubuntu:18.04
COPY . /tmp/
RUN chmod a+x /tmp/test.sh
CMD /tmp/test.sh
