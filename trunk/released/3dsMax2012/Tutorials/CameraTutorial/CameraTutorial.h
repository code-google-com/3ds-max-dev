//
// Copyright 2010 Autodesk, Inc.  All rights reserved.
//
// Use of this software is subject to the terms of the Autodesk license
// agreement provided at the time of installation or download, or which
// otherwise accompanies this software in either electronic or hard copy form.  
//

#pragma once

#include <gencam.h>

#include "resource.h"
#include "../../Shared/Common.h"
#include "../../Shared/ObjectPlugin.h"
#include "../../Shared/NodePicker.h"

const Class_ID CAMERA_TUTORIAL_CLASS_ID = Class_ID(0x7af83c5f, 0x40480da4);

//============================================================
// The implementation is in CameraMesh.cpp 

extern void __cdecl BuildCameraMesh(Mesh& mesh);

//============================================================
// Class descriptor declaration

/**
 * The class descriptor for CameraTutorial
 */
class CameraTutorialClassDesc
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
 * This plug-in implements a camera similar to the default 
 * camera of 3ds Max but with fewer parameter options. The camera 
 * has a button that allows it to orient itself towards a single object 
 * \par
 * This tutorial demonstrates the following concepts
 * \li GenCamera derived plug-ins
 * \li Implementing node picking buttons
 * \li Objects that don't resize when the viewport is zoomed  
 */ 
class CameraTutorial 
    : public ObjectPlugin<GenCamera>
    , public SingleObjectNodePicker
{
private:
    
    //==========================================================
    // Encapsulates additional state data beyond what is found 
    // in the CameraState object

    struct CameraExtState
    {
        BOOL bEnvRangeDisplay;
        BOOL bConeState;
        BOOL bEnabled;
        int fovType;
        int cameraType;
        BOOL bDOFEnable;
        float fDOFFStop;    
        float fTargetDistance;
    };
    
    //============================================================
    // Fields

    CameraState state;
    CameraExtState ext;
    INode* source;

    //============================================================
    // Constants

    static const int FOV_W = 0;
    static const int FOV_H = 1;
    static const int FOV_D = 2;

public:
   
    //============================================================
    // Parameter IDs 

    static const ParamID FOV_PARAM_ID = 0;
    static const ParamID DISTANCE_PARAM_ID = 1;
    
    //============================================================    
    // Static functions

    static float DefaultDistance() { return 160.0f; }
    static float DefaultAngle() { return DegToRad(45.0); }

    //============================================================
    // Constructor/destructor

    CameraTutorial();

    //============================================================
    // Animatable overrides 

    virtual void BeginEditParams(IObjParam *ip, ULONG flags, Animatable *prev);
    virtual void EndEditParams(IObjParam* ip, ULONG flags, Animatable *next);

    //============================================================
    // RefMaker overrides 

    // Do not call this function directly, it is for use by 3ds Max
    // If you wish to clone a plug-in you should use CloneRefHierarchy()
    virtual RefTargetHandle Clone(RemapDir& remap);

    //=========================================================================
    // ObjectPlugin<CameraObject> overrides 

    virtual CreateMouseCallBack* GetCreateMouseCallBack();
    virtual void BuildMesh(TimeValue t, Mesh& m);
    virtual int HitTest(TimeValue t, INode* inode, int type, int crossing, int flags, IPoint2 *p, ViewExp *vpt);
    virtual int Display(TimeValue t, INode* inode, ViewExp *vpt, int flags);
    virtual void GetDeformBBox(TimeValue t, Box3& box, Matrix3 *tm, BOOL useSel );
    void GetWorldBoundBox(TimeValue t, INode* inode, ViewExp* vpt, Box3& box );
    void GetLocalBoundBox(TimeValue t, INode* inode, ViewExp* vpt, Box3& box );
    int DoOwnSelectHilite();
	BOOL HasViewDependentBoundingBox();
    BOOL UsesWireColor();

    //=========================================================================
    // CameraObject overrides

    virtual RefResult EvalCameraState(TimeValue time, Interval& valid, CameraState* cs);
	virtual void SetOrtho(BOOL b);
	virtual BOOL IsOrtho();
	virtual void SetFOV(TimeValue t, float f);
	virtual float GetFOV(TimeValue t, Interval& valid = Interval(0,0));
	virtual void SetTDist(TimeValue t, float f);
	virtual float GetTDist(TimeValue t, Interval& valid = Interval(0,0));
	virtual int GetManualClip();
	virtual void SetManualClip(int onOff);
	virtual float GetClipDist(TimeValue t, int which, Interval &valid=Interval(0,0));
	virtual void SetClipDist(TimeValue t, int which, float val);
	virtual float GetEnvRange(TimeValue t, int which, Interval& valid = Interval(0,0));
	virtual void SetEnvRange(TimeValue time, int which, float f);
	virtual void SetEnvDisplay(BOOL b, int notify=TRUE);
	virtual BOOL GetEnvDisplay();
    virtual void RenderApertureChanged(TimeValue t);
	virtual void UpdateTargDistance(TimeValue t, INode* inode);

    //=========================================================================
    // Multi-pass effects

    virtual void SetMultiPassEffectEnabled(TimeValue t, BOOL enabled);
    virtual BOOL GetMultiPassEffectEnabled(TimeValue t, Interval& valid);
    virtual void SetMPEffect_REffectPerPass(BOOL enabled);
	virtual BOOL GetMPEffect_REffectPerPass();
    virtual IMultiPassCameraEffect* GetIMultiPassCameraEffect();

    //=========================================================================
    // GenCamera overrides

	virtual GenCamera* NewCamera(int type);
	virtual void SetConeState(int s);
	virtual int GetConeState();
	virtual void SetHorzLineState(int s);
	virtual int GetHorzLineState();
	virtual void Enable(int enab);
    virtual BOOL IsEnabled();
	virtual BOOL SetFOVControl(Control *c);
    Control* GetFOVControl();
	virtual void SetFOVType(int ft);
	virtual int GetFOVType();
	virtual	int Type();
	virtual void SetType(int tp);
	virtual void SetDOFEnable(TimeValue t, BOOL onOff);
    virtual BOOL GetDOFEnable(TimeValue t, Interval& valid = Interval(0,0));
    virtual void SetDOFFStop(TimeValue t, float fs);
	virtual float GetDOFFStop(TimeValue t, Interval& valid = Interval(0,0));

private:

    //======================================================================
    // Helper functions

    void AddButtonPressHandler();
    void OnLookAtPress();
    int DrawCone(TimeValue t, INode* inode, GraphicsWindow *gw );
    void GetConePoints(TimeValue t, Point3* q, float dist);
    float GetNearEnvRange(TimeValue t);
    float GetFarEnvRange(TimeValue t);
    float GetHitherClipDist(TimeValue t);
    float GetYonClipDist(TimeValue t);

    //======================================================================
    // NodePicker overrides

    virtual void OnObjectPicked(INode* node);
};

//======================================================================
