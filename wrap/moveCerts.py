import os
from datetime import datetime, timedelta
import shutil

certLEDir = "/etc/letsencrypt/live/"+os.environ['INSTANCE']
certDir = "/certs"

newSaveDate = datetime.now().strftime("%Y.%m.%d")
newSaveDir = certDir+"/"+newSaveDate
two_days_ago = datetime.now() - timedelta(days=2) 

newfiletime = datetime.fromtimestamp(os.path.getmtime(certLEDir+'/fullchain.pem'))
if os.path.isfile(certDir+'/fullchain.pem') :
	oldfiletime = datetime.fromtimestamp(os.path.getmtime(certDir+'/fullchain.pem'))
else :
	oldfiletime = datetime.datetime(1988,7,5)

if oldfiletime > two_days_ago:
	print("Certificats deja copies")
	exit()
	
if newfiletime < two_days_ago:
	print("Certificats non renouveles")
	exit()

if not os.path.exists(newSaveDir):
	os.makedirs(newSaveDir)
	
for filename in next(os.walk(certDir))[2]:
	fpath = os.path.join(certDir, filename)
	shutil.move(fpath, newSaveDir+"/"+ filename)

for dirname, dirnames, filenames in os.walk(certLEDir):
	for filename in filenames:
		fpath = os.path.realpath(os.path.join(dirname, filename))
		shutil.copyfile(fpath, certDir+"/"+filename)

