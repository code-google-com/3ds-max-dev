/* Copyright (c) 2011, Autodesk 
   All rights reserved.

   Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

  Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
  Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
  Neither the name of Autodesk or the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

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