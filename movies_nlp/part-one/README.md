### Part 1 Documentation

My answer to part 1 of the assignment is contained in the [part-one-answer.py](part-one-answer.py) python script.

#### Instructions to run
- Open command line on linux or windows machine.
- run the script using python on the command line like so:
```python
python part-one-answer.py {FILENAME}
```
where {FILENAME} is replaced with the name of the input text file.
- The output is printed in the console and written to a file named {FILENAME}_out.txt


#### Considerations
- Sentences can end with different forms of punctuation "[.?!:]" .
- Mr., Mrs., Ms., Miss., Dr., Prof., are not sentence endings, but rather honorifics.

To capture as many normal cases as possible, I will assume the following:
- Correct sentence endings are always used in the input text files. That is, a space must follow a sentence-end punctuation to be considered a sentence ending, and sentences do not start with lowercase letters.
-  A sentence does not end with a single capital letter. As a result of this assumption, the rare case in which it does end with a capital letter will not be detected.

