FROM bitnami/spark:3.5.1

USER root
# Set environment variables for Livy version
ENV LIVY_VERSION 0.8.0
ENV LIVY_HOME /opt/livy

# Update package list and install necessary packages
RUN apt-get update -y && apt-get install -y wget zip curl git maven

WORKDIR /tmp/
RUN git clone https://github.com/apache/incubator-livy.git
RUN cd incubator-livy && mvn package -DskipTests

# Set the correct permissions for the livy directory
RUN chown -R 1001:1001 /opt/livy

# Generate a comma-separated list of the REPL jars
RUN ls /opt/livy/repl_2.11-jars/*.jar | tr '\n' ',' | sed 's/,$//' > /opt/livy/repl_jars.txt

# Set Livy configurations
RUN printf "livy.server.host = 0.0.0.0\n" > /opt/livy/conf/livy.conf \
    && printf "livy.repl.jars = $(cat /opt/livy/repl_jars.txt)\n" >> /opt/livy/conf/livy.conf

# Create log4j.properties file to output logs to stdout
RUN printf "log4j.rootLogger=INFO, stdout\n\
log4j.appender.stdout=org.apache.log4j.ConsoleAppender\n\
log4j.appender.stdout.Target=System.out\n\
log4j.appender.stdout.layout=org.apache.log4j.PatternLayout\n\
log4j.appender.stdout.layout.ConversionPattern=%%d{ISO8601} [%%t] %%-5p %%c{2} - %%m%%n" \
> /opt/livy/conf/log4j.properties

# Create logs directory with correct permissions
RUN mkdir -p /opt/livy/logs && chown -R 1001:1001 /opt/livy/logs

# Set environment variables
ENV SPARK_HOME /opt/bitnami/spark
ENV HADOOP_CONF_DIR /etc/hadoop/conf
ENV LIVY_CONF_DIR /opt/livy/conf
ENV LIVY_LOG_DIR /opt/livy/logs

# Expose Livy port
EXPOSE 8998

USER 1001

# Print the configuration to verify its content and start Livy
CMD cat /opt/livy/conf/livy.conf && /opt/livy/bin/livy-server
