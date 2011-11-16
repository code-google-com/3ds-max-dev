import sys
import autodesk 
import BaseHTTPServer
import SocketServer
import traceback
import StringIO

class Handler(BaseHTTPServer.BaseHTTPRequestHandler):          
    shutting_down = False
    
    def do_GET(self):
        try:
            if Handler.shutting_down:
                self.send_response(503)
                return                        
            self.send_response(200)
            self.send_header("Content-type", "text/plain")                 
            self.send_header("Accept", "text/plain")    
            self.end_headers()
            if '/exit' == self.path:
                Handler.shutting_down = True
                self.wfile.write('shutting down web server')
            elif '/scene' == self.path:
                self.wfile.write(autodesk.scene_json())
            elif '/test' == self.path:
                self.wfile.write("This is a test")
            elif '/tree' == self.path:
                autodesk.output_scene_tree(self.wfile)
            elif '/mesh' == self.path:
                self.wfile.write(autodesk.selected_mesh_json())
            else:
                self.wfile.write(self.path)          
        except:
            Handler.shutting_down = True            
                        
def ServeContent():
    httpd = SocketServer.TCPServer(("", 8000), Handler)
    while not Handler.shutting_down:
        httpd.handle_request()

ServeContent()

'''
autodesk.write_line("Testing")

autodesk.write_line("Root node: " + autodesk.root().name)

f = StringIO.StringIO()
autodesk.output_scene_tree(f)
autodesk.write_line(f.getvalue())

s = autodesk.scene_json_data()
autodesk.write_line(s)

for n in autodesk.root().tree:
    if n.selected:
        autodesk.write_line("Selected node: " + n.name)
'''

#s = autodesk.scene_json()
#autodesk.write_line(s)
    
    


            

