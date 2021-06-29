I will use a Jupyter notebook to document the data processing and cleaning.
cleaning.md contains details on cleaning using OpenRefine

Notes:

1. xlrd package was a dependency to read xlsx files.
2. openpyxl was a dependency for reading excel workbooks.
3. I found that I didn't correctly merge some of the location names eg. O'Connel St Outside/at Clerys So I had to go back and redo this.
4. Coercing the "Date and Time" column into pandas datetime took a while to run as the function was checking the string format of each date and logically mapping it to the correct datetime. Some of the dates (2019-jan-jun) was not in the standard dd-mm-yy but rather mm-dd-yy.

