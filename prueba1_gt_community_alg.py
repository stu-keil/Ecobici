# -*- coding: utf-8 -*-
"""
Created on Thu Mar 24 18:59:34 2016

@author: denny
"""
from py2neo import neo4j, authenticate
from py2neo import Graph as NeoCon
from graph_tool.all import *
import time

# Connect to graph and add constraints.
url = "http://localhost:7474/db/data/"
authenticate("localhost:7474", "neo4j", "denny1987")
neocon = NeoCon(url)

# setting up graph tool graph
graph = Graph()
vertex_list = []

estaciones = {}


nombre_estacion = graph.new_vertex_property('string')
id_estacion = graph.new_vertex_property('string')
viajes = graph.new_edge_property('int')

# extracting estaciones
query = """MATCH (e:Estacion) RETURN e.nombre as nom, e.id as id"""
results = neocon.cypher.execute(query)
for estacion in results:
    v = graph.add_vertex()
    vertex_list.append(v)
    #nombre_estacion[v] = estacion['nom']
    id_estacion[v] = estacion['id']
    estaciones[estacion['id']] = len(vertex_list) -1

# connecting estaciones
query = """MATCH (a:Estacion) <-[s:Arribo]-(n:Viaje)-[t:Retiro] -> (r:Estacion) RETURN count (n) ,r.id as ret ,a.id as arr"""
results = neocon.cypher.execute(query)

for result in results:
    weight = result['count (n)']
    arista = graph.add_edge(estaciones[result['ret']],estaciones[result['arr']])
    viajes[arista] = weight

graph.edge_properties['weight'] = viajes
graph.vertex_properties['nombre'] = nombre_estacion
graph.vertex_properties['id'] = id_estacion

g = graph
state = graph_tool.community.minimize_blockmodel_dl(g)
b = state.b
pos = sfdp_layout(g)
graph_draw(g, pos, vertex_fill_color=b, vertex_shape=b, output="prueba1_blocks_mdl.png")

#imprime los vertices
for v in g.vertices():
    print(v,id_estacion[g.vertex(v)],state.get_blocks()[g.vertex(v)])

#numero de grupos
state.B

graph.save("prueba_1.graphml",fmt="graphml")
