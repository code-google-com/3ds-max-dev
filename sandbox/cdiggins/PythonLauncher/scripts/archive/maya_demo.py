import sys
sys.path.append('C:\\svn\\3ds-max-dev\\sandbox\\cdiggins\\PythonLauncher\\scripts')
import autodesk

app = autodesk.common.app

def mesh_details(m):
    app.write_line('Indices ' + str(len(tuple(m.indices))))
    app.write_line('Vertices ' + str(len(tuple(m.vertices))))
    app.write_line('Normals ' + str(len(tuple(m.normals))))
    app.write_line('Uvs ' + str(len(tuple(m.uvs))))

def output(n, s=''):
    if not n: 
        app.write_line('No node')
        return
    app.write_line(s + n.name)
    app.write_line('transform ' + str(n.transform))
    if n.element:
        m = n.element.mesh
        if m:
            mesh_details(m)
        else:
            app.write_line('has no mesh')
    else:
        app.write_line('has no element')      
    for n2 in n.children:
        output(n2, s + '  ')

app.write_line('Scene Graph')
for n in app.roots:
    output(n)
