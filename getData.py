import requests
import shutil
import os
import json
from bs4 import BeautifulSoup
import tinify
import glob

def CollectLogos():
	base = 'https://cdn.bleacherreport.net/images/team_logos/328x328/'
	with open("json/nhl/teams.json",'r') as f:
		data = json.loads(f.read())
	for team in data:
		link = base+team['city'].lower().replace(" ","_")+"_"+team['name'].lower().replace(" ","_")+".png"
		r = requests.get(link, stream=True)
		if r.status_code == 200:
			print("Collecting: " + team['name'])
			with open("images/hockey/"+team['name']+".png", 'wb') as f:
			    r.raw.decode_content = True
			    shutil.copyfileobj(r.raw, f)
		else:
			print("Missing: " + team['name'])

def Compress():
	tinify.key = "nS9NVOLmIOTcugSigryYJyDK0dmH7FqH"
	images = glob.glob("images/hockey/*.png")
	for img in images:
		source = tinify.from_file(img)
		resized = source.resize(method="scale",width=164)
		resized.to_file(img)
		#source.to_file(img)

Compress()