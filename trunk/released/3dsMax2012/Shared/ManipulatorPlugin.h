//
// Copyright 2010 Autodesk, Inc.  All rights reserved.
//
// Use of this software is subject to the terms of the Autodesk license
// agreement provided at the time of installation or download, or which
// otherwise accompanies this software in either electronic or hard copy form.  
//

#pragma once

#include <manipulator.h>

/**
 * Base class for manipulators. Derives from SimpleManipulator 
 * which manages references and parameter block. 
 */
class ManipulatorPlugin
    : public SimpleManipulator
{

public:

    ManipulatorPlugin() 
        : SimpleManipulator()
    {
    }

    ManipulatorPlugin(INode* node)
        : SimpleManipulator(node)
    { 
    }

    /**
     * Default implementation of Object::GetCreateMouseCallBack()
     * 
     * \return     Returns a value of type CreateMouseCallBack *.
     */
    virtual CreateMouseCallBack* GetCreateMouseCallBack()
    {
        return NULL;
    }
};