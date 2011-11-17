import json 
import autodesk.shared

def scene_tree():
    for r in common.app.roots:
        for n in r.tree:
            yield n

def root():
    for n in common.app.roots: return n
    return None
    
def selected():
    for n in scene_tree():
        return n
    return None
    
def output_node_tree(f, n, s=""):
    f.write(s + n.name + "\n")
    for n2 in n.children:
       output_node_tree(f, n2, s + "  ")

def output_scene_tree(f):
    for n in common.app.roots:
        output_node_tree(f, n)     
  
def element_as_dict(e):
    if e == None: return None
    return {
        'name' : e.name,
        }    
    
def node_as_dict(node):
    return { 
        'name' : node.name, 
        'selected' : node.selected, 
        'transform' : node.transform, 
        'element' : element_as_dict(node.element),
        'children' : [node_as_dict(n) for n in node.children],
        } 

def selected_mesh_json():
    try:
        return json.dumps(selected().element.mesh.__dict__)
    except:
        return '{}'

def scene_json():
    return json.dumps(node_as_dict(root())) 
    
def write_line(s):
    return common.app.write_line(s)

