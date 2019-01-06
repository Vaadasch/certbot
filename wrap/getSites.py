import os
import re

strsites=""

if os.environ['SERVER'] == "nginx":
	pattern= 'server_name *([^\s]*) *;'
elif  os.environ['SERVER'] == "apache":
	pattern= 'ServerName *([^\s]*) *$'
else :
	print "Error : web server not reconize to find servername"
	quit()

for dirname, dirnames, filenames in os.walk('/sitesconf'):
	for filename in filenames:
		fpath = os.path.join(dirname, filename)

		tmpssl = 0
		tmpsite = ""
		with open(fpath) as f:   # open file
			for line in f:       # process line by line
			
				if 'server_name' in line:
					tmpsearch=re.search(pattern,line, re.IGNORECASE)
					if tmpsearch :
						tmpsite=tmpsearch.group(1)
				
				
				if os.environ['SSL_FLAG'] in line:    
					tmpssl=1
					
			else :
				if tmpssl and tmpsite :
					if len(strsites):
						strsites+= ","
					strsites+=tmpsite				

print strsites
	