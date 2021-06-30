import pandas as pd
from bs4 import BeautifulSoup
from string import punctuation

# read webpage from the file
html = open('webpages/webpage1.html', encoding="utf8").read()

soup = BeautifulSoup(html, 'lxml')

# scraping webpage

# parsing the webpage
menu = soup.find('div', {'class': 'menu-english-cs-circles-nav-menu-container'})
content = soup.find('div', {'class': 'entry-content'}).get_text()

names = []
words = {}

tokens = content.strip().split()

# clean the text data
i = 0
while i < len(tokens):
  tokens[i] = tokens[i].strip(punctuation)

  i += 1

print("test")
# load into dictionary
for token in tokens:
  if token not in words:
    words[token] = 1
  else:
    words[token] += 1

# load words into dataframe
words_df = pd.DataFrame(list(words.items()), columns=["word", "count"])
words_df.sort_values(by="count", inplace=True, ascending = False)

# remove words that only occur once
words_df = words_df[words_df['count'] > 1].reset_index(drop=True)

# extracting the menu
for article in menu.find_all('li'):
  names.extend(article.get_text().strip().split('\n'))

# removing empty strings
i = 0
while i < len(names):
  if names[i] == '':
    names.pop(i)
  else:
    i += 1

for name in names:
  print(name)
  print('------')

# writing data to file
words_df.to_csv('data/word_count.csv')

print("done")
