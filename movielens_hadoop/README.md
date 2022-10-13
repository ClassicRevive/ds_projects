### CA4022 Assignment 1

See "Report" Directory for the full project report. This home directory contains all the scripts used to complete the project.

In this project, I used apache hive and pig running on a local hadoop cluster to clean and preprocess the data and then run sum analysis tasks. 

First I used Apache Pig (movie_clean.pig)

And then created tables using Hive (create_tables.hql), and then loaded the data from the hadoop HDFS into the tables.

The remaining HQL files contain queries used to answer analysis questions or retrieve data to produce graphs.

The output data from the Hive queries were used to create graphs in python (See hive_analysis.py) .