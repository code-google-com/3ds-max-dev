//
// Copyright 2010 Autodesk, Inc.  All rights reserved.
//
// Use of this software is subject to the terms of the Autodesk license
// agreement provided at the time of installation or download, or which
// otherwise accompanies this software in either electronic or hard copy form.  
//

#pragma once

#include "MtlBasePlugin.h"

//=========================================================================
// Provides default empty implementations of the Mtl functions

/** 
 * Base class for material plug-ins (derived from Mtl) which provides default 
 * implementations of the Mtl function.
 */
class MaterialPlugin
    : public MtlBasePlugin<Mtl>
{

public:

    //===========================================================================
    // Constructor

    MaterialPlugin(ClassDesc2* classDesc) 
        : MtlBasePlugin(classDesc)
    {
    }

    //===========================================================================
    // Mtl overrides
   
    /**
     * \see         Mtl::NumSubMtls() 
     * \return      Returns a value of type int.
     */
    virtual int NumSubMtls()
    {
        return 0;
    }

    /**
     * \see         Mtl::GetSubMtl() 
     * \param       i An argument of type int.
     * \return      Returns a value of type Mtl *.
     */
    virtual Mtl* GetSubMtl(int i)
    {
        // Does nothing. 
        DbgError(_T("There is no sub-material"));
        return NULL;
    }
    
    /**
     * \see         Mtl::SetSubMtl()
     * \param       i An argument of type int.
     * \param       m An argument of type Mtl *.
     */
    virtual void SetSubMtl(int i, Mtl *m)
    {
        DbgError(_T("There are no sub-materials"));       
    }

    /**
     * \see         Mtl::GetSubMtlSlotName()
     * 
     * \param       i An argument of type int.
     * \return      Returns a value of type TSTR.
     */
    virtual TSTR GetSubMtlSlotName(int i)
    {
        DbgError(_T("There are no sub-materials"));       
	    return _T(""); 
    }

    /**
     * \see         Mtl::GetSubMtlTVName()
     * 
     * \param       i An argument of type int.
     * \return      Returns a value of type TSTR.
     */
    virtual TSTR GetSubMtlTVName(int i)
    {
        DbgError(_T("There are no sub-materials"));       
	    return GetSubMtlSlotName(i);
    }

    /**
     * \see         Mtl::GetSubTexmapTVName()
     * 
     * \param       i An argument of type int.
     * \return      Returns a value of type TSTR.
     */
    virtual TSTR GetSubTexmapTVName(int i)
    {
	    return GetSubTexmapSlotName(i);
    }

    /**
     * \see         Mtl::SetAmbient()
     * 
     * \param       c An argument of type Color.
     * \param       t An argument of type TimeValue.
     */
    virtual void SetAmbient(Color c, TimeValue t) 
    {
        // Does nothing by default        
    }		

    /**
     * \see         Mtl::SetDiffuse()
     * 
     * \param       c An argument of type Color.
     * \param       t An argument of type TimeValue.
     */
    virtual void SetDiffuse(Color c, TimeValue t) 
    {
        // Does nothing by default
    }		
    
    /**
     * \see         Mtl::SetSpecular()
     * 
     * \param       c An argument of type Color.
     * \param       t An argument of type TimeValue.
     */
    virtual void SetSpecular(Color c, TimeValue t) 
    {
        // Does nothing by default
    }

    /**
     * \see         Mtl::SetShininess()
     * 
     * \param       v An argument of type float.
     * \param       t An argument of type TimeValue.
     */
    virtual void SetShininess(float v, TimeValue t) 
    {
        // Does nothing by default
    }
    				
    /**
     * \see         Mtl::GetAmbient()
     * 
     * \param       mtlNum An argument of type int.
     * \param       backFace An argument of type BOOL.
     * \return      Returns a value of type Color.
     */
    virtual Color GetAmbient(int mtlNum=0, BOOL backFace=FALSE)
    {
	    return Color(0,0,0);
    }

    /**
     * \see         Mtl::GetDiffuse()
     * 
     * \param       mtlNum An argument of type int.
     * \param       backFace An argument of type BOOL.
     * \return      Returns a value of type Color.
     */
    virtual Color GetDiffuse(int mtlNum=0, BOOL backFace=FALSE)
    {
	    return Color(0,0,0);
    }

    /**
     * \see         Mtl::GetSpecular()
     * 
     * \param       mtlNum An argument of type int.
     * \param       backFace An argument of type BOOL.
     * \return      Returns a value of type Color.
     */
    virtual Color GetSpecular(int mtlNum=0, BOOL backFace=FALSE)
    {
	    return Color(0,0,0);
    }

    /**
     * \see         Mtl::GetXParency()
     * 
     * \param       mtlNum An argument of type int.
     * \param       backFace An argument of type BOOL.
     * \return      Returns a value of type float.
     */
    virtual float GetXParency(int mtlNum=0, BOOL backFace=FALSE)
    {
	    return 0.0f;
    }

    /**
     * \see         Mtl::GetShininess()
     * 
     * \param       mtlNum An argument of type int.
     * \param       backFace An argument of type BOOL.
     * \return      Returns a value of type float.
     */
    virtual float GetShininess(int mtlNum=0, BOOL backFace=FALSE)
    {
	    return 0.0f;
    }

    /**
     * \see         Mtl::GetShinStr()
     * 
     * \param       mtlNum An argument of type int.
     * \param       backFace An argument of type BOOL.
     * \return      Returns a value of type float.
     */
    virtual float GetShinStr(int mtlNum=0, BOOL backFace=FALSE)
    {
	    return 0.0f;
    }

    /**
     * \see         Mtl::WireSize()
     * 
     * \param       mtlNum An argument of type int.
     * \param       backFace An argument of type BOOL.
     * \return      Returns a value of type float.
     */
    virtual float WireSize(int mtlNum=0, BOOL backFace=FALSE)
    {
	    return 0.0f;
    }

    /**
     * \see         Mtl::Shade()
     * 
     * \param       sc An argument of type ShadeContext &.
     */
    virtual void Shade(ShadeContext& sc)
    {
    	if (gbufID) sc.SetGBufferID(gbufID);
    }
  		
    /**
     * \see         Mtl::EvalDisplacement()
     * 
     * \param       sc An argument of type ShadeContext &.
     * \return      Returns a value of type float.
     */
    virtual float EvalDisplacement(ShadeContext& sc)
    {
        // Do nothing by default
        return 0.0f;
    }

    /**
     * \see         Mtl::DisplacementValidity()
     * 
     * \param       t An argument of type TimeValue.
     * \return      Returns a value of type Interval.
     */
    virtual Interval DisplacementValidity(TimeValue t)
    {
        // Do nothing by default
        return Interval();
    }
};
    
