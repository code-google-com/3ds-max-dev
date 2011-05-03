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
#include "impexp.h"

//============================================================
// Class descriptor declaration

class TemplateFileImporterClassDesc
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

class TemplateFileImporter 
    : public UtilityPlugin<SceneImport>
{
    //============================================================
    // Fields

    // Use member fields only when data is not managed by the parameter block
    // or the reference manager. 
    TODO("Add member fields");

public:
   
    //============================================================
    // Constructor/destructor

    TemplateFileImporter()
        : UtilityPlugin<SceneImport>()
    {         
        TODO("Initialize any member fields");
    }

    ~TemplateFileImporter()
    { 
        TODO("Free any memory allocated here");
    }

    //=========================================================================
    // UtilityPlugin<SceneImport> overrides 

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
    virtual const MCHAR* OtherMessage1()
    {
        TODO("Return additional string to be displayed in the UI");
        return "";
    }
    virtual const MCHAR* OtherMessage2()
    {
        TODO("Return additional string to be displayed in the UI");
        return "";
    }
    virtual int DoImport(const MCHAR *name, ImpInterface *ii, Interface *i, BOOL suppressPrompts=FALSE)
    {
        TODO("Perform the import");
        return IMPEXP_FAIL;
    }

    //=========================================================================
    // UtilityPlugin overrides

    virtual ClassDesc2* GetClassDesc()
    {
        return TemplateFileImporterClassDesc::GetClassDescInstance();
    }
};

//======================================================================
