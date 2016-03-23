import requests

import time
from py2neo import neo4j, authenticate, Graph





# Connect to graph and add constraints.
url = "http://localhost:7474/db/data/"
authenticate("localhost:7474", "neo4j", "rama0000")
graph = Graph(url)

# Add uniqueness constraints.
graph.cypher.execute("CREATE CONSTRAINT ON (b:Bici) ASSERT b.id IS UNIQUE;")
#graph.cypher.execute("CREATE CONSTRAINT ON (t:TipoUsuario) ASSERT t.edad+t.genero IS UNIQUE;")
graph.cypher.execute("CREATE CONSTRAINT ON (e:Estacion) ASSERT e.id IS UNIQUE;")
graph.cypher.execute("CREATE CONSTRAINT ON (d:Direccion) ASSERT d.id IS UNIQUE;")
#graph.cypher.execute("CREATE CONSTRAINT ON (d:Direccion) ASSERT d.latitud,d.longitud IS UNIQUE;")

# fetch XML data
import csv



with open('/home/ramja/workspacePy/graf4ds/src/distancias_estaciones_metros.csv','r') as csvfile:
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
        
