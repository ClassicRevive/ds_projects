'''
    In this script, I build a naiive bayes sentiment polarity classifier from scratch and then test it using 200 movie reviews.
    Instructions to run can be found in the README.md file in this directory.

    The program outputs some sample predictions, and the accuracy metric from the test set.
    After that, it returns some examples of correct and incorrect predictions, which I explore further in ANALYSIS.md.

'''
import pandas as pd
import numpy as np
from collections import defaultdict
import string
import math
import sys

seed=42

try:
    train_file = sys.argv[1]
    test_file = sys.argv[2]
except:
    print("Need to provide training and testing files as command line arguments")

train_df = pd.read_csv(train_file, index_col=0)
test_df = pd.read_csv(test_file, index_col=0)

def run_nb_model(train_df=train_df, test_df=test_df, precision=8):
    '''
        Given a training and testing dataframe as input containing columns [review, label], return the label predictions of
        the test data. If the testing dataframe has a label column, use it to compute the accuracy of the classifier. Otherwise, 
        just return the predictions.

        Arguments:
            train_df (pd.DataFrame): data frame with training reviews and their "positive" or "negative" labels
            test_df (pd.DataFrame): data frame with testing reviews. The predicted labels are appended to test_df when this function is run.
            precision (int): decimal point precision with which to return float values.
        
        Returns:
            predicted labels for test_df, and optionally the accuracy as a float with the specified precision.
    '''
    def tokenize_review(review):
        ''' Helper function to return tokens from a review as a list. '''
        tokens = []
        for token in review.split():
            token = token.strip(string.punctuation+' ').lower()
            
            # ignore empty tokens
            if token != ' ' and token != '':
                tokens.append(token)
        
        return tokens
    
    def calc_accuracy(y_true, y_pred):
        ''' Helper function to compute model accuracy given true labels and predictions '''
        n_correct = 0
        i = 0
        while i < len(y_true):
            if y_true[i] == y_pred[i]:
                n_correct += 1
            i += 1
        return n_correct / len(y_true)

    # build word count dictionaries for positive and negative reviews.
    pos_freq = defaultdict(int)
    neg_freq = defaultdict(int)

    # parse through each review in training data, tokenize and add tokens to their respective dictionaries
    for index, row in train_df.iterrows():
        for token in tokenize_review(row.review):
            # add tokens to the word counts
            if row.label == 'positive':
                pos_freq[token] += 1
            else:
                neg_freq[token] += 1
    
    n_pos_tokens = sum(pos_freq.values())
    n_neg_tokens = sum(neg_freq.values())
    
    # number of unique words in all reviews
    n_vocab = len(set(pos_freq.keys()).union(set(pos_freq.keys())))
    
    # find probability of review from both positive and negative frequency distributions.
    predictions = []
    lp_pos = []
    lp_neg = []
    for index, row in test_df.iterrows():
        # in this case, prior is not useful because we have same number of positive and negative documents
        log_prob_pos = 0
        log_prob_neg = 0
        for token in tokenize_review(row.review):
            # ignores tokens that didn't appear in the training reviews, includes add-1 smoothing

            # if the word is in each review class, update probability
            if (pos_freq[token] > 0) or (neg_freq[token] > 0):
                log_prob_pos += math.log((pos_freq[token]+1)/(n_pos_tokens+n_vocab))
                log_prob_neg += math.log((neg_freq[token]+1)/(n_neg_tokens+n_vocab))
                

        # whichever probability is highest determines the predicted label.
        ans = 'positive' if log_prob_pos >= log_prob_neg else 'negative'
        predictions.append(ans)
        lp_pos.append(log_prob_pos)
        lp_neg.append(log_prob_neg)

    
    # add the predictions, and log probabilities to the test dataframe for analysis
    test_df['pred_label'] = predictions
    test_df['logp_positive'] = lp_pos
    test_df['logp_negative'] = lp_neg

    if 'label' in test_df.columns:
        accuracy = round(calc_accuracy(y_true=test_df.label.tolist(), y_pred=predictions), precision)
        
        return predictions, accuracy
    else:
        return predictions


# since our test set has the true labels, we also get back the model accuracy.    
predictions, accuracy = run_nb_model(train_df, test_df, precision=8)

print("Accuracy:", accuracy)
print("-"*100)
print("Sample predictions:\n", test_df.loc[:, ['review', 'pred_label', 'label']].sample(5, random_state=seed))
print("\n"+"-"*100)

# extract samples for analysing classifier output
correct_sample = test_df.loc[test_df.label == test_df.pred_label].sample(5, random_state=seed)
incorrect_sample = test_df.loc[test_df.label != test_df.pred_label].sample(5, random_state=seed)
correct_sample['log_p_diff'] = np.abs(correct_sample.logp_positive - correct_sample.logp_negative)
incorrect_sample['log_p_diff'] = np.abs(incorrect_sample.logp_positive - incorrect_sample.logp_negative)

# print the correct and incorrect samples to command line, with log probability difference between the 
print("CORRECT PREDICTIONS SAMPLE")
print(correct_sample.loc[:, ['review', 'label', 'pred_label', 'log_p_diff']].round())
print("INCORRECT PREDICTIONS SAMPLE")
print(incorrect_sample.loc[:, ['review', 'label', 'pred_label', 'log_p_diff']].round())
print()

print("View the analysed reviews in full in test_notebook.ipynb, Part 3\n")

# write the test dataset, with the predictions column added, to the current working directory
file_out = "test_predictions.csv"
test_df.to_csv(file_out)
print("Exported test set with predictions to {}".format(file_out))