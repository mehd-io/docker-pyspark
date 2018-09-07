FROM java:8-jdk-alpine

# PYTHON 3

ENV PYTHON_VERSION 3.5.2-r2

# Installing given python3 version
RUN apk update && \
    apk add python3=$PYTHON_VERSION

# Upgrading pip to the last compatible version
RUN pip3 install --upgrade pip

# Installing IPython
RUN pip install ipython

# GENERAL DEPENDENCIES

RUN apk update && \
    apk add curl && \
    apk add bash && \
    apk add build-base && \
    apk add wget \
    apk add libc6-compat

# HADOOP

ENV HADOOP_VERSION 2.7.2
ENV HADOOP_HOME /usr/hadoop-$HADOOP_VERSION
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV PATH $PATH:$HADOOP_HOME/bin
RUN curl -sL --retry 3 \
    "http://archive.apache.org/dist/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz" \
    | gunzip \
    | tar -x -C /usr/ && \
    rm -rf $HADOOP_HOME/share/doc

# SPARK

ENV SPARK_VERSION 2.3.1
ENV SPARK_PACKAGE spark-$SPARK_VERSION-bin-without-hadoop
ENV SPARK_HOME /usr/spark-$SPARK_VERSION
ENV PYSPARK_PYTHON python3
ENV PYSPARK_DRIVER_PYTHON python3
ENV PATH $PATH:$SPARK_HOME/bin
RUN ln -s /usr/bin/python3.5 /usr/bin/python
RUN wget http://apache.mirror.iphh.net/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION:0:3}.tgz \
     && tar -xvzf spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION:0:3}.tgz \
     && mv spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION:0:3} $SPARK_HOME \
     && rm spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION:0:3}.tgz

WORKDIR /$SPARK_HOME
CMD ["bin/spark-class", "org.apache.spark.deploy.master.Master"]
