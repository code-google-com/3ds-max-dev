import sys

# TODO: change this depending on where your Python modules are stored. 
sys.path.append('c:\Python27\Lib')

import os
import json

def adsk_product():
    return os.environ['ADSKPRODUCT']

# Import the correct module depending on the ADSKPRODUCT environment variable
if 'max' == adsk_product():
    import max_common as common
elif 'maya' == adsk_product():
    import maya_common as common
elif 'mobu' == adsk_product():
    import mobu_common as common
elif 'fbx' == adsk_product():
    import fbx_common as common
else:
    raise ImportError('The environment variable ADSKPRODUCT was not set') 
        
def scene_tree():
    for r in common.app.roots:
        for n in r.tree:
            yield n

def root():
    for n in common.app.roots: 
		return n
    return None
    
def selected():
    for n in scene_tree(): 
		if n.selected: 
			return n
    return None
    
def output_node_tree(f, n, s=""):
    f.write(s + n.name + "\n")
    for n2 in n.children:
       output_node_tree(f, n2, s + "  ")

def output_scene_tree(f = sys.stdout):
    for n in common.app.roots:
        output_node_tree(f, n)     
  
def node_as_dict(node):
    return { 
        'name' : node.name, 
        'selected' : node.selected, 
        'transform' : node.transform, 
        'children' : [node_as_dict(n) for n in node.children],
        } 

def selected_mesh_json():
	return json.dumps(selected().element.mesh.__dict__)

def scene_json():
    return json.dumps([node_as_dict(n) for n in common.app.roots]) 
    
def write_line(s):
    return common.app.write_line(s)

