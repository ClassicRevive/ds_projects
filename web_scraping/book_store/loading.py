import pickle
import json
import pandas as pd

myBooklist = pickle.load(open('data/booklist.p', 'rb'))
print("length of booklist (1000?)", len(myBooklist))

with open('data/data.json', 'w') as outfile:
    json.dump(myBooklist, outfile)

headers = ['Name', 'Price', 'Rating']
books = pd.read_json('data/data.json')
books.columns = headers

# the book data has successfully been scraped and stored!
print(books.head())
books.to_csv('data/data.csv')