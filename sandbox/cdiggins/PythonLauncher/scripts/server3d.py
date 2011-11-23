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
            self.wfile.write('Error occured')
            traceback.print_tb(sys.last_traceback, None, sys.stdout)
            Handler.shutting_down = True            
                        
def serve(port=8000):
    httpd = SocketServer.TCPServer(("", port), Handler)
    while not Handler.shutting_down:
        httpd.handle_request()


