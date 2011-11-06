'''
	self.uvs = tuple(_uvcoords) 
print str(FBSystem().Scene.RootModel.Children[0].Name)
'''

def _v4_to_tuple(v):
    return (v.mValue[0], v.mValue[1], v.mValue[2])

class Application(object):
    def __init__(self):
        self._system = FBSystem()

    @property
    def scene_roots(self):
        print node(FBSystem().Scene.RootModel)

class Node(object):
    def __init__(self, model):
        self._model = model

    @property 
    def name(self):
        return self._model.Name

    @property
    def children(self):
        return (Node(x) for x in self._model.Children)

class Element(object):
    def __init__(self, model):
        self._model = model

    @property
    def mesh(self):
        return Mesh(self._model.Geometry)

class Mesh(object):
    def __init__(self, mesh):
        self._mesh = mesh
        self.vertices = tuple((_v4_to_tuple(mesh.VertextGet(i)) from i in xrange(0, mesh.VertexCount)))
        self.normals = tuple((_v4_to_tuple(i) from i in xrange(0, mesh.PolygonCount())))                        
        # TODO: self.uvs
        # TODO: self.faces

    def _get_normal(self, i):
        index = self._mesh.GetNormalsIndexArray()[i];
        return self._mesh.GetNormalsDirectArray()[index];
        
app = Application()
