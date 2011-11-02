import sys
sys.path.append("C:\Program Files\IronPython 2.6 for .NET 4.0\Lib")

from SimpleXMLRPCServer import SimpleXMLRPCServer
import logging
import os

from Adsk3dsMax import *

# Set up logging
logging.basicConfig(level=logging.DEBUG)

server = SimpleXMLRPCServer(('localhost', 9000), logRequests=True)

def list_contents(dir_name):
    logging.debug('list_contents(%s)', dir_name)
    return os.listdir(dir_name)

def shutdown():
    server.shutdown()
    
def say_hello(s):


server.register_function(list_contents)
server.register_function(shutdown)
server.register_function(say_hello)

server.serve_forever()
