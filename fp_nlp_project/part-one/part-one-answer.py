''' Takes filename as input via the command line. Separates the text into sentences and writes this to a new file named
    ORIGINAL_FILENAME_out.txt

    Instructions to run are located in the README.md file.
'''

import re
import io
import sys

try:
    filename = sys.argv[1]
except:
    raise IndexError("No filename was provided. Provide a text file as input like this: 'python3 part-one-answer.py FILENAME'")
    quit()

# read in text file with UTF8 encoding
f = io.open(filename, mode="r", encoding="utf-8")
text = f.read().replace('\n', ' ')
f.close()


def sentence_split(text):
    '''
        Given an input string, split it up into sentences and return.
        "text" must be a string input.
    '''
    
    # helper function to add newline when we find the regex pattern for an end of sentence
    def add_newline(match_obj):
        return match_obj.group(0)+'\n'


    # known abbreviations of different lengths
    abbrv2 = 'Mr|Ms|Dr'
    abbrv3 = 'Mrs|[Ee]\.[Gg]|[Ii]\.[Ee]|[Ee]tc'
    abbrv4 = 'Prof|Miss'

    initial='\s[A-Z]'

    # check that previous word is not an abbreviation
    lookbehind_abbrv='(?<!'+abbrv2+')(?<!'+abbrv3+')(?<!'+abbrv4+')' 

    # check that previous word is not a single capital letter (assumed to be an initial)
    lookbehind_initial='(?<!'+initial+')'

    # check that sentence end is not followed by a lowercase letter
    lookahead='(?![a-z])'

    # matches sentences ending in non-period punctuation
    sentence_end_punct='[?!:]+\s+'

    # separate sentence end pattern as initials are only followed by a period (J. K. Rowling, not J: K: Rowling)
    sentence_end_period='[\.]+\s+'

    end_re1 = lookbehind_abbrv + sentence_end_punct + lookahead  # punctuation pattern match
    end_re2 = lookbehind_initial + lookbehind_abbrv + sentence_end_period + lookahead # for catching initials
    
    return re.sub(end_re1+"|"+end_re2, add_newline, text)


output = sentence_split(text)
print("Output of sentence split:\n\n"+output)

# save the output of the sentence split to the output file.
filename_out = filename[:-4]+'_out.txt'
f = io.open(filename_out, mode='w', encoding='utf-8')
f.write(output)
f.close()

print('Saved output to', filename_out)