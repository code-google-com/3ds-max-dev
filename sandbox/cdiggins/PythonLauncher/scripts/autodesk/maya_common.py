# Written by Christopher Diggins
# Copyright Autodesk
# Licensed under the New BSD License

import pymel.core as pm
import base

class Application(base.BaseApplication):
    def __init__(self):
        pass
        
    def write_line(self, text):
        print text

    @property
    def roots(self):
        # return all transform nodes without a parent
        return (Node(x) for x in pm.ls(tr=True) if not pm.listRelatives(x, parent=True))  
        
    def load_file(self, fname):
        return pm.importFile
    
    def shutdown(self):
        self._mgr.Destroy()
        
class Node(base.BaseNode):
    def __init__(self, node):
        self._node = node        
    
    @property
    def children(self):
        return pm.listRelatives(self._node)

    @property
    def name(self):
        return self._node.Name()
    
    @name.setter  
    def set_name(self, value):
        pm.rename(self._node, value)
    
    @property
    def parent(self):
        xs = pm.listRelatives(self._node, parent=True)
        if len(xs) < 1: return None
        return xs[0]
    
    @property
    def transform(self):
        return _mat_to_tuple(self._node.transformationMatrix())
                
    @property
    def element(self):
        return self._node.getShape()
                        
class GeometricObject(base.BaseGeometricObject):
    def __init__(self, shape):
        self._shape = shape
        
    @property 
    def mesh(self):
        return Mesh(self._attr)

class Mesh(base.BaseMesh):                
    def __init__(self, mesh):    
        self._mesh = mesh
        
    @property
    def indices(self):
        for f in self._mesh.faces
            vxs = f.getVertices()
            poly_size = len(vxs)
            if poly_size == 3:
                yield vxs[0]; yield vxs[1]; yield vxs[2]
            elif poly_size == 4:
                yield vxs[0]; yield vxs[1]; yield vxs[3]
                yield vxs[1]; yield vxs[2]; yield vxs[3]
            else:
                raise Exception('Only triangle and quad meshes are supported') 
                        
    @property 
    def uvs(self):
        for f in self._mesh.faces
            poly_size = len(f.getVertices())
            if poly_size == 3:
                yield f.getUV(0); yield f.getUV(1); yield f.getUV(2)
            elif poly_size == 4:
                yield f.getUV(0); yield f.getUV(1); yield f.getUV(3)
                yield f.getUV(1); yield f.getUV(2); yield f.getUV(2)
            else:
                raise Exception('Only triangle and quad meshes are supported') 
    
    @property
    def vertices(self):
        return (tuple(v) for v in self._mesh.getPoints())        
        
    @property
    def normals(self):
        for f in m.faces:
            poly_size = len(f.getVertices)
            normals = f.getNormals()
            if poly_size == 3:
                yield normals[0]; yield normals[1]; yield normals[2]
            elif poly_size == 4:
                yield normals[0]; yield normals[1]; yield normals[3]
                yield normals[1]; yield normals[2]; yield normals[3]
            else:
                raise Exception('Only triangle and quad meshes are supported') 

def _mat_to_tuple(m):
    return tuple(tuple(r) for r in m)

''' This is a singleton representing the application '''
app = Application()
