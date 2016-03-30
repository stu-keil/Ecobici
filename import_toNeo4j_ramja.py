
import time
from py2neo import neo4j, authenticate, Graph
import csv
import datetime as datetime


path = '/home/stuka/itam2/graph4ds/Ecobici/data'

def parsea(renglon,contador):
	strRetiro= time.strptime(renglon["Fecha_hora_retiro"],"%Y-%m-%d %H:%M:%S")
	renglon['FHRetiro']=time.mktime(strRetiro)
	renglon['aRetiro']=strRetiro[0]	
	renglon['mRetiro']=strRetiro[1]	
	renglon['dRetiro']=strRetiro[2]	
	renglon['nsRetiro']=datetime.datetime(renglon['aRetiro'],renglon['mRetiro'],renglon['dRetiro'],0,0).isocalendar()[1]
	renglon['hRetiro']=strRetiro[3]	
	renglon['mnRetiro']=strRetiro[4]	
	renglon['sRetiro']=strRetiro[5]	
	renglon['wdRetiro']=strRetiro[6]	
	strArribo= time.strptime(renglon["Fecha_hora_arribo"],"%Y-%m-%d %H:%M:%S")
	renglon['FHArribo']=time.mktime(strArribo)
	renglon['aArribo']=strArribo[0]	
	renglon['mArribo']=strArribo[1]	
	renglon['dArribo']=strArribo[2]	
	renglon['nsArribo']=datetime.datetime(renglon['aArribo'],renglon['mArribo'],renglon['dArribo'],0,0).isocalendar()[1]
	renglon['hArribo']=strArribo[3]	
	renglon['mnArribo']=strArribo[4]	
	renglon['sArribo']=strArribo[5]	
	renglon['wdArribo']=strArribo[6]	
	renglon['id']=renglon['Bici']+renglon['Ciclo_Estacion_Retiro']+str(renglon['FHRetiro'])
	renglon['TipoUsuario']=renglon['Edad_Usuario']+renglon['Genero_Usuario']
	if (float(renglon['Duracion_viaje']<=0.0)):
		renglon['Duracion_viaje']='0.5'
	renglon['Velocidad']= float(renglon['Distancia_km'])/float(renglon['Duracion_viaje'])
	return renglon
 
def load_stations(filename):
    with open(filename,'r') as csvfile:
        reader = csv.DictReader(csvfile)
        for row in reader:
            # Pass dict to Cypher and build query.
            query = """
            UNWIND {estacion} AS e
    
            MERGE (estacion:Estacion {id:e.id})
            SET estacion.id = e.id,
                estacion.nombre = e.name,
                estacion.tipo = e.stationType
            
            MERGE (direc:Direccion {id:e.id})
            SET direc.id = e.id,
                direc.cp = e.zipCode,
                direc.colonia = e.districtName,
                direc.latitud = e.lat,
                direc.longitud = e.lon
                
            MERGE (estacion)-[:UbicadaEn]->(direc)
            """
            # Send Cypher query.
            graph.cypher.execute(query, estacion=row)
        print("Estaciones anadidas!\n")
            
def load_distances(filename):        
    with open(filename,'r') as csvfile:
        reader = csv.DictReader(csvfile)
        for row in reader:
            # Pass dict to Cypher and build query.
            query = """
            UNWIND {distancia} AS d
    
            MERGE (estacion1:Estacion {id:d.InputID})
            SET estacion1.id = d.InputID
            
            MERGE (estacion2:Estacion {id:d.TargetID})
            SET estacion2.id = d.TargetID
                
            MERGE (estacion1)-[e:Distancia]-(estacion2)
            SET e.valor = TOFLOAT(d.Distance)
    
            """
            # Send Cypher query.
            graph.cypher.execute(query, distancia=row)
        print("Distancias anadidas!\n")



def load_viajes(filename):
    with open(filename,'r') as csvfile:
        reader = csv.DictReader(csvfile)
        ###Por hacer un query que regrese el maximo valor de un id de viaje
        cont=0;
        for row in reader:
            # Pass dict to Cypher and build query.
            query = """
            UNWIND {viaje} AS v
            
            MERGE (fha:FechaHora {id:v.FHArribo})
            SET fha.id = v.FHArribo,
            fha.anio= v.aArribo,
            fha.mes = v.mArribo,
            fha.dia = v.dArribo,
            fha.nsemana= v.nsArribo,
            fha.hora = v.hArribo,
            fha.minuto = v.mnArribo,
            fha.segundo = v.sArribo,
            fha.dsemana = v.wdArribo
            
            MERGE (fhr:FechaHora {id:v.FHRetiro})
            SET fhr.id = v.FHRetiro,
            fhr.anio= v.aRetiro,
            fhr.mes = v.mRetiro,
            fhr.dia = v.dRetiro,
            fhr.nsemana= v.nsRetiro,
            fhr.hora = v.hRetiro,
            fhr.minuto = v.mnRetiro,
            fhr.segundo = v.sRetiro,
            fhr.dsemana = v.wdRetiro
            
            MERGE (viaje:Viaje {id:v.id})
            SET viaje.id = v.id,
            viaje.velocidad = v.Velocidad
            
            MERGE (viaje)-[:FHRetiro]->(fhr)
            
            MERGE (viaje)-[:FHArribo]->(fha)
            
            MERGE (estacion1:Estacion {id:v.Ciclo_Estacion_Retiro})
            SET estacion1.id = v.Ciclo_Estacion_Retiro
            
            MERGE (viaje)-[:Retiro]->(estacion1)
            
            MERGE (estacion2:Estacion {id:v.Ciclo_Estacion_Arribo})
            SET estacion2.id = v.Ciclo_Estacion_Arribo
            
            MERGE (viaje)-[:Arribo]->(estacion2)
            
            MERGE (bici:Bici {id:v.Bici})
            SET bici.id = v.Bici
            
            MERGE (viaje)-[:Monta]->(bici)
            
            MERGE (tipo:TipoUsuario {id:v.TipoUsuario})
            SET tipo.id = v.TipoUsuario,
            	tipo.genero = v.Genero_Usuario,
            	tipo.edad = TOINT(v.Edad_Usuario)
            
            MERGE (viaje)-[:RealizadoPor]->(tipo)
            """
            # Send Cypher query.
            cont=cont+1
            graph.cypher.execute(query, viaje=parsea(row,cont))
    
        print("Viajes anadidos!\n")



# Connect to graph and add constraints.
url = "http://localhost:7474/db/data/"
authenticate("localhost:7474", "neo4j", "test1234")
graph = Graph(url)

# Add uniqueness constraints.

graph.cypher.execute("CREATE CONSTRAINT ON (b:Bici) ASSERT b.id IS UNIQUE;")
graph.cypher.execute("CREATE CONSTRAINT ON (v:Viaje) ASSERT v.id IS UNIQUE;")
graph.cypher.execute("CREATE CONSTRAINT ON (e:Estacion) ASSERT e.id IS UNIQUE;")
graph.cypher.execute("CREATE CONSTRAINT ON (d:Direccion) ASSERT d.id IS UNIQUE;")
graph.cypher.execute("CREATE CONSTRAINT ON (t:TipoUsuario) ASSERT t.id IS UNIQUE;")
graph.cypher.execute("CREATE CONSTRAINT ON (f:FechaHora) ASSERT f.id IS UNIQUE;")

load_stations(path+'/estaciones.csv')
#load_distances(path+'/distancias_estaciones_metros.csv')
load_viajes('/home/stuka/itam2/graph4ds/Ecobici/temporal/ecobici_preprocessed_2015_sample.csv')

