import autodesk 
import sys
import BaseHTTPServer
import SocketServer
import socket
import shutil
import traceback
import StringIO
import urlparse
import json

##########################################################################
# Functions

def log(s):
    ''' Outputs a string to the application's console '''
    autodesk.write_line(s)

def exception_string():
    etype, evalue = sys.exc_info()[:2] 
    return str(etype) + " : " + str(evalue)

def output_node_tree(f, n, s=""):
    ''' Outputs all child-node as a tree. '''
    f.write(s + n.name + "\n")
    for n2 in n.children:
       output_node_tree(f, n2, s + "  ")

def node_by_name(name):
    ''' Gets the first node with the given name. '''
    for n in autodesk.app.tree:
        if n.name == name:
            return n
    return None
    
def node_as_dict(node):
    ''' Returns a dictionary representation of a node. '''
    return { 
        'name' : node.name, 
        'selected' : node.selected, 
        'transform' : node.transform, 
        'children' : [node_as_dict(n) for n in node.children],
        } 

def first_node_with_mesh():
    ''' Returns the first node in the scen graph that has an associated mesh ''' 
    for n in autodesk.app.tree:
        if n.element:
            if n.element.mesh:
                return n
    return None

def flatten(list):
    '''' Converts a list of lists to a single list '''
    return [x for sublist in list 
            for x in sublist]

def mesh_to_glge(mesh):
    ''' Converts a mesh to a format that is easily consumed by GLGE and other WebGL frameworks '''    
    vertices = flatten(mesh.vertices[i] for i in mesh.indices)
    normals = flatten(mesh.normals)
    indices = range(len(mesh.indices))
    uvs = flatten(mesh.uvs)
    return { 'vertices' : vertices, 'normals' : normals, 'indices' : indices, 'uvs' : uvs }   

def node_mesh_to_glge_json(node):
    ''' Returns a JSON representation of the given node's mesh '''
    try:
        if not node: return "Null node"
        if not node.element: return "Null element"
        if not node.element.mesh: return "Null mesh"
        return json.dumps(mesh_to_glge(node.element.mesh))
    except:
        return 'Exception retrieving mesh: ' + exception_string()

def scene_json():
    ''' Converts the entire scene into a JSON representation. ''' 
    return json.dumps([node_as_dict(n) for n in autodesk.app.roots])

def serve(port=8000):
    ''' Launches a 3d web server on the specified port. '''
    log('Opening connection at on port ' + str(port))        
    Handler.shutting_down = False
    httpd = SocketServer.TCPServer(("", port), Handler)    
    httpd.timeout = 0.5 # seconds between canceling and rechecking for requests, 
    try:
        while not Handler.shutting_down:
            httpd.handle_request()
            autodesk.app.process_tasks()
    finally:
        log('Shutting down server')
        httpd.server_close()

##########################################################################
# Classes

class Handler(BaseHTTPServer.BaseHTTPRequestHandler):          
    ''' Responds to HTTP requests. '''
    
    # Class variable used to indicate a shut-down request from client. 
    # Unfortunately self.shut_down() does not work as expected in IronPython
    shutting_down = False
    
    def create_content(self):
        ''' Returns the content and the mime-type '''
        content = StringIO.StringIO()
        mimetype = 'text/plain'
        parse = urlparse.urlparse(self.path)
        path = parse.path
        qs = parse.query
        params = {}
        if qs:
            params = urlparse.parse_qs(qs)         

        # Shut down the web server 
        if '/exit' == self.path:
            Handler.shutting_down = True
            content.write('shutting down web server')            
        
        # Return a JSON representation of the scene (without meshes) in the response.
        elif '/scene' == path:
            content.write(scene_json())

        # Return the product name in the response. 
        elif '/test' == path:
            content.write("This is a test. You are running " + autodesk.app.product)

        # Return a tree representation of the scene in the response.
        elif '/tree' == path:
            for n in autodesk.app.roots:
                output_node_tree(content, n)
            
        # Return a JSON representation of the mesh of the first selected object or the named object. 
        elif '/mesh' == path:
            try:
                # Check is a node name has been specified
                if 'name' in params:
                    name = params['name'][0]
                    node = node_by_name(name)
                else:
                    node = autodesk.app.first_selected
                    if not node:
                        node = first_node_with_mesh()
                jsondata = node_mesh_to_glge_json(node)
            except:
                jsondata = 'Exception: ' + exception_string()
            content.write(jsondata)

        # Return an HTML file 
        elif '/demo' == path:
            source = open('C:\demos\webGL\demo.html', 'rb')
            mimetype = 'text/html'
            shutil.copyfileobj(source, content)
            source.close()
                                    
        # Echo the request
        else:
            content.write("url = " + self.path + "\n")
            content.write("path = " + path + "\n")
            content.write("query = " + qs + "\n")
            content.write("params = " + str(params) + "\n")

        content.seek(0)
        return content, mimetype
    
    def create_response(self):
        ''' Creates the HTTP response '''
        if Handler.shutting_down:
            self.send_response(503, "Service unavailable")
        else:            
            content, mimetype = self.create_content()        
            self.send_response(200, "OK")
            self.send_header("Access-Control-Allow-Origin", "*")
            self.send_header("Content-type", mimetype)        
            self.end_headers()    
            return content
                    
    def handle_exception(self):
        ''' Used for reporting exceptions, and shutting down the server. '''        
        self.wfile.write("Exception occured: " + exception_string())
        Handler.shutting_down = True

    def do_HEAD(self):                
        ''' Respond to an HTTP HEAD request '''
        try:
            log('Responding to HEAD request: ' + self.path)
            response = self.create_response()
            response.close()
        except:
            self.handle_exception()
        
    def do_GET(self):
        ''' Respond to an HTTP GET request '''
        try:
            log('Responding to GET request: ' + self.path)
            response = self.create_response()
            shutil.copyfileobj(response, self.wfile)
            response.close()
        except:
            self.handle_exception()
            
##########################################################################
# Main

if __name__ == '__main__':
    serve()
