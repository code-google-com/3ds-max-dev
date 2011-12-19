# Load the .NET API from 3ds Max 
import clr
clr.AddReference("Autodesk.Max")
import Autodesk.Max as native

# Load the module containing the base classes.
import base

class Application(base.Application):
    def __init__(self):
        self._g = native.GlobalInterface.Instance
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

    def process_tasks(self):
        self._i.CheckMAXMessages

    @property
    def menu(self):
        return Menu(self._i.MenuManager)

    @property
    def actions(self):
        return Actions(self._i.ActionManager)
         
class Action(object):
    def __init__(self, action):
        self._action = action

    def execute(self):
        self._action.ExecuteAction()

    @property
    def name(self):
        s = ''
        self._action.GetButtonText(s)
        return s

    @property
    def alt_name(self):
        s = ''
        self._action.GetMenuText(s)
        return s
  
    @property
    def enabled(self):
        return self._action.IsEnabled

    @property
    def checked(self):
        return self._action.IsChecked

    @property
    def description(self):
        s = ''
        self._action.GetDescription(s)
        return s

    @property 
    def category(self):
        s = ''
        self._action.GetCategory(s)
        return s

    @property
    def id(self):
        return self._action.Id()

class PropertyDescriptor(object):
    def __init__(self, paramdef):
        self._paramdef = paramdef

    @property
    def name(self):
        return self._params.GetLocalName(self._id)

    @property
    def ascii_name(self):
        return ''

    @property
    def has_limits(self):
        return False

    @property
    def has_default(self):
        return False

    @property
    def get_limits(self):
        return (None, None)

    @property
    def get_default(self):
        return (None)

    @property
    def dimension_name(self):
        return self._paramdef.dim.DimensionName

    @property
    def validate(self, Value):
        return True

    @property
    def description(self):
        return self._paramdef.dim.DimensionName

class PropertySet(object):
    def __init__(self, params):
        self._params = params

    def __getitem__(self, index):
        return self._params[index]

    def __setitem__(self, index, value):
        self._params[index] = value

    @property 
    def __len__(self):
        return self._params.Count       

    def get_descriptor(self, index):
        return None

class Menu(object):
    def __init__(self, menu):
        self._menu = menu

    def actions(self):
        for i in xrange(self._menu.numItems):
            yield self._menu.GetItem(i).actionItem

    @property
    def title(self):
        return self._menu.Title

class Actions(object):
    def __init__(self, action_mgr):
        self._mgr = action_mgr

    @property
    def actions(self):
        for i in xrange(action_mgr.NumActionTables):
            table = action_mgr.GetTable(i)
            for j in table.Count:
                yield table[j]

class Node(base.Node):
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

class GeometricObject(base.GeometricObject):
    def __init__(self, e):
        self._object = e
        
    @property 
    def mesh(self):
        return _obj_to_mesh(self._object, _now())
        
    @property
    def name(self):
        return self._object.ObjectName

class Camera(base.Camera):
    def __init__(self, cam):
        self._cam = cam
        self._state = native.IGlobal.IGlobalCameraState.Create()
        cam.EvalCameraState(_now(), _interval(), self._state)
        
    @property
    def is_ortho(self):
        return self._state.IsOrtho

    @property
    def field_of_view(self):
        return self._state.Fov

    @property
    def aspect_ratio(self):
        return 1.0

    @property 
    def near_clip(self):
        return self._state.Hither

    @property
    def far_clip(self):
        return self._state.Yon

class Mesh(base.Mesh):                
    def __init__(self, m):
        m.BuildNormals()
        self.indices = tuple(self._compute_indices(m))
        self.vertices = tuple(_point3_to_tuple(v) for v in m.Verts)
        self.normals = tuple(self._compute_normals(m))
        self.uvs = tuple(self._compute_uvs(m))

    def _compute_indices(self, m):
        for f in m.Faces:
            yield int(f.V[0])
            yield int(f.V[1])
            yield int(f.V[2])

    def _compute_normals(self, m):
        for i in xrange(m.NumFaces):
            yield _normal_to_tuple(m.FaceNormal(i, True)) 
            yield _normal_to_tuple(m.FaceNormal(i, True)) 
            yield _normal_to_tuple(m.FaceNormal(i, True)) 
        
    def _compute_uvs(self, m):
        for f in m.TvFace:
            for v in f.T:
                uvw = m.TVerts[v]				
                yield (float(uvw[0]), float(uvw[1]))
            
def _point3_to_tuple(p):
    return (float(p.X), float(p.Y), float(p.Z))

def _normal_to_tuple(n):
    return (float(n.X), float(n.Y), float(n.Z))
    
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

def _interval():
    return native.IGlobal.IGlobalInterval.Create()

        
# Singleton instance of the Application object 
app = Application()

