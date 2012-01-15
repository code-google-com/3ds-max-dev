------------------------------------------------------------------------------------------------------------------
-- Copyright: Autodesk
-- License: The New BSD License 1.0 
-- Description: 
--   Functions for exporting a mesh to JSON (JavaScript Object Notation).
------------------------------------------------------------------------------------------------------------------

fn export_mesh_as_json m out_name = (		
	out_file = createfile out_name
	num_faces = m.numfaces
	num_verts = m.numverts 

	fn PrintPoint pt = (
		format "%, %, %" pt.x pt.y pt.z to:out_file
	) 	

	fn PrintPointUV pt = (
		format "%, %" pt.x pt.y to:out_file
	) 	

	fn PrintPointInt pt = (
		x = int(pt.x) - 1
		y = int(pt.y) - 1
		z = int(pt.z) - 1
		format "%, %, %" x y z to:out_file
	) 	

	format "{\n" to:out_file

	-- Vertex Positions 
	format "    \"positions\" : [" to:out_file
	for i = 1 to num_verts do
	(
		if (i > 1) then format ", " to:out_file
		vert = getVert m i
		PrintPoint vert
	)
	format "],\n" to:out_file

	-- Vertex Normals
	format "    \"normals\" : [" to:out_file
	for i = 1 to num_verts do
	(
		if (i > 1) then format ", " to:out_file
		vert = getNormal m i
		PrintPoint vert
	)
	format "],\n" to:out_file

	-- Vertex Texture Coordinates 
	format "    \"uv\" : [" to:out_file
	for i = 1 to num_faces do
	(
		-- Iterate over faces 
		if (i > 1) then format ", " to:out_file
		tvface = getTVFace m i
		for j = 1 to 3 do (
			if (j > 1) then format ", " to:out_file
			-- Get a specific texture vertex
			tvert = getTVert m tvface[j]		
			PrintPointUV tvert
		)
	)
	format "],\n" to:out_file

	-- Face Indexes
	format "    \"indices\" : [" to:out_file
	for i = 1 to num_faces do
	(
		if (i > 1) then format ", " to:out_file
		face = getFace m i
		PrintPointInt face
	)
	format "]\n" to:out_file
	
	format "}" to:out_file

	close out_file
	delete m
	edit out_name
	print "Finished writing to " + out_name	
)

fn export_selected_mesh_as_json out_name = (
	export_mesh_as_json (snapshotAsMesh selection[1]) out_name
)

fn export_selected_mesh_as_json_default = (
	export_selected_mesh (GetDir #export) + "/output.json" 
)