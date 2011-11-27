
# Copyright 2009 Autodesk, Inc.  All rights reserved.
# Use of this software is subject to the terms of the Autodesk license agreement 
# provided at the time of installation or download, or which otherwise accompanies
# this software in either electronic or hard copy form.
#
# This script is to demonstrate the ssimple geometry creation and gemoetry instancing feature.
#
# Topic: FBMesh, FBVector3d, FBModelTransformationMatrix, FBModelShadingMode
#
from pyfbsdk import FBMesh, FBModelCube, FBVector3d, FBModelTransformationMatrix, FBModelShadingMode

def make_mesh(name, vertices, faces):
    m = FBMesh(name)
    m.GeometryBegin()
    for v in vertices:
        m.VertexAdd(v[0], v[1], v[2])
    for f in faces:
        m.PolygonBegin()
        for i in f:
            m.PolygonVertexAdd(i)
        m.PolygonEnd()
    m.ComputeVertexNormals(True)
    m.GeometryEnd()
    return m

vxs = ((0, 100, 0), (100,100, 0), (100, 0, 0), (0, 0, 0))
faces = ((0, 1, 2, 3),)

mesh = make_mesh("mesh", vxs, faces)

# And we use Geometry Instancing feature to share this simple plane among multiple models.
for lIndex in range(1, 10):
    #create a cube but we will replace its geometry
    lModel = FBModelCube("myModel")
    
    # Replace the geometry instance
    lModel.Geometry = mesh
    
    lModel.SetVector( FBVector3d(120*lIndex - 600, 50, 50 ) )
        
    # The object must be set visible to be present in the system.
    lModel.Visible = True
    lModel.Show = True

def face(m, f): 
    return [m.PolygonVertexIndex(f, i) 
        for i in xrange(m.PolygonVertexCount(f))]
            