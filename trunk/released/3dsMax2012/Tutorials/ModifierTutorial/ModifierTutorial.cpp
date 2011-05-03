//
// Copyright 2009 Autodesk, Inc.  All rights reserved.
//
// Use of this software is subject to the terms of the Autodesk license
// agreement provided at the time of installation or download, or which
// otherwise accompanies this software in either electronic or hard copy form.  
//

#include "ModifierTutorial.h"

// Static DLL handle
static HINSTANCE hDllInstance = 0; 

//==========================================================================
// Class descriptor implementation

int ModifierTutorialClassDesc::IsPublic() 
{ 
    return 1; 
} 
void* ModifierTutorialClassDesc::Create(BOOL loading) 
{ 
    return new ModifierTutorial(); 
} 
const MCHAR* ModifierTutorialClassDesc::ClassName() 
{ 
    return _M("Modifier tutorial"); 
} 
SClass_ID ModifierTutorialClassDesc::SuperClassID() 
{ 
    return OSM_CLASS_ID;
} 
Class_ID ModifierTutorialClassDesc::ClassID() 
{ 
    return MODIFIER_TUTORIAL_CLASS_ID; 
} 
const MCHAR* ModifierTutorialClassDesc::Category() 
{ 
    return SDK_TUTORIALS_CATEGORY; 
}  
const MCHAR* ModifierTutorialClassDesc::GetInternalName() 
{ 
    return _M("ModifierTutorial"); 
} 
HINSTANCE ModifierTutorialClassDesc::HInstance() 
{ 
    return hDllInstance; 
} 
ClassDesc2* ModifierTutorialClassDesc::GetInstance() 
{
    static ModifierTutorialClassDesc desc;
    return &desc;
}

//============================================================
// Define the static parameter block descriptor

static float BIGFLOAT = 999999.0f;

// This class derives from ParamBlockDesc2, but adds a number of convenience functions 
// for constructing parameter block descriptors incrementally.
// The ParamBlockDescUtil assumes the flags "P_AUTO_UI" and "P_AUTO_CREATE"

class ModifierTutorialParams
    : public ParamBlockDescUtil
{
private:
    //============================================================
    // Allows for a call back mechanism on GetValue / SetValue calls. You can check the value
    // being passed by PB2Value and to manipulate it as necessary.
    // Implement the check here for from/to crossover.  

    class BendPBAccessor : public PBAccessor
    {
    public:
		void Set(PB2Value& v, ReferenceMaker* owner, ParamID id, int /*tabIndex*/, TimeValue /*t*/)    // set from v
		{
			ModifierTutorial* u = dynamic_cast<ModifierTutorial*>(owner);
			if (u == NULL)
				return;

			float from;
			float to;

			switch (id)
			{
				case ModifierTutorial::FROM_PARAM_ID:				
					to = u->GetTo();
					from = v.f;
					if (from > to) 
						u->SetTo(from);
					break;

				case ModifierTutorial::TO_PARAM_ID:
					from = u->GetFrom();
					to = v.f;
					if (from > to) 
						u->SetFrom(to);
					break;
			}
		}
	};

    BendPBAccessor  bendPBAccessor;

public:        

    ModifierTutorialParams()
        : ParamBlockDescUtil(
				  ModifierTutorial::PBLOCK_ID
				, _M("ModifierTutorialParameters")
				, IDS_RB_PARAMETERS
				, ModifierTutorialClassDesc::GetInstance()
				, 0
				, 0 // Reference System ID for the Parameter Block
				, IDD_BENDPARAM
				, IDS_RB_PARAMETERS
				, NULL
				)
    {
        int id = ModifierTutorial::ANGLE_PARAM_ID;
        AddParam(id, _T("Angle"),	TYPE_FLOAT,	P_RESET_DEFAULT|P_ANIMATABLE, IDS_ANGLE, end);
		ParamOption(id, p_default,  0.0f, end);
		ParamOption(id, p_range,    -BIGFLOAT, BIGFLOAT, end);
		ParamOption(id, p_ui,       TYPE_SPINNER, EDITTYPE_FLOAT, IDC_ANGLE, IDC_ANGLESPINNER, 0.5f, end);

        id = ModifierTutorial::DIR_PARAM_ID;
        AddParam(id, _T("Direction"),	TYPE_FLOAT,	P_RESET_DEFAULT|P_ANIMATABLE, IDS_DIR, end);
		ParamOption(id, p_default,  0.0f, end);
		ParamOption(id, p_range,    -BIGFLOAT, BIGFLOAT, end);
		ParamOption(id, p_ui,       TYPE_SPINNER, EDITTYPE_FLOAT, IDC_DIR, IDC_DIRSPINNER, 0.5f, end);

        id = ModifierTutorial::AXIS_PARAM_ID;
        AddParam(id, _T("Axis"), TYPE_INT, P_RESET_DEFAULT,	IDS_AXIS, end);
		ParamOption(id, p_default,  2, end);
		ParamOption(id, p_ui,       TYPE_RADIO, 3,IDC_X,IDC_Y,IDC_Z, 
						p_vals,     0,1,2, end); // Notice here how p_vals is passed in with p_ui to ParamOption. 

		id = ModifierTutorial::FROM_TO_PARAM_ID;
        AddParam(id, _T("FromTo"), TYPE_BOOL, P_RESET_DEFAULT, IDS_FROMTO, end);
        ParamOption(id, p_default,  FALSE, end);
		ParamOption(id, p_ui,       TYPE_SINGLECHEKBOX, IDC_BEND_AFFECTREGION, end);

        id = ModifierTutorial::FROM_PARAM_ID;
        AddParam(id, _T("From"), TYPE_FLOAT, P_RESET_DEFAULT|P_ANIMATABLE, IDS_FROM, end);
		ParamOption(id, p_default,  0.0f, end);
		ParamOption(id, p_range,    -BIGFLOAT, 0.0f, end);
		ParamOption(id, p_ui,       TYPE_SPINNER, EDITTYPE_UNIVERSE, IDC_BEND_FROM, IDC_BEND_FROMSPIN, SPIN_AUTOSCALE, end);
		ParamOption(id, p_accessor, &bendPBAccessor, end);

        id = ModifierTutorial::TO_PARAM_ID;
        AddParam(id, _T("To"), TYPE_FLOAT, P_RESET_DEFAULT|P_ANIMATABLE, IDS_TO, end);
		ParamOption(id, p_default,	0.0f, end);
		ParamOption(id, p_range, 	0.0f, BIGFLOAT, end);
		ParamOption(id, p_ui,		TYPE_SPINNER, EDITTYPE_UNIVERSE, IDC_BEND_TO, IDC_BEND_TOSPIN, SPIN_AUTOSCALE, end);
		ParamOption(id, p_accessor, &bendPBAccessor, end);

        // Prevent further changes to the parameter block descriptor
        SetFinished(); 
    }

    // Create a parameter block descriptor
    static ModifierTutorialParams* GetInstance()
    {
        static ModifierTutorialParams desc;
        return &desc;
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
	return _T("Modifier tutorial plug-in project."); 
} 
__declspec( dllexport ) int LibNumberClasses() 
{ 
	return 1;  
} 
__declspec( dllexport ) ClassDesc2* LibClassDesc(int i) 
{ 
    return ModifierTutorialClassDesc::GetInstance();
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
    ModifierTutorialParams::GetInstance();
    return 1;
}
__declspec( dllexport ) ULONG LibShutdown() 
{ 
    return 1;
}

//==========================================================================================================
// ModifierTutorial implementations

ModifierTutorial::ModifierTutorial() : ModifierPlugin<Modifier>(ModifierTutorialClassDesc::GetInstance())
{
    // Ask the class descriptor to make the parameter blocks
    // This will trigger 3ds Max to call ReplaceReference with the 
    // constructed parameter block 
    ModifierTutorialClassDesc::GetInstance()->MakeAutoParamBlocks(this);
}

RefTargetHandle ModifierTutorial::Clone(RemapDir &remap) 
{        
    ModifierTutorial* r = new ModifierTutorial();
    BaseClone(this, r, remap);
    return r;
}

Deformer* ModifierTutorial::GetDeformer(TimeValue t, ModContext &mc, Matrix3& mat, Matrix3& invmat) 
{
    deformer = BendDeformer(t, mc, GetAngle(t), GetDirection(t),
        GetAxis(t), GetFrom(t), GetTo(t), GetFromTo(t), mat, invmat);
    return &deformer;
}

float ModifierTutorial::GetAngle(TimeValue t)
{
    return GetParameter<float>(ANGLE_PARAM_ID, t);
}

float ModifierTutorial::GetDirection(TimeValue t)
{
    return GetParameter<float>(DIR_PARAM_ID, t);
}

int ModifierTutorial::GetAxis(TimeValue t)
{
    return GetParameter<int>(AXIS_PARAM_ID, t);
}

float ModifierTutorial::GetFrom(TimeValue t)
{
    return GetParameter<float>(FROM_PARAM_ID, t);
}

float ModifierTutorial::GetTo(TimeValue t)
{
    return GetParameter<float>(TO_PARAM_ID, t);
}

void ModifierTutorial::SetFrom(float x, TimeValue t)
{
    SetParameter(FROM_PARAM_ID, x, t);
}

void ModifierTutorial::SetTo(float x, TimeValue t)
{
    SetParameter(TO_PARAM_ID, x, t);
}

BOOL ModifierTutorial::GetFromTo(TimeValue t)
{
    return GetParameter<BOOL>(FROM_TO_PARAM_ID, t);
}
