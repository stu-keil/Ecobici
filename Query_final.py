# -*- coding: utf-8 -*-
"""
Created on Thu Mar 24 18:59:34 2016

@author: denny
"""
from py2neo import neo4j, authenticate
from py2neo import Graph as NeoCon
from graph_tool.all import *
import time
import pandas as pd

# Connect to graph and add constraints.
url = "http://localhost:7474/db/data/"
authenticate("localhost:7474", "neo4j", "denny1987")
neocon = NeoCon(url)

# setting up graph tool graph
graph = Graph()
vertex_list = []

estaciones = {}


#nombre_estacion = graph.new_vertex_property('string')
id_estacion = graph.new_vertex_property('string')
viajes = graph.new_edge_property('int')

# extracting estaciones
query = """MATCH (e:Estacion) RETURN e.id as id"""
results = neocon.cypher.execute(query)
for estacion in results:
    v = graph.add_vertex()
    vertex_list.append(v)
    #nombre_estacion[v] = estacion['nom']
    id_estacion[v] = estacion['id']
    estaciones[estacion['id']] = len(vertex_list) -1

# connecting estaciones
query = """MATCH p=(middle:Viaje)-[fechRet:FHRetiro] -> (fHora:FechaHora) 
WHERE fHora.hora IN [6,7,8,9,10,11,12] and fHora.dsemana IN [1,2,3,4,5]
WITH middle MATCH (tipo:TipoUsuario) <-[s:RealizadoPor]-(middle:Viaje)-[retiro:Retiro]-> (estIni:Estacion),(fHoraArr:FechaHora)<-[fhArribo:FHArribo]- (middle:Viaje)-[arribo:Arribo]-> (estFin:Estacion),(estIni:Estacion)-[dist:Distancia]-(estFin:Estacion)
RETURN estIni.id, estFin.id, count(estIni.id), tipo.genero ORDER BY count(estIni.id) DESC"""

results = neocon.cypher.execute(query)

for result in results:
    weight = result['count(estIni.id)']
    arista = graph.add_edge(estaciones[result['estIni.id']],estaciones[result['estFin.id']])
    viajes[arista] = weight

graph.edge_properties['weight'] = viajes
graph.vertex_properties['nombre'] = nombre_estacion
graph.vertex_properties['id'] = id_estacion

g = graph
state = graph_tool.community.minimize_blockmodel_dl(g, eweight=viajes, max_B=4)
b = state.b
pos = sfdp_layout(g)
graph_draw(g, pos, vertex_fill_color=b, vertex_shape=b, output="./resultados/Est_Com_6-12_wd.png")

#imprime los vertices

lista = []
lista2 = []
for v in g.vertices():
    lista.append(id_estacion[g.vertex(v)])
    lista2.append(state.get_blocks()[g.vertex(v)])
    #print(v,id_estacion[g.vertex(v)],state.get_blocks()[g.vertex(v)])
 

data = pd.DataFrame(zip(lista,lista2))
data.to_csv("./resultados/Est_Com_6-12_wd.csv",index=False,header=False)
   
#/resultados/

#numero de grupos
state.B

graph.save("./resultados/Est_Com_6-12_wd.graphml",fmt="graphml")