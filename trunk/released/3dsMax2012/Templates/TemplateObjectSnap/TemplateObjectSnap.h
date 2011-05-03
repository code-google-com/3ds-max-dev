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
#include "osnap.h"

//============================================================
// Class descriptor declaration

class TemplateObjectSnapClassDesc
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

class TemplateObjectSnap 
    : public UtilityPlugin<Osnap>
{
    //============================================================
    // Fields

    // Use member fields only when data is not managed by the parameter block
    // or the reference manager. 
    TODO("Add member fields");

public:
   
    //============================================================
    // Constructor/destructor

    TemplateObjectSnap()
        : UtilityPlugin<Osnap>()
    {         
        TODO("Initialize any member fields");
    }

    ~TemplateObjectSnap()
    { 
        TODO("Free any memory allocated here");
    }

    //=========================================================================
    // UtilityPlugin<Osnap> overrides 

    virtual MSTR *snapname(int index)
    {
        TODO("Return the snap name"); 
        static MSTR name = GetClassDesc()->ClassName();
        return &name;
    }
    virtual boolean ValidInput(SClass_ID scid, Class_ID cid)
    {
        TODO("Return true if the snap is supported for the given object type");
        return false;
    }
    virtual OsnapMarker* GetMarker(int  index)  
    {
        TODO("Return a custom OsnapMarker if desired");
        return NULL;
    }
    virtual HBITMAP getMasks()  
    {
        TODO("Returns a handle to a bitmap that contains the masks for the UI icons");        
        return HBITMAP(0);
    }
    virtual HBITMAP getTools()
    {
        TODO("Returns a handle to a bitmap that contains the snap's icon");
        return HBITMAP(0);
    }
    virtual WORD AccelKey(int index)  
    {
        // unused
        return 0;
    }

    //=========================================================================
    // UtilityPlugin overrides

    virtual ClassDesc2* GetClassDesc()
    {
        return TemplateObjectSnapClassDesc::GetClassDescInstance();
    }
};

//======================================================================
