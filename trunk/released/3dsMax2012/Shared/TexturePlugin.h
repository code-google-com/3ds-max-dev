//
// Copyright 2010 Autodesk, Inc.  All rights reserved.
//
// Use of this software is subject to the terms of the Autodesk license
// agreement provided at the time of installation or download, or which
// otherwise accompanies this software in either electronic or hard copy form.  
//

#pragma once

#include "MtlBasePlugin.h"

/**
 * A base-class for both 2D and 3D textures. It manages ParamDlgs
 * for both UVGen and XYZGen. 
 */
template<typename Base_T>
class TexturePlugin
    : public MtlBasePlugin<Base_T>
{
    // Note: these fields may get deleted (i.e. invalidated) at some arbitrary 
    // point by 3ds Max. They are only used in DlgSetThing.
    // This is slightly inefficient, because both all maps whether they are 
    // 2D or 3D will have access to both. This is inconsequential, and putting 
    // them here, reduce complexity in those classes. Besides, if you wanted 
    // you can now create a texture map that is both 2D and 3D.
    ParamDlg* dlgUVGen;
    ParamDlg* dlgXYZGen;
    
public:

    //===========================================================================
    // Constructor

    TexturePlugin(ClassDesc2* classDesc) 
        : MtlBasePlugin(classDesc), dlgUVGen(NULL), dlgXYZGen(NULL)
    {
    }

    //===========================================================================
    // MtlBase overrides

    /// \name MtlBase Overrides
    //@{
    virtual ParamDlg* CreateParamDlg(HWND hwMtlEdit, IMtlParams *imp) 
    {
        IAutoMParamDlg* masterDlg = 
            dynamic_cast<IAutoMParamDlg*>(MtlBasePlugin::CreateParamDlg(hwMtlEdit, imp));
        DbgAssert(masterDlg != NULL);

        if (GetTheUVGen() != NULL)
        {
            dlgUVGen = GetTheUVGen()->CreateParamDlg(hwMtlEdit, imp);
            masterDlg->AddDlg(dlgUVGen);
        }

        if (GetTheXYZGen() != NULL)
        {
            dlgXYZGen = GetTheXYZGen()->CreateParamDlg(hwMtlEdit, imp);
            masterDlg->AddDlg(dlgXYZGen);
        }

	    return masterDlg;
    }  
    //@}

    //===========================================================================
    // Texmap overrides

    /// \name Texmap Overrides
    //@{
    /**
     * \see         Texmap::SetDlgThing()
     * 
     * \param       dlg An argument of type ParamDlg *.
     * \return      Returns a value of type BOOL.
     */
    virtual BOOL SetDlgThing(ParamDlg* dlg)
    {
	    if (dlg == dlgUVGen)
        {
		    dlgUVGen->SetThing(GetTheUVGen());
    	    return TRUE;
        }
	    else if (dlg == dlgXYZGen)
        {
            dlgXYZGen->SetThing(GetTheXYZGen());
    	    return TRUE;
        }
		else 
        {
            return FALSE;
        }
    }

    /**
     * Resets the validity interval and calls reset on the UVGen 
     * and XYZGen
     * 
     * \see         MtlBasePlugin::Reset() 
     */
    virtual void Reset()
    {
        if (GetTheUVGen() != NULL)
            GetTheUVGen()->Reset();
        if (GetTheXYZGen() != NULL)
            GetTheXYZGen()->Reset();
        MtlBasePlugin::Reset();
    }
    //@}
};
    
