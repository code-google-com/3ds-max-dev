//
// Copyright 2009 Autodesk, Inc.  All rights reserved.
//
// Use of this software is subject to the terms of the Autodesk license
// agreement provided at the time of installation or download, or which
// otherwise accompanies this software in either electronic or hard copy form.  
//

#include "TemplateTexture3D.h"

// Static Dll handle
static HINSTANCE hDllInstance = 0; 

//==========================================================================
// Class descriptor implementation

int TemplateTexture3DClassDesc::IsPublic() 
{ 
    return 1; 
} 
void* TemplateTexture3DClassDesc::Create(BOOL loading) 
{ 
    return new TemplateTexture3D(); 
} 
const MCHAR* TemplateTexture3DClassDesc::ClassName() 
{ 
    TODO("Replace with your own localized plug-in name");
    return _M("Template 3D Texture"); 
} 
SClass_ID TemplateTexture3DClassDesc::SuperClassID() 
{ 
    return TEXMAP_CLASS_ID;
} 
Class_ID TemplateTexture3DClassDesc::ClassID() 
{ 
    TODO("Replace the Class_ID with a new unique one")
    static const Class_ID cid = Class_ID(0x2A76AE97, 0x639A03D3);
    return cid; 
} 
const MCHAR* TemplateTexture3DClassDesc::Category() 
{ 
    TODO("Replace with an appropriate category")
    return SDK_TUTORIALS_CATEGORY; 
}  
const MCHAR* TemplateTexture3DClassDesc::GetInternalName() 
{ 
    TODO("Replace with your own internal (non-localized) plug-in name");
    return _M("TemplateTexture3D"); 
} 
HINSTANCE TemplateTexture3DClassDesc::HInstance() 
{ 
    return hDllInstance; 
} 
ClassDesc2* TemplateTexture3DClassDesc::GetClassDescInstance() 
{
    static TemplateTexture3DClassDesc desc;
    return &desc;
}

//============================================================
// Define the static parameter block descriptor

// This class derives from ParamBlockDesc2, but adds a number of convenience functions 
// for constructing parameter block descriptors incrementally.
// The ParamBlockDescUtil assumes the flags "P_AUTO_UI" and "P_AUTO_CREATE"
class TemplateTexture3DParams
    : public ParamBlockDescUtil
{
public:        
    TemplateTexture3DParams()
        : ParamBlockDescUtil(TemplateTexture3DClassDesc::GetClassDescInstance(), _T("TemplateTexture3DParameters"), 
            IDS_PARAMS, IDD_PANEL, IDS_TITLE)
    {
        TODO("Describe your own parameters here");

        // Adds a float parameter, with a spinner UI
        AddFloatSpinnerParam(TemplateTexture3D::FLOAT_PARAM_ID, _T("Float"), IDS_FLOAT_PARAM, 0.0f, 1000.0f, 0.0f, IDC_PARAM_EDIT, IDC_PARAM_SPIN);

        // Adds a node parameter, with a pick parameter
        AddNodePickParam(TemplateTexture3D::NODE_PARAM_ID, _T("Node"), IDS_NODE_PARAM, IDC_TARGET);
        
        // Prevent further changes to the parameter block descriptor
        SetFinished(); 
    }
};

// Create a parameter block descriptor
static TemplateTexture3DParams pblockdesc;

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
	return "3D Texture template plug-in project."; 
} 
__declspec( dllexport ) int LibNumberClasses() 
{ 
	return 1;  
} 
__declspec( dllexport ) ClassDesc2* LibClassDesc(int i) 
{ 
    // Returns a class descriptor
    static TemplateTexture3DClassDesc classdesc; 
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

