
import time
from py2neo import neo4j, authenticate, Graph





# Connect to graph and add constraints.
url = "http://localhost:7474/db/data/"
authenticate("localhost:7474", "neo4j", "rama0000")
graph = Graph(url)

# Add uniqueness constraints.
graph.cypher.execute("CREATE CONSTRAINT ON (b:Bici) ASSERT b.id IS UNIQUE;")
graph.cypher.execute("CREATE CONSTRAINT ON (v:Viaje) ASSERT v.id IS UNIQUE;")
graph.cypher.execute("CREATE CONSTRAINT ON (e:Estacion) ASSERT e.id IS UNIQUE;")
graph.cypher.execute("CREATE CONSTRAINT ON (d:Direccion) ASSERT d.id IS UNIQUE;")
graph.cypher.execute("CREATE CONSTRAINT ON (t:TipoUsuario) ASSERT t.id IS UNIQUE;")
graph.cypher.execute("CREATE CONSTRAINT ON (f:FechaHora) ASSERT f.id IS UNIQUE;")

# fetch XML data
import csv

def parsea(renglon,contador):
	renglon['FHRetiro']=time.mktime(time.strptime(renglon["Fecha_hora_retiro"],"%Y-%m-%d %H:%M:%S"))
	renglon['FHArribo']=time.mktime(time.strptime(renglon["Fecha_hora_arribo"],"%Y-%m-%d %H:%M:%S"))
	renglon['id']=cont
	renglon['TipoUsuario']=renglon['Edad_Usuario']+renglon['Genero_Usuario']
	if (float(renglon['Duracion_viaje']<=0.0)):
		renglon['Duracion_viaje']='0.5'
	renglon['Velocidad']= float(renglon['Distancia_km'])/float(renglon['Duracion_viaje'])
	return renglon

with open('/home/ramja/workspacePy/graf4ds/src/ecobici_preprocessed.csv','r') as csvfile:
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
        
