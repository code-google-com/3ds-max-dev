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
#include "ikhierarchy.h"
#include "iksolver.h"

//============================================================
// Class descriptor declaration

class TemplateIKSolverClassDesc
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

class TemplateIKSolver 
    : public UtilityPlugin<IKSolver>
{
    //============================================================
    // Fields

    // Use member fields only when data is not managed by the parameter block
    // or the reference manager. 
    TODO("Add member fields");

public:
   
    //============================================================
    // Constructor/destructor

    TemplateIKSolver()
        : UtilityPlugin<IKSolver>()
    {         
        TODO("Initialize any member fields");
    }

    ~TemplateIKSolver()
    { 
        TODO("Free any memory allocated here");
    }

    //=========================================================================
    // UtilityPlugin<IKSolver> overrides 
;
    virtual Class_ID ClassID()
    {
        return GetClassDesc()->ClassID();
    }
    virtual void GetClassName(MSTR &s) 
    {
        s = GetClassDesc()->ClassName();
    }
    virtual bool IsHistoryDependent() const 
    {
        return true;
    }
    virtual bool DoesOneChainOnly() const 
    {
        return true;
    }
    virtual bool IsInteractive() const 
    {
        return false;
    }
    virtual bool UseSlidingJoint() const 
    {
        return false;
    }
    virtual bool UseSwivelAngle() const 
    {
        return false;
    }
    virtual bool IsAnalytic() const  
    {
        return false;
    }
    virtual bool DoesRootJointLimits() const  
    {
        return false;
    }
    virtual bool DoesJointLimitsButRoot() const  
    {
        return false;
    }
    virtual Interface_ID ExpectGoal() const 
    {
        TODO("Return an interface representing the kind of goal (e.g. kGoalID, kHIIKGoalID, kSplineIKGoalID, or IID_SPLINE_IKGOAL2)");
        return IKSys::kGoalID;
    }
    virtual bool  SolveEERotation () const 
    {
        return false;
    }
    virtual float GetPosThreshold() const
    {
        return 0.0f;
    }
    virtual float GetRotThreshold() const
    {
        return 0.0f;
    }
    virtual unsigned GetMaxIteration() const 
    {
        return 0;
    }
    virtual void SetPosThreshold(float x)
    {
    }
    virtual void SetRotThreshold(float x)
    {
    } 
    virtual void SetMaxIteration(unsigned x)
    {
    }
    virtual ReturnCondition Solve(IKSys::LinkChain& linkChain)
    {
        TODO("Implement the IK Solving algorithm");
        return 0;
    }

    //=========================================================================
    // UtilityPlugin overrides

    virtual ClassDesc2* GetClassDesc()
    {
        return TemplateIKSolverClassDesc::GetClassDescInstance();
    }
};

//======================================================================
