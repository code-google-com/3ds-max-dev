/* Copyright (c) 2011, Autodesk 
   All rights reserved.

   Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

  Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
  Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
  Neither the name of Autodesk or the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#pragma once

#include "resource.h"
#include "../../Shared/Common.h"
#include "hsv.h"

//============================================================
// Class descriptor declaration

class TemplateColorSelectorClassDesc
    : public ClassDesc2 
{
public:
    //---------------------------------------
    // ClassDesc2 overrides 

    virtual int IsPublic();
    virtual void* Create(BOOL loading = FALSE);
    virtual const MCHAR* ClassName();
    virtual SClass_ID SuperClassID();
    virtual Class_ID ClassID();
    virtual const MCHAR* Category();
    virtual const MCHAR* GetInternalName();
    virtual HINSTANCE HInstance();

    //---------------------------------------
    // Returns a singleton instance of this class descriptor
    static ClassDesc2* GetClassDescInstance();
}; 

//============================================================
// The plug-in definition

class TemplateColorSelector 
    : public UtilityPlugin<ColPick>
{
    //============================================================
    // Fields

    // Use member fields only when data is not managed by the parameter block
    // or the reference manager. 
    TODO("Add member fields");

public:
   
    //============================================================
    // Constructor/destructor

    TemplateColorSelector()
        : UtilityPlugin<ColPick>()
    {         
        TODO("Initialize any member fields");
    }

    ~TemplateColorSelector()
    { 
        TODO("Free any memory allocated here");
    }

    //=========================================================================
    // UtilityPlugin<ColPick> overrides 

    INT_PTR ModalColorPicker(HWND hwndOwner, DWORD* lpc, IPoint2* spos, HSVCallback* callback, MCHAR* name)
    {
        TODO("Show a custom modal color picker");
        // Shows the default color selection dialog box
        return HSVDlg_Do(hwndOwner, lpc, spos, callback, name);
    }
    INT_PTR ModalColorPicker(HWND hwndOwner, AColor* lpc, IPoint2* spos, HSVCallback* callback, MCHAR* name)
    {
        TODO("Show a custom modal color picker");
        // Shows the default color selection dialog box
        return HSVDlg_Do(hwndOwner, lpc, spos, callback, name);
    }
    ColorPicker* CreateColorPicker(HWND hwndOwner, DWORD initColor, IPoint2* spos, HSVCallback* pcallback, MCHAR* name, BOOL isObjectColor=FALSE)
    {
        TODO("Create a custom modeless color picker");
        // Shows the default color selection dialog box
        return ::CreateColorPicker(hwndOwner, initColor, spos, pcallback, name, isObjectColor);
    }
    ColorPicker* CreateColorPicker(HWND hwndOwner, AColor initColor, IPoint2* spos, HSVCallback* pcallback, MCHAR* name, BOOL isObjectColor=FALSE)
    {
        TODO("Create a custom modeless color picker");
        // Shows the default color selection dialog box
        return ::CreateColorPicker(hwndOwner, initColor, spos, pcallback, name, isObjectColor);
    }
    const char *ColPick::ClassName()
    {
        return GetClassDesc()->ClassName();
    }
    Class_ID ClassID()
    {
        return GetClassDesc()->ClassID();
    }
    void DeleteThis()
    { 
        delete this;
    } 
    INT_PTR Execute(int,ULONG_PTR,ULONG_PTR,ULONG_PTR)
    {
        // The function is not used.
        return 0;
    }

    //=========================================================================
    // UtilityPlugin overrides

    virtual ClassDesc2* GetClassDesc()
    {
        return TemplateColorSelectorClassDesc::GetClassDescInstance();
    }
};

//======================================================================
