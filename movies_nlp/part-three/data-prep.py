''' 
    This doesn't need to be rerun!
    This script was used to produce the train and test datasets for Part 3, Naive Bayes Sentiment Polarity Classifier.
'''

# create dataset from the text files
import pandas as pd
import os

pos_path = '../../data/txt_sentoken/pos'
neg_path = '../../data/txt_sentoken/neg'
pos_df = pd.DataFrame()
neg_df = pd.DataFrame()

# parse the files in positive directory
for filename in os.listdir(pos_path):
    with open(os.path.join(pos_path, filename)) as f:
        review = f.read()
        label='positive'
        
        # assign to train and test set depending on the filename
        which_set = 'train' if int(filename[2]) < 9 else 'test'
        row = pd.DataFrame({'review':[review], 'label':[label], 'set':[which_set]})

    pos_df = pd.concat([pos_df, row], axis=0)

# parse the files in negative directory
for filename in os.listdir(neg_path):
    with open(os.path.join(neg_path, filename)) as f:
        review = f.read()
        label='negative'
        
        # assign to train and test set depending on the filename
        which_set = 'train' if int(filename[2]) < 9 else 'test'
        row = pd.DataFrame({'review':[review], 'label':[label], 'set':[which_set]})

    neg_df = pd.concat([neg_df, row], axis=0)

df = pd.concat([pos_df, neg_df], axis=0).reset_index(drop=True)
train_df = df.loc[df.set=='train', :].drop(columns=['set'])
test_df = df.loc[df.set=='test', :].drop(columns=['set'])

train_df.to_csv("train_df.csv")
test_df.to_csv("test_df.csv")
print("Exported train and test df to current working directory.")