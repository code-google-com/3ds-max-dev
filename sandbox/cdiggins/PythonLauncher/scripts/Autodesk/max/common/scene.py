# Requires the 3ds Max 2012 Subscription Advantage Pack to be installed. 
# Written by Christopher Diggins
# Copyright Autodesk
# Licensed under the New BSD License

import clr
clr.AddReference("Autodesk.Max")
import Autodesk.Max 

def _face_to_tuple(face):
    return (face.v[0], face.v[1], face.v[2])
	
def _point3_to_tuple(p):
    return (p.x, p.y, p.z)
		
def _obj_to_mesh(obj, time):
    id = Autodesk.Max.ClassID.TriObject._IClass_ID
    tri = obj.ConvertToType(time, id)
    if tri == null:
        return None
    mesh = Mesh(tri.Mesh)
    if not tri.Handle == obj.Handle:
        tri.MaybeAutoDelete()
    return mesh
	
def _matrix_to_tuple(mat):
    return (_point3_to_tuple(mat.GetRow(i)) for i in xrange(0, 3))
		
class Application(object):
    def __init__(self):
        self._g = Autodesk.Max.GlobalInterface.Instance
        self._i = self.g.COREInterface13    

    def write_line(self, text):
	# There might be a more direct way to do this from the Autodesk.Max namespace
        self._g.ExecuteMAXScriptScript("format \"" + text + "\n\" print", False, None)

    @property
    def scene_roots(self):
        yield Node(self._i.RootNode)		
		
    @property
    def scene_tree(self):
        for root in self.scene_roots:
            for node in root.tree:
                yield node
		
    @property
    def selected_nodes(self):
        return (n for n in self.scene_tree if n.selected)
    		
class Node(object):
    def __init__(self, inode):
        self._node = inode
	
    @property
    def children(self):
        for i in xrange(0, self._node.NumberOfChildren):
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
    def tranform(self):
        t = app.i.Time
        v = app.g.Interval.Create()
	m = self._node.GetNodeTransform(t, v)
	return _matrix_to_tuple(m)
				
    @property
    def element(self):
        if self._node == None: return None
	return Element(self._node.ObjectRef)
						
class Element(object):
    def __init__(self, e):
        self._object = e
		
    @property 
    def mesh(self):
        return Mesh(_object)

class Mesh(object):
    def _uvcoords(self):
        for f in xrange(0, self._mesh.NumFaces):
            tvface = self._mesh.tvFace[f]
            for i in xrange(0, 2):
                yield self._mesh.tverts(tvface.t[i])
                
    def __init__(self, m)
        self._mesh = m
	self.faces = tuple((_face_to_tuple(m.Faces[i]) for i in xrange(0, m.NumFaces)))
	self.vertices = tuple(m.Verts[i] for i in xrange(0, m.NumVerts))
	self.normals = tuple(_point3_to_tuple(m.getFaceNormal(i)) for i in xrange(0, m.NumFaces)))
	self.uvs = tuple(_uvcoords) 

    def num_faces(self):
        return len(self.faces)

    def num_vertices(self):
        return len(self.vertices)
		
# Singleton instance of the Application object 
app = Application()

