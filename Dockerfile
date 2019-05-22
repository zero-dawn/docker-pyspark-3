FROM python:3

MAINTAINER Elwin Arens <elwin@zerodawn.eu>

RUN update-ca-certificates -f \
  && apt-get update \
  && apt-get upgrade -y \
  && apt-get install -y \
    wget \
    git \
    default-jdk \
    scala \
  && apt-get clean

ENV SPARK_VERSION=2.3.3
ENV HADOOP_VERSION=2.7

# SPARK
RUN cd /usr/ \
  && wget http://apache.cs.uu.nl/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION.tgz \
  && tar xzf spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION.tgz \
  && rm spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION.tgz \
  && mv spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION spark

ENV SPARK_HOME /usr/spark
ENV PYTHONPATH $SPARK_HOME/python:$SPARK_HOME/python/lib/py4j-0.10.4-src.zip

RUN mkdir -p /usr/spark/work/ \
  && chmod -R 777 /usr/spark/work/

ENV SPARK_MASTER_PORT 7077

RUN pip install --upgrade pip \
  && pip install --upgrade --quiet pylint pytest coverage numpy setuptools scipy findspark

CMD /usr/spark/bin/spark-class org.apache.spark.deploy.master.Master
