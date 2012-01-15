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
#include "shaders.h"
#include "../../Shared/FXPlugin.h"

//============================================================
// Class descriptor declaration

class TemplateShaderClassDesc
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

class TemplateShader 
    : public FXPlugin<Shader>
{
    //============================================================
    // Fields

    // Use member fields only when data is not managed by the parameter block
    // or the reference manager. 
    TODO("Add member fields");

    //============================================================
    // Identifiers for chunks when loading and saving

    TODO("Add your own chunk ids");

    static const int TemplateShaderHeaderChunkID = 1;

public:
   
    //============================================================
    // Parameter IDs 

    TODO("Replace these with your own parameter IDs");

    static const ParamID FLOAT_PARAM_ID = 0;
    static const ParamID NODE_PARAM_ID = 1;

    //============================================================
    // Constructor/destructor

    TemplateShader()
		: FXPlugin<Shader>(TemplateShaderClassDesc::GetClassDescInstance())
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

    ~TemplateShader()
    { 
        TODO("Free any memory allocated here");
    }

    //============================================================
    // Animatable overrides 

    IOResult Save(ISave *isave) 
    { 
	    IOResult res;
	    isave->BeginChunk(TemplateShaderHeaderChunkID);
        
        TODO("Save any member fields");

        res = FXPlugin<Shader>::Save(isave);
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
			    case TemplateShaderHeaderChunkID:
        
                    TODO("Load any member fields");

                    res = FXPlugin<Shader>::Load(iload);
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
        ReferenceTarget* r = new TemplateShader();
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
        TemplateShader* source = dynamic_cast<TemplateShader*>(from);
        TemplateShader* target = dynamic_cast<TemplateShader*>(to);
        
        DbgAssert(source != NULL && "The source is not the expected type");
        DbgAssert(target != NULL && "The target is not the expected type");

        // Note: the reference manager automatically clones all references for us
        TODO("Copy any data fields from the source to the target");
                
        FXPlugin<Shader>::BaseClone(from, to, remap);
    }

    //=========================================================================
    // FXPlugin<Shader> overrides 

    //-------------------------------------------------------
    // BaseShader overrides 

    virtual ULONG GetRequirements(int subMtlNum)
    {
        TODO("Return the material requirements flags");
        return 0;
    }
    virtual ShaderParamDlg* CreateParamDialog(HWND hOldRollup, HWND hwMtlEdit, IMtlParams *imp, StdMat2 *theMtl, int rollupOpen, int n=0)
    {
        TODO("Create a parameter dialog");
        return NULL;
    }
    virtual ShaderParamDlg* GetParamDlg(int n=0)
    {
        TODO("Return a pointer to the ShaderParamDlg object which manages the user interface");
        return NULL;
    }
    virtual void SetParamDlg(ShaderParamDlg *newDlg, int n=0)
    {
        TODO("Store the parameter dialog");
    }
    virtual ULONG SupportStdParams()
    {
        TODO("Return a value which indicates which of the standard parameters are supported.");
        return STD_PARAM_NONE;
    }
    virtual void GetIllumParams(ShadeContext &sc, IllumParams &ip)
    {
        TODO("Update the channels(as well as other) data member of the IllumParams object.");
    }
    virtual void Illum(ShadeContext &sc, IllumParams &ip)
    {
        TODO("Perform the illumination");
    }
    virtual long nTexChannelsSupported()
    {
        TODO("Return the number of texture map map channels supported by this Shader."); 
        return 0;
    }
    virtual MSTR GetTexChannelName(long nTextureChan)
    {
        TODO("Return the name of the specified texture map channel.");
        return "";
    }
    virtual long ChannelType(long nTextureChan)
    {
        TODO("Return the channel type for the specified texture map channel.");
        return UNSUPPORTED_CHANNEL;
    }
    virtual long StdIDToChannel(long stdID)
    {
        TODO("Returns the index of the channel which corresponds to the specified standard material's texture map ID");
        return -1;
    }
    virtual void Reset()
    {
        TODO("Reset the shader parameters to their default values.");
    }

    //--------------------------------------------------------
    // Shader overrides

    virtual void CopyStdParams(Shader *pFrom)
    {
        TODO("Copy the standard parameters from the other shader");
    } 
    virtual void SetLockDS(BOOL lock)
    {
        TODO("Set or unset the diffuse / specular lock");
    } 
    virtual BOOL GetLockDS()
    {
        TODO("Return TRUE if the diffuse / specular lock is on; otherwise FALSE");
        return FALSE;
    } 
    virtual void SetLockAD(BOOL lock)
    {
        TODO("Set or unset the ambient / diffuse lock");
    } 
    virtual BOOL GetLockAD()
    {
        TODO("Return TRUE if the ambient / diffuse lock is set");
        return FALSE;
    } 
    virtual void SetLockADTex(BOOL lock)
    {
        TODO("Set or unset the ambient / diffuse texture lock");
    }
    virtual BOOL GetLockADTex()
    {
        TODO("Return TRUE if the ambient / diffuse lock texture is set");
        return FALSE;
    }
    virtual void SetSelfIllum(float v, TimeValue t)
    {
        TODO("Set the self-illumination parameter at the specified time");
    }
    virtual void SetSelfIllumClrOn(BOOL on)
    {
        TODO("Set the self illumination color on/off state.");
    }
    virtual void SetSelfIllumClr(Color c, TimeValue t)
    {
        TODO("Set the self illumination color at the specified time.");
    }
    virtual void SetAmbientClr(Color c, TimeValue t)
    {
        TODO("Set the ambient color at the specified time.");
    }
    virtual void SetDiffuseClr(Color c, TimeValue t)
    {
        TODO("Set the diffuse color at the specified time.");
    }
    virtual void SetSpecularClr(Color c, TimeValue t)
    {
        TODO("Set the specular color at the specified time.");
    }
    virtual void SetGlossiness(float v, TimeValue t)
    {
        TODO("Set the glossiness at the specified time.");
    }
    virtual void SetSpecularLevel(float v, TimeValue t)
    {
        TODO("Set the specular level at the specified time.");
    }
    virtual void SetSoftenLevel(float v, TimeValue t)
    {
        TODO("Set the soften specular highlights level at the specified time.");
    }
    virtual BOOL IsSelfIllumClrOn(int mtlNum, BOOL backFace)
    {
        TODO("Return TRUE if the self illumination color setting is on (checked); FALSE if off.");
        return FALSE;
    }
    virtual Color GetAmbientClr(int mtlNum, BOOL backFace)
    {
        TODO("Return the ambient color.");
        return Color(0,0,0);
    }
    virtual Color GetDiffuseClr(int mtlNum, BOOL backFace)
    {
        TODO("Return the diffuse color");
        return Color(0,0,0);
    }
    virtual Color GetSpecularClr(int mtlNum, BOOL backFace)
    {
        TODO("Return the specular color");
        return Color(0,0,0);
    }
    virtual Color GetSelfIllumClr(int mtlNum, BOOL backFace)
    {
        TODO("Return the self-illumination color");
        return Color(0,0,0);
    }
    virtual float GetSelfIllum(int mtlNum, BOOL backFace)
    {
        TODO("Return the self-illumination amount");
        return 0.0f;
    }
    virtual float GetGlossiness(int mtlNum, BOOL backFace)
    {
        TODO("Return the glossiness amount");
        return 0.0f;
    }
    virtual float GetSpecularLevel(int mtlNum, BOOL backFace)
    {
        TODO("Return the specular level");
        return 0.0f;
    }
    virtual float GetSoftenLevel(int mtlNum, BOOL backFace)
    {
        TODO("Return the soften specular highlights level");
        return 0.0f;
    }
    virtual BOOL IsSelfIllumClrOn()
    {
        TODO("Return whether the self-illumination color is on");
        return FALSE;
    }
    virtual Color GetAmbientClr(TimeValue t)
    {
        TODO("Return the ambient color at the specified time.");
        return Color(0,0,0);
    } 
    virtual Color GetDiffuseClr(TimeValue t)
    {
        TODO("Return the diffuse color at the specified time");
        return Color(0,0,0);   
    }
    virtual Color GetSpecularClr(TimeValue t)
    {
        TODO("Return the specular color at the specified time");
        return Color(0,0,0);   
    } 
    virtual float GetGlossiness(TimeValue t)
    {
        TODO("Return the glossiness at the specified time");
        return 0.0f;   
    }
    virtual float GetSpecularLevel(TimeValue t)
    {
        TODO("Return the specular level at the specified time");
        return 0.0f;   
    }
    virtual float GetSoftenLevel(TimeValue t)
    {
        TODO("Return the soften specular highlights level at the specified time");
        return 0.0f;   
    }
    virtual float GetSelfIllum(TimeValue t)
    {
        TODO("Return the self-illumination amount at the specified time");
        return 0.0f;   
    } 
    virtual Color GetSelfIllumClr(TimeValue t)
    {
        TODO("Return the self-illumination color at the specified time");
        return Color(0,0,0);   
    }

    //=========================================================================
    // AnimatablePlugin overrides

    virtual ClassDesc2* GetClassDesc()
    {
        return TemplateShaderClassDesc::GetClassDescInstance();
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
