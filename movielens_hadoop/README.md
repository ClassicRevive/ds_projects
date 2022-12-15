### CA4022 Assignment 1 - Data Processing with Hadoop.

**See "report" Directory for the full project writeup, or click [here](report/CA4022 Assignment 1 Report.pdf).** 

This home directory contains all the scripts used in the project. Below is a brief outline of the steps.

In this project, I used apache hive and pig running on a local hadoop cluster to clean and preprocess the movielens dataset and then ran some analysis tasks. 

First I used Apache Pig ([movie_clean.pig](movie_clean.pig)) to preprocess the data, 

then created tables using Hive ([create_tables.hql](create_tables.hql)), and then loaded the data from the hadoop HDFS into the tables.

The remaining HQL files contain queries used to answer analysis questions or retrieve data to produce graphs.

The output data from the Hive queries were used to create graphs in python (See [hive_analysis.py](hive_analysis.py)) .

