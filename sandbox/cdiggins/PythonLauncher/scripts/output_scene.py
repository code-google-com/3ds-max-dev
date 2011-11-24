import autodesk

def write_line(s):
    autodesk.common.app.write_line(s)

def mesh_details(m):
    write_line(s + 'Number of indices ' + str(len(m.indices)))
    write_line(s + 'Number of vertices ' + str(len(m.vertices)))
    write_line(s + 'Number of normals ' + str(len(m.normals)))
    write_line(s + 'Number of uvs ' + str(len(m.uvs)))

def output(n, s=''):
    if not n:
        write_line(s + 'No node')
        return
    write_line(s + n.name)
    write_line(s + 'Transform ' + str(n.transform))
    if n.element:
        m = n.element.mesh
        if m:
            mesh_details(m)
        else:
            write_line(s + 'No mesh')
    else:
        write_line(s + 'No element')

    for n2 in n.children:
        output(n2, s + '  ')

def output_scene():
    for n in autodesk.common.app.roots:
        output(n)


