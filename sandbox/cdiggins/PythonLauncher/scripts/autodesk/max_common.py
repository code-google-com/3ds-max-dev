# Requires the 3ds Max 2012 Subscription Advantage Pack to be installed. 
# Written by Christopher Diggins
# Copyright Autodesk
# Licensed under the New BSD License

import clr
clr.AddReference("Autodesk.Max")
import Autodesk.Max 

class Application(object):
    def __init__(self):
        self._g = Autodesk.Max.GlobalInterface.Instance
        self._i = self._g.COREInterface13    

    def write_line(self, text):
        # There might be a more direct way to do this from the Autodesk.Max namespace
        s = str(text).replace("\"", "\\\"")
        self._g.ExecuteMAXScriptScript("format \"" + s + "\n\" print", False, None)

    @property
    def roots(self):
        yield Node(self._i.RootNode)        
        
class Node(object):
    def __init__(self, inode):
        self._node = inode
    
    @property
    def children(self):
        for i in xrange(self._node.NumberOfChildren):
            yield Node(self._node.GetChildNode(i))

    @property
    def tree(self):
        for child in self.children: 
            for desc in child.tree:
                yield desc
        yield self

    @property
    def name(self):
        return self._node.Name
    
    @name.setter  
    def set_name(self, value):
        self._node.Name = value
    
    @property
    def parent(self):
        return Node(self._node.Parent)
    
    @property
    def selected(self):
        return self._node.Selected
    
    @selected.setter    
    def set_selected(self, value):
        self._node.Selected = value
        
    @property
    def transform(self):
        v = app._g.Interval.Create()
        m = self._node.GetNodeTM(_now(), v)
        return _matrix_to_tuple(m)
                
    @property
    def element(self):
        obj = self._node.ObjectRef
        if obj == None: return None
        return GeometricObject(obj)

class GeometricObject(object):
    def __init__(self, e):
        self._object = e
        
    @property 
    def mesh(self):
        return _obj_to_mesh(self._object, _now())
        
    @property
    def name(self):
        return self._object.ObjectName

class Mesh(object):                
    def __init__(self, m):
        self.faces = tuple(_face_to_tuple(m.Faces[i]) for i in xrange(m.NumFaces))
        self.vertices = tuple(_point3_to_tuple(m.Verts[i]) for i in xrange(m.NumVerts))
        self.normals = tuple(_point3_to_tuple(m.FaceNormal(i, False)) for i in xrange(m.NumFaces))
        self.uvs = tuple(_tvface_to_tuple(m.TvFace[i]) for i in xrange(m.NumFaces))

def _face_to_tuple(face):
    return (int(face.V[0]), int(face.V[1]), int(face.V[2]))
    
def _point3_to_tuple(p):
    return (float(p.X), float(p.Y), float(p.Z))

def _tvface_to_tuple(tvf):
    return (int(tvf.T[0]), int(tvf.T[1]))
            
def _obj_to_mesh(obj, time):    
    cid = app._g.Class_ID.Create(9, 0)
    tri = obj.ConvertToType(time, cid)
    if tri == None: return None
    mesh = Mesh(tri.Mesh_)
    tri.MaybeAutoDelete()
    return mesh
    
def _matrix_to_tuple(mat):
    return tuple(_point3_to_tuple(mat.GetRow(i)) for i in xrange(4))

def _now():
    return app._i.Time
        
# Singleton instance of the Application object 
app = Application()

