import fbx as native
import FbxCommon 
import base

class Application(base.Application):
    def __init__(self):
        (self._mgr, self._scene) = FbxCommon.InitializeSdkObjects()

    def write_line(self, text):
        print text

    @property
    def roots(self):
        yield Node(self._scene.GetRootNode())   
        
    def load_file(self, fname):
        return FbxCommon.LoadScene(self._mgr, self._scene, fname)
    
    def shutdown(self):
        self._mgr.Destroy()

    @property
    def product():
        return "Autodesk FBX"		

class Node(base.Node):
    def __init__(self, node):
        self._node = node
        self.selected = False
    
    @property
    def children(self):
        for i in xrange(self._node.GetChildCount()):
            yield Node(self._node.GetChild(i))

    @property
    def name(self):
        return self._node.GetName()
    
    @name.setter  
    def set_name(self, value):
        self._node.SetName(value)
    
    @property
    def parent(self):
        return Node(self._node.GetParent())
    
    @property
    def transform(self):
        e = app._scene.GetEvaluator()
        return _mat_to_tuple(e.GetNodeLocalTransform(self._node))
                
    @property
    def element(self):
        if not self._node: return None
        attr = self._node.GetNodeAttribute()
        if not attr: return None
        atype = attr.GetAttributeType()
        if atype == native.KFbxNodeAttribute.eMESH:
            return GeometricObject(attr)
        elif atype == native.KFbxNodeAttribute.eMARKER:
            return None # Marker(attr)
        elif atype == native.KFbxNodeAttribute.eSKELETON:
            return None #  Skeleton(attr)
        elif atype == native.KFbxNodeAttribute.eNURB:
            return None # Nurb(attr)
        elif atype == native.KFbxNodeAttribute.ePATCH:
            return None # Patch(attr)
        elif atype == native.KFbxNodeAttribute.eCAMERA:
            return None # Camera(attr)
        elif atype == native.KFbxNodeAttribute.eLIGHT:
            return None # Light(attr)                
        else: 
            raise Exception('Unrecognized attribute type')
                        
class GeometricObject(base.GeometricObject):
    def __init__(self, attr):
        self._attr = attr
        
    @property 
    def mesh(self):
        return Mesh(self._attr)

class Mesh(base.Mesh):                
    def __init__(self, m):        
        self.indices = tuple(_get_indices(m))                
        self.vertices = tuple((x[0], x[1], x[2]) for x in m.GetControlPoints())
        self.normals = tuple(_get_normals(m))
        self.uvs = tuple(_get_uvs(m, 0))

    def _get_indices(m):
        for i in xrange(m.GetPolygonCount()):
            poly_size = m.GetPolygonSize(i)
            for j in xrange(1, poly_size-1):
                yield (m.GetPolygonVertex(i, 0), m.GetPolygonVertex(i, j), m.GetPolygonVertex(i, j + 1))

    def _get_normals(m):
        for i in xrange(m.GetPolygonCount()):
            poly_size = m.GetPolygonSize(i)
            for j in xrange(1, poly_size-1):
                yield (m.GetPolygonVertex(i, 0), m.GetPolygonVertex(i, j), m.GetPolygonVertex(i, j + 1))

    def _get_uvs(m, nlayer):        
        layer = m.GetElementUV(nlayer)
        for i in xrange(m.GetPolygonCount()):
            poly_size = m.GetPolygonSize(i)
            for j in xrange(1, poly_size-1):
                if layer.GetMappingMode() == KFbxLayerElement.eBY_CONTROL_POINT:
                    index = m.GetPolygonVertex(i, j)
                    uv = _get_layer_element_at(layer, index)
                    yield (uv[0], uv[1])
                elif layer.GetMappingMode() ==  KFbxLayerElement.eBY_POLYGON_VERTEX:
                    index = m.GetTextureUVIndex(i, j)
                    uv = _get_layer_element_at(layer, index)
                    yield (uv[0], uv[1])
                else:
                    raise Exception('Unrecognized method of storing UV coordinates')        
    
    def _get_layer_element_at(layer, index):    
        if layer.GetReferenceMode() == KFbxLayerElement.eDIRECT:
            return layer.GetDirectArray().GetAt(index)
        else: 
            id = layer.GetIndexArray().GetAt(index)
            return layer.GetDirectArray().GetAt(id)
    

def _mat_to_tuple(m):
    return tuple(tuple(r) for r in m)

''' This is a singleton representing the application '''
app = Application()
