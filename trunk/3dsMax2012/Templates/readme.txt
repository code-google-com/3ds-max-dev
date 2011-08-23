/** 

\mainpage 3ds Max SDK Template Projects

    \note This is not an officially supported Autodesk project. 

    The template plug-in projects are intended to be used as skeleton plug-in 
    projects which can be used as starting points for new plug-ins. There are 
    essentially two kinds of plug-ins those that derived directly or indirectly 
    from the Animatable base class (called Animatable plug-ins), and those that 
    don't called Utility plug-ins. 

    The template plug-ins are built using a shared code base which is found in the folder 
    "maxsdk\howto\shared". The contents of this folder are described further on. 

    When copying a template project to use for a new project you will have to do the 
    following things:

    - Create a new ClassID using the class id generator program included with the SDK
    - Replace all instances of the old ClassID with the new one.
    - Rename the project
    - [optional] rename the project file (.vcproj) and source files (.cpp and .h)
    - [optional] replace the project GUID within the project file with a new unique one
    - replace all "TODO" macros with the appropriate code as per the instructions
    - update the string table with your own localizable strings
    - update the dialog box in the resource file with your own rollout
    - change the strings in "veroverrides.h" to something more appropriate to your plug-in

    These projects will compile as-is, but will do nothing (and possibly crash)
    if loaded into 3ds Max. It is up to you to fill out the implementations correctly, 
    and read the appropriate 3ds Max SDK documentation.

\section about_shared About the Shared Code Base 

    All of the template plug-ins include the header file "Common.h" and use the file 
    "common.def" which defines the exported functions. 

    In the shared folder there are a number of files that contains classes which are used as 
    base-classes. Utility plug-ins derive from a template class called UtilityPlugin<> 
    found in the file "UtilityPlugin.h". 

    One of the more important classes in the shared folder is a "ParamBlockDescUtil" class 
    found in "ParamBlockUtility.h" which derives from "ParamBlockDesc2". It allows parameter 
    blocks to be constructed using multiple method calls, with a fixed number of types parameters 
    instead of a single constructor that uses varargs.

    Within the shared code base the following header files contain miscellaneous
    utility functions and classes:

    - Macros.h
    - ControlUtility.h
    - MathUtility.h
    - NodePicker.h
    - Utility.h		

\section hierarchy The Template Plug-in Class Hierarchy

    The template plug-in base classes use a technique of inheriting from a template parameter.
    This is used to allow us to use a common set of base classes for different plug-in types.  

    For utility plug-ins the "UtilityPlugin<>" template takes a type as a parameter, which is 
    the base class that the plug-in will derive from. For example TemplateColorSelector derives 
    from UtilityPlugin<ColPick> which in turn derives from "ColPick". 

    This is clear if we look at the declaration of UtilityPlugin.

    \code
	    template<typename Base_T>
	    class UtilityPlugin : public Base_T
    \endcode

    Animatable derived template plug-ins have a deeper type hierarchy as follows:

    \code
        template<typename Base_T>
	    class ReferenceManager : public Base_T

        template<typename Base_T>
	    class SubAnimManager : ReferenceManager<Base_T>
    	
	    template<typename Base_T>
	    class AnimatablePlugin : SubAnimManager<Base_T>
    \endcode
    	
    Other more specialized base plug-in classes derive from 
    the AnimatablePlugin template such as:

    \code
	    template<typename Base_T>
	    class ObjectPlugin : AnimatablePlugin<Base_T>
    	
	    template<typename Base_T>
	    class MtlBasePlugin : AnimatablePlugin<Base_T>

	    template<typename Base_T>
	    class TexturePlugin : MtlBasePlugin<Base_T>

	    template<typename Base_T>
	    class ModifierPlugin : AnimatablePlugin<Base_T>
    	
	    template<typename Base_T>
	    class FXPlugin : AnimatablePlugin<Base_T>
    \endcode

    In some cases these are further specialized. 

\section trh The ReferenceManager Hierarchy

    Most of the tutorial plug-ins are derived from an instance of the AnimatablePlugin template.
    This template class derives from SubAnimManager, which in turn derives from ReferenceManager. 

    The class that a specific plug-in would normally derive directly from (e.g. Control for a controller plug-in, 
    Mtl for a material plug-in, GeomObject for a geometric object plug-in, etc.) must be passed to AnimatablePlugin
    template as the template parameter, if you wish to benefit from the extra code provided in AnimatablePlugin. 

    The AnimatablePlugin provides the following services:

      - Default implementations of a number of Animatable virtual functions.
      - Management of the parameter block, as reference index 0 and sub-animatable index 0.
      - Reference management via ReferenceManager
      - Sub-animatable management via SubAnimManager

    This means that SimpleObject2, SimpleMod2, and SimpleManipulator or any other class that manages references 
    manually or a parameter block should not be used as parameters for the AnimatablePlugin. 

\section pbc Parameter Block Construction

    In addition to the animatable hierarchy the shared code base simplifies the construction of parameter block descriptors. 
    This is done using a class ParamBlockDescUtil that derives from ParamBlockDesc2. Instead of using the single constructor
    that takes a variable length list of arguments (varargs), construction is incremental via a series of calls to 
    ParamBlockDesc2::AddParam and ParamBlockDesc2::AddParamOption. A number of utility functions are provided to 
    simplify creation of parameters that have UI components. 

\section Controllers Controller Plug-ins

    Controller are a special kind of plug-in because there are several 
    different kinds of control plug-ins, with different behavior in their 
    GetValue() and SetValue() methods depending on their super class ID. 
    To simplify definition of correct controllers, there is a ControlPlugin 
    template class which can be used as a base class, but which takes a super 
    class ID as a template parameter. 

    \code
	    template<SClass_ID scid>
	    class ControlPlugin
		    : public AnimatablePlugin<Control>
    \endcode

\section tt The Tutorials 

    The following tutorials are implemented: 

    \li CameraTutorial - \copybrief CameraTutorial
    \li ControllerTutorial - \copybrief ControllerTutorial
    \li GeometricObjectTutorial - \copybrief GeometricObjectTutorial
    \li ModifierTutorial - ModifierTutorial \copybrief ModifierTutorial
    \li UtilityObjectTutorial - UtilityObjectTutorial \copybrief UtilityObjectTutorial

    The tutorials are built from the common shared code base, which is intended 
    to eliminate the need for a lot of boiler-plate code when constructing 
    simple plug-ins. The inspiration for these tutorials were the SimpleObject2 and 
    SimpleMod2 classes in the 3ds Max SDK. 

    Each plug-in type must derive from a different class (e.g. Modifier, Controller, GeomObject, etc.)
    but ultimately share many common ancestors, such as Animatable, ReferenceTarget, and ReferenceMaker, 
    each with a set of required functions to implement. To abstract out the boiler-plate 
    a technique is used of inheriting from templates that derive from a template parameter.
    For an example of this look at the ReferenceManager template class. 

    There are a number of restrictions of the plug-ins that derive from an instance of the 
    AnimatablePlugin template:

      - The number of references does not vary over the lifetime of the plug-in. 
      - All sub-animatables are registered as strong references with the ReferenceManager.
      - There is exactly one parameter block per plug-in. 
      - The reference index 0 is reserved for the parameter block
      - The parameter block is auto-created by the class descriptor. 

\section ou Other Utilities

    The shared code base provides a number of utility functions and classes in the header file utility.h. There are also 
    some specialized utilities for working with controllers in the file ControlUtility.h. 

*/