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
#include "../../Shared/ControlPlugin.h"

const Class_ID CONTROLLER_TUTORIAL_CLASS_ID = Class_ID(0x1f742fc, 0x7b2e4c04);

//============================================================
// Class descriptor declaration

/**
 * The class descriptor for ControllerTutorial
 */
class ControllerTutorialClassDesc
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
 * This plug-in implements a position controller that will 
 * maintain a specific distance to a target node. 
 * This tutorial demonstrates the following concepts
 * \li Implementing Control derived plug-ins
 * \li Implementing position controllers using the ControlPlugin hierarchy 
 */ 
class ControllerTutorial 
    : public PositionControlPlugin
{
private:
    //============================================================
    // Fields

    Point3 previousPos; 
    INode* prevTarget;

public:
	//============================================================
	// Parameter Block ID

	static const BlockID PBLOCK_ID = 0;

    //============================================================
    // Parameter IDs 

    static const ParamID DISTANCE_PARAM_ID = 0;
    static const ParamID   TARGET_PARAM_ID = 1;

    //============================================================
    // Constructor/destructor

    ControllerTutorial();

    //============================================================
    // RefMaker overrides 

    // Do not call this function directly, it is for use by 3ds Max
    // If you wish to clone a plug-in you should use CloneRefHierarchy()
    virtual RefTargetHandle Clone(RemapDir& remap);

    //=========================================================================
    // Plug-in base overrides 

    virtual void OnParamChangeMsg(ParamID id);

    //=========================================================================
    // ControlPlugin 

    virtual void GetAbsoluteValue(TimeValue t, Point3& v, Interval& valid);
    virtual void GetRelativeValue(TimeValue t, Matrix3& v, Interval& valid);    
	virtual void Copy(Control *from);

    //=========================================================================
    // Follow controller specific utility functions 
    
    Point3 GetTargetPosition(TimeValue t = Now());
    Point3 GetPreviousPosition();

    //=========================================================================
    // Follow controller specific functions, for accessing and settting the parameters.

    void SetDistance(float size, TimeValue t = Now());
    float GetDistance(TimeValue t = Now());
    void SetTarget(INode* node, TimeValue t = Now());
    INode* GetTarget(TimeValue t = Now());
};

//======================================================================
