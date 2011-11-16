import sys
sys.path.append("C:\Program Files\IronPython 2.6 for .NET 4.0\Lib")
import json
from autodesk.common import *

def output_node(n, indent=''):    
    app.write_line(indent + n.name)
    for x in n.children:
        output_node(x, indent + '  ')

def output_scene_tree():
    for n in app.scene_roots:
        output_node(n)

def selected_node():
    for n in app.selected_nodes:
        return n
    return None

def output_mesh_stats(m):
    if m == None:
        app.write_line("No mesh")
        return
    app.write_line("# faces = " + str(len(m.faces)))
    app.write_line("# vertices = " + str(len(m.vertices)))
    app.write_line("# normals = " + str(len(m.normals)))
    app.write_line("# uvs = " + str(len(m.uvs)))
        
def output_element_stats(e):
    if e == None:
        app.write_line("No element")
        return
    output_mesh_stats(e.mesh)

def output_node_stats(n):
    if n == None:
        app.write_line("No node")
        return
    app.write_line("node " + n.name)
    output_element_stats(n.element)    

def selected_node_stats():
    sel = selected_node() 
    if sel == None:
        app.write_line("No selected node")
        return
    output_node_stats(sel)

def selected_mesh():
    return selected_node().element.mesh

app.write_line("Scene tree")
output_scene_tree()

app.write_line("Selected node")
selected_node_stats()

app.write_line("Selected mesh as dictionary")
m = selected_mesh()
d = m.__dict__
app.write_line(d)

app.write_line("Selected mesh as JSON")
app.write_line(json.dumps(d))

# app.write_line("So long, and thanks for all the fish!")
        
        


    
