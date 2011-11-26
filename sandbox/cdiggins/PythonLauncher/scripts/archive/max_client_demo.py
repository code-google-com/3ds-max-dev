import json
import urllib2
import autodesk

def demo(host = 'http://localhost:8000'):
    f = urllib2.urlopen(host + '/mesh')   
    s = f.read()
    f.close()
    o = json.loads(s)    
    return autodesk.common.app.add_geometry(o['vertices'], o['indices'], 'ImportedGeometry')


