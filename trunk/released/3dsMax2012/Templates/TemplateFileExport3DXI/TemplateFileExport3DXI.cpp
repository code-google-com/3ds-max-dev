//
// Copyright 2009 Autodesk, Inc.  All rights reserved.
//
// Use of this software is subject to the terms of the Autodesk license
// agreement provided at the time of installation or download, or which
// otherwise accompanies this software in either electronic or hard copy form.  
//

#include "TemplateFileExport3DXI.h"

// Static Dll handle
static HINSTANCE hDllInstance = 0; 

//==========================================================================
// Class descriptor implementation

int TemplateFileExport3DXIClassDesc::IsPublic() 
{ 
    return 1; 
} 
void* TemplateFileExport3DXIClassDesc::Create(BOOL loading) 
{ 
    return new TemplateFileExport3DXI(); 
} 
const MCHAR* TemplateFileExport3DXIClassDesc::ClassName() 
{ 
    TODO("Replace with your own localized plug-in name");
    return _M("Template File Export 3DXI"); 
} 
SClass_ID TemplateFileExport3DXIClassDesc::SuperClassID() 
{ 
    return SCENE_EXPORT_CLASS_ID;
} 
Class_ID TemplateFileExport3DXIClassDesc::ClassID() 
{ 
    TODO("Replace the Class_ID with a new unique one")
    static const Class_ID cid = Class_ID(0x59D4DDD1, 0x1A6BA043);
    return cid; 
} 
const MCHAR* TemplateFileExport3DXIClassDesc::Category() 
{ 
    TODO("Replace with an appropriate category")
    return SDK_TUTORIALS_CATEGORY; 
}  
const MCHAR* TemplateFileExport3DXIClassDesc::GetInternalName() 
{ 
    TODO("Replace with your own internal (non-localized) plug-in name");
    return _M("TemplateFileExport3DXI"); 
} 
HINSTANCE TemplateFileExport3DXIClassDesc::HInstance() 
{ 
    return hDllInstance; 
} 
ClassDesc2* TemplateFileExport3DXIClassDesc::GetClassDescInstance() 
{
    static TemplateFileExport3DXIClassDesc desc;
    return &desc;
}

//==========================================================================
// Exported DLL functions

BOOL WINAPI DllMain(HINSTANCE hinstDLL, ULONG fdwReason, LPVOID lpvReserved) { 
    // NOTE: Do not call managed code from here.
    // You should do any initialization in LibInitialize
	hDllInstance = hinstDLL; 
	switch(fdwReason) { 
		case DLL_PROCESS_ATTACH: break; 
		case DLL_THREAD_ATTACH: break; 
		case DLL_THREAD_DETACH: break; 
		case DLL_PROCESS_DETACH: break; 
	} 
	return(TRUE); 
} 
__declspec( dllexport ) const TCHAR * LibDescription() 
{ 
	return "File Export 3DXI template plug-in project."; 
} 
__declspec( dllexport ) int LibNumberClasses() 
{ 
	return 1;  
} 
__declspec( dllexport ) ClassDesc2* LibClassDesc(int i) 
{ 
    static TemplateFileExport3DXIClassDesc classdesc; 
    return &classdesc; 
} 
__declspec( dllexport ) ULONG LibVersion() 
{ 
	return VERSION_3DSMAX; 
} 
__declspec( dllexport ) ULONG CanAutoDefer() 
{ 
	return 1; 
} 
__declspec( dllexport ) ULONG LibInitialize() 
{ 
    // Note: called after the DLL is loaded (i.e. DllMain is called with DLL_PROCESS_ATTACH)
    TODO("Add any library initialization here");
    return 1;
}
__declspec( dllexport ) ULONG LibShutdown() 
{ 
    // Note: called before the DLL is unloaded (i.e. DllMain is called with DLL_PROCESS_DETACH)
    TODO("Add any library finalization here");
    return 1;
}

TODO("Define a parameter block descriptor if you want");
