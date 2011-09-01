//**************************************************************************/
// Copyright (c) 1998-2007 Autodesk, Inc.
// All rights reserved.
// 
// These coded instructions, statements, and computer programs contain
// unpublished proprietary information written by Autodesk, Inc., and are
// protected by Federal copyright law. They may not be disclosed to third
// parties or copied or duplicated in any form, in whole or in part, without
// the prior written consent of Autodesk, Inc.
//**************************************************************************/
// DESCRIPTION: Appwizard generated plugin
// AUTHOR: 
//***************************************************************************/

#include "Lesson5b.h"

#define SampleGObject2_CLASS_ID	Class_ID(0x73fc6599, 0x9746e2b9)

#define PBLOCK_REF	0

class SampleGObject2 : public SimpleObject2 {
	public:
		// Parameter block handled by parent
		float objSize;

		//Class vars
		static IObjParam *ip;			//Access to the interface
		// From BaseObject
		CreateMouseCallBack* GetCreateMouseCallBack();
		
		// From Animatable
		void BeginEditParams( IObjParam  *ip, ULONG flags,Animatable *prev);
		void EndEditParams( IObjParam *ip, ULONG flags,Animatable *next);

		// From SimpleObject
		void BuildMesh(TimeValue t);
		//void InvalidateUI();

		//From Animatable
		Class_ID ClassID() {return SampleGObject2_CLASS_ID;}		
		SClass_ID SuperClassID() { return GEOMOBJECT_CLASS_ID; }
		void GetClassName(TSTR& s) {s = GetString(IDS_CLASS_NAME);}

		void DeleteThis() { delete this; }	

		//Constructor/Destructor
		SampleGObject2();
		~SampleGObject2();
};



class SampleGObject2ClassDesc : public ClassDesc2 
{
public:
	virtual int IsPublic() 							{ return TRUE; }
	virtual void* Create(BOOL /*loading = FALSE*/) 		{ return new SampleGObject2(); }
	virtual const TCHAR *	ClassName() 			{ return GetString(IDS_CLASS_NAME); }
	virtual SClass_ID SuperClassID() 				{ return GEOMOBJECT_CLASS_ID; }
	virtual Class_ID ClassID() 						{ return SampleGObject2_CLASS_ID; }
	virtual const TCHAR* Category() 				{ return GetString(IDS_CATEGORY); }

	virtual const TCHAR* InternalName() 			{ return _T("SampleGObject2"); }	// returns fixed parsable name (scripter-visible name)
	virtual HINSTANCE HInstance() 					{ return hInstance; }					// returns owning module handle
};

ClassDesc2* GetSampleGObject2Desc() { 
	static SampleGObject2ClassDesc SampleGObject2Desc;
	return &SampleGObject2Desc; 
}

IObjParam *SampleGObject2::ip			= NULL;

//--- SampleGObject2 -------------------------------------------------------

SampleGObject2::SampleGObject2()
{
	this->objSize = 0.0;
}

SampleGObject2::~SampleGObject2()
{
}

void SampleGObject2::BeginEditParams(IObjParam *ip,ULONG flags,Animatable *prev)
{
	this->ip = ip;
	SimpleObject2::BeginEditParams(ip,flags,prev);
}

void SampleGObject2::EndEditParams( IObjParam *ip, ULONG flags,Animatable *next )
{
	SimpleObject2::EndEditParams(ip,flags,next);
	this->ip = NULL;
}

//Class for interactive creation of the object using the mouse
class SampleGObject2CreateCallBack : public CreateMouseCallBack {
	IPoint2 sp0;		//First point in screen coordinates
	SampleGObject2 *ob;	//Pointer to the object 
	Point3 p0;			//First point in world coordinates
	Point3 p1;			//We added this point. Second point in world coordinates.
public:	
	int proc( ViewExp *vpt,int msg, int point, int flags, IPoint2 m, Matrix3& mat);
	void SetObj(SampleGObject2 *obj) {ob = obj;}
};

int SampleGObject2CreateCallBack::proc(ViewExp *vpt,int msg, int point, int flags, IPoint2 m, Matrix3& mat )
{
	TimeValue t (0);
	if (msg==MOUSE_POINT||msg==MOUSE_MOVE) {
		// You can use DebugPrint() simmilar to the following line to get useful information 
		// on the program flow when you are debugging your plug-in project:
		//	DebugPrint("\nmousecallback::proc() called with: msg: %d point: %d flags: %d", msg, point, flags);
		switch(point) 
		{
		case 0: // only happens with MOUSE_POINT msg
			ob->suspendSnap = TRUE;
			sp0 = m;
			p0 = vpt->SnapPoint(m,m,NULL,SNAP_IN_PLANE);
			mat.SetTrans(p0); // sets the pivot location

			ob->objSize = 0.0;
			break;
		case 1:
			{
				ob->suspendSnap = TRUE; 
				p1 = vpt->SnapPoint(m,m,NULL,SNAP_IN_PLANE);

				float speedFactor = 24.0f;

				ob->objSize = (Length(p1 - p0) / speedFactor);
				ob->mesh.InvalidateGeomCache();
				ob->BuildMesh(t);
				if (msg == 1)
					return CREATE_STOP;
				break;
			}
		case 2:
			{
				return CREATE_STOP;
			}
		}
		ob->NotifyDependents(FOREVER, PART_ALL, REFMSG_CHANGE);
	} 
	else {
		if (msg == MOUSE_ABORT) return CREATE_ABORT;
	}
	return TRUE;
}

static SampleGObject2CreateCallBack SampleGObject2CreateCB;

//From BaseObject
CreateMouseCallBack* SampleGObject2::GetCreateMouseCallBack() 
{
	SampleGObject2CreateCB.SetObj(this);
	return(&SampleGObject2CreateCB);
}

//From SimpleObject
void SampleGObject2::BuildMesh(TimeValue t)
{
	ivalid = FOREVER;

	mesh.setNumVerts(4);
	mesh.setNumFaces(3);

	mesh.setVert(0,objSize*Point3(0.0,0.0,0.0)); 
	mesh.setVert(1,objSize*Point3(10.0,0.0,0.0)); 
	mesh.setVert(2,objSize*Point3(0.0,10.0,0.0)); 
	mesh.setVert(3,objSize*Point3(0.0,0.0,10.0)); 

	mesh.faces[0].setVerts(0, 1, 2);
	mesh.faces[0].setEdgeVisFlags(1,1,0);
	mesh.faces[0].setSmGroup(2);
	mesh.faces[1].setVerts(3, 1, 0);
	mesh.faces[1].setEdgeVisFlags(1,1,0);
	mesh.faces[1].setSmGroup(2);
	mesh.faces[2].setVerts(0, 2, 3);
	mesh.faces[2].setEdgeVisFlags(1,1,0);
	mesh.faces[2].setSmGroup(4);
}

