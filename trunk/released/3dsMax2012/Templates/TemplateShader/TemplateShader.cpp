/* Copyright (c) 2011, Autodesk 
   All rights reserved.

   Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

  Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
  Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
  Neither the name of Autodesk or the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#include "TemplateShader.h"

// Static Dll handle
static HINSTANCE hDllInstance = 0; 

//==========================================================================
// Class descriptor implementation

int TemplateShaderClassDesc::IsPublic() 
{ 
    return 1; 
} 
void* TemplateShaderClassDesc::Create(BOOL loading) 
{ 
    return new TemplateShader(); 
} 
const MCHAR* TemplateShaderClassDesc::ClassName() 
{ 
    TODO("Replace with your own localized plug-in name");
    return _M("Template Shader"); 
} 
SClass_ID TemplateShaderClassDesc::SuperClassID() 
{ 
    return SHADER_CLASS_ID ;
} 
Class_ID TemplateShaderClassDesc::ClassID() 
{ 
    TODO("Replace the Class_ID with a new unique one")
    static const Class_ID cid = Class_ID(0x05382FC4, 0x408E906B);
    return cid; 
} 
const MCHAR* TemplateShaderClassDesc::Category() 
{ 
    TODO("Replace with an appropriate category")
    return SDK_TUTORIALS_CATEGORY; 
}  
const MCHAR* TemplateShaderClassDesc::GetInternalName() 
{ 
    TODO("Replace with your own internal (non-localized) plug-in name");
    return _M("TemplateShader"); 
} 
HINSTANCE TemplateShaderClassDesc::HInstance() 
{ 
    return hDllInstance; 
} 
ClassDesc2* TemplateShaderClassDesc::GetClassDescInstance() 
{
    static TemplateShaderClassDesc desc;
    return &desc;
}

//============================================================
// Define the static parameter block descriptor

// This class derives from ParamBlockDesc2, but adds a number of convenience functions 
// for constructing parameter block descriptors incrementally.
// The ParamBlockDescUtil assumes the flags "P_AUTO_UI" and "P_AUTO_CREATE"
class TemplateShaderParams
    : public ParamBlockDescUtil
{
public:        
    TemplateShaderParams()
        : ParamBlockDescUtil(TemplateShaderClassDesc::GetClassDescInstance(), _T("TemplateShaderParameters"), 
            IDS_PARAMS, IDD_PANEL, IDS_TITLE)
    {
        TODO("Describe your own parameters here");

        // Adds a float parameter, with a spinner UI
        AddFloatSpinnerParam(TemplateShader::FLOAT_PARAM_ID, _T("Float"), IDS_FLOAT_PARAM, 0.0f, 1000.0f, 0.0f, IDC_PARAM_EDIT, IDC_PARAM_SPIN);

        // Adds a node parameter, with a pick parameter
        AddNodePickParam(TemplateShader::NODE_PARAM_ID, _T("Node"), IDS_NODE_PARAM, IDC_TARGET);
        
        // Prevent further changes to the parameter block descriptor
        SetFinished(); 
    }
};

// Create a parameter block descriptor
static TemplateShaderParams pblockdesc;

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
	return "Shader template plug-in project."; 
} 
__declspec( dllexport ) int LibNumberClasses() 
{ 
	return 1;  
} 
__declspec( dllexport ) ClassDesc2* LibClassDesc(int i) 
{ 
    // Returns a class descriptor
    static TemplateShaderClassDesc classdesc; 
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

