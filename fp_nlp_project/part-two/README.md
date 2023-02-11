### Part 2 Documentation

My answer to part 2 of the assignment is contained in the [part-two-answer.py](part-two-answer.py) python script. The training corpus and test sentences were provided in the question, so no file input is required here.

#### Instructions to run
- Open command line on linux or windows machine.
- run the script using python on the command line like so:
```python
python part-two-answer.py
```

#### Considerations
- I included "<s>" and "</s>" as tokens when training the bigram model. This was to incorporate context on which words are more likely to start and finish sentences.