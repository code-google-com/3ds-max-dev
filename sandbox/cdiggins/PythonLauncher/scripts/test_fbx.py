# Tell the autodesk package that we are using it from FBX.
# This only has to be done once per Python session. 
import init_autodesk_fbx

# Load the common API 
import autodesk

# Open an FBX file 
fname = "C:\\demos\\ADN-AU-2011\\scenes\\teapot.FBX"
if not autodesk.app.load_file(fname):
    print "Failed to open file"

# Output information about the scene 
import output_scene
output_scene.output_scene()

