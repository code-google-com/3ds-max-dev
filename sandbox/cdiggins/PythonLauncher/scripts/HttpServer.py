import sys
sys.path.append("C:\Program Files\IronPython 2.6 for .NET 4.0\Lib")

import BaseHTTPServer 

from Adsk3dsMax import *

class MyHandler(BaseHTTPServer.BaseHTTPRequestHandler):
    def do_GET(self):
        App.Print("Woohoo a request")
        self.send_response(200)
        self.wfile.write("Here is a response\n")    

def run_while_true(server_class, handler_class):
    server_address = ('localhost', 8000)
    App.Print("Launching the server")
    httpd = server_class(server_address, handler_class)
    cnt = 0
    while cnt < 5:
        cnt = cnt + 1
        App.Print("Waiting for next request")
        httpd.handle_request()

run_while_true(BaseHTTPServer.HTTPServer, MyHandler)
App.Print("I'm out of here")
