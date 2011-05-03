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
#include "../../Shared/ObjectPlugin.h"

//============================================================
// Class descriptor declaration

class TemplateCameraClassDesc
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
    static ClassDesc2* GetClassDescInstance();
}; 

//============================================================
// The plug-in definition

class TemplateCamera 
	: public ObjectPlugin<CameraObject>
{
    //============================================================
    // Fields

    // Use member fields only when data is not managed by the parameter block
    // or the reference manager. 
    TODO("Add member fields");

    //============================================================
    // Identifiers for chunks when loading and saving

    TODO("Add your own chunk ids");

    static const int TemplateCameraHeaderChunkID = 1;

public:
   
    //============================================================
    // Parameter IDs 

    TODO("Replace these with your own parameter IDs");

    static const ParamID FLOAT_PARAM_ID = 0;
    static const ParamID NODE_PARAM_ID = 1;

    //============================================================
    // Constructor/destructor

    TemplateCamera()
        : ObjectPlugin<CameraObject>(TemplateCameraClassDesc::GetClassDescInstance())
    {         
        TODO("Initialize any member fields");

        // Register references. Note that the parameter block is already registered as a reference 
        // by the PluginBase class
        TODO("Call RegisterReference() for any references you want managed automatically");

        // Register sub-anims. All sub-anims must first be registered as references. Note that the 
        // parameter block is already registered as a reference by the PluginBase class
        TODO("Call RegisterSubAnim() for any managed references which are also sub-animatables");

        // Ask the class descriptor to make the parameter blocks
        // This will trigger 3ds Max to call ReplaceReference with the 
        // constructed parameter block 
        GetClassDesc()->MakeAutoParamBlocks(this);
    }

    ~TemplateCamera()
    { 
        TODO("Free any memory allocated here");
    }

    //============================================================
    // Animatable overrides 

    IOResult Save(ISave *isave) 
    { 
	    IOResult res;
	    isave->BeginChunk(TemplateCameraHeaderChunkID);
        
        TODO("Save any member fields");

        res = ObjectPlugin<CameraObject>::Save(isave);
	    if (res != IO_OK) return res;
	    isave->EndChunk();
	    return IO_OK;
	}	

    IOResult Load(ILoad *iload) 
    { 
	    IOResult res = IO_OK;
	    
        while (iload->OpenChunk() == IO_OK) 
        {
            int id = iload->CurChunkID();
		    switch(id)  
            {
			    case TemplateCameraHeaderChunkID:
        
                    TODO("Load any member fields");

                    res = ObjectPlugin<CameraObject>::Load(iload);
				    break;
			}
		    iload->CloseChunk();
		
            if (res != IO_OK) 
			    return res;
		}        

	    return IO_OK;
	}

    //============================================================
    // RefMaker overrides 

    // Do not call this function directly, it is for use by 3ds Max
    // If you wish to clone a plug-in you should use CloneRefHierarchy()
    virtual RefTargetHandle Clone(RemapDir& remap) 
    {
        ReferenceTarget* r = new TemplateCamera();
        BaseClone(this, r, remap);
        return r;
    }

    // Called automatically by SafeClone()
    virtual void BaseClone(ReferenceTarget* from, ReferenceTarget* to, RemapDir& remap)  
    {
        // Don't copy to or from a NULL pointer
        // and don't copy of the source and destination is the same
        if (!from || !to || from == to)
            return;

        // Cast to the correct types
        TemplateCamera* source = dynamic_cast<TemplateCamera*>(from);
        TemplateCamera* target = dynamic_cast<TemplateCamera*>(to);
        
        DbgAssert(source != NULL && "The source is not the expected type");
        DbgAssert(target != NULL && "The target is not the expected type");

        // Note: the reference manager automatically clones all references for us
        TODO("Copy any data fields from the source to the target");
                
        ObjectPlugin<CameraObject>::BaseClone(from, to, remap);
    }

    //=========================================================================
    // ObjectPlugin<CameraObject> overrides 

    virtual void BuildMesh(TimeValue t, Mesh& m) 
    {
        TODO("Build the mesh object");
    }
    virtual RefResult EvalCameraState(TimeValue time, Interval &valid, CameraState *cs)
    {
        TODO("Update the CameraState and validity interval at the specified time.");
        return REF_SUCCEED;
    }
    virtual void SetOrtho(BOOL b)
    {
        TODO("Set or unset orthographic projection mode");
    }
    virtual BOOL IsOrtho()
    {
        TODO("Return TRUE or FALSE depending on whether or not in orthographic projection mode");
        return FALSE;
    }
    virtual void SetFOV(TimeValue t, float f)
    {
        TODO("Set the field of view in radians at the specified time.");
    }
    virtual float GetFOV(TimeValue t, Interval &valid=Interval(0, 0))
    {
        TODO("Return the field of view in radians");
        return 45.0f;
    }
    virtual void SetTDist(TimeValue t, float f)
    {
        TODO("Set the target distance at the specified time.");        
    }
    virtual float GetTDist(TimeValue t, Interval &valid=Interval(0, 0))
    {
        TODO("Return the target distance at the specified time.");
        return 100.0f;
    }
    virtual int GetManualClip()
    {
        TODO("Return 1 if manual clipping is set for hither and yon distances, or 0 otherwise");
        return 0;
    }
    virtual void SetManualClip(int onOff)
    {
        TODO("Set or unset manual clipping at hither and yon distances");
    }
    virtual float GetClipDist(TimeValue t, int which, Interval &valid=Interval(0, 0))
    {
        TODO("Return the clipping distance.");
        if (which == CAM_HITHER_CLIP)
        {
            return 50.0f;
        }
        else // which == CAM_YON_CLIP
        {
            return 100.0f;
        }
    }
    virtual void SetClipDist(TimeValue t, int which, float val)
    {
        TODO("Set the clipping distance.");        
    }
    virtual void SetEnvRange(TimeValue time, int which, float f)
    {   
        TODO("Set the environment range distance");    
    }
    virtual float GetEnvRange(TimeValue t, int which, Interval &valid=Interval(0, 0))
    {
        TODO("Get the environment range distance");    
        if (which == ENV_NEAR_RANGE)
        {
            return 25.0f;
        }
        else // which == ENV_FAR_RANGE
        {
            return 200.0f;
        }
    }
    virtual void SetEnvDisplay(BOOL b, int notify=TRUE)
    {
        TODO("Set or unset the environment range.");
    }
    virtual BOOL GetEnvDisplay()
    {
        TODO("Return TRUE if displaying the environment range.");
        return FALSE;
    }
    virtual void RenderApertureChanged(TimeValue t)
    {
        TODO("Respond to a change the in the render aperture width.");
    }

    //=========================================================================
    // AnimatablePlugin overrides

    virtual ClassDesc2* GetClassDesc()
    {
        return TemplateCameraClassDesc::GetClassDescInstance();
    }

    //=========================================================================
    // Utility functions for accessing and settting the parameters. 

    TODO("Replace these with your own functions for accessing and setting any parameters");

    void SetFloat(float x, TimeValue t = Now()) 
    {
        SetParameter(FLOAT_PARAM_ID, x, t);
    }

    float GetFloat(TimeValue t = Now()) 
    {
        return GetParameter<float>(FLOAT_PARAM_ID, t);
    }

    void SetNode(INode* node, TimeValue t = Now())
    {
        return SetParameter<INode*>(NODE_PARAM_ID, node, t);
    }

    INode* GetNode(TimeValue t = Now())
    {
        return GetParameter<INode*>(NODE_PARAM_ID, t);
    }
};

//======================================================================
