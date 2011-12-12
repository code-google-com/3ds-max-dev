import autodesk

def make_triobj(vertices, indices, normals, uvs):
    tri = autodesk.native.CreateNewTriObject()
    if not tri: return None

    assert(points.size() == normals.size() and normals.size() == uvs.size())
    assert(triangleVertIndices.size() % 3 == 0)
    
    numVertices = len(vertices)
    numTriangles = len(indices) / 3
    mesh = triobj.GetMesh()

    # set vertex positions
    mesh.setNumVerts(numVertices)
    for i in xrange(numVertices):
        mesh.setVert(i, points[i])
    
    # set vertex normals
    mesh.SpecifyNormals()
    normalSpec = mesh.GetSpecifiedNormals()
    normalSpec.ClearNormals()
    normalSpec.SetNumNormals(numVertices)
    for i in xrange(numVertices):
        normalSpec.Normal[i] = normals[i].Normalize()
        normalSpec.SetNormalExplicit(i, true)

    # UVs
    # TODO: multiple map channels?
    # channel 0 is reserved for vertex color, channel 1 is the default texture mapping
    mesh.setNumMaps(2)
    mesh.setMapSupport(1, True) # enable map channel
    map = mesh.Map(1)
    map.setNumVerts(numVertices)
    for i in xrange(numVertices):
        texVert = map.tv[i]
        texVert.x = uvs[i].x
        texVert.y = uvs[i].y
        texVert.z = 0.0

    # set triangles
    mesh.setNumFaces(numTriangles)
    normalSpec.SetNumFaces(numTriangles)
    map.setNumFaces(numTriangles)
    for i in xrange(numTriangless):
        j = i * 3
        # three vertex indices of a triangle
        v0 = triangleVertIndices[j]
        v1 = triangleVertIndices[j+1]
        v2 = triangleVertIndices[j+2]

        # vertex positions
        face = mesh.faces[i]
        face.setMatID(1)
        face.setEdgeVisFlags(1, 1, 1)
        face.setVerts(v0, v1, v2)

        # vertex normals
        normalFace = normalSpec.Face(i)
        normalFace.SpecifyAll()
        normalFace.SetNormalID(0, v0)
        normalFace.SetNormalID(1, v1)
        normalFace.SetNormalID(2, v2)

        # svertex UVs
        texFace = map.tf[i]
        texFace.setTVerts(v0, v1, v2)

    mesh.InvalidateGeomCache()
    mesh.InvalidateTopologyCache()
    return triobj
