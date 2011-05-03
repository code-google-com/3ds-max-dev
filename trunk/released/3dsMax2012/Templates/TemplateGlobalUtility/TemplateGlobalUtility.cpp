//
// Copyright 2009 Autodesk, Inc.  All rights reserved.
//
// Use of this software is subject to the terms of the Autodesk license
// agreement provided at the time of installation or download, or which
// otherwise accompanies this software in either electronic or hard copy form.  
//

#include "TemplateGlobalUtility.h"

// Static Dll handle
static HINSTANCE hDllInstance = 0; 

//==========================================================================
// Class descriptor implementation

int TemplateGlobalUtilityClassDesc::IsPublic() 
{ 
    return 1; 
} 
void* TemplateGlobalUtilityClassDesc::Create(BOOL loading) 
{ 
    return new TemplateGlobalUtility(); 
} 
const MCHAR* TemplateGlobalUtilityClassDesc::ClassName() 
{ 
    TODO("Replace with your own localized plug-in name");
    return _M("Template Global Utility"); 
} 
SClass_ID TemplateGlobalUtilityClassDesc::SuperClassID() 
{ 
    return GUP_CLASS_ID;
} 
Class_ID TemplateGlobalUtilityClassDesc::ClassID() 
{ 
    TODO("Replace the Class_ID with a new unique one")
    static const Class_ID cid = Class_ID(0x196ADBDC, 0x0B480F44);
    return cid; 
} 
const MCHAR* TemplateGlobalUtilityClassDesc::Category() 
{ 
    TODO("Replace with an appropriate category")
    return SDK_TUTORIALS_CATEGORY; 
}  
const MCHAR* TemplateGlobalUtilityClassDesc::GetInternalName() 
{ 
    TODO("Replace with your own internal (non-localized) plug-in name");
    return _M("TemplateGlobalUtility"); 
} 
HINSTANCE TemplateGlobalUtilityClassDesc::HInstance() 
{ 
    return hDllInstance; 
} 
ClassDesc2* TemplateGlobalUtilityClassDesc::GetClassDescInstance() 
{
    static TemplateGlobalUtilityClassDesc desc;
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
	return "Global Utility template plug-in project."; 
} 
__declspec( dllexport ) int LibNumberClasses() 
{ 
	return 1;  
} 
__declspec( dllexport ) ClassDesc2* LibClassDesc(int i) 
{ 
    static TemplateGlobalUtilityClassDesc classdesc; 
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
