//
// Copyright 2010 Autodesk, Inc.  All rights reserved.
//
// Use of this software is subject to the terms of the Autodesk license
// agreement provided at the time of installation or download, or which
// otherwise accompanies this software in either electronic or hard copy form.  
//

#include <istdplug.h>
#include <iparamb2.h> 
#include <iparamm2.h> 
#include <decomp.h>
#include <animtbl.h> 
#include <gfx.h>

const MSTR SDK_TUTORIALS_CATEGORY = _M("SDK Tutorials");

// Disable the "unreferenced formal parameter" warning
#pragma warning(disable:4100) 

// Disable the argument conversion to reference warning
#pragma warning(disable:4239)

#include "Macros.h"
#include "UtilityPlugin.h"
#include "AnimatablePlugin.h"
#include "MathUtility.h"
#include "Utility.h"
#include "ParamBlockUtility.h"
