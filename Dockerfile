# FOR TESTING
FROM ubuntu:20.04
RUN echo testing1
COPY . /tmp/
RUN chmod a+x /tmp/test.sh
CMD /tmp/test.sh
