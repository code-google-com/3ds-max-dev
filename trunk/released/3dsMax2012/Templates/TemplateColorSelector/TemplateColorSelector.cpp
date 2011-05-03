//
// Copyright 2009 Autodesk, Inc.  All rights reserved.
//
// Use of this software is subject to the terms of the Autodesk license
// agreement provided at the time of installation or download, or which
// otherwise accompanies this software in either electronic or hard copy form.  
//

#include "TemplateColorSelector.h"

// Static Dll handle
static HINSTANCE hDllInstance = 0; 

//==========================================================================
// Class descriptor implementation

int TemplateColorSelectorClassDesc::IsPublic() 
{ 
    return 1; 
} 
void* TemplateColorSelectorClassDesc::Create(BOOL loading) 
{ 
    return new TemplateColorSelector(); 
} 
const MCHAR* TemplateColorSelectorClassDesc::ClassName() 
{ 
    TODO("Replace with your own localized plug-in name");
    return _M("Template Color Selector"); 
} 
SClass_ID TemplateColorSelectorClassDesc::SuperClassID() 
{ 
    return COLPICK_CLASS_ID;
} 
Class_ID TemplateColorSelectorClassDesc::ClassID() 
{ 
    TODO("Replace the Class_ID with a new unique one")
    static const Class_ID cid = Class_ID(0x2F617EB0, 0x5C6F8640);
    return cid; 
} 
const MCHAR* TemplateColorSelectorClassDesc::Category() 
{ 
    TODO("Replace with an appropriate category")
    return SDK_TUTORIALS_CATEGORY; 
}  
const MCHAR* TemplateColorSelectorClassDesc::GetInternalName() 
{ 
    TODO("Replace with your own internal (non-localized) plug-in name");
    return _M("TemplateColorSelector"); 
} 
HINSTANCE TemplateColorSelectorClassDesc::HInstance() 
{ 
    return hDllInstance; 
} 
ClassDesc2* TemplateColorSelectorClassDesc::GetClassDescInstance() 
{
    static TemplateColorSelectorClassDesc desc;
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
	return "Color Selector template plug-in project."; 
} 
__declspec( dllexport ) int LibNumberClasses() 
{ 
	return 1;  
} 
__declspec( dllexport ) ClassDesc2* LibClassDesc(int i) 
{ 
    static TemplateColorSelectorClassDesc classdesc; 
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
