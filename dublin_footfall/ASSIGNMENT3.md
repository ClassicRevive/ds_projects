# CA273 Assignment 3: Data Processing & Cleaning

**Due date:** Friday 20th November 23:59    
**Submission method:** Checked in to gitlab    
**Marks:** 12% of module total    

**Aim:** Create a single, unified and clean dataset from a collection of data using a mixture of tools (python, bash, spreadsheets, OpenRefine) documented in a Jupyter Notebook and recorded in a git repository.

## 1. Fork this git repository

This repository should be forked to your own userspace and renamed to 2021-ca273-username-a3 where username is your computing account login (eg, 2021-ca273-slittle-a3).     

Repository structure: [partially based on cookiecutter data science](http://drivendata.github.io/cookiecutter-data-science/)

| directory | description |
|---:|:---|
| data/raw | Source data files, **do not** change any files in this directory |
| data/processed | Put your processed & cleaned data files here |
| notebooks | This should contain at least 1 Jupyter Notebook documenting your processing and (optionally) cleaning and/or a cleaning.md file. |
| README.md | This should use markdown formatting and contain a summary of your work (at least 100 words) plus a list of the tools you used, links to your final dataset files (in the repository) and to the notebook(s) explaining your processing and cleaning. |


## 2. Data processing

Perform any required reformatting or processing needed to read all of the data in the files in data/raw into a pandas dataframe.

Document your processing in a well-structured and commented Juypter Notebook. The end result should be a single dataframe object containing all data.

You may use external programs or write other scripts to extract the data but document them in the notebook.

The dataframe should contain the pedestrian count per hour (so sum the 15 minute counts when provided) and a column for each of the count locations.

## 3. Data cleaning

Find and repair data errors and artefacts in the dataset. You can either do this in a Jupyter Notebook or export your dataframe to a suitable format and use another tool (e.g., spreadsheet or OpenRefine).

If you use a Jupyter Notebook then you should document each error and how you corrected it.

If you use an external programme you must create a markdown file (cleaning.md) in the notebooks directory describing each of the cleaning steps and explicitly listing the data errors and how you corrected them.

The cleaned data file or files should be saved in data/processed.

## 4. Describe and use your dataframe

The end of your notebook should contain the outputs of `dataframe.describe()`, `dataframe.info()` and the code to answer the following question: "Calculate the total number of pedestrians counted at the location nearest to "O'Connell Street at Clerys" during March 2010, March 2019 and March 2020."

## 5. Submission

The version of your repository present at 23:59 on Friday 20th November 2020 will be used to mark the assignment. You must make sure that you have correctly committed and uploaded your repository before that time. You should also perform at least 3 commits of the repository during the assignment with a suitable commit comment.

## Marking Criteria
1. Data processing [4 marks]: 1 mark each for successfully re-formatting and merging each data format in the dataset.    
2. Data cleaning [4 marks]: 0.5 mark each for identifying the major errors or artefacts (up to 8 errors or artefacts).    
3. Documentation [4 marks]: 3 marks for a well formatted notebook and correctly documented repository using markdown. This is a sliding scale mark where full marks are only awarded for a well-structured, high quality and complete notebook and README.md file. 1 mark for following all instructions, correct use of gitlab including a tidy repository and at least 3 commits with good comments.    
