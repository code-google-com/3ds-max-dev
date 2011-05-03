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
#include "utilapi.h"

//============================================================
// Class descriptor declaration

class TemplateUtilityObjectClassDesc
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

class TemplateUtilityObject 
    : public UtilityPlugin<UtilityObj>
{
    //============================================================
    // Fields

    // Use member fields only when data is not managed by the parameter block
    // or the reference manager. 
    TODO("Add member fields");

public:
   
    //============================================================
    // Constructor/destructor

    TemplateUtilityObject()
        : UtilityPlugin<UtilityObj>()
    {         
        TODO("Initialize any member fields");
    }

    ~TemplateUtilityObject()
    { 
        TODO("Free any memory allocated here");
    }

    //=========================================================================
    // UtilityPlugin<UtilityObj> overrides 

    virtual void BeginEditParams (Interface *ip, IUtil *iu)
    {
        TODO("Open the parameter dialog box");
    }
    virtual void EndEditParams (Interface *ip, IUtil *iu)
    {
        TODO("Close the parameter dialog box");
    }
    virtual void SelectionSetChanged (Interface *ip, IUtil *iu) 
    {
        TODO("Respond to changes in the selection set");
    }   
    virtual void DeleteThis()
    {
        delete this;
    }

    //=========================================================================
    // UtilityPlugin overrides

    virtual ClassDesc2* GetClassDesc()
    {
        return TemplateUtilityObjectClassDesc::GetClassDescInstance();
    }
};

//======================================================================
