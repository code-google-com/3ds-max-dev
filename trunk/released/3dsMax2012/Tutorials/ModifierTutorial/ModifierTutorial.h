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
#include "macrorec.h"
#include "../../Shared/ModifierPlugin.h"
#include "BendDeformer.h"

const Class_ID MODIFIER_TUTORIAL_CLASS_ID = Class_ID(0x25725b80, 0x251b3ee9);

//============================================================
// Class descriptor declaration

/**
 * The class descriptor for ModifierTutorial.
 */
class ModifierTutorialClassDesc
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
 * This plug-in demonstrates a bend modifier which is a re-implementation
 * of the standard 3ds Max bend modifier. The following concepts are 
 * demonstrated: 
 * \li Implementing a plug-in derived from Modifier
 * \li Using a Deformer to implement a plug-in.
 */
class ModifierTutorial 
    : public ModifierPlugin<Modifier>
{
private:

	//============================================================
	// Member fields

	BendDeformer deformer;

public:
	//============================================================
	// Parameter Block Identifier
	static const BlockID        PBLOCK_ID = 0;

    //============================================================
    // Parameter identifiers 
    
    static const ParamID ANGLE_PARAM_ID = 0;
    static const ParamID DIR_PARAM_ID = 1;
    static const ParamID AXIS_PARAM_ID = 2;
    static const ParamID FROM_TO_PARAM_ID = 3;
    static const ParamID FROM_PARAM_ID = 4;
    static const ParamID TO_PARAM_ID = 5;

	ModifierTutorial();

	//============================================================
    // RefMaker overrides 

	virtual RefTargetHandle Clone(RemapDir &remap);

    //============================================================
    // ModifierPlugin overrides 

    virtual Deformer* GetDeformer(TimeValue t, ModContext &mc, Matrix3& mat, Matrix3& invmat);

    //=========================================================================
    // BendModifier specific functions for accessing the parameters.

    float GetAngle(TimeValue t);
    float GetDirection(TimeValue t = Now());
    int GetAxis(TimeValue t = Now());
    float GetFrom(TimeValue t = Now());
    float GetTo(TimeValue t = Now());
    void SetFrom(float x, TimeValue t = Now());
    void SetTo(float x, TimeValue t = Now());
    BOOL GetFromTo(TimeValue t = Now());
};

//======================================================================
