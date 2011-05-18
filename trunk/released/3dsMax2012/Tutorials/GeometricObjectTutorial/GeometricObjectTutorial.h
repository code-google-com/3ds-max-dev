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
