//
// Copyright 2010 Autodesk, Inc.  All rights reserved.
//
// Use of this software is subject to the terms of the Autodesk license
// agreement provided at the time of installation or download, or which
// otherwise accompanies this software in either electronic or hard copy form.  
//

#pragma once

//========================================================
// Utility macros

/// Used for constructing strings at compile time.
#define STRING2(X) #X
/// Used for constructing strings at compile time.
#define STRING(X) STRING2(X)
/// Creates a message pragma with specific instructions that appears in the output pane.
#define TODO(MSG) __pragma(message("TODO, at line " STRING(__LINE__) " in file : " __FILE__ " : " MSG))

// Forces an assertion to occur
#define DbgError(X) DbgAssert(false && (X))
