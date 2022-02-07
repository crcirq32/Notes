import requests
from bs4 import BeautifulSoup

URL = 'https://www.wikipedia.org/wiki/Nikola_Tesla'
page = requests.get(URL)

soup = BeautifulSoup(page.content, 'html.parser')

#find all content
results = soup.find(id='mw-content-text')

#parse for specifics
#job_elems = results.find_all('section', class_='mw-content-text')

#show all job listing
#for job_elem in job_elems:
#	print(job_elem, end='\n'*2)

#find h2 by string
#python_jobs = results.find_all('h2', string='firstHeading')

#for job_elem in job_elems:
   # Each job_elem is a new BeautifulSoup object.
   # You can use the same methods on it as you did before.
   # title_elem = job_elem.find('id', class_='content')
   # parser_elem = job_elem.find('class', class_='mw-body')
   # location_elem = job_elem.find('role', class_='main')
   # print(title_elem)
   # print(company_elem)
   # print(location_elem)
   # print()

print(results)

