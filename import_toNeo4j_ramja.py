
import time
from py2neo import neo4j, authenticate, Graph
import csv


path = '/home/stuka/itam2/graph4ds/Ecobici/data'

def parsea(renglon,contador):
	renglon['FHRetiro']=time.mktime(time.strptime(renglon["Fecha_hora_retiro"],"%Y-%m-%d %H:%M:%S"))
	renglon['FHArribo']=time.mktime(time.strptime(renglon["Fecha_hora_arribo"],"%Y-%m-%d %H:%M:%S"))
	renglon['id']=cont
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
            print("Estacion anadida!\n")
            
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
    
            MERGE (viaje:Viaje {id:v.id})
            SET viaje.id = v.id,
                viaje.fechaHoraRetiro = v.FHRetiro,
                viaje.fechaHoraArribo = v.FHArribo,
                viaje.velocidad = v.Velocidad
                
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
    
    print("Estacion anadida!\n")



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
load_distances(path+'/distancias_estaciones_metros.csv')
load_viajes('/home/stuka/itam2/graph4ds/Ecobici/temporal/ecobici_preprocessed.csv')

