import pandas as pd
import openpyxl as xl

d = {"O'Connell St at Clerys": [],
     "Grafton St at Card Gallery": [],
     "Grafton St at M&S": [],
     "O'Connell St at Easons": [],
     "Henry Street at Butlers": [],
     "Grafton St at Korkys": []
     }


wb = xl.load_workbook(filename="../data/processed/a3-2008.xlsx")
#for sheet in wb:
#    print(sheet.title)
'''groups = [[7, 30], [35, 58], [63, 86], [91, 114], [119, 142], [147, 170]]

def loop_through_block(start, end, letter, l, ws):
    for i in range(start, end + 1):
        l.append(ws[letter + str(i)].value)

col_letters = ["B", "D", "F", "H", "J", "L", "N"]
for sheet in wb:
    ws = wb[sheet.title]
    count = 0
    for key in d:
        group = groups[count]
        l = []
        for letter in col_letters:
            loop_through_block(group[0], group[1], letter, l, ws)
        count += 1

        d[key] += l
#print(d)

df = pd.DataFrame.from_dict(d)
df.to_csv("a3-2008-fixed.csv")'''