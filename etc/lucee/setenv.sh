#!/bin/sh

CATALINA_OPTS="$JAVA_OPTS -Xms2G -Xmx3G -Djava.security.egd=file:/dev/./urandom";
export CATALINA_OPTS;