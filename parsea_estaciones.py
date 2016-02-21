# -*- coding: utf-8 -*-
"""
Created on Thu Feb 18 17:59:53 2016

@author: stuka
"""
import json
import urllib2
import pandas as pd 
from pandas.io.json import json_normalize
import os


os.listdir('.')
os.chdir('/home/stuka/itam2/graph4ds/Ecobici')


url = 'https://pubsbapi.smartbike.com/oauth/v2/token?client_id=541_39k7kp0ezfswokcswsc0oc8s4sccswk4g0kc84csss008gw440&client_secret=46lb6to6tp8ggcg88wo4g80cgwwoc4o40kc4c0s44s4wcwws4o&grant_type=client_credentials'
data = json.load(urllib2.urlopen(url))


#data.keys()

url2 = 'https://pubsbapi.smartbike.com/api/v1/stations.json?access_token='+data["access_token"]
estaciones = json.load(urllib2.urlopen(url2))  
estaciones.keys()

labels = estaciones["stations"][0].keys()
df = pd.read_json(estaciones2)


result = json_normalize(estaciones, 'stations',['stations','location'])



result = json_normalize(estaciones,'stations')

nuevo = pd.concat([result,json_normalize(list(result['location']))],axis=1)

nuevo = nuevo.drop(['addressNumber','altitude','location'],axis=1)
nuevo.to_csv('estaciones.csv',encoding='utf-8')

