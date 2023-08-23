FROM python:3.10-bullseye as spark-base

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      sudo \
      curl \
      vim \
      unzip \
      rsync \
      openjdk-11-jdk \
      build-essential \
      software-properties-common \
      ssh && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*



## Download spark and hadoop dependencies and install

# Optional env variables
ENV SPARK_HOME=${SPARK_HOME:-"/opt/spark"}
ENV HADOOP_HOME=${HADOOP_HOME:-"/opt/hadoop"}

RUN mkdir -p ${HADOOP_HOME} && mkdir -p ${SPARK_HOME}
WORKDIR ${SPARK_HOME}


RUN curl https://downloads.apache.org/spark/spark-3.3.2/spark-3.3.2-bin-hadoop3.tgz -o spark-3.3.2-bin-hadoop3.tgz \
 && tar xvzf spark-3.3.2-bin-hadoop3.tgz --directory /opt/spark --strip-components 1 \
 && rm -rf spark-3.3.2-bin-hadoop3.tgz


FROM spark-base as pyspark

# Install python deps
COPY requirements.txt .
RUN pip3 install -r requirements.txt

ENV PATH="/opt/spark/sbin:/opt/spark/bin:${PATH}"
ENV SPARK_HOME="/opt/spark"
ENV SPARK_MASTER="spark://127.0.01:7077"
ENV SPARK_MASTER_HOST 127.0.0.1
ENV SPARK_MASTER_PORT 7077
ENV PYSPARK_PYTHON python3

COPY conf/spark-defaults.conf "$SPARK_HOME/conf"

RUN chmod u+x /opt/spark/sbin/* && \
    chmod u+x /opt/spark/bin/*

ENV PYTHONPATH=$SPARK_HOME/python/:$PYTHONPATH

# RUN ./sbin/start-master.sh -i 127.0.0.1 -p 7077 &
# RUN ./sbin/start-worker.sh spark://127.0.0.1:7077 &


# COPY entrypoint.sh .

# ENTRYPOINT ["./entrypoint.sh"]
# CMD tail -f /dev/null