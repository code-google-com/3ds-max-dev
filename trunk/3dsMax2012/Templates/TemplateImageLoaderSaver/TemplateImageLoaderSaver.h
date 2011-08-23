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

class TemplateImageLoaderSaverClassDesc
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
    // Returns a singleton instance of this class descriptor
    static ClassDesc2* GetClassDescInstance();
}; 

//============================================================
// The plug-in definition

class TemplateImageLoaderSaver 
    : public UtilityPlugin<BitmapIO>
{
    //============================================================
    // Fields

    // Use member fields only when data is not managed by the parameter block
    // or the reference manager. 
    TODO("Add member fields");

public:
   
    //============================================================
    // Constructor/destructor

    TemplateImageLoaderSaver()
        : UtilityPlugin<BitmapIO>()
    {         
        TODO("Initialize any member fields");
    }

    ~TemplateImageLoaderSaver()
    { 
        TODO("Free any memory allocated here");
    }

    //=========================================================================
    // UtilityPlugin<BitmapIO> overrides 

    virtual unsigned int Version ()
    {
        TODO("Return the version number, where 3.01 is counted as 301")
        return 100;
    }
    virtual int ExtCount()
    {
        TODO("return the number of extensions");
        return 1; 
    }
    virtual const MCHAR* Ext(int n)
    {
        TODO("return the nth file extensionm, without leading dot");
        return _M("txt");
    }
    virtual const MCHAR* LongDesc()
    {
        TODO("Return a long description of the file type");
        return "ASCII text files";
    }
    virtual const MCHAR* ShortDesc()
    {
        TODO("Return a short description of the file type");
        return "Text";
    }
    virtual const MCHAR* AuthorName()
    {
        TODO("Return the author name");
        return "";
    }
    virtual const MCHAR* CopyrightMessage()
    {
        TODO("Return the copyright message");
        return "";
    }
    virtual void ShowAbout(HWND hWnd)
    {
        TODO("Display an about box");
    }
    virtual BOOL LoadConfigure (void *ptr)
    {
        TODO("Load any configuration data");
        return TRUE;
    }
    virtual BOOL SaveConfigure (void *ptr)
    {
        TODO("Save any configuration data");
        return TRUE;
    }
    virtual DWORD EvaluateConfigure()  
    {
        TODO("Return the number of bytes needed by the plug-in to save configuration data");
        return 0;
    }
    virtual BitmapStorage* Load(BitmapInfo *bi, Bitmap *map, BMMRES *status)
    {
        TODO("Load the bitmap and return a BitmapStorage class");
        return NULL;
    }
    virtual BMMRES GetImageInfo(BitmapInfo* bi)
    {
        TODO("Set the bitamp info values");
        // A sample implementation
        bi->SetWidth(640);
        bi->SetHeight(480);
        bi->SetType(BMM_TRUE_24);
        bi->SetAspect(1.0f);
        bi->SetGamma(1.0f);
        bi->SetFirstFrame(0);
        bi->SetLastFrame(0);
        return BMMRES_SUCCESS;
    }
    virtual int Capability()
    {
        TODO("Return capability flags");
        return BMMIO_NONE;
    }

    //=========================================================================
    // UtilityPlugin overrides

    virtual ClassDesc2* GetClassDesc()
    {
        return TemplateImageLoaderSaverClassDesc::GetClassDescInstance();
    }
};

//======================================================================
