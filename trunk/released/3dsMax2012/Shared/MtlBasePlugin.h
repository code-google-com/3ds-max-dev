//
// Copyright 2010 Autodesk, Inc.  All rights reserved.
//
// Use of this software is subject to the terms of the Autodesk license
// agreement provided at the time of installation or download, or which
// otherwise accompanies this software in either electronic or hard copy form.  
//

#pragma once

//=========================================================================
// Provides default empty implementations of the MtlBase functions
// This class might be the base class of a TexMap or a Mtl derived plug-in

/**
 * A base-class for MtlBase derived plug-ins (e.g. TexMap or Mtl plug-ins). Provides 
 * some default empty implementation of functions, and manages a validity 
 * interval automatically. 
 * 
 * \see         MtlBase
 */
template<typename Base_T>
class MtlBasePlugin
    : public AnimatablePlugin<Base_T>
{
private:

    //===========================================================================
    // fields

    Interval ivalid;
    
public:

    //===========================================================================
    // Constructor / destructor

    MtlBasePlugin(ClassDesc2* classDesc) 
        : AnimatablePlugin(classDesc), ivalid()
    {
    }

    /// \name ReferenceTarget Overrides
    //@{
    /**
     * Copies the ivalid interval automatically. 
     * \note        Place important notes that you want emphasized here.
     * \see         ReferenceTarget::BaseClone()
     * 
     * \param       from An argument of type ReferenceTarget *.
     * \param       to An argument of type ReferenceTarget *.
     * \param       remap An argument of type RemapDir &.
     */
    virtual void BaseClone(ReferenceTarget* from, ReferenceTarget* to, RemapDir& remap) 
    {
        MtlBasePlugin* fromMtl = dynamic_cast<MtlBasePlugin*>(from);
        MtlBasePlugin* toMtl = dynamic_cast<MtlBasePlugin*>(to);
        if (fromMtl != NULL && toMtl != NULL)
            toMtl->ivalid = fromMtl->ivalid;
        AnimatablePlugin::BaseClone(from, to, remap);
    }

    //@}

    //===========================================================================
    // MtlBase overrides

    /// \name MtlBase Overrides
    //@{
    /**
     * Automatically creates a master parameter dialog.     
     * 
     * \see         Mtlbase::CreateParamDlg()
     * 
     * \param       hwMtlEdit An argument of type HWND.
     * \param       imp An argument of type IMtlParams *.
     * \return      Returns a value of type ParamDlg *.
     */
    virtual ParamDlg* CreateParamDlg(HWND hwMtlEdit, IMtlParams *imp) 
    {
        IAutoMParamDlg* masterDlg = GetClassDesc()->CreateParamDlgs(hwMtlEdit, imp, this);   	
	    return masterDlg;
    }  

    /**
     * Computes the validity interval automatically based on all
     * references that are MtlBase and the parameter block.
     * 
     * \see         Mtlbase::Validity()
     * 
     * \param       t An argument of type TimeValue.
     * \return      Returns a value of type Interval.
     */
    virtual Interval Validity(TimeValue t)
    {
        Interval r = FOREVER;
        
        // Compute the validity based on all references that are also MtlBase* 
        // e.g. sub-materials and sub-texture maps
        for (int i=0; i < NumRefs(); ++i)
        {
            MtlBase* mtl = dynamic_cast<MtlBase*>(GetReference(i));            
            if (mtl != NULL && !IsWeakRef(i))
                r &= mtl->Validity(t);
        }

        GetMainParamBlock()->GetValidity(t, r);
        return r;
    }   

    /**
     * Updates the validity interval.
     * 
     * \see         MtlBase::Update()
     * 
     * \param       t An argument of type TimeValue.
     * \param       valid An argument of type Interval &.
     */
    virtual void Update(TimeValue t, Interval& valid) 
    {	
	    if (!ivalid.InInterval(t)) 
        {
		    ivalid.SetInfinite();

            GetMainParamBlock()->GetValidity(t, ivalid);

            // Call update on all sub-texture maps and sub-materials 
            for (int i=0; i < NumRefs(); ++i)
            {
                MtlBase* mtl = dynamic_cast<MtlBase*>(GetReference(i));            
                if (mtl != NULL && !IsWeakRef(i))
                    mtl->Update(t, ivalid);
            }
	    }

        valid &= ivalid;
    }

    /**
     * Resets the validity interval, and calls reset on all references 
     * which are derived from "MtlBase". 
     * This will reset the UVGen and XYZGen because they would be 
     * added as references. 
     * 
     * \see         MtlBase::Reset()
     * 
     */
    virtual void Reset()
    {
	    ivalid.SetEmpty();
    	ResetParams();
    }
    //@}

    /// \name ReferenceManager Overrides
    //@{
    /**
     * Updates the validity interval.
     * 
     * \param       id An argument of type ParamID.
     */
    virtual void OnParamChanged(ParamID id)
    {
        ivalid.SetEmpty();
    }
    //@}
};
    
