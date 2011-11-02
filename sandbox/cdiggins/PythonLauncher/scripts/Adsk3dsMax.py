import clr

# This requires the 3ds Max 2012 Subscription Advantage Pack to be installed. 
clr.AddReference("Autodesk.Max")

from Autodesk.Max import *

# Provides access to services offered by 3ds Max 
class Application(object):
    def __init__(self):
        self.g = GlobalInterface.Instance
        self.i = self.g.COREInterface13    

    def Print(self, text):
        self.g.ExecuteMAXScriptScript("format \"" + text + "\n\" print", False, None)

    @property
    def SceneRoots(self):
        yield Node(self.i.RootNode)

# A node in the scene graph.  
class Node(object):
    def __init__(self, _inode):
        self.node = _inode

    @property
    def Children(self):
        for i in range(0, self.node.NumberOfChildren):
            yield Node(self.node.GetChildNode(i))

    @property
    def Name(self):
        return self.node.Name
    
    @Name.setter  
    def set_Name(self, value):
        self.node.Name = value
    
    @property
    def Parent(self):
        return Node(self.node.Parent)
    
    @property
    def Selected(self):
        return self.node.Selected
    
    @Selected.setter    
    def set_Selected(self, value):
        self.node.Selected = value
        
    @property
    def Tranform(sefl):
        return 

# Singleton instance of the Application object 
App = Application()

def DemoPrintNodes():
    def PrintNode(n, indent):
        App.Print(indent + n.Name)
        for n2 in n.Children:
            PrintNode(n2, "  " + indent)

    for n in App.SceneRoots:
        PrintNode(n, "")

# DemoPrintNodes()