//
// Copyright 2009 Autodesk, Inc.  All rights reserved.
//
// Use of this software is subject to the terms of the Autodesk license
// agreement provided at the time of installation or download, or which
// otherwise accompanies this software in either electronic or hard copy form.  
//

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
