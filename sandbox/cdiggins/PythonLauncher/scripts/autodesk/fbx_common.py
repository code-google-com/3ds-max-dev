import fbx as native
import FbxCommon 
import base

class Application(base.Application):
    def __init__(self):
        (self._mgr, self._scene) = FbxCommon.InitializeSdkObjects()

    @property
    def roots(self):
        yield Node(self._scene.GetRootNode())   
        
    def load_file(self, fname):
        return FbxCommon.LoadScene(self._mgr, self._scene, fname)
    
    def shutdown(self):
        self._mgr.Destroy()

    @property
    def product(self):
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
        self.indices = tuple(self._get_indices(m))                
        self.vertices = tuple((x[0], x[1], x[2]) for x in m.GetControlPoints())
        self.normals = tuple(self._get_normals(m))
        self.uvs = tuple(self._get_uvs(m, 0))

    def _get_indices(self, m):
        for i in xrange(m.GetPolygonCount()):
            poly_size = m.GetPolygonSize(i)
            for j in xrange(1, poly_size-1):
                yield m.GetPolygonVertex(i, 0)
                yield m.GetPolygonVertex(i, j)
                yield m.GetPolygonVertex(i, j + 1)

    def _get_normals(self, m):
        v = native.KFbxVector4()
        for i in xrange(m.GetPolygonCount()):
            poly_size = m.GetPolygonSize(i)
            for j in xrange(1, poly_size-1):                
                m.GetPolygonVertexNormal(i, 0, v)
                yield (v[0], v[1], v[2])
                m.GetPolygonVertexNormal(i, j, v)
                yield (v[0], v[1], v[2])
                m.GetPolygonVertexNormal(i, j + 1, v)
                yield (v[0], v[1], v[2])

    def _get_uvs(self, m, nlayer):        
        layer = m.GetLayer(nlayer).GetUVs()
        for i in xrange(m.GetPolygonCount()):
            poly_size = m.GetPolygonSize(i)
            for j in xrange(1, poly_size-1):
                if layer.GetMappingMode() == native.KFbxLayerElement.eBY_CONTROL_POINT:
                    uv = self._get_layer_element_at(layer, m.GetPolygonVertex(i, 0))
                    yield (uv[0], uv[1])
                    uv = self._get_layer_element_at(layer, m.GetPolygonVertex(i, j))
                    yield (uv[0], uv[1])
                    uv = self._get_layer_element_at(layer, m.GetPolygonVertex(i, j+1))
                    yield (uv[0], uv[1])
                elif layer.GetMappingMode() == native.KFbxLayerElement.eBY_POLYGON_VERTEX:
                    uv = self._get_layer_element_at(layer, m.GetTextureUVIndex(i, 0))
                    yield (uv[0], uv[1])
                    uv = self._get_layer_element_at(layer, m.GetTextureUVIndex(i, j))
                    yield (uv[0], uv[1])
                    uv = self._get_layer_element_at(layer, m.GetTextureUVIndex(i, j+1))
                    yield (uv[0], uv[1])
                else:
                    raise Exception('Unrecognized method of storing UV coordinates')        
    
    def _get_layer_element_at(self, layer, index):    
        if layer.GetReferenceMode() == native.KFbxLayerElement.eDIRECT:
            return layer.GetDirectArray().GetAt(index)
        else: 
            id = layer.GetIndexArray().GetAt(index)
            return layer.GetDirectArray().GetAt(id)
    
def _mat_to_tuple(m):
    return tuple(tuple(r) for r in m)

''' This is a singleton representing the application '''
app = Application()
