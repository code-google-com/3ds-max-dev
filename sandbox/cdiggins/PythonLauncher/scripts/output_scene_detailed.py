import autodesk

def write_line(s):
    autodesk.common.app.write_line(s)

def output_mesh(s, m):
    write_line(s + 'Number of indices ' + str(len(m.indices)))
    write_line(s + 'Number of vertices ' + str(len(m.vertices)))
    write_line(s + 'Number of normals ' + str(len(m.normals)))
    write_line(s + 'Number of UVs ' + str(len(m.uvs)))

def output_node(n, s=''):
    if not n:
        write_line(s + 'No node')
        return
    write_line(s + n.name)
    write_line(s + 'Transform ' + str(n.transform))
    if n.element:
        if n.element.mesh:
            output_mesh(s, n.element.mesh)
        else:
            write_line(s + 'No mesh')
    else:
        write_line(s + 'No element')

    for n2 in n.children:
        output_node(n2, s + '  ')

def output_scene():
    ''' Outputs the scene graph ''' 
    for n in autodesk.common.app.roots:
        output_node(n)

if __name__ == '__main__':
    output_scene()

