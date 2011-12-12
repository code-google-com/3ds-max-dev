import base
import pyfbsdk as native

class Application(base.Application):
    def __init__(self):
        self._system = native.FBSystem()

    @property
    def roots(self):
        yield Node(self._system.SceneRootModel)

    @property
    def product(self):
        return "Autodesk MotionBuilder"    
        
    def add_geometry(self, vertices, indices, name):
        mesh = native.FBMesh(name)
        mesh.GeometryBegin()
        for v in vertices:
            mesh.VertexAdd(v[0], v[1], v[2])
        for f in zip(*[iter(indices)]*3):
            mesh.PolygonBegin()
            for i in f:
                mesh.PolygonVertexAdd(i)
            mesh.PolygonEnd()
        mesh.ComputeVertexNormals(True)
        mesh.GeometryEnd()
        model = native.FBModelCube(name)
        model.Geometry = mesh
        v = native.FBVector3d(5, 5, 5)
        model.Scaling = v
        model.Show = True
        return model        
        
class Node(base.Node):
    def __init__(self, model):
        self._model = model

    @property 
    def name(self):
        return self._model.Name

    @name.setter
    def name(self, value):
        self._model.Name = value
        
    @property
    def children(self):
        return (Node(x) for x in self._model.Children)

    @property
    def transform(self):
        mat = native.FBMatrix()
        self._model.GetMatrix(mat)
        return _mat_to_tuple(mat)

    @property
    def selected(self):
        return self._model.Selected

    @selected.setter
    def set_selected(self, value):
        self._model.Selected = value

    @property
    def element(self):
        return GeometricObject(self._model)

class GeometricObject(base.GeometricObject):
    def __init__(self, model):
        self._model = model

    @property
    def mesh(self):
        g = self._model.Geometry
        if not g: return None
        return Mesh(g)

class Camera(base.Camera):
    def __init__(self, cam):
        self._cam = cam

    @property
    def is_ortho(self):
        return False

    @property
    def field_of_view(self):
        return self._cam.FieldOfView

    @property
    def aspect_ratio(self):
        return self._cam.FilmAspectRatio

    @property 
    def near_clip(self):
        return self._cam.NearPlaneDistance

    @property
    def far_clip(self):
        return self._cam.FarPlaneDistance

class Mesh(base.Mesh):
    def __init__(self, mesh):
        self.vertices = tuple(_vector4_to_tuple(mesh.VertexGet(i)) for i in xrange(mesh.VertexCount()))
        self.indices = tuple(self._compute_indices(mesh))
        self.uvs = tuple(tuple(mesh.VertexUVGet(i)) for i in self.indices)
        self.normals = tuple(self._compute_normals(mesh))

    def _compute_normals(self, m):
        j = 0
        for f in xrange(m.PolygonCount()):
            n = m.PolygonVertexCount(f)
            for i in xrange(1, n - 1):
                yield _vector4_to_tuple(m.VertexNormalGet(j))
                yield _vector4_to_tuple(m.VertexNormalGet(j + i))
                yield _vector4_to_tuple(m.VertexNormalGet(j + i + 1))
            j = j + n
        
    def _compute_indices(self, m):
        for f in xrange(m.PolygonCount()):
            n = m.PolygonVertexCount(f)
            for i in xrange(1, n - 1):
                yield m.PolygonVertexIndex(f, 0)
                yield m.PolygonVertexIndex(f, i)
                yield m.PolygonVertexIndex(f, i + 1) 
    
                
def _vector4_to_tuple(v):
    return (v[0], v[1], v[2])

def _mat_row(mat, row):
    return tuple(mat[row * 4 + i] for i in xrange(4))

def _mat_to_tuple(mat):
    return tuple(_mat_row(mat, i) for i in xrange(4))
                       
app = Application()
