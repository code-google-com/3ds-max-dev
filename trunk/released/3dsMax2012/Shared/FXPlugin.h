//
// Copyright 2010 Autodesk, Inc.  All rights reserved.
//
// Use of this software is subject to the terms of the Autodesk license
// agreement provided at the time of installation or download, or which
// otherwise accompanies this software in either electronic or hard copy form.  
//

#pragma once

/**
 * An instantiation of this template class is used when a plug-in
 * derives from SpecialFX.
 */
template<typename Base_T>
class FXPlugin
    : public AnimatablePlugin<Base_T>
{
public:
    FXPlugin(ClassDesc2* classDesc)
        : AnimatablePlugin(classDesc)        
    { 
    }
};
