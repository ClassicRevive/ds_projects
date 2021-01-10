from bs4 import BeautifulSoup
import pandas as pd
import numpy as np

''' get the list of all Ireland champions from Wikipedia into a dataset '''

# read webpage from the file
html = open('webpage.html', encoding="utf8").read()
soup = BeautifulSoup(html, 'lxml')

myChampionlist = []

# investigate parsing capabilities

table = soup.find('table', {'class': 'sortable wikitable plainrowheaders'})
winners = []
years = []
turnout = []
for row in table.find_all('tr'):
    var = row.find_all('td')
    if len(var) == 9:  # check that the row is a complete record
        winner_name = var[2].get_text().split()[0] # get winner name, clean and add to winners list
        year = var[0].get_text()
        if 4 < len(year):  # clean year
            year = year[:4]
        attendance = var[7].get_text().strip()

        myChampionlist.append([year, winner_name, attendance])

myChampionlist = np.array(myChampionlist)
myChampionlist[-1, -1] = 0

df = pd.DataFrame(myChampionlist, columns=['Year', 'Winner', 'Attendance'])
print(df.head())

df.to_csv('data/all_ireland.csv')