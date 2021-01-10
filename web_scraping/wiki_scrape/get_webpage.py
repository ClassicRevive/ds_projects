import requests


url = "https://en.wikipedia.org/wiki/List_of_All-Ireland_Senior_Football_Championship_finals"
response = requests.get(url)
print("status", response.raise_for_status())
html = response.content

# wrote the data into a file as not to keep sending requests to the server
with open("webpage.html", "wb") as page:
    page.write(html)

print("done")