class Application(object):
    def __init__(self):
        self._system = FBSystem()

    @property
    def scene_roots(self):
        print node(FBSystem().Scene.RootModel)

    @property
    def scene_tree(self):
        for root in self.scene_roots:
            for node in root.tree:
                yield node
		
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
        self.vertices = tuple(_v4_to_tuple(mesh.VertexGet(i)) from i in xrange(0, mesh.VertexCount()))
        self.normals = tuple(_v4_to_tuple(self._get_normal(i)) from i in xrange(0, mesh.PolygonCount()))
        self.uvs = tuple(_uv_to_tuple(mesh.VertexUVGet(i)) from i in xrange(0, mesh.VertexCount()))
        self.faces = tuple(self._get_face(i) from i in xrange(0, mesh.PolygonCount())

    def _get_normal(self, i):
        index = self._mesh.GetNormalsIndexArray()[i];
        return self._mesh.GetNormalsDirectArray()[index];

    def _get_face(self, i):
        if not self._mesh.PolygonVertexCount(i) == 3: raise ValueError('Not a triangle mesh')
        return tuple(self._mesh.PolygonVertexIndex(i) for x in xrange(0, 3))

def _v4_to_tuple(v):
    return (v.mValue[0], v.mValue[1], v.mValue[2])

def _uv_to_tuple(uv):
    return (
        
app = Application()
