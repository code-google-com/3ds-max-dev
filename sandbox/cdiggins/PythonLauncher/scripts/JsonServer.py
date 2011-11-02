import sys
sys.path.append("C:\Program Files\IronPython 2.6 for .NET 4.0\Lib")

import BaseHTTPServer 

from Adsk3dsMax import *

class MyHandler(BaseHTTPServer.BaseHTTPRequestHandler):
    def do_GET(self):
        App.Print("Woohoo a request")
        self.send_response(200)
        self.send_header("Content-type", "application/json")         
        self.send_header("Accept", "text/plain")         
        self.end_headers()         
        self.wfile.write('{ "author" : "CHristopher Diggins", "title" : "Something about Everything", "price" : 149.99 }\n')    
        return

def run_while_true(server_class, handler_class):
    server_address = ('localhost', 8000)
    App.Print("Launching the server")
    httpd = server_class(server_address, handler_class)
    cnt = 0
    while cnt < 3:
        cnt = cnt + 1
        App.Print("Waiting for next request")
        httpd.handle_request()

run_while_true(BaseHTTPServer.HTTPServer, MyHandler)
App.Print("I'm out of here")
