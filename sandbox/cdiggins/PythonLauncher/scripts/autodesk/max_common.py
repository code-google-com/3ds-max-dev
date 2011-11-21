# Load the .NET API from 3ds Max 
import clr
clr.AddReference("Autodesk.Max")
import Autodesk.Max

# Load your local instance of Python 2.6
import sys
sys.path.append("C:\Python26\Lib")

# Load the base classes.
import base

class Application(base.BaseApplication):
    def __init__(self):
        self._g = Autodesk.Max.GlobalInterface.Instance
        self._i = self._g.COREInterface13    

    def write_line(self, text):
        self._g.TheListener.EditStream.Wputs(text + "\n")
        self._g.TheListener.EditStream.Flush()

    @property
    def roots(self):
        yield Node(self._i.RootNode)        
        
    @property
    def product(self):
        return "Autodesk 3ds Max"    
		
class Node(base.BaseNode):
    def __init__(self, inode):
        self._node = inode
    
    @property
    def children(self):
        for i in xrange(self._node.NumberOfChildren):
            yield Node(self._node.GetChildNode(i))

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

class GeometricObject(base.BaseGeometricObject):
    def __init__(self, e):
        self._object = e
        
    @property 
    def mesh(self):
        return _obj_to_mesh(self._object, _now())
        
    @property
    def name(self):
        return self._object.ObjectName

class Mesh(base.BaseMesh):                
    def __init__(self, m):
        m.BuildNormals()
        self.indices = tuple(self._compute_indices(m))
        self.vertices = tuple(_point3_to_tuple(v) for v in m.Verts)
        self.normals = tuple(self._compute_normals(m))
        self.uvs = tuple(self._compute_uvs(m))

    def _compute_indices(self, m):
        for f in m.Faces:
            for v in f.V:
                yield int(v)

    def _compute_normals(self, m):
        for i in xrange(m.NumFaces):
            yield _point3_to_tuple(m.FaceNormal(i, False)) 
            yield _point3_to_tuple(m.FaceNormal(i, False)) 
            yield _point3_to_tuple(m.FaceNormal(i, False)) 
        
    def _compute_uvs(self, m):
        for f in m.TvFace:
            for v in f.T:
                uvw = m.TVerts[v]				
                yield (float(uvw[0]), float(uvw[1]))
            
def _point3_to_tuple(p):
    return (float(p.X), float(p.Y), float(p.Z))

def _matrix_to_tuple(mat):
    return tuple(_point3_to_tuple(mat.GetRow(i)) for i in xrange(4))

def _obj_to_mesh(obj, time):    
    cid = app._g.Class_ID.Create(9, 0)
    tri = obj.ConvertToType(time, cid)
    if tri == None: return None
    mesh = Mesh(tri.Mesh_)
    tri.MaybeAutoDelete()
    return mesh
    
def _now():
    return app._i.Time
        
# Singleton instance of the Application object 
app = Application()

