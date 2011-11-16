'''
    This module contains the base classes of the object model. 
    It is useful to know what what attributes (properties, fields, and methods)
    a particular object will provide. 
    
    It also defines a number of utility functions that are defined in terms 
    of existing functions. 
'''

class BaseApplication(object):
    ''' Represents an application. Only one instance should be created. '''     
    def write_line(self, text):
        ''' Outputs a line of text to the console ''' 
        print(text)

    def load_file(self, fname):
        ''' Opens the specified file. '''   
        return False
    
    def shutdown(self):
        ''' Shuts down the host application. '''
        pass        
    
    @property
    def roots(self):
        ''' Returns the list root nodes in the scene. ''' 
        return ()
        
    @property
    def tree(self):
        ''' All nodes in the scene in depth first order. '''
        for root in self.roots:
            for node in root.tree:
                yield node      
    
class BaseNode(object):    
    ''' A node in the scene graph. '''
    
    @property
    def children(self):
        ''' A generator that produces all child nodes. '''
        return ()
    
    @property
    def parent(self):
        ''' The parent node. Only scene roots have no parent '''
        return None
    
    @property
    def tranform(self):
        ''' The local transform matrix. '''
        return ((0,0,0,0),(0,0,0,0),(0,0,0,0),(0,0,0,0))
                
    @property
    def element(self):
        ''' The associated scene element. Could be None. ''' 
        return None
                    
    @property
    def tree(self):
        for child in self.children: 
            for desc in child.tree:
                yield desc
        yield self  

class BaseGeometricObject(object):
    ''' An element of the scene with a geometric representation. '''
    
    @property 
    def mesh(self):
        ''' A triangle mesh. '''
        return None

class BaseMesh(object):                
    ''' A triangle mesh. '''
    pass    
