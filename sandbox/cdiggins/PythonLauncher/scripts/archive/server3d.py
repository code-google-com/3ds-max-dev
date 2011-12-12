import autodesk 
import sys
import BaseHTTPServer
import SocketServer
import socket

class Handler(BaseHTTPServer.BaseHTTPRequestHandler):          
    ''' Responds to HTTP requests. '''
    
    # Class variable used to indicate a shut-down request from client. 
    # Unfortunately self.shut_down() does not work as expected in IronPython
    shutting_down = False
    
    def send_headers(self):
        ''' Send all headers and status code. ''' 

        # Check if shutting down 
        if Handler.shutting_down:
            # Send the client a 503 response indicating that service is 
            # unavailable.
            self.send_response(503, "Service unavailable")
            return False
        else:
            # Everything else is treated successfully 
            self.send_response(200, "OK")
            self.send_header("Content-type", "text/plain")                 
            self.send_header("Accept", "text/plain")    
            self.send_header("Access-Control-Allow-Origin", "*")
            self.end_headers()
            return True
    
    def do_HEAD(self):                
        ''' Respond to a "HEAD" request. '''
        self.send_headers()

    def do_GET(self):
        ''' Respond to a "GET" request.  '''
        try:
            autodesk.write_line('GET request: ' + self.path)

            # Send headers, but abort if not successful.
            if not self.send_headers():
                return                        

            # Shut down the web server 
            if '/exit' == self.path:
                Handler.shutting_down = True
                self.wfile.write('shutting down web server')            
            
            # Return a JSON representation of the scene (without meshes) in the response.
            elif '/scene' == self.path:
                self.wfile.write(autodesk.scene_json())

            # Return the product name in the response. 
            elif '/test' == self.path:
                self.wfile.write("This is a test. You are running " + autodesk.app.product)

            # Return a tree representation of the scene in the response.
            elif '/tree' == self.path:
                autodesk.output_scene_tree(self.wfile)

            # Return a JSON representation of the mesh of the first selected object. 
            elif '/mesh' == self.path:
                self.wfile.write(autodesk.selected_mesh_json())

            # Echo the query request. 
            else:
                self.wfile.write(self.path)          
        except:
            self.wfile.write('Error occured')
            Handler.shutting_down = True            
                        
def serve(port=8000):
    ''' Launches the server on the specified port. '''
    autodesk.write_line('Opening connection at on port ' + str(port))        
    httpd = SocketServer.TCPServer(("", port), Handler)    
    httpd.timeout = 0.5
    try:
        while not Handler.shutting_down:
            httpd.handle_request()
            autodesk.app.process_tasks()
    finally:
        autodesk.write_line('Shutting down server')
        httpd.server_close()

if __name__ == '__main__':
    serve()
