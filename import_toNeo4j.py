import requests
import os
import time
import csv
from py2neo import neo4j, authenticate, Graph


os.getcwd()
os.chdir("/home/stuka/itam2/graph4ds/Ecobici/temporal")
os.listdir(".")

def get_max_id_viaje():
    return 1

def load_stations(filename):
    with open(filename, 'r+') as in_file:

        reader = csv.reader(in_file, delimiter=',')
        next(reader, None)        
        batch = graph.cypher.begin()                           

        try:
            i = 0;
            j = 0;
            for row in reader:    
                if row:
                    station_name = row[1]
                    colonia_id = row[2]
                    colonia_name = row[3]
                    station_id = row[4]
                    postal_code = row[8]
                    latitude = row[9]
                    longitude = row[10]
                    query = """
                        merge (s:Station {Name: {a}, Colonia_Id:{b}, Colonia_Name:{c}, Station_ID:{d}, Postal_Code:{e}, Latitude:{f}, Longitude:{g}})        
                    """
                    batch.append(query, {"a":station_name, "b": colonia_id, "c": colonia_name, "d":station_id, "e":postal_code, "f":latitude, "g":longitude})
                    i += 1
                    j += 1
                batch.process()

                if (i == 1000): #submits a batch every 1000 lines read
                    batch.commit()
                    print j, "lines processed"
                    i = 0                
                    batch = graph.cypher.begin()
            else: batch.commit() #submits remainder of lines read                       
            print j, "lines processed"     

        except Exception as e:
            print e, row, reader.line_num
            
def load_distances(filename):
    with open(filename, 'r+') as in_file:

        reader = csv.reader(in_file, delimiter=',')
        next(reader, None)        
        batch = graph.cypher.begin()                           

        try:
            i = 0;
            j = 0;
            for row in reader:    
                if row:
                    station_origin_id = row[0]
                    station_destination_id = row[1]
                    distance = row[2]
                    query = """
                        merge (s:Station {Name: {a}, Colonia_Id:{b}, Colonia_Name:{c}, Station_ID:{d}, Postal_Code:{e}, Latitude:{f}, Longitude:{g}})        
                    """
                    batch.append(query, {"a":station_name, "b": colonia_id, "c": colonia_name, "d":station_id, "e":postal_code, "f":latitude, "g":longitude})
                    i += 1
                    j += 1
                batch.process()

                if (i == 1000): #submits a batch every 1000 lines read
                    batch.commit()
                    print j, "lines processed"
                    i = 0                
                    batch = graph.cypher.begin()
            else: batch.commit() #submits remainder of lines read                       
            print j, "lines processed"     

        except Exception as e:
            print e, row, reader.line_num

def load_to_neo4j():
    # Connect to graph and add constraints.
    url = "http://localhost:7474/db/data/"
    authenticate("localhost:7474", "neo4j", "test1234")
    graph = Graph(url)

    # Add uniqueness constraints.
    graph.cypher.execute("CREATE CONSTRAINT ON (b:Bike) ASSERT b.id_bike IS UNIQUE;")
    #graph.cypher.execute("CREATE CONSTRAINT ON (u:User) ASSERT u.age+u.gender IS UNIQUE;")
    graph.cypher.execute("CREATE CONSTRAINT ON (s:Station) ASSERT s.Station_Id IS UNIQUE;")
    
    stations_file = "/home/stuka/itam2/graph4ds/Ecobici/data/estaciones.csv" 
    distance_file = "/home/stuka/itam2/graph4ds/Ecobici/data/distancias_estaciones_metros.csv"
    viajes_file = "/home/stuka/itam2/graph4ds/Ecobici/temporal/ecobici_preprocessed.csv"
    contador_viajes = get_max_id_viaje()
    
    load_stations(stations_file)                        
    

if __name__ == '__main__':
    start = time.time()
    load_to_neo4j()
    end = time.time() - start
    print "Time to complete:", end