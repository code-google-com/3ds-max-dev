import autodesk

app = autodesk.common.app
app.write_line(autodesk.scene_json())
if autodesk.selected():
	app.write_line(autodesk.selected_mesh_json())

