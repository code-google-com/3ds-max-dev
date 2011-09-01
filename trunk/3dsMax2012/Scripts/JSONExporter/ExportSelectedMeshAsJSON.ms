------------------------------------------------------------------------------------------------------------------
-- ExportSelectedMashAsJson
-- Original author: Christopher Diggins
-- License: The New BSD License 1.0 
-- Description: 
--   Demonstrates a simple mesh exporter.
------------------------------------------------------------------------------------------------------------------

tmesh = snapshotAsMesh selection[1]
out_name = (GetDir #export)+"/output.json"
out_file = createfile out_name

num_faces = tmesh.numfaces
num_verts = tmesh.numverts 

fn PrintPoint pt = (
 format "%, %, %, " pt.x pt.y pt.z to:out_file
) 	

fn PrintPointUV pt = (
 format "%, %, " pt.x pt.y to:out_file
) 	

fn PrintPointInt pt = (
	x = int(pt.x) - 1
	y = int(pt.y) - 1
	z = int(pt.z) - 1
	format "%, %, %, " x y z to:out_file
) 	

format "{\n" to:out_file

-- Vertex Positions 
-- format "    \"vertexPositions\" : [" to:out_file
format "    positions : [" to:out_file
for i = 1 to num_verts do
(
 vert = getVert tmesh i
 PrintPoint vert
)
format "],\n" to:out_file

-- Vertex Normals
-- format "    \"vertexNormals\" : [" to:out_file
format "    normals : [" to:out_file
for i = 1 to num_verts do
(
  vert = getNormal tmesh i
  PrintPoint vert
)
format "],\n" to:out_file

-- Vertex Texture Coordinates 
-- format "    \"vertexTextureCoords\" : [" to:out_file
format "    uv : [" to:out_file
for i = 1 to num_faces do
(
	-- Iterate over faces 
	tvface = getTVFace tmesh i
	for j = 1 to 3 do (
		-- Get a specific texture vertex
		tvert = getTVert tmesh tvface[j]		
  	    PrintPointUV tvert
	)
)
format "],\n" to:out_file

-- Face Indexes
-- format "    \"indices\" : [" to:out_file
format "    indices : [" to:out_file
for f = 1 to num_faces do
(
   face = getFace tmesh f
   PrintPointInt face
)
format "],\n" to:out_file

format "}" to:out_file

close out_file
delete tmesh
edit out_name
print "Finished writing to " + out_name
