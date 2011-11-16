# Written by Christopher Diggins
# Copyright Autodesk
# Licensed under the New BSD License

import fbx
import FbxCommon 
import base

class Application(base.BaseApplication):
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
        
class Node(base.BaseNode):
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
        if atype == fbx.KFbxNodeAttribute.eMESH:
            return GeometricObject(attr)
        elif atype == fbx.KFbxNodeAttribute.eMARKER:
            return None # Marker(attr)
        elif atype == fbx.KFbxNodeAttribute.eSKELETON:
            return None #  Skeleton(attr)
        elif atype == fbx.KFbxNodeAttribute.eNURB:
            return None # Nurb(attr)
        elif atype == fbx.KFbxNodeAttribute.ePATCH:
            return None # Patch(attr)
        elif atype == fbx.KFbxNodeAttribute.eCAMERA:
            return None # Camera(attr)
        elif atype == fbx.KFbxNodeAttribute.eLIGHT:
            return None # Light(attr)                
        else: 
            raise Exception('Unrecognized attribute type')
                        
class GeometricObject(base.BaseGeometricObject):
    def __init__(self, attr):
        self._attr = attr
        
    @property 
    def mesh(self):
        return Mesh(self._attr)

class Mesh(base.BaseMesh):                
    def __init__(self, m):        
        m.ComputeVertexNormals()
        self.faces = tuple(_get_faces(m))                
        self.uvs = tuple(_get_uvs(m.GetLayer(0)))
        self.vertices = tuple((x[0], x[1], x[2]) for x in m.GetControlPoints())
        self.normals = tuple(_get_normals(m))

def _get_faces(m):
    for i in xrange(m.GetPolygonCount()):
        poly_size = m.GetPolygonSize(i)
        if poly_size == 3:
            yield (m.GetPolygonVertex(i, 0), m.GetPolygonVertex(i, 1), m.GetPolygonVertex(i, 2))
        elif poly_size == 4:
            yield (m.GetPolygonVertex(i, 0), m.GetPolygonVertex(i, 1), m.GetPolygonVertex(i, 3))
            yield (m.GetPolygonVertex(i, 1), m.GetPolygonVertex(i, 2), m.GetPolygonVertex(i, 3))
        else:
            raise Exception('Only triangle and quad meshes are supported') 

def _v3_avg(v0, v1, v2):
    return ((v0[0] + v1[0] + v2[0]) / 3.0, 
            (v0[1] + v1[1] + v2[1]) / 3.0, 
            (v0[2] + v1[2] + v2[2]) / 3.0)

def _get_uvs(layer):        
    # TODO: finish
    return _
    
def _get_layer_array(layer):    
    direct = layer.GetDirectArray()
    if layer.GetReferenceMode() == KFbxLayerElement.eDIRECT:
        return direct
    else: 
        indices = layer.GetIndexArray
        return (direct[i] for i in indices)
    
    
def _get_normals(m):
    ns = None
    if not m.GetPolygonVertexNormals
    for i in xrange(m.GetPolygonVertexCount()):
        for j in xrange(3):
            m.GetPolygonVertexNormal(i, j, n)
            yield (n[0], n[1], n[2])

def _mat_to_tuple(m):
    return tuple(tuple(r) for r in m)

''' This is a singleton representing the application '''
app = Application()
