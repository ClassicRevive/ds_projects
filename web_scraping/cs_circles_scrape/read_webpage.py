import requests


url = "https://cscircles.cemc.uwaterloo.ca"
response = requests.get(url)
print("status", response.raise_for_status())
html = response.content

# wrote the data into a file as not to keep sending requests to the server
with open("webpages/webpage1.html", "wb") as page:
    page.write(html)

print("done")
