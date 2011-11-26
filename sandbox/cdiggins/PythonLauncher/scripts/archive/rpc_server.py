import SimpleXMLRPCServer
import logging
import os

import autodesk

def list_contents(dir_name):
    logging.debug('list_contents(%s)', dir_name)
    return os.listdir(dir_name)

def shutdown():
    server.shutdown()

def say_hello(s):
    autodesk.write_line("Hello")

# Set up logging
logging.basicConfig(level=logging.DEBUG)

# Initialize server 
server = SimpleXMLRPCServer.SimpleXMLRPCServer(('localhost', 9000), logRequests=True)

# Run functions
server.register_function(list_contents)
server.register_function(shutdown)
server.register_function(say_hello)

def serve():
    server.serve_forever()
