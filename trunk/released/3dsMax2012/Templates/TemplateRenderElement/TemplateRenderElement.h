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
#include "../../Shared/FXPlugin.h"

//============================================================
// Class descriptor declaration

class TemplateRenderElementClassDesc
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

class TemplateRenderElement 
    : public FXPlugin<MaxBakeElement10>
{
    //============================================================
    // Fields

    // Use member fields only when data is not managed by the parameter block
    // or the reference manager. 
    TODO("Add member fields");

    //============================================================
    // Identifiers for chunks when loading and saving

    TODO("Add your own chunk ids");

    static const int TemplateRenderElementHeaderChunkID = 1;

public:
   
    //============================================================
    // Parameter IDs 

    TODO("Replace these with your own parameter IDs");

    static const ParamID FLOAT_PARAM_ID = 0;
    static const ParamID NODE_PARAM_ID = 1;

    //============================================================
    // Constructor/destructor

    TemplateRenderElement()
		: FXPlugin<MaxBakeElement10>(TemplateRenderElementClassDesc::GetClassDescInstance())
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

    ~TemplateRenderElement()
    { 
        TODO("Free any memory allocated here");
    }

    //============================================================
    // Animatable overrides 

    IOResult Save(ISave *isave) 
    { 
	    IOResult res;
	    isave->BeginChunk(TemplateRenderElementHeaderChunkID);
        
        TODO("Save any member fields");

        res = FXPlugin<MaxBakeElement10>::Save(isave);
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
			    case TemplateRenderElementHeaderChunkID:
        
                    TODO("Load any member fields");

                    res = FXPlugin<MaxBakeElement10>::Load(iload);
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
        ReferenceTarget* r = new TemplateRenderElement();
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
        TemplateRenderElement* source = dynamic_cast<TemplateRenderElement*>(from);
        TemplateRenderElement* target = dynamic_cast<TemplateRenderElement*>(to);
        
        DbgAssert(source != NULL && "The source is not the expected type");
        DbgAssert(target != NULL && "The target is not the expected type");

        // Note: the reference manager automatically clones all references for us
        TODO("Copy any data fields from the source to the target");
                
        FXPlugin<MaxBakeElement10>::BaseClone(from, to, remap);
    }

    //=========================================================================
    // FXPlugin<MaxBakeElement10> overrides 

    //-------------------------------------------
    // IRenderElement

    virtual void SetEnabled (BOOL enabled)
    {
        TODO("Enable or disable the texture renderer.");
    }
    virtual BOOL IsEnabled() const 
    {
        TODO("Return TRUE or FALSE depending if enabled or not");
        return TRUE;
    }
    virtual void SetFilterEnabled (BOOL filterEnabled)
    {
        TODO("Set the option of using the current AA filter or simple blending within the pixel.");
    }
    virtual BOOL IsFilterEnabled () const 
    {
        TODO("Returns TRUE if using the current AA filter or FALSE if only using simple blending within the pixel.");
        return FALSE;
    }
    virtual BOOL BlendOnMultipass() const 
    {
        TODO("Return whether this element type should be blended during multipass effects.");
        return FALSE;
    }
    virtual BOOL AtmosphereApplied() const 
    {
        TODO("Return TRUE if atmospheric effects are enabled, or FALSE otherwise.");
        return FALSE;
    }
    virtual BOOL ShadowsApplied() const 
    {
        TODO("Return TRUE if shadows are enabled, or FALSE otherwise.");
        return FALSE;
    }
    virtual void SetElementName(const MCHAR *newName)
    {
        TODO("Store the element name as it will appear in the render dialog.");
    }
    virtual const MCHAR* ElementName() const 
    {
        TODO("Return the element name, as it will appear in the render dialog.");
        return const_cast<TemplateRenderElement*>(this)->GetClassDesc()->ClassName();
    }
    virtual void SetPBBitmap(PBBitmap *&pPBBitmap) const 
    {
        TODO("Set the bitmap used as a rendering target.");
    }
    virtual void GetPBBitmap(PBBitmap *&pPBBitmap) const 
    {
        pPBBitmap = NULL;
        TODO("Return the bitmap used as a rendering target.");
    }
    virtual IRenderElementParamDlg* CreateParamDialog(IRendParams *ip) 
    {
        TODO("Return the render element parameter dialog");
        return GetClassDesc()->CreateParamDialogs(ip, this);
    }

    //---------------------------------------------------------
    // IRenderElement overrides 

    virtual void PostIllum(ShadeContext &sc, IllumParams &ip)
    {
        TODO("Compute the element and store the result in the ShadeContext's ShadeOutput.");
    }
    virtual void PostAtmosphere (ShadeContext &sc, float z, float prevZ)
    {
        TODO("Apply any atmospheric effects if applicable");
    }

    //---------------------------------------------------------
    // IMaxBakeElement overrides

    virtual void SetOutputSz(int xSz, int ySz)
    {
        TODO("Set the output size of the bitmap to be created.");
    }
    virtual void GetOutputSz(int &xSz, int &ySz) const 
    {
        TODO("Return the output size of the bitmap created.");    
    }
    virtual void SetFileName(const MCHAR *newName)
    {
        TODO("Store the file name.");
    }
    virtual const MCHAR* GetFileName() const 
    {
        TODO("Return the file name");
        return "";    
    }
    virtual void SetFileType(const MCHAR *newType)
    {
        TODO("Set the file type");
    }
    virtual const MCHAR* GetFileType() const 
    {
        TODO("Return the file type");
        return "";
    }
    virtual void SetFileNameUnique(BOOL on)
    {
        TODO("Set a flag on or off that indicates the plug-in should assure that the file name is unique.");
    }
    virtual BOOL IsFileNameUnique() const 
    {
        TODO("Return true if the flag is set to assure that the file name is unique.");
        return TRUE;
    }
    virtual void SetRenderBitmap(Bitmap *pBitmap)
    {
        TODO("Store the bitmap to render to");
    }
    virtual Bitmap* GetRenderBitmap() const 
    {
        TODO("Return the bitmap being rendered to.");
        return NULL;
    }
    virtual void SetLightApplied(BOOL on)
    {
        TODO("Store whether or not lighting is to be used during rendering.");
    }
    virtual BOOL IsLightApplied() const 
    {
        TODO("Return TRUE or FALSE depending on whether lighting is used during rendering.");
        return TRUE;
    }
    virtual void SetShadowApplied(BOOL on)
    {
        TODO("Store whether shadows are to be used or not.");
    }
    virtual BOOL IsShadowApplied() const 
    {
        TODO("Return TRUE or FALSE depending on whether shadows are to be applied.");
        return TRUE;
    }
    virtual void SetAtmosphereApplied(BOOL on)
    {
        TODO("Store whether atmospheric effects effects are used or not.");
    }
    virtual BOOL IsAtmosphereApplied() const
    {
        TODO("Return TRUE or FALSE depending on whether atmospheric effects are used or not.");
        return FALSE;
    }
    virtual int GetNParams() const 
    {
        TODO("Return the number of parameters");
        return 0;
    }
    virtual const MCHAR* GetParamName(int nParam)
    {
        TODO("Return the name of the n+1 parameter (parameters are indexed by one)");
        return "";
    } 
    virtual const int FindParamByName(MCHAR *name)
    {
        TODO("Return the index of parameter (starting counting from 1) with the given name");
        return 0;
    }
    virtual int GetParamType(int nParam)
    {
        TODO("Return the type of the n+1 parameter");
        return 0;
    }
    virtual int GetParamValue(int nParam)
    {
        TODO("Return the value of the n+1 parameter");
        return 0;
    }
    virtual void SetParamValue(int nParam, int newVal)
    {
        TODO("Set the value of the n+1 parameter");
    }

    //---------------------------------------------------------
    // MaxBakeElement8 overrides

    virtual FPValue GetParamFPValue(int nParam)
    {
        TODO("Return the n+1 parameter value");
        return FPValue();
    } 
    virtual void SetParamFPValue(int nParam, FPValue newVal)
    {
        TODO("Set the n+1 parameter value");
    }
    virtual FPValue GetParamFPValueMin(int nParam)
    {
        TODO("Return the minimum parameter value for the nth parameter");
        return FPValue();
    } 
    virtual FPValue GetParamFPValueMax(int nParam)
    {
        TODO("Return the maximum parameter value for the nth parameter");
        return FPValue();
    }

    //---------------------------------------------------------
    // MaxBakeElement10 overrides
    virtual AColor GetBackgroundColor()
    {
        TODO("Get the background color of the bitmap to be created.");
        return AColor(0,0,0);
    } 
    virtual void SetBackgroundColor (AColor color)
    {
        TODO("Set the background color.");    
    }

    //=========================================================================
    // AnimatablePlugin overrides

    virtual ClassDesc2* GetClassDesc()
    {
        return TemplateRenderElementClassDesc::GetClassDescInstance();
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
