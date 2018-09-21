# Spark and python as Docker
Lighweight image to use as standalone spark cluster for dev purpose or small jobs only.

This image runs :
* Hadoop 2.7
* Spark 2.3
* python 3.5.2
* Java 8 sdk alpine

# How to use it
Replace /my/local/path/ with your local path to have persistent volume mapped.
```
docker run -it -d -v /my/local/path/:/home --name pyspark -p 4040:4040 mehdio/docker-pyspark
```
