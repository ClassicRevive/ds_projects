

The training and testing sets for the classifier are in the part-three directory, and were created using the [data-prep.py](data-prep.py) script.

Given train and test set filenames as command line arguments, [part-three-answer.py](part-three-answer.py) predicts the sentiment label of the movie reviews in the test set, writing these to a CSV file named [test_predictions.csv](test_predictions.csv). 

Also, 5 randomly chosen correct and incorrect predictions are extracted to [correct_sample.csv](correct_sample.csv) and [incorrect_sample.csv](incorrect_sample.csv) respectively. My analysis of these is present in [ANALYSIS.md](ANALYSIS.md). You can view the 10 analysed reviews in full at the end of [test_notebook.ipynb](../test_notebook.ipynb) in Part 3.

#### Instructions to run:
- Open command line on linux or windows machine.
- run the script using python on the command line like so:
```python
python part-three-answer.py {TRAIN_FILE} {TEST_FILE}
```
where {TRAIN_FILE} is replaced with the name of the CSV file for training the classifier (**train_df.csv**) and {TEST_FILE} is replaced with the test CSV file (**test_df.csv**).
- The accuracy of the model, with a sample of predictions is printed to the console, while the artefacts described above are extracted.
