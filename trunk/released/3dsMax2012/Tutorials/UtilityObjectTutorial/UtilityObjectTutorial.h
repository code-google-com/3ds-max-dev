//
// Copyright 2010 Autodesk, Inc.  All rights reserved.
//
// Use of this software is subject to the terms of the Autodesk license
// agreement provided at the time of installation or download, or which
// otherwise accompanies this software in either electronic or hard copy form.  
//

#pragma once

#include "resource.h"
#include "../../Shared/Common.h"
#include "utilapi.h"

const Class_ID UTILITY_OBJECT_TUTORIAL_CLASS_ID = Class_ID(0x3ca845c0, 0x2fdc768f);

//============================================================
// Class descriptor declaration

/**
 * The class descriptor for the UtilityObjectTutorial,
 */
class UtilityObjectTutorialClassDesc
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
    static ClassDesc2* GetInstance();
}; 

//============================================================
// The plug-in definition

/** 
 * This plug-in implements a simple utility that provides a single
 * button, which when pressed displays a message box to the user. 
 * The following concepts are demonstrated:
 * \li Implementing UtilityObj derived plug-ins
 */
class UtilityObjectTutorial 
    : public UtilityPlugin<UtilityObj>
{
    //============================================================
    // Fields

    HWND m_hPanel;

public:
   
    //============================================================
    // Constructor/destructor

    UtilityObjectTutorial();

    //=========================================================================
    // Dialog procedures 

    static INT_PTR CALLBACK DlgProc(HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam);	

    //=========================================================================
    // UtilityPlugin<UtilityObj> overrides 

    virtual void BeginEditParams(Interface *ip, IUtil *iu);
    virtual void EndEditParams (Interface *ip, IUtil *iu);
    virtual void SelectionSetChanged (Interface *ip, IUtil *iu);   
    virtual void DeleteThis();
};

//======================================================================
