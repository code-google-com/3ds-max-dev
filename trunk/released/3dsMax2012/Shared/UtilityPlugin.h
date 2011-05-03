//
// Copyright 2010 Autodesk, Inc.  All rights reserved.
//
// Use of this software is subject to the terms of the Autodesk license
// agreement provided at the time of installation or download, or which
// otherwise accompanies this software in either electronic or hard copy form.  
//

#pragma once

/**
 * A class template for use as a base class for plug-ins that don't derive from Animatable.
 */
template<typename Base_T>
class UtilityPlugin
    : public Base_T
{
	

};

