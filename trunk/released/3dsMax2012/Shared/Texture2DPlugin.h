//
// Copyright 2010 Autodesk, Inc.  All rights reserved.
//
// Use of this software is subject to the terms of the Autodesk license
// agreement provided at the time of installation or download, or which
// otherwise accompanies this software in either electronic or hard copy form.  
//

#pragma once

#include "TexturePlugin.h"

/**
 * Provides a base class for 2D texture plug-ins. Automatically
 * manages the UVGen reference / sub-animatable, and uses 
 * it to provide many of the default implementations.
 * Also provides MapSampler functionality.
 */
class Texture2DPlugin
    : public TexturePlugin<Texmap>
    , public MapSampler
{

public:

    Texture2DPlugin(ClassDesc2* classDesc)
        : TexturePlugin(classDesc), MapSampler()
    {
        RegisterReference(1, GetNewDefaultUVGen());
        RegisterSubAnim(1, 1, _T("UVGen"));
    }

    ~Texture2DPlugin()
    {
    }

    //=========================================================
    // TexMap overrides

    /// \name TexMap Overrides
    //@{
    /**
     * \see         TexMap::GetTheUVGen()
     * 
     * \return      Returns a value of type UVGen *.
     */
    UVGen* GetTheUVGen() 
    { 
        return GetReferenceAs<UVGen*>(1);
    }
    /**
     * \see         TexMap::GetUVTransform()
     * 
     * \param       uvtrans An argument of type Matrix3 &.
     */
    void GetUVTransform(Matrix3 &uvtrans) 
    { 
        GetTheUVGen()->GetUVTransform(uvtrans); 
    }
    /**
     * \see         TexMap::GetTextureTiling() 
     * 
     * \return      Returns a value of type int.
     */
    int GetTextureTiling() 
    { 
        return GetTheUVGen()->GetTextureTiling(); 
    }
	/**
	 * \see         TexMap::GetUVWSource() 
	 * 
	 * \return      Returns a value of type int.
	 */
	int GetUVWSource() 
    { 
        return GetTheUVGen()->GetUVWSource(); 
    }

    /**
     * \see         TexMap::EvalColor()
     * 
     * \param       sc An argument of type ShadeContext &.
     * \return      Returns a value of type AColor.
     */
    AColor EvalColor(ShadeContext& sc)
    {
    	if (!sc.doMaps) return AColor(0.0f,0.0f,0.0f,0.0f);;
    	if (gbufID) sc.SetGBufferID(gbufID);
        return GetTheUVGen()->EvalUVMap(sc, this);
    }

    /**
     * \see         TexMap::EvalMono()
     * 
     * \param       sc An argument of type ShadeContext &.
     * \return      Returns a value of type float.
     */
    float EvalMono(ShadeContext& sc)
    {
	    if (!sc.doMaps) return 0.0f;
    	if (gbufID) sc.SetGBufferID(gbufID);
    	return GetTheUVGen()->EvalUVMapMono(sc, this);
    }

    /**
     * \see         TexMap::EvalNormalPerturb()
     * 
     * \param       sc An argument of type ShadeContext &.
     * \return      Returns a value of type Point3.
     */
    Point3 EvalNormalPerturb(ShadeContext& sc)
    {
	    if (!sc.doMaps) return Point3(0,0,0);
	    if (gbufID) sc.SetGBufferID(gbufID);

        Point3 dPdu, dPdv;
        GetTheUVGen()->GetBumpDP(sc, dPdu, dPdv);	    

        Point2 dM = GetTheUVGen()->EvalDeriv(sc, this);
	    Point3 np = dM.x*dPdu+dM.y*dPdv;        
	    return np;
    }

    /**
     * \see         TexMap::LocalRequirements()
     * 
     * \param       subMtlNum An argument of type int.
     * \return      Returns a value of type ULONG.
     */
    ULONG LocalRequirements(int subMtlNum)
    {
	    return GetTheUVGen()->Requirements(subMtlNum); 
    }
    //@}

    /// \name MapSampler Overrides
    //@{
    /**
     * \see         TexMap::Sample()
     * 
     * \param       sc An argument of type ShadeContext &.
     * \param       u An argument of type float.
     * \param       v An argument of type float.
     * \return      Returns a value of type AColor.
     */
    virtual AColor Sample(ShadeContext &sc, float u, float v)
    {
        return AColor(0.0f, 0.0f, 0.0f, 0.0f);
    }

    /**
     * \see         TexMap::SampleFilter()
     * 
     * \param       sc An argument of type ShadeContext &.
     * \param       u An argument of type float.
     * \param       v An argument of type float.
     * \param       du An argument of type float.
     * \param       dv An argument of type float.
     * \return      Returns a value of type AColor.
     */
    virtual AColor SampleFilter(ShadeContext &sc, float u, float v, float du, float dv)
    {
        return AColor(0.0f, 0.0f, 0.0f, 0.0f);
    }
    //@}
};
