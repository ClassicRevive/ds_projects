from bs4 import BeautifulSoup
import requests
import pickle


'''
Note: I was trying to write html to file for scraping instead of sending requests:
response = requests.get(url)
html = response.content
soup = BeautifulSoup(html, 'lxml')
'''

# read webpage from the file
url = "http://books.toscrape.com/"
html = open("webpage1.html").read()
soup = BeautifulSoup(html, 'lxml')

myBooklist = []

# testing the parser for different elements of the webpage
for article in soup.find_all('article'):  # find all article tags in the document
    title = article.find('h3').find('a')['title']  # get the h3->a tag where the Title is stored
    price = article.find('p', {'class': 'price_color'}).get_text()[1:]

    # Now scrape the book rating myself!
    p_search = article.find_all('p')
    for col in p_search:
        if col.has_attr('class') and col['class'][0] == 'star-rating':
            rating = col['class'][1]

    myBooklist.append([title, price, rating])



# find next page url
next = soup.find('li', {'class': 'next'})

# basic crawler to find all book names, prices, and ratings
while next is not None:
    next = next.find('a')['href']
    if not next.startswith('catalogue/'): next="catalogue/"+next
    next_url = url+next
    print(next_url)
    response = requests.get(next_url)
    html = response.content
    soup = BeautifulSoup(html, 'lxml')
    for article in soup.find_all('article'):  # find all article tags in the document
        title = article.find('h3').find('a')['title']  # get the h3->a tag where the Title is stored
        price = article.find('p', {'class': 'price_color'}).get_text()[1:]
        # Now scrape the book rating myself!

        p_search = article.find_all('p')
        for col in p_search:
            if col.has_attr('class') and col['class'][0] == 'star-rating':
                rating = col['class'][1]

        myBooklist.append([title, price, rating])
    next = soup.find('li', {'class': 'next'})


# pickle the list into another file
pickle.dump(myBooklist, open('booklist.p', 'wb'))
