### Repository for CA273 Assignment 3: Data Processing & Cleaning

tools used:
1. python (details in [notebook](notebooks/data_processing.ipynb))
2. OpenRefine (details in [cleaning.md](notebooks/cleaning.md))

Please note that I annotated the data processing and cleaning steps in detail in my [notebook](notebooks/data_processing.ipynb) (before realizing that a README was required).

At the start of the assignment, I read in all the csv, xlsx, and json files, leaving out 2008.

I pivoted each table as to make the Location and count columns. I had to change the names of some datetime columns to make them monogamous before concatenating the dataframes into a single dataframe and writing this out to a file. I cleaned the data, removing missing values, fixing inconsistencies in naming conventions (using OpenRefine), removing duplicates etc. I then aggregated the "Date and Time" column into hourly intervals.
After completing the final section I went back to try and process 2008. I needed a way to process entire excel workbooks in python so that I could refer to cells and extract the data through a script. DataFrame indexing seemed much more tedious. The openpyxl package offered this sort of functionality. After getting it to a desired structure, I went back and integrated it into the data cleaning process. I repeated some parts several times after new findings such as the OpenRefine cleaning.

- Data processing in cleaning notebook [here](notebooks/data_processing.ipynb)
- Final cleaned csv version [here](data/processed/cleaned-data.csv)
- xlsx version of a3-2008 [here](data/processed/a3-2008.xlsx)




