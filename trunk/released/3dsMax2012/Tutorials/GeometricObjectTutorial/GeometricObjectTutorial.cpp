//
// Copyright 2010 Autodesk, Inc.  All rights reserved.
//
// Use of this software is subject to the terms of the Autodesk license
// agreement provided at the time of installation or download, or which
// otherwise accompanies this software in either electronic or hard copy form.  
//

#include "GeometricObjectTutorial.h"

// Static Dll handle
static HINSTANCE hDllInstance = 0; 

//==========================================================================
// Class descriptor implementation

int GeometricObjectTutorialClassDesc::IsPublic() 
{ 
    return 1; 
} 
void* GeometricObjectTutorialClassDesc::Create(BOOL loading) 
{ 
    return new GeometricObjectTutorial(); 
} 
const MCHAR* GeometricObjectTutorialClassDesc::ClassName() 
{ 
    return _M("Object Demo"); 
} 
SClass_ID GeometricObjectTutorialClassDesc::SuperClassID() 
{ 
    return GEOMOBJECT_CLASS_ID;
} 
Class_ID GeometricObjectTutorialClassDesc::ClassID() 
{ 
    return GEOMETRIC_OBJECT_TUTORIAL_CLASS_ID; 
} 
const MCHAR* GeometricObjectTutorialClassDesc::Category() 
{ 
    return SDK_TUTORIALS_CATEGORY; 
}  
const MCHAR* GeometricObjectTutorialClassDesc::GetInternalName() 
{ 
    return _M("GeometricObjectTutorial"); 
} 
HINSTANCE GeometricObjectTutorialClassDesc::HInstance() 
{ 
    return hDllInstance; 
} 
ClassDesc2* GeometricObjectTutorialClassDesc::GetInstance() 
{
    static GeometricObjectTutorialClassDesc desc;
    return &desc;
}

//============================================================
// Define the static parameter block descriptor

// The ParamBlockDescUtil assumes the flags "P_AUTO_UI" and "P_AUTO_CREATE"
class GeometricObjectTutorialParams
    : public ParamBlockDescUtil
{
public:        
    GeometricObjectTutorialParams()
        : ParamBlockDescUtil(
			0,
			_M("GeometricObjectTutorialParameters"),
            IDS_PARAMS, 
			GeometricObjectTutorialClassDesc::GetInstance(),  
			0,
			0,
			IDD_PANEL, 
			IDS_TITLE,
			NULL)
    {
        // Adds a float parameter, with a spinner UI
        AddFloatSpinnerParam(GeometricObjectTutorial::SIZE_PARAM_ID, _M("Size"), IDS_FLOAT_PARAM, 0.0f, 1000.0f, 0.0f, IDC_PARAM_EDIT, IDC_PARAM_SPIN);

        // Prevent further changes to the parameter block descriptor
        SetFinished(); 
    }


    // Create a parameter block descriptor
    static GeometricObjectTutorialParams* GetInstance()
    {
        static GeometricObjectTutorialParams pblockdesc;
        return &pblockdesc;
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
    return _T("Geometric Object template plug-in project.");
} 
__declspec( dllexport ) int LibNumberClasses() 
{ 
    return 1;  
} 
__declspec( dllexport ) ClassDesc2* LibClassDesc(int i) 
{ 
    return GeometricObjectTutorialClassDesc::GetInstance();
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
    GeometricObjectTutorialParams::GetInstance();
    return 1;
}
__declspec( dllexport ) ULONG LibShutdown() 
{ 
    return 1;
}

//============================================================

/** 
 * A call-back function class for creation of objects via the mouse.
 */
class GeometricMouseCallBack 
    : public CreateMouseCallBack 
{
    GeometricObjectTutorial* object;	///< Pointer to the object 
    IPoint2 sp0;	///< First point in screen coordinates
    Point3 wp0;		///< First point in world coordinates
    Point3 wp1;		///< We added this point. Second point in world coordinates.

public:	

    GeometricMouseCallBack()
        : object(NULL)
    { }

    void SetObject(GeometricObjectTutorial* obj)
    {
        object = obj;
    }

    int proc(ViewExp *vpt, int msg, int point, int flags, IPoint2 m, Matrix3& mat)
    {
        switch (msg)
        {
            // Occurs if the right mouse button is clicked
        case MOUSE_ABORT:
            return CREATE_ABORT;

            // Occurs if the left mouse button is clicked
        case MOUSE_POINT :
            if (point == 0)
            {
                sp0 = m;
                wp0 = vpt->SnapPoint(m,m,NULL,SNAP_IN_PLANE);
                mat.SetTrans(wp0);
                return CREATE_CONTINUE;
            }
            else 
            {
                // Do not create 0 sized objects 
                if (object->GetSize() == 0)
                    return CREATE_ABORT;

                // Otherwise we are done creating.
                return CREATE_STOP;
            }

            // Occurs if the mouse is moved 
        case MOUSE_MOVE :

            if (point == 0)
            {
                // Should never happen. Only the MOUSE_POINT 
                // message should be accompanied with the point parameter 
                // equal to zero
            }
            else if (point == 1)
            {
                wp1 = vpt->SnapPoint(m,m,NULL,SNAP_IN_PLANE);

                // Compute the size. 
                const float scalingFactor = 24.0f;       				
                float size = Length(wp1 - wp0) / scalingFactor;

                //Set the overall size in parameter block
                object->SetSize(size);                        
                return CREATE_CONTINUE;
            }
            else 
            {
                // Do not create 0 sized objects 
                if (object->GetSize() == 0)
                    return CREATE_ABORT;

                // Otherwise we are done creating.
                return CREATE_STOP;
            }

        case MOUSE_DBLCLICK :
        case MOUSE_INIT :
        case MOUSE_UNINIT :
        case MOUSE_FREEMOVE :
        case MOUSE_KEYBOARD :
        case MOUSE_PROPCLICK :
        case MOUSE_SNAPCLICK :
        default:
            return CREATE_CONTINUE;
        }
    }
};

//==========================================================================
// GeometricObjectTutorial implementation

CreateMouseCallBack* GeometricObjectTutorial::GetCreateMouseCallBack()
{
    // This function must return a mouse call-back object that is valid 
    // longer than the lifetime of the plug-in. The easiest way to do this
    // is to declare a static variable
    static GeometricMouseCallBack mouseCB;
    mouseCB.SetObject(this);
    return &mouseCB;
}

GeometricObjectTutorial::GeometricObjectTutorial() : ObjectPlugin<GeomObject>(GeometricObjectTutorialClassDesc::GetInstance())
{
    // Ask the class descriptor to make the parameter blocks
    // This will trigger 3ds Max to call ReplaceReference with the 
    // constructed parameter block 
    GeometricObjectTutorialClassDesc::GetInstance()->MakeAutoParamBlocks(this);
}

void GeometricObjectTutorial::BuildMesh( TimeValue t, Mesh& m )
{
    // The mesh is supposed to be always valid.
    // If values controlling the mesh are animated they will update the validity interval
    // when GetValue is called.
    GetValidityRef() = FOREVER;
    float size = GetSize();

    m.setNumVerts(4);
    m.setNumFaces(4);
    m.setVert(0, size * Point3(-10.0, 10.0, -10.0)); 
    m.setVert(1, size * Point3(0.0, -10.0, 0.0)); 
    m.setVert(2, size * Point3(10.0, 10.0, -10.0)); 
    m.setVert(3, size * Point3(0.0, 10.0, 10.0)); 

    m.faces[0].setVerts(0, 1, 2);
    m.faces[0].setEdgeVisFlags(1,1,1);
    m.faces[1].setVerts(1, 2, 3);
    m.faces[1].setEdgeVisFlags(1,1,1);
    m.faces[2].setVerts(0, 1, 3);
    m.faces[2].setEdgeVisFlags(1,1,1);
    m.faces[3].setVerts(0, 2, 3);
    m.faces[3].setEdgeVisFlags(1,1,1);

    m.InvalidateGeomCache();
}

RefTargetHandle GeometricObjectTutorial::Clone(RemapDir& remap) {
    ReferenceTarget* r = new GeometricObjectTutorial();
    BaseClone(this, r, remap);
    return r;
}

void GeometricObjectTutorial::SetSize(float size, TimeValue t) 
{
    SetParameter(SIZE_PARAM_ID, size, t);
}

float GeometricObjectTutorial::GetSize(TimeValue t) 
{
    return GetParameter<float>(SIZE_PARAM_ID, t);
}
