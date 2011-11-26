import json
import urllib2
import autodesk

def get_mesh_over_http(port = 8000, host = 'http://localhost'):    
    # Open a URL 
    f = urllib2.urlopen(host + ':' + str(port) + '/mesh')   
    # Read the data 
    s = f.read()
    # Close the file 
    f.close()
    # Decode the JSON encoded text into a dictionary
    dict = json.loads(s)    
    # Add the geometry to the scene.
    return autodesk.common.app.add_geometry(dict['vertices'], dict['indices'], 'ImportedGeometry')


