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
#include "../../Shared/ManipulatorPlugin.h"

//============================================================
// Class descriptor declaration

class TemplateManipulatorClassDesc
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

class TemplateManipulator 
    : public ManipulatorPlugin
{
    //============================================================
    // Fields

    // Use member fields only when data is not managed by the parameter block
    // or the reference manager. 
    TODO("Add member fields");

public:
   
    //============================================================
    // Constructor/destructor

    TemplateManipulator()
        : ManipulatorPlugin()
    {         
        TODO("Initialize any member fields");
    }

    ~TemplateManipulator()
    { 
        TODO("Free any memory allocated here");
    }

    //=========================================================================
    // ManipulatorPlugin overrides 

    virtual void UpdateShapes(TimeValue t, MSTR& toolTip) 
    {
        if (mValid.InInterval(t)) return;
        ClearPolyShapes();
        toolTip = mToolTip;
        TODO("Update the shapes by calling AppendPolyShape(), AppendGizmo(), etc.");                
        mValid.SetInfinite();
    }

    //=========================================================================
    // UtilityPlugin overrides

    virtual ClassDesc2* GetClassDesc()
    {
        return TemplateManipulatorClassDesc::GetClassDescInstance();
    }
};

//======================================================================
