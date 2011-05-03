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
