import sys
sys.path.append('C:\\svn\\3ds-max-dev\\sandbox\\cdiggins\\PythonLauncher\\scripts')
import autodesk
import pyfbsdk as mb 

cube = mb.FBModelCube('cube')
cube.Show = True
cube.Scaling = mb.FBVector3d( 25, 25, 25 )

app = autodesk.common.app

def mesh_details(m, s):
    app.write_line(s + 'Indices ' + str(m.indices))
    app.write_line(s + 'Vertices ' + str(m.vertices))
    app.write_line(s + 'Normals ' + str(m.normals))
    app.write_line(s + 'Uvs ' + str(m.uvs))

def output(n, s=''):
    app.write_line(s + n.name)
    app.write_line(s + 'transform ' + str(n.transform))
    if n.element:
        m = n.element.mesh
        if m:
            mesh_details(m, s)
        else:
            app.write_line(s + 'has no mesh')
    else:
        app.write_line(s + 'has no element')      
    for n2 in n.children:
        output(n2, s + '  ')

app.write_line('Scene Graph')
for n in app.roots:
    output(n)
