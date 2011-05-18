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
