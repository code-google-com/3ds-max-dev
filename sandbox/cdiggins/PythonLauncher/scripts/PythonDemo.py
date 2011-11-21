import sys
sys.path.append('C:\svn\3ds-max-dev\sandbox\cdiggins\PythonLauncher\scripts')
import autodesk

app = autodesk.shared.app

def mesh_details(m):
    app.write_line('# indices ' + str(len(m.indices)))
    app.write_line('# vertices ' + str(len(m.vertices)))
    app.write_line('# normals ' + str(len(m.normals)))
    app.write_line('# uvs ' + str(len(m.uvs)))

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
        attr = n._node.GetNodeAttribute()
        if attr: app.write_line('has an attribute')
        else: app.write_line('has no attribute')
    for n2 in n.children:
        output(n2, s + '  ')

for n in app.roots:
    output(n)


