-- Load the assembly
AssemblyType = dotNetClass "System.Reflection.Assembly"
maxroot = pathConfig.GetDir #maxroot
AssemblyType.LoadFile (maxroot + "\\Autodesk.Max.dll")

-- Get a handle to the global interface instance 
GlobalInterfaceType = dotNetClass "Autodesk.Max.GlobalInterface"
global GlobalInterface = GlobalInterfaceType.Instance

