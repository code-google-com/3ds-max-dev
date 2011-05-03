//
// Copyright 2010 Autodesk, Inc.  All rights reserved.
//
// Use of this software is subject to the terms of the Autodesk license
// agreement provided at the time of installation or download, or which
// otherwise accompanies this software in either electronic or hard copy form.  
//

#include "UtilityObjectTutorial.h"

// Static DLL handle
static HINSTANCE hDllInstance = 0; 

//==========================================================================
// Class descriptor implementation

int UtilityObjectTutorialClassDesc::IsPublic() 
{ 
    return 1; 
} 
void* UtilityObjectTutorialClassDesc::Create(BOOL loading) 
{ 
    return new UtilityObjectTutorial(); 
} 
const MCHAR* UtilityObjectTutorialClassDesc::ClassName() 
{ 
    return _M("Template Utility Object"); 
} 
SClass_ID UtilityObjectTutorialClassDesc::SuperClassID() 
{ 
    return UTILITY_CLASS_ID;
} 
Class_ID UtilityObjectTutorialClassDesc::ClassID() 
{     
    return UTILITY_OBJECT_TUTORIAL_CLASS_ID; 
} 
const MCHAR* UtilityObjectTutorialClassDesc::Category() 
{ 
    return SDK_TUTORIALS_CATEGORY; 
}  
const MCHAR* UtilityObjectTutorialClassDesc::GetInternalName() 
{ 
    return _M("UtilityObjectTutorial"); 
} 
HINSTANCE UtilityObjectTutorialClassDesc::HInstance() 
{ 
    return hDllInstance; 
} 
ClassDesc2* UtilityObjectTutorialClassDesc::GetInstance() 
{
    static UtilityObjectTutorialClassDesc desc;
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
	return "Utility Object template plug-in project."; 
} 
__declspec( dllexport ) int LibNumberClasses() 
{ 
	return 1;  
} 
__declspec( dllexport ) ClassDesc2* LibClassDesc(int i) 
{ 
	return UtilityObjectTutorialClassDesc::GetInstance();
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
    return 1;
}
__declspec( dllexport ) ULONG LibShutdown() 
{ 
    return 1;
}

//============================================================
// UtilityObjectTutorial implementation

UtilityObjectTutorial::UtilityObjectTutorial() : UtilityPlugin<UtilityObj>(), m_hPanel(0)
{
}

INT_PTR CALLBACK UtilityObjectTutorial::DlgProc( HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam )
{
    switch (msg) {
        case WM_COMMAND:
            switch (LOWORD(wParam)) {
        case IDC_BUTTON:
            MessageBox("This plug-in does nothing");
            break;
            }
            break;
        default:
            return FALSE;
    }
    return TRUE;
}

void UtilityObjectTutorial::BeginEditParams(Interface *ip, IUtil *iu)
{
    m_hPanel = ip->AddRollupPage(hDllInstance, MAKEINTRESOURCE(IDD_PANEL), DlgProc, _M("Tutorial utility plug-in"), 0);
}

void UtilityObjectTutorial::EndEditParams( Interface *ip, IUtil *iu )
{
    ip->DeleteRollupPage(m_hPanel);
    m_hPanel = 0;
}

void UtilityObjectTutorial::SelectionSetChanged( Interface *ip, IUtil *iu )
{
}

void UtilityObjectTutorial::DeleteThis()
{
    delete this;
}