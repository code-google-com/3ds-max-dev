/* Copyright (c) 2011, Autodesk 
   All rights reserved.

   Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

  Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
  Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
  Neither the name of Autodesk or the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#pragma once

#include "resource.h"
#include "../../Shared/Common.h"

//============================================================
// Class descriptor declaration

class TemplateSplineShapeClassDesc
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

class TemplateSplineShape 
    : public AnimatablePlugin<ShapeObject>
{
    //============================================================
    // Fields

    // Use member fields only when data is not managed by the parameter block
    // or the reference manager. 
    TODO("Add member fields");

    //============================================================
    // Identifiers for chunks when loading and saving

    TODO("Add your own chunk ids");

    static const int TemplateSplineShapeHeaderChunkID = 1;

public:
   
    //============================================================
    // Parameter IDs 

    TODO("Replace these with your own parameter IDs");

    static const ParamID FLOAT_PARAM_ID = 0;
    static const ParamID NODE_PARAM_ID = 1;

    //============================================================
    // Constructor/destructor

    TemplateSplineShape()
		: AnimatablePlugin<ShapeObject>(TemplateSplineShapeClassDesc::GetClassDescInstance())
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

    ~TemplateSplineShape()
    { 
        TODO("Free any memory allocated here");
    }

    //============================================================
    // Animatable overrides 

    IOResult Save(ISave *isave) 
    { 
	    IOResult res;
	    isave->BeginChunk(TemplateSplineShapeHeaderChunkID);
        
        TODO("Save any member fields");

        res = AnimatablePlugin<ShapeObject>::Save(isave);
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
			    case TemplateSplineShapeHeaderChunkID:
        
                    TODO("Load any member fields");

                    res = AnimatablePlugin<ShapeObject>::Load(iload);
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
        ReferenceTarget* r = new TemplateSplineShape();
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
        TemplateSplineShape* source = dynamic_cast<TemplateSplineShape*>(from);
        TemplateSplineShape* target = dynamic_cast<TemplateSplineShape*>(to);
        
        DbgAssert(source != NULL && "The source is not the expected type");
        DbgAssert(target != NULL && "The target is not the expected type");

        // Note: the reference manager automatically clones all references for us
        TODO("Copy any data fields from the source to the target");
                
        AnimatablePlugin<ShapeObject>::BaseClone(from, to, remap);
    }

    //=========================================================================
    // AnimatablePlugin<ShapeObject> overrides 

    //------------------------------------------------
    // Object overrides 
    
    virtual ObjectState Eval(TimeValue t)
    {
        return ObjectState(this);
    }

    //------------------------------------------------
    // BaseObject overrides 
    
    virtual CreateMouseCallBack* GetCreateMouseCallBack() 
    {
        TODO("Return a custom mouse call back object");
        return NULL;
    }

    //------------------------------------------------
    // ShapeObject overrides 

    virtual int NumberOfCurves()
    {
        TODO("Return the number of curves");
        return 1;
    }
    virtual BOOL CurveClosed (TimeValue t, int curve)
    {
        TODO("Return TRUE if the specified curve is closed");
        return FALSE;
    }
    virtual Point3 InterpCurve3D (TimeValue t, int curve, float param, int ptype=PARAM_SIMPLE)
    {
        TODO("Return a point interpolated to the curve");
        return Point3(0,0,0);
    }
    virtual Point3 TangentCurve3D (TimeValue t, int curve, float param, int ptype=PARAM_SIMPLE)
    {
        TODO("Return a tangent vector interpolated on the entire curve");
        return Point3(0,0,0);
    }
    virtual float LengthOfCurve (TimeValue t, int curve)
    {
        TODO("Return the length of the specified curve");
        return 0.0f;
    }
    virtual int NumberOfPieces (TimeValue t, int curve)
    {
        TODO("Return the number of sub-curves");
        return 0;
    }
    virtual Point3 InterpPiece3D(TimeValue t, int curve, int piece, float param, int ptype=PARAM_SIMPLE)
    {
        TODO("Return an interpolated point along the specified sub-curve");
        return Point3(0,0,0);
    }
    virtual Point3 TangentPiece3D(TimeValue t, int curve, int piece, float param, int ptype=PARAM_SIMPLE)
    {
        TODO("Return a tangent vector on a sub-curve at the specified 'distance' along the curve.");
        return Point3(0,0,0);
    }
    virtual ShapeHierarchy& OrganizeCurves(TimeValue t, ShapeHierarchy *hier=NULL)
    {
        TODO("Return a shape hierarchy");
        static ShapeHierarchy local = *hier;
        return local;
    }
    virtual void MakePolyShape(TimeValue t, PolyShape &shape, int steps=PSHAPE_BUILTIN_STEPS, BOOL optimize=FALSE)
    {
        TODO("Create a PolyShape representation");
    }
    virtual int MakeCap(TimeValue t, MeshCapInfo &capInfo, int capType)
    {
        TODO("Generate mesh capping info");
        return 0;
    }

    //=========================================================================
    // AnimatablePlugin overrides

    virtual ClassDesc2* GetClassDesc()
    {
        return TemplateSplineShapeClassDesc::GetClassDescInstance();
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
