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
#include "filters.h"

//============================================================
// Class descriptor declaration

class TemplateImageFilterClassDesc
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

class TemplateImageFilter 
    : public UtilityPlugin<ImageFilter>
{
    //============================================================
    // Fields

    // Use member fields only when data is not managed by the parameter block
    // or the reference manager. 
    TODO("Add member fields");

public:
   
    //============================================================
    // Constructor/destructor

    TemplateImageFilter()
        : UtilityPlugin<ImageFilter>()
    {         
        TODO("Initialize any member fields");
    }

    ~TemplateImageFilter()
    { 
        TODO("Free any memory allocated here");
    }

    //=========================================================================
    // UtilityPlugin<ImageFilter> overrides 

    virtual const MCHAR* Description() 
    {
        TODO("Return a description");
        return "A description of the image filter.";
    }
    virtual const MCHAR* AuthorName()
    {
        TODO("Return the author name");
        return "your name";
    }
    virtual const MCHAR* CopyrightMessage()
    {
        TODO("return a copyright message");
        return "your copyright message";
    }
    virtual UINT Version()
    {
        return 1;
    }
    virtual DWORD Capability ()
    {
        TODO("Return the appropriate capability flags or'd together");
        return IMGFLT_NONE;
    }
    virtual void ShowAbout (HWND hWnd)
    {
        TODO("Display the About Box");
    }
    virtual BOOL Render (HWND hWnd)
    {
        TODO("Perform the image rendering")
        return FALSE;
    }

    //=========================================================================
    // UtilityPlugin overrides

    virtual ClassDesc2* GetClassDesc()
    {
        return TemplateImageFilterClassDesc::GetClassDescInstance();
    }
};

//======================================================================
