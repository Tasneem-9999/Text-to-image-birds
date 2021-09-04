import os 
from app import app , databasePath , db

if not os.path.exists(databasePath):
    db.create_all() 

app.run(debug= True,use_reloader= False ,host="192.168.43.17",port=5000)