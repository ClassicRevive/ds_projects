''' Base python implementation of unsmoothed bigram language model '''

from collections import defaultdict
import math

corpus = ['<s> b c </s>', '<s> c c </s>', '<s> c b </s>', '<s> b b </s>']

def train(corpus):
    '''
    Given a training corpus in the form of a list of sentences, returns word and bigram frequency dictionaries
    for computing probabilities.

    Returns:    
        2 dicitonaries; word_freq [0] and bigram_freq [1]
    '''     
    word_freq = defaultdict(int)
    bigram_freq = defaultdict(int)

    for sentence in corpus:
        tokens = sentence.split()
        
        # update word frequency dicitonary
        for token in tokens:
            word_freq[token] += 1
        
        # update bigram frequency dictionary
        if len(tokens) >= 2:
            i = 0
            while i < len(tokens)-1:
                bigram_freq[tokens[i]+' '+tokens[i+1]] += 1
                i += 1
    
    return word_freq, bigram_freq

# create the frequency dictionaries from corpus
word_freq, bigram_freq = train(corpus)

def compute_prob(sentence, word_freq=word_freq, bigram_freq=bigram_freq, precision=4):
    ''' 
    Given bigram and word frequencies from a coprus, computes the probability of the input sentence.

    In a bigram model, P(w1, w2, ..., wn) = P(w1)*P(w2|w1)*P(w3|w2)*...*P(wn|wn-1).

    Since the model uses word frequencies from the corpus to approximate probabilities:
    P(wn|wn-1) = (Count of [wn-1, wn] bigram in corpus) / Count of wn-1 in corpus.

    Arguments:
        sentence (str): input sentence
        word_freq (dict): contains word frequencies from training corpus.
        bigram_freq (dict): contains bigram frequencies from training corpus.
        precision (int): decimal point precision with which to round probabilities.

    Returns:
        Probability of sentence to the precision determined by the argument (default = 4).  

    '''
    n_corpus_tokens = sum(word_freq.values())
    tokens = sentence.split()
    i = 0
    log_prob = 0
    while i < len(tokens):
        curr = tokens[i]
        if i == 0:  # edge case: start of sentence
            log_prob += math.log((word_freq[curr]) / n_corpus_tokens)
        else:
            prev = tokens[i-1]
            log_prob += math.log((bigram_freq[prev+" "+curr])/(word_freq[prev]))
        i += 1
    
    return round(math.e ** (log_prob), precision)

test_set = [
    '<s> c </s>',
    '<s> b </s>',
    '<s> b c </s>',
    '<s> b b </s>',
    '<s> b c b </s>',
]

for sentence in test_set:
    print("Sentence: "+sentence+"\nProbability: "+str(compute_prob(sentence)))
    print('-'*30)
