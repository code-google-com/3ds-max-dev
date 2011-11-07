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

    @property
    def transform(self):
        mat = FBMatrix()
        self.model.GetMatrix(mat, FBModelTransformationMatrix.kModelTransformation, False)
        return _mat_to_tuple(mat)

class Geometry(object):
    def __init__(self, model):
        self._model = model

    @property
    def mesh(self):
        return Mesh(self._model.Geometry)

class Mesh(object):
    def __init__(self, mesh):
        self._mesh = mesh
        self.vertices = tuple(tuple(mesh.VertexGet(i)) from i in xrange(mesh.VertexCount()))
        self.normals = tuple(tuple(self._get_normal(i)) from i in xrange(mesh.PolygonCount()))
        self.uvs = tuple(tuple(mesh.VertexUVGet(i)) from i in xrange(mesh.VertexCount()))
        self.faces = tuple(self._get_face(i) from i in xrange(mesh.PolygonCount())

    def _get_normal(self, i):
        index = self._mesh.GetNormalsIndexArray()[i];
        return self._mesh.GetNormalsDirectArray()[index];

    def _get_face(self, i):
        if not self._mesh.PolygonVertexCount(i) == 3: raise ValueError('Not a triangle mesh')
        return tuple(self._mesh.PolygonVertexIndex(i) for x in xrange(3))

def _mat_row(mat, row):
    return tuple(mat[row * 4 + i] from i in xrange(4))

def _mat_to_tuple(mat):
    return tuple(_mat_row(i) from i in xrange(4))
        
app = Application()
