import autodesk

def output_node(n, s=''):
    autodesk.write_line(s + n.name)
    for n2 in n.children:
        output_node(n2, s + '  ')

def output_scene():
    for n in autodesk.app.roots:
        output_node(n)

if __name__ == '__main__':
    output_scene()

