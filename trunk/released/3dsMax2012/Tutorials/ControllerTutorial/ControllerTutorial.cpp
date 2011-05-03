//
// Copyright 2010 Autodesk, Inc.  All rights reserved.
//
// Use of this software is subject to the terms of the Autodesk license
// agreement provided at the time of installation or download, or which
// otherwise accompanies this software in either electronic or hard copy form.  
//

#include "ControllerTutorial.h"

// Static Dll handle
static HINSTANCE hDllInstance = 0; 

//==========================================================================
// Class descriptor implementation

int ControllerTutorialClassDesc::IsPublic() 
{ 
    return 1; 
} 
void* ControllerTutorialClassDesc::Create(BOOL loading) 
{ 
    return new ControllerTutorial(); 
} 
const MCHAR* ControllerTutorialClassDesc::ClassName() 
{ 
    return _M("SDK Controller Tutorial"); 
} 
SClass_ID ControllerTutorialClassDesc::SuperClassID() 
{ 
    return CTRL_POSITION_CLASS_ID;
} 
Class_ID ControllerTutorialClassDesc::ClassID() 
{ 
    return CONTROLLER_TUTORIAL_CLASS_ID; 
} 
const MCHAR* ControllerTutorialClassDesc::Category() 
{ 
    return SDK_TUTORIALS_CATEGORY; 
}  
const MCHAR* ControllerTutorialClassDesc::GetInternalName() 
{ 
    return _M("ControllerTutorial"); 
} 
HINSTANCE ControllerTutorialClassDesc::HInstance() 
{ 
    return hDllInstance; 
} 
ClassDesc2* ControllerTutorialClassDesc::GetInstance() 
{
    static ControllerTutorialClassDesc desc;
    return &desc;
}

//============================================================
// Define the static parameter block descriptor

// This class derives from ParamBlockDesc2, but adds a number of convenience functions 
// for constructing parameter block descriptors incrementally.
// The ParamBlockDescUtil assumes the flags "P_AUTO_UI" and "P_AUTO_CREATE"
class ControllerTutorialParams
    : public ParamBlockDescUtil
{
public:        
    
    ControllerTutorialParams()
		: ParamBlockDescUtil(
			ControllerTutorial::PBLOCK_ID,
			_T("ControllerTutorialParameters"), 
			IDS_PARAMS, 
			ControllerTutorialClassDesc::GetInstance(),
			BEGIN_EDIT_MOTION, 
			// ----------------------
			0, // Reference System Index
			IDD_SDK_CONTROLLER_TUTORIAL,
			IDS_PARAMS, 
			NULL
			)
    {
        AddFloatSpinnerParam(ControllerTutorial::DISTANCE_PARAM_ID, _T("distance"), IDS_DISTANCE, 0.0f, 1000.0f, 0.0f, IDC_PARAM_EDIT, IDC_PARAM_SPIN);
        AddNodePickParam(ControllerTutorial::TARGET_PARAM_ID, _T("target"), IDS_TARGET, IDC_TARGET);
    }

    // Creates a static instance of the ControllerTutorialParams
    static ControllerTutorialParams* GetInstance()
    {
        static ControllerTutorialParams params;
        return &params;
    }
};

//============================================================
// DLL Main functions 

BOOL WINAPI DllMain(HINSTANCE hinstDLL, ULONG fdwReason, LPVOID lpvReserved) { 
    // NOTE: Do not call managed code from here.
    // You should do any initialization in LibInitialize
	hDllInstance = hinstDLL; 
	switch(fdwReason) { 
		case DLL_PROCESS_ATTACH: break; 
		case DLL_THREAD_ATTACH: break; 
		case DLL_THREAD_DETACH: break; 
		case DLL_PROCESS_DETACH: break; 
	} 
	return(TRUE); 
} 
__declspec( dllexport ) const TCHAR * LibDescription() 
{ 
	return _T("Controller template plug-in project.");
} 
__declspec( dllexport ) int LibNumberClasses() 
{ 
	return 1;  
} 
__declspec( dllexport ) ClassDesc2* LibClassDesc(int i) 
{ 
	return ControllerTutorialClassDesc::GetInstance();
} 
__declspec( dllexport ) ULONG LibVersion() 
{ 
	return VERSION_3DSMAX; 
} 
__declspec( dllexport ) ULONG CanAutoDefer() 
{ 
	return 1; 
} 
__declspec( dllexport ) ULONG LibInitialize() 
{ 
    // Initialize the parameter block descriptor
    ControllerTutorialParams::GetInstance();
    return 1;
}
__declspec( dllexport ) ULONG LibShutdown() 
{ 
    return 1;
}

//==========================================
// ControllerTutorial functions

ControllerTutorial::ControllerTutorial() : PositionControlPlugin(ControllerTutorialClassDesc::GetInstance())
, previousPos(0,0,0)
, prevTarget(NULL)
{
    // Ask the class descriptor to make the parameter blocks
    // This will trigger 3ds Max to call ReplaceReference with the 
    // constructed parameter block 
    ControllerTutorialClassDesc::GetInstance()->MakeAutoParamBlocks(this);
}

RefTargetHandle ControllerTutorial::Clone(RemapDir& remap) 
{
    ReferenceTarget* r = new ControllerTutorial();
    BaseClone(this, r, remap);
    return r;
}

void ControllerTutorial::OnParamChangeMsg(ParamID id) 
{
    // Respond to changes in the target node
    if (id == TARGET_PARAM_ID)
    {
        INode* target = GetTarget();

        // Do we have a new target? 
        if (target != prevTarget)
        {
            // Recompute the distance
            // Use 0.0f for null targets
            float dist = 0.0f;
            if (target != NULL)
                dist = GetDistanceTo(previousPos, target);

            SetDistance(dist);

            // Compute the previous target
            prevTarget = target;
        }
    }

    PositionControlPlugin::OnParamChangeMsg(id);
}    

void ControllerTutorial::GetAbsoluteValue(TimeValue t, Point3& v, Interval& valid)
{
    // If no target is available, the value is the original position
    if (GetTarget(t) == NULL)
    {
        v = previousPos;
        return;
    }

    // Compute the target location
    // it is offset from the main location
    v = GetTargetPosition(t);
    Point3 delta = v - previousPos;

    // Normalize the delta 
    delta.Unify();

    // If after normalizing, we are left with a zero vector
    // we choose an arbitrary unit vector
    if (delta.Equals(Point3::Origin))
        delta.Set(1.0f, 1.0f, 1.0f);

    // Multiply by the distance parameter 
    delta *= GetDistance(t);

    // Compute the new location, by subtracting the delta
    v -= delta;

    // Update the previous position
    // Note that this position will not take into account any parent-child transforms
    previousPos = v;

    // Update the validity, based on the parameters.
    GetMainParamBlock()->GetValidity(t, valid);    
}

void ControllerTutorial::GetRelativeValue(TimeValue t, Matrix3& v, Interval& valid)
{
    // The relative position is the same as the absolute position
    Point3 pos(0,0,0);
    GetAbsoluteValue(t, pos, valid);

    // Update the matrix
    // For position controllers, we are supposed to pre-multiply the position
    v.PreTranslate(pos);

    // If we wanted to ignore the parent-child relation, we would just call 
    // v.SetTrans(pos)
}   

void ControllerTutorial::Copy(Control *from)
{
    // When assigning the controller to the object, this Copy method is
    // called immediately after the controller is created.
    // This initializes the value in the new controller with the
    // value of the old controller. This way, the position of the object
    // will not jump to some new location when assigning this controller
    // onto the object
    from->GetValue(Now(), &previousPos, FOREVER);
}

Point3 ControllerTutorial::GetTargetPosition(TimeValue t)
{
    INode* node = GetTarget(t);
    DbgAssert(node != NULL && "No targeted node");
    return GetNodeLocation(node, t);
}

Point3 ControllerTutorial::GetPreviousPosition()
{
    return previousPos;
}

void ControllerTutorial::SetDistance(float size, TimeValue t) 
{
    SetParameter(DISTANCE_PARAM_ID, size, t);
}

float ControllerTutorial::GetDistance(TimeValue t) 
{
    return GetParameter<float>(DISTANCE_PARAM_ID, t);
}

void ControllerTutorial::SetTarget(INode* node, TimeValue t)
{
    return SetParameter<INode*>(TARGET_PARAM_ID, node, t);
}

INode* ControllerTutorial::GetTarget( TimeValue t)
{
    return GetParameter<INode*>(TARGET_PARAM_ID, t);
}
