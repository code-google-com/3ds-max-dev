//
// Copyright 2009 Autodesk, Inc.  All rights reserved.
//
// Use of this software is subject to the terms of the Autodesk license
// agreement provided at the time of installation or download, or which
// otherwise accompanies this software in either electronic or hard copy form.  
//

#include "TemplateImageLoaderSaver.h"

// Static Dll handle
static HINSTANCE hDllInstance = 0; 

//==========================================================================
// Class descriptor implementation

int TemplateImageLoaderSaverClassDesc::IsPublic() 
{ 
    return 1; 
} 
void* TemplateImageLoaderSaverClassDesc::Create(BOOL loading) 
{ 
    return new TemplateImageLoaderSaver(); 
} 
const MCHAR* TemplateImageLoaderSaverClassDesc::ClassName() 
{ 
    TODO("Replace with your own localized plug-in name");
    return _M("Template Image Loader / Saver"); 
} 
SClass_ID TemplateImageLoaderSaverClassDesc::SuperClassID() 
{ 
    return BMM_IO_CLASS_ID;
} 
Class_ID TemplateImageLoaderSaverClassDesc::ClassID() 
{ 
    TODO("Replace the Class_ID with a new unique one")
    static const Class_ID cid = Class_ID(0x6FE9E909, 0x4C308526);
    return cid; 
} 
const MCHAR* TemplateImageLoaderSaverClassDesc::Category() 
{ 
    TODO("Replace with an appropriate category")
    return SDK_TUTORIALS_CATEGORY; 
}  
const MCHAR* TemplateImageLoaderSaverClassDesc::GetInternalName() 
{ 
    TODO("Replace with your own internal (non-localized) plug-in name");
    return _M("TemplateImageLoaderSaver"); 
} 
HINSTANCE TemplateImageLoaderSaverClassDesc::HInstance() 
{ 
    return hDllInstance; 
} 
ClassDesc2* TemplateImageLoaderSaverClassDesc::GetClassDescInstance() 
{
    static TemplateImageLoaderSaverClassDesc desc;
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
	return "Image Loader / Saver template plug-in project."; 
} 
__declspec( dllexport ) int LibNumberClasses() 
{ 
	return 1;  
} 
__declspec( dllexport ) ClassDesc2* LibClassDesc(int i) 
{ 
    static TemplateImageLoaderSaverClassDesc classdesc; 
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
