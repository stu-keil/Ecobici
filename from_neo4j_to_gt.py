from py2neo import neo4j, authenticate
from py2neo import Graph as NeoCon
from graph_tool.all import * as gt
import time

# Connect to graph and add constraints.
url = "http://localhost:7474/db/data/"
n4juser = "neo4j"
n4jpassw = "test1234"
authenticate("localhost:7474", n4juser, n4jpassw)
neocon = NeoCon(url)

# setting up graph tool graph
graph = Graph()
vertex_list = []
username_to_index = {}
capacity = graph.new_edge_property('int')
screen_name = graph.new_vertex_property('string')

# extracting users
print "[Info]: getting users from Neo4J"
query = "match (u:User) return u.screen_name"
results = neocon.cypher.execute(query)
for username in results:
    vertex_list.append(graph.add_vertex())
    username_to_index[username['u.screen_name']]=len(vertex_list)-1

# connecting users
print "[Info]: getting users connections..."
stime = time.time()
counter = 0
for key in username_to_index:
    root = username_to_index[key]
    query = """MATCH (user:User {screen_name:"%s"})-[:POSTS]->(onetweet)<-[:TAGS]-(hashtag)-[:TAGS]->(othertweet)<-[:POSTS]-(coposter)
RETURN coposter.screen_name, count(*) ORDER BY count(*) DESC"""%key
    results = neocon.cypher.execute(query)
    for result in results:
        weight = result['count(*)']
        coposter = result['coposter.screen_name']
        coposter = username_to_index[coposter]
        capacity[graph.add_edge(root,coposter)]=weight
        counter += 1

print "[Info]: %d edges added, took %f seconds"%(counter,time.time()-stime)

graph.edge_properties['capacity'] = capacity
graph.vertex_properties['screen_name'] = screen_name
graph.save("coposting_graph.graphml",fmt="graphml")



