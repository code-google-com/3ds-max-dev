import sys
import autodesk

app = autodesk.shared.app

def mesh_details(m):
    app.write_line('# polys ' + str(len(m.faces)))
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

def load(f):    
    if not app.load_file(f):
        app.write_line('Failed to load file: ' + f)
    else:
        for n in app.roots:
            output(n)

load('c:\\assets\\bird.fbx')

