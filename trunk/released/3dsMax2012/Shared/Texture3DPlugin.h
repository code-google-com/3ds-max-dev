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
 * Base class for 3D texture plug-ins.
 * Manages a XYZGen and uses it to provide many of the default 
 * implementations. 
 */
class Texture3DPlugin
    : public TexturePlugin<Tex3D>
{

public:

    Texture3DPlugin(ClassDesc2* classDesc)
        : TexturePlugin(classDesc)
    {
        RegisterReference(1, GetNewDefaultXYZGen());
        RegisterSubAnim(1, 1, _T("XYZGen"));
    }

    //=========================================================
    // TexMap overrides

    /// \name TexMap Overrides
    //@{
    /**
     * \see         TexMap::GetTheXYZGen()
     * 
     * \return      Returns a value of type XYZGen *.
     */
    XYZGen* GetTheXYZGen() 
    { 
        return GetReferenceAs<XYZGen*>(1);
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
        return AColor(0.0f,0.0f,0.0f,0.0f);;
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
    	return Intens(EvalColor(sc));
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
        return Point3(0,0,0);
    }

    /**
     * \see         TexMap::LocalRequirements()
     * 
     * \param       subMtlNum An argument of type int.
     * \return      Returns a value of type ULONG.
     */
    ULONG LocalRequirements(int subMtlNum)
    {
	    return GetTheXYZGen()->Requirements(subMtlNum); 
    }

	/**
	 * \see         TexMap::ReadSXPData()
	 * 
	 * \param       name An argument of type TCHAR *.
	 * \param       sxpdata An argument of type void *.
	 */
	void ReadSXPData(TCHAR *name, void *sxpdata) 
    { 
        // Do nothing
    }
    //@}
};
