import requests


url = "http://books.toscrape.com/"
response = requests.get(url)
print("status", response.raise_for_status())
html = response.content

# wrote the data into a file as not to keep sending requests to the server
with open("webpage1.html", "wb") as page:
    page.write(html)

print("done")