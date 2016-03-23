
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

# fetch XML data
import csv



with open('/home/ramja/workspacePy/graf4ds/src/estaciones.csv','r') as csvfile:
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
        
