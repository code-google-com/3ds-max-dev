//
// Copyright 2009 Autodesk, Inc.  All rights reserved.
//
// Use of this software is subject to the terms of the Autodesk license
// agreement provided at the time of installation or download, or which
// otherwise accompanies this software in either electronic or hard copy form.  
//

#include "TemplateConstructionGridObject.h"

// Static Dll handle
static HINSTANCE hDllInstance = 0; 

//==========================================================================
// Class descriptor implementation

int TemplateConstructionGridObjectClassDesc::IsPublic() 
{ 
    return 1; 
} 
void* TemplateConstructionGridObjectClassDesc::Create(BOOL loading) 
{ 
    return new TemplateConstructionGridObject(); 
} 
const MCHAR* TemplateConstructionGridObjectClassDesc::ClassName() 
{ 
    TODO("Replace with your own localized plug-in name");
    return _M("Template Construction Grid Object"); 
} 
SClass_ID TemplateConstructionGridObjectClassDesc::SuperClassID() 
{ 
    return HELPER_CLASS_ID;
} 
Class_ID TemplateConstructionGridObjectClassDesc::ClassID() 
{ 
    TODO("Replace the Class_ID with a new unique one")
    static const Class_ID cid = Class_ID(0x351D2D44, 0x31D74CA5);
    return cid; 
} 
const MCHAR* TemplateConstructionGridObjectClassDesc::Category() 
{ 
    TODO("Replace with an appropriate category")
    return SDK_TUTORIALS_CATEGORY; 
}  
const MCHAR* TemplateConstructionGridObjectClassDesc::GetInternalName() 
{ 
    TODO("Replace with your own internal (non-localized) plug-in name");
    return _M("TemplateConstructionGridObject"); 
} 
HINSTANCE TemplateConstructionGridObjectClassDesc::HInstance() 
{ 
    return hDllInstance; 
} 
ClassDesc2* TemplateConstructionGridObjectClassDesc::GetClassDescInstance() 
{
    static TemplateConstructionGridObjectClassDesc desc;
    return &desc;
}

//============================================================
// Define the static parameter block descriptor

// This class derives from ParamBlockDesc2, but adds a number of convenience functions 
// for constructing parameter block descriptors incrementally.
// The ParamBlockDescUtil assumes the flags "P_AUTO_UI" and "P_AUTO_CREATE"
class TemplateConstructionGridObjectParams
    : public ParamBlockDescUtil
{
public:        
    TemplateConstructionGridObjectParams()
        : ParamBlockDescUtil(TemplateConstructionGridObjectClassDesc::GetClassDescInstance(), _T("TemplateConstructionGridObjectParameters"), 
            IDS_PARAMS, IDD_PANEL, IDS_TITLE)
    {
        TODO("Describe your own parameters here");

        // Adds a float parameter, with a spinner UI
        AddFloatSpinnerParam(TemplateConstructionGridObject::FLOAT_PARAM_ID, _T("Float"), IDS_FLOAT_PARAM, 0.0f, 1000.0f, 0.0f, IDC_PARAM_EDIT, IDC_PARAM_SPIN);

        // Adds a node parameter, with a pick parameter
        AddNodePickParam(TemplateConstructionGridObject::NODE_PARAM_ID, _T("Node"), IDS_NODE_PARAM, IDC_TARGET);
        
        // Prevent further changes to the parameter block descriptor
        SetFinished(); 
    }
};

// Create a parameter block descriptor
static TemplateConstructionGridObjectParams pblockdesc;

//============================================================
// DLL Main functions 

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
	return "Construction Grid Object template plug-in project."; 
} 
__declspec( dllexport ) int LibNumberClasses() 
{ 
	return 1;  
} 
__declspec( dllexport ) ClassDesc2* LibClassDesc(int i) 
{ 
    // Returns a class descriptor
    static TemplateConstructionGridObjectClassDesc classdesc; 
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

