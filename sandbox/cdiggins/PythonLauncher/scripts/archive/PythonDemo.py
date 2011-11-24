import autodesk

def write_line(s):
    autodesk.common.app.write_line(s)

def output_mesh(m, s):
    write_line(s + 'Indices ' + str(m.indices))
    write_line(s + 'Vertices ' + str(m.vertices))
    write_line(s + 'Normals ' + str(m.normals))
    write_line(s + 'UVs ' + str(m.uvs))

def output(n, s=''):
    if not n:
        write_line(s + 'No node')
        return
    write_line(s + n.name)
    write_line(s + 'Transform ' + str(n.transform))
    if n.element:
        m = n.element.mesh
        if m:
            output_mesh(m, s)
        else:
            write_line(s + 'No mesh')
    else:
        write_line(s + 'No element')

    for n2 in n.children:
        output(n2, s + '  ')

def output_scene():
    for n in autodesk.common.app.roots:
        output(n)


