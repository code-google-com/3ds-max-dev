//
// Copyright 2010 Autodesk, Inc.  All rights reserved.
//
// Use of this software is subject to the terms of the Autodesk license
// agreement provided at the time of installation or download, or which
// otherwise accompanies this software in either electronic or hard copy form.  
//

#include "CameraTutorial.h"
#include "CameraMesh.h"

// Static DLL handle
static HINSTANCE hDllInstance = 0; 

//==========================================================================
// Class descriptor implementation

int CameraTutorialClassDesc::IsPublic() 
{ 
    return 1; 
} 
void* CameraTutorialClassDesc::Create(BOOL loading) 
{ 
    return new CameraTutorial(); 
} 
const MCHAR* CameraTutorialClassDesc::ClassName() 
{ 
    return _M("Camera plug-in"); 
} 
SClass_ID CameraTutorialClassDesc::SuperClassID() 
{ 
    return CAMERA_CLASS_ID;
} 
Class_ID CameraTutorialClassDesc::ClassID() 
{ 
    return CAMERA_TUTORIAL_CLASS_ID; 
} 
const MCHAR* CameraTutorialClassDesc::Category() 
{ 
    return SDK_TUTORIALS_CATEGORY; 
}  
const MCHAR* CameraTutorialClassDesc::GetInternalName() 
{ 
    return _M("CameraTutorial"); 
} 
HINSTANCE CameraTutorialClassDesc::HInstance() 
{ 
    return hDllInstance; 
} 
ClassDesc2* CameraTutorialClassDesc::GetInstance() 
{
    static CameraTutorialClassDesc desc;
    return &desc;
}

//============================================================
// Define the static parameter block descriptor

// This class derives from ParamBlockDesc2, but adds a number of convenience functions 
// for constructing parameter block descriptors incrementally.
// The ParamBlockDescUtil assumes the flags "P_AUTO_UI" and "P_AUTO_CREATE"
class CameraTutorialParams
    : public ParamBlockDescUtil
{
public:        
    CameraTutorialParams()
        : ParamBlockDescUtil(
			0, 
			_M("CameraTutorialParameters"),
			IDS_PARAMS,
			CameraTutorialClassDesc::GetInstance(), 
			0,
			0,
            IDD_PANEL, 
			IDS_PARAMS, 
			0)
    {
        // Adds a float parameter, with a spinner UI
        AddAngleSpinnerParam(CameraTutorial::FOV_PARAM_ID, _T("fov"), IDS_FOV, 0.000025f, 179.0f, CameraTutorial::DefaultAngle(), IDC_PARAM1_EDIT, IDC_PARAM1_SPIN);

        // Adds a float parameter, with a spinner UI
        AddFloatSpinnerParam(CameraTutorial::DISTANCE_PARAM_ID, _T("distance"), IDS_DISTANCE, 0.000025f, 10000.0f, CameraTutorial::DefaultDistance(), IDC_PARAM2_EDIT, IDC_PARAM2_SPIN);

        // Prevent further changes to the parameter block descriptor
        SetFinished(); 
    }

    // Create a parameter block descriptor
    static CameraTutorialParams* GetInstance()
    {
        static CameraTutorialParams pblockdesc;
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
	return _T("Camera tutorial plug-in project."); 
} 
__declspec( dllexport ) int LibNumberClasses() 
{ 
	return 1;  
} 
__declspec( dllexport ) ClassDesc2* LibClassDesc(int i) 
{ 
	return CameraTutorialClassDesc::GetInstance();
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
    CameraTutorialParams::GetInstance();
    return 1;
}
__declspec( dllexport ) ULONG LibShutdown() 
{ 
    return 1;
}

//==================================================================================================
// CameraTutorial 

CameraTutorial::CameraTutorial() : ObjectPlugin<GenCamera>(CameraTutorialClassDesc::GetInstance())
{
    state.farRange = 1000.0f;
    state.fov = DefaultAngle();
    state.hither = 1.0f;
    state.horzLine = FALSE;
    state.yon = 1000.0f;
    state.manualClip = FALSE;
    state.nearRange = 0.0f;
    state.tdist = DefaultDistance();

    ext.bEnvRangeDisplay = FALSE;
    ext.bConeState = TRUE;
    ext.bEnabled = TRUE;
    ext.cameraType = FREE_CAMERA;
    ext.bDOFEnable = TRUE;
    ext.fDOFFStop = 2.0f;
    ext.fovType = FOV_W;

    source = NULL;

    // Ask the class descriptor to make the parameter blocks
    // This will trigger 3ds Max to call ReplaceReference with the 
    // constructed parameter block 
    CameraTutorialClassDesc::GetInstance()->MakeAutoParamBlocks(this);
}

void CameraTutorial::BeginEditParams(IObjParam *ip, ULONG flags, Animatable *prev) 
{   
    ObjectPlugin::BeginEditParams(ip, flags, prev);                
    AddButtonPressHandler();
}

void CameraTutorial::EndEditParams(IObjParam* ip, ULONG flags, Animatable *next)
{
    ip->ClearPickMode();
    ObjectPlugin::EndEditParams(ip, flags, next);
}

RefTargetHandle CameraTutorial::Clone(RemapDir& remap) 
{
    ReferenceTarget* r = new CameraTutorial();
    BaseClone(this, r, remap);
    return r;
}

CreateMouseCallBack* CameraTutorial::GetCreateMouseCallBack() 
{
    class CameraMouseCallBack 
        : public CreateMouseCallBack 
    {
        CameraTutorial* object;	// Pointer to the object 

    public:	

        CameraMouseCallBack()
            : object(NULL)
        { }

        void SetObject(CameraTutorial* obj)
        {
            object = obj;
        }

        int proc(ViewExp *vpt, int msg, int point, int flags, IPoint2 m, Matrix3& mat)
        {
            if (msg == MOUSE_FREEMOVE)
            {
                vpt->SnapPreview(m,m,NULL, SNAP_IN_3D);
            }
            else if (msg==MOUSE_POINT||msg==MOUSE_MOVE) 
            {
                if ( point == 0 )
                {
                    ULONG handle;

                    object->NotifyDependents( FOREVER, (PartID)&handle, REFMSG_GET_NODE_HANDLE );
                    INode* node = GetCOREInterface()->GetINodeByHandle( handle );

                    if ( node ) 
                    {
                        // we set the camera color to blue instead of the default random object color.
                        Point3 color = GetUIColor( COLOR_CAMERA_OBJ );
                        node->SetWireColor( RGB( color.x*255.0f, color.y*255.0f, color.z*255.0f ) );
                    }
                }

                mat.SetTrans( vpt->SnapPoint(m,m,NULL,SNAP_IN_3D) );
                if (point==1 && msg==MOUSE_POINT) 
                    return 0;
            }
            else if (msg == MOUSE_ABORT)
            {
                return CREATE_ABORT;
            }

            return CREATE_CONTINUE;
        }
    };

    // This function must return a mouse call-back object that is valid 
    // longer than the lifetime of the plug-in. The easiest way to do this
    // is to declare a static variable
    static CameraMouseCallBack mouseCB;
    mouseCB.SetObject(this);
    return &mouseCB;
}   

void CameraTutorial::BuildMesh(TimeValue t, Mesh& m)
{
    // This function is defined in CameraMesh.h for convenience
    BuildCameraMesh(m);
}

int CameraTutorial::HitTest(TimeValue t, INode* inode, int type, int crossing, int flags, IPoint2 *p, ViewExp *vpt) 
{
    if (!IsEnabled()) 
        return 0;

    HitRegion hitRegion;
    Matrix3 m;
    GraphicsWindow *gw = vpt->getGW();	
    MakeHitRegion(hitRegion, type, crossing, 4, p);	

    // Sets the renderer to GW_PICK_MODE, and restores it automatically
    // when the function terminates
    HitTestModeRAII hitTestHelper(gw);

    GetUnscaledMatrix(t,inode,vpt,m);
    gw->setTransform(m);

    return GetMesh().select( gw, gw->getMaterial(), &hitRegion, flags & HIT_ABORTONHIT ); 
}

int CameraTutorial::Display(TimeValue t, INode* inode, ViewExp *vpt, int flags) 
{
    if (!IsEnabled()) 
        return 0;

    Rect r = vpt->GetDammageRect();

    UpdateMesh(t);
    Matrix3 m;
    GraphicsWindow* gw = vpt->getGW();
    GetUnscaledMatrix(t, inode, vpt, m);
    gw->setTransform(m);
    DWORD rlim = gw->getRndLimits();
    gw->setRndLimits(GW_WIREFRAME|GW_EDGES_ONLY|GW_BACKCULL| (rlim & GW_Z_BUFFER) );

    Color color = inode->Selected() != 0
        ? Color(GetSelColor())
        : Color(inode->GetWireColor());

    gw->setColor( LINE_COLOR, color );	
    GetMesh().render( gw, gw->getMaterial(), NULL, COMP_ALL);	

    if (IsSelected())
        DrawCone(t, inode, gw);

    gw->setRndLimits(rlim);
    return 0;
}

void CameraTutorial::GetDeformBBox(TimeValue t, Box3& box, Matrix3 *tm, BOOL useSel )
{
    ObjectPlugin::GetDeformBBox(t, box, tm, useSel);
}

void CameraTutorial::GetWorldBoundBox(TimeValue t, INode* inode, ViewExp* vpt, Box3& box )
{
    UpdateMesh(t);
    Matrix3 m;
    GetUnscaledMatrix(t, inode, vpt, m);        

    int nv = GetMesh().getNumVerts();
    for (int i=0; i < nv; ++i)
        box += m * GetMesh().getVert(i);

    m = inode->GetObjectTM(t);

    Point3 q[4];
    if (IsSelected()) {
        float d = GetTDist(t);
        box += m * Point3(0.0f, 0.0f, -d);
        GetConePoints(t, q, GetTDist(t));
        box.IncludePoints(q, 4, &m);
    }

    // TODO: verify that this is unneeded and remove it
    box.EnlargeBy(10000.0f);
}

void CameraTutorial::GetLocalBoundBox(TimeValue t, INode* inode, ViewExp* vpt, Box3& box )
{
    UpdateMesh(t);
    Matrix3 m = inode->GetObjectTM(t);
    float scaleFactor = vpt->NonScalingObjectSize() * vpt->GetVPWorldWidth(m.GetTrans()) / 360.0f;
    box = GetMesh().getBoundingBox();
    box.Scale(scaleFactor);

    Point3 q[4];	    
    if (IsSelected()) {
        float d = GetTDist(t);
        box += Point3(0.0f, 0.0f, -d);
        GetConePoints(t, q, d);
        box.IncludePoints(q, 4);
    }	    

    // TODO: verify that this is unneeded and remove it
    box.EnlargeBy(10000.0f);
}

int CameraTutorial::DoOwnSelectHilite() {
    return TRUE;
}

BOOL CameraTutorial::HasViewDependentBoundingBox() { 
    return TRUE; 
}

BOOL CameraTutorial::UsesWireColor() {
    return TRUE;
}

RefResult CameraTutorial::EvalCameraState(TimeValue time, Interval& valid, CameraState* cs)
{
    state.fov = GetFOV(time, valid);
    state.tdist = GetTDist(time, valid);
    *cs = state;
    return REF_SUCCEED;
}

void CameraTutorial::SetOrtho(BOOL b)
{
    state.isOrtho = b;
}

BOOL CameraTutorial::IsOrtho()
{
    return state.isOrtho;
}

void CameraTutorial::SetFOV(TimeValue t, float f)
{
    GetMainParamBlock()->SetValue( FOV_PARAM_ID, t, f );
}

float CameraTutorial::GetFOV(TimeValue t, Interval& valid)
{
    float f = 0.0f;
    GetMainParamBlock()->GetValue( FOV_PARAM_ID, t, f, valid );
    return f;
}

void CameraTutorial::SetTDist(TimeValue t, float f)
{
    GetMainParamBlock()->SetValue( DISTANCE_PARAM_ID, t, f );
}

float CameraTutorial::GetTDist(TimeValue t, Interval& valid)
{
    float f = 0.0f;
    GetMainParamBlock()->GetValue( DISTANCE_PARAM_ID, t, f, valid );
    return f;
}

int CameraTutorial::GetManualClip()
{
    return state.manualClip;
}

void CameraTutorial::SetManualClip(int onOff)
{
    state.manualClip = onOff;
}

float CameraTutorial::GetClipDist(TimeValue t, int which, Interval &valid)
{
    if (which == CAM_HITHER_CLIP) {
        return state.hither;
    }
    else if (which == CAM_YON_CLIP) {
        return state.yon;
    }
    else {
        DbgError("Illegal parameter to GetClipDist");
        return 0.0f; 
    }
}

void CameraTutorial::SetClipDist(TimeValue t, int which, float val)
{
    if (which == CAM_HITHER_CLIP) {
        state.hither = val;
    }
    else if (which == CAM_YON_CLIP) {
        state.yon = val;
    }
    else {
        DbgError("Illegal parameter to SetClipDist");
    }
}

float CameraTutorial::GetEnvRange(TimeValue t, int which, Interval& valid)
{
    if (which == ENV_NEAR_RANGE) {
        return state.nearRange;
    }
    else if (which == ENV_FAR_RANGE) {
        return state.farRange;
    }
    else 
    {
        DbgError("Illegal parameter to GetEnvRange");
        return 0.0f; 
    }
}

void CameraTutorial::SetEnvRange(TimeValue time, int which, float f)
{
    if (which == ENV_NEAR_RANGE) {
        state.nearRange = f;
    }
    else if (which == ENV_FAR_RANGE) {
        state.farRange = f;
    }
    else 
    {
        DbgError("Illegal parameter to SetEnvRange");
    }
}

void CameraTutorial::SetEnvDisplay(BOOL b, int notify)
{
    ext.bEnvRangeDisplay = b;
}

BOOL CameraTutorial::GetEnvDisplay()
{
    return ext.bEnvRangeDisplay;
}

void CameraTutorial::RenderApertureChanged(TimeValue t)
{
    // Optional: Custom handling of render aperture change event
}

void CameraTutorial::UpdateTargDistance(TimeValue t, INode* inode) 
{ 
    // Optional: Handle change of distance to target
}

//=========================================================================
// Multi-pass effects

void CameraTutorial::SetMultiPassEffectEnabled(TimeValue t, BOOL enabled) 
{ 
    // Optional: turn on multi-pass effects
}

BOOL CameraTutorial::GetMultiPassEffectEnabled(TimeValue t, Interval& valid) 
{ 
    // Optional: return TRUE if handling on multi-pass effects
    return FALSE; 
}

void CameraTutorial::SetMPEffect_REffectPerPass(BOOL enabled) 
{ 
    // Optional: turn on multi-pass effects
}

BOOL CameraTutorial::GetMPEffect_REffectPerPass() 
{ 
    // Optional: return TRUE if handling on multi-pass effects
    return FALSE; 
}

IMultiPassCameraEffect* CameraTutorial::GetIMultiPassCameraEffect() 
{ 
    // Optional: return the multi-pass camera effect
    return NULL; 
}

GenCamera* CameraTutorial::NewCamera(int type)
{
    CameraTutorial* r = new CameraTutorial();
    r->SetType(type);
    return r;
}

void CameraTutorial::SetConeState(int s)
{
    ext.bConeState = s;
}

int CameraTutorial::GetConeState()
{
    return ext.bConeState;
}

void CameraTutorial::SetHorzLineState(int s)
{
    state.horzLine = s;
}

int CameraTutorial::GetHorzLineState()
{
    return state.horzLine;
}

void CameraTutorial::Enable(int enab)
{
    ext.bEnabled = enab;
}

BOOL CameraTutorial::IsEnabled()
{
    return ext.bEnabled;
}

BOOL CameraTutorial::SetFOVControl(Control *c)
{
    GetMainParamBlock()->SetControllerByID(FOV_PARAM_ID, 0, c);
    return TRUE;
}

Control* CameraTutorial::GetFOVControl() 
{
    return GetMainParamBlock()->GetControllerByID(FOV_PARAM_ID);
}

void CameraTutorial::SetFOVType(int ft)
{
    if (ft == FOV_W || ft == FOV_H || ft == FOV_D)
        ext.fovType = ft;
}

int CameraTutorial::GetFOVType()
{
    return ext.fovType;
}

int CameraTutorial::Type()
{
    return ext.cameraType;
}

void CameraTutorial::SetType(int tp)
{
    if (tp == FREE_CAMERA || tp == TARGETED_CAMERA || tp == PARALLEL_CAMERA) 
        ext.cameraType = tp;
}

void CameraTutorial::SetDOFEnable(TimeValue t, BOOL onOff) 
{
    ext.bDOFEnable = onOff;
}

BOOL CameraTutorial::GetDOFEnable(TimeValue t, Interval& valid) 
{ 
    return ext.bDOFEnable; 
}

void CameraTutorial::SetDOFFStop(TimeValue t, float fs) 
{
    ext.fDOFFStop = fs;
}

float CameraTutorial::GetDOFFStop(TimeValue t, Interval& valid) 
{ 
    return ext.fDOFFStop; 
}

void CameraTutorial::AddButtonPressHandler()
{
    class ButtonPressDlgProc 
        : public ParamMap2UserDlgProc
    {
        CameraTutorial* plugin;

    public:
        ButtonPressDlgProc(CameraTutorial* p) 
            : plugin(p)
        { }

        INT_PTR DlgProc(TimeValue t, IParamMap2 *map, HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam) {                 
            switch (msg) 
            {
            case WM_COMMAND:                    
                if (LOWORD(wParam) == IDC_LOOKAT_BUTTON)
                    plugin->OnLookAtPress();
                break;
            }
            return FALSE;
        }

        void DeleteThis() {
            delete this;
        }
    };

    GetMainParamBlock()->GetDesc()->SetUserDlgProc(new ButtonPressDlgProc(this));
}

void CameraTutorial::OnLookAtPress()
{
    source = GetSelectedSelfNode();
    if (source == NULL)
        return;
    GetCOREInterface()->SetPickMode(this);
}

int CameraTutorial::DrawCone(TimeValue t, INode* inode, GraphicsWindow *gw ) 
{
    Matrix3 tm = inode->GetObjectTM(t);
    gw->setTransform(tm);
    gw->clearHitCode();   

    Point3 q[4 + 1];
    GetConePoints(t, q, GetTDist(t));

    gw->setColor( LINE_COLOR, GetUIColor(COLOR_CAMERA_CONE));
    gw->polyline( 4, q, NULL, NULL, TRUE, NULL );	

    Point3 u[2 + 1];
    u[0] = Point3(0,0,0);
    for (int i=0; i < 4; i++) {
        u[1] = q[i];	
        gw->polyline( 2, u, NULL, NULL, FALSE, NULL );	
    }   

    return gw->checkHitCode();
}

void CameraTutorial::GetConePoints(TimeValue t, Point3* q, float dist) 
{
    const float MAXVP_DIST = 1.0e8f;  
    if (dist > MAXVP_DIST)
        dist = MAXVP_DIST;
    float ta = (float)tan(0.5*(double)GetFOV(t));
    float w = dist * ta;
    float h = w / GetAspect();
    q[0] = Point3( w, h,-dist);				
    q[1] = Point3(-w, h,-dist);				
    q[2] = Point3(-w,-h,-dist);				
    q[3] = Point3( w,-h,-dist);				
}

float CameraTutorial::GetNearEnvRange(TimeValue t)
{
    return GetEnvRange(t, ENV_NEAR_RANGE);
}

float CameraTutorial::GetFarEnvRange(TimeValue t)
{
    return GetEnvRange(t, ENV_FAR_RANGE);
}

float CameraTutorial::GetHitherClipDist(TimeValue t)
{
    return GetClipDist(t, CAM_HITHER_CLIP);
}

float CameraTutorial::GetYonClipDist(TimeValue t)
{
    return GetClipDist(t, CAM_YON_CLIP);
}

void CameraTutorial::OnObjectPicked(INode* node)
{ 
    if (node == NULL)
        return;
    if (source == NULL)
        return;
    float dist = GetDistanceBetween(source, node);
    SetTDist(Now(), dist);
    TurnNodeTowards(source, node);
    source = NULL;
}

