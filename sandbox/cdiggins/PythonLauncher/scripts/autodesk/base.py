'''
    This module contains the  classes of the object model. 
    It is useful to know what what attributes (properties, fields, and methods)
    a particular object will provide. 
    
    It also defines a number of utility functions that are defined in terms 
    of existing functions. 
'''

class Application(object):
    ''' Represents an application. Only one instance should be created. '''     

    # The following functions should be overridden. 
    
    def write_line(self, text):
        ''' Outputs a line of text to the console ''' 
        print(text)

    def load_file(self, fname):
        ''' Opens the specified file. '''   
        raise NotImplementedError()
    
    def save_file(self, fname):
        ''' Opens the specified file. '''   
        raise NotImplementedError()
    
    def shutdown(self):
        ''' Shuts down the host application. '''
        pass        
    
    @property
    def roots(self):
        ''' Returns the root (unparented) nodes in the scene. ''' 
        raise NotImplementedError()
        
    def create_node(self, name='', parent=None):
        ''' Creates a new node in the scene graph '''
        return None        

    @property
    def product(self):
        ''' Returns a string identifying the product API. '''
        return "unknown"

    def add_geometry(self, vertices, indices, name):
        ''' Creates a new node associated with the given geometry. '''
        raise NotImplementedError()

    # The following properties and functions are defined in terms of the overridden
    # functions and properties. 

    @property
    def tree(self):
        ''' All nodes in the scene in depth first order. '''
        for root in self.roots:
            for node in root.tree:
                yield node

    @property 
    def first_root(self):
        ''' Returns the first root node.'''
        for r in self.roots:
            return r
        return None

    @property 
    def selected(self):
        ''' Returns all selected nodes. '''
        return (x for x in self.scene_tree if x.selected)

    @property 
    def first_selected(self):
        ''' Returns the first selected node. '''
        for r in self.scene_tree:
            if r.selected:
                return r
        return None

class Node(object):    
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
        return ((1,0,0,0),(0,1,0,0),(0,0,1,0),(0,0,0,1))
                
    @property
    def element(self):
        ''' The associated scene element. Could be None. ''' 
        return None
                    
    @property
    def tree(self):
        ''' Returns the entire node hierarchy. '''
        for child in self.children: 
            for desc in child.tree:
                yield desc
        yield self

    def add_child(self, node):
        ''' Adds a child node '''
        raise NotImplementedError()

    def remove_child(self, node):
        ''' Removes (detaches) a child node ''' 
        raise NotImplementedError()

class GeometricObject(object):
    ''' An element of the scene with a geometric representation. '''
    
    @property 
    def mesh(self):
        ''' Returns the associated triangle mesh '''
        return None

class Camera(object):
    ''' A camera. '''
    @property 
    def is_ortho(self):
        ''' Returns True or False if the camera is orthographic '''
        raise NotImplementedError()

    @property
    def near_clip(self):
        ''' Returns the near clip plane distance. '''
        raise NotImplementedError()

    @property
    def far_clip(self):
        ''' Returns the far clip plane distance. '''
        raise NotImplementedError()

    @property
    def aspect_ratio(self):
        ''' Returns the aspect ratio. '''
        raise NotImplementedError()

    @property
    def field_of_view(self):
        ''' Returns the field of view. '''
        raise NotImplementedError()

class Light(object):
    ''' A light. '''
    pass

class Mesh(object):                
    ''' A triangle mesh. '''
    pass    