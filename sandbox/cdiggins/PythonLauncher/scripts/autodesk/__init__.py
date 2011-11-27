import sys
import os
import json

# Import the correct module depending on the ADSKPRODUCT environment variable
if not 'ADSKPRODUCT' in os.environ:
    raise ImportError('The environment variable ADSKPRODUCT was not set') 

product = os.environ['ADSKPRODUCT']
if 'max' == product:
    import max_common as common
elif 'maya' == product:
    import maya_common as common
elif 'mobu' == product:
    import mobu_common as common
elif 'fbx' == product:
    import fbx_common as common
else:
    raise ImportError("Not a recognized product: " + product)

# A shortcut to the single instance of Application
app = common.app

# The following functions are just for convenience sake. 
def root():
    ''' Returns the first root (unparented) node in a scene. ''' 
    for n in app.roots: 
        return n
    return None
    
def selected():
    ''' Returns the first selected node in a scene. '''
    for n in app.tree:
        if n.selected: 
            return n
    return None
    
def output_node_tree(f, n, s=""):
    ''' Outputs all child-node as a tree. '''
    f.write(s + n.name + "\n")
    for n2 in n.children:
       output_node_tree(f, n2, s + "  ")

def output_scene_tree(f = sys.stdout):    
    ''' Outputs all node names in a scene as a tree. '''
    for n in app.roots:
        output_node_tree(f, n)     
  
def node_as_dict(node):
    ''' Returns a dictionary representation of a node. '''
    return { 
        'name' : node.name, 
        'selected' : node.selected, 
        'transform' : node.transform, 
        'children' : [node_as_dict(n) for n in node.children],
        } 

def selected_mesh_json():
    ''' Converts the first selected mesh into a JSON representation '''
    return json.dumps(app.first_selected.element.mesh.__dict__)

def scene_json():
    ''' Converts the entire scene into a JSON representation. ''' 
    return json.dumps([node_as_dict(n) for n in common.app.roots]) 
    
def write_line(s):
    ''' Writes text to the application console window. '''
    return app.write_line(s)

