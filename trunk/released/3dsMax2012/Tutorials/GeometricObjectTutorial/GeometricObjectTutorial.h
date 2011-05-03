//
// Copyright 2010 Autodesk, Inc.  All rights reserved.
//
// Use of this software is subject to the terms of the Autodesk license
// agreement provided at the time of installation or download, or which
// otherwise accompanies this software in either electronic or hard copy form.  
//

#pragma once

#include "resource.h"
#include "../../Shared/Common.h"
#include "../../Shared/ObjectPlugin.h"

const Class_ID GEOMETRIC_OBJECT_TUTORIAL_CLASS_ID = Class_ID(0x55a302e4, 0x287e638c);

//============================================================
// Class descriptor declaration

/**
 * The class descriptor for GeometricObjectTutorial
 */
class GeometricObjectTutorialClassDesc
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
    // Returns a singleton instance of the class descriptor
    static ClassDesc2* GetInstance();
}; 

//============================================================
// The plug-in definition

/**
 * This plug-in creates a triangle-based pyramid geometric 
 * object with a single size parameter.
 * The following concepts are demonstrated:
 * \li GeomObject derived plug-ins
 * \li Mouse based creation of objects. 
 * \li Simple parameter block creation.
 */
class GeometricObjectTutorial 
    : public ObjectPlugin<GeomObject>
{
public:
   
    //============================================================
    // Parameter IDs 

    static const ParamID SIZE_PARAM_ID = 0;

    //============================================================
    // Constructor/destructor

    GeometricObjectTutorial();

    //============================================================
    // ReferenceMaker overrides 

    // Do not call this function directly, it is for use by 3ds Max
    // If you wish to clone a plug-in you should use CloneRefHierarchy()
    virtual RefTargetHandle Clone(RemapDir& remap);

    //============================================================
    // BaseObject overrides

    /// Returns a call-back class used by 3ds Max for interactive creation of objects 
    /// by a 3ds Max user using the mouse.
    /// 
    /// \return     A pointer to a CreateMouseCallBack. Do not deallocate this object, 
    ///             it is managed by the plug-in. 
    virtual CreateMouseCallBack* GetCreateMouseCallBack();    
    
    //=========================================================================
    // ObjectPlugin<GeomObject> overrides 

    virtual void BuildMesh(TimeValue t, Mesh& m);

    //=========================================================================
    // Utility functions for accessing and setting the parameters. 

    void SetSize(float size, TimeValue t = Now());
    float GetSize(TimeValue t = Now());
};

//======================================================================
