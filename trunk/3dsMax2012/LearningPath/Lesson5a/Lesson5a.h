#pragma once

#include "3dsmaxsdk_preinclude.h"
#include "Max.h"
#include "resource.h"
#include "istdplug.h"
#include "iparamb2.h"
#include "iparamm2.h"

//SIMPLE TYPE

#include "utilapi.h"

#define Lesson5a_CLASS_ID	Class_ID(0x723ee064, 0x53b5df90)
#define PBLOCK_REF    0


class Lesson5a : public UtilityObj 
{
public:

	//Constructor/Destructor
	Lesson5a();
	virtual ~Lesson5a();

	virtual void DeleteThis() { }		

	virtual void BeginEditParams(Interface *ip,IUtil *iu);
	virtual void EndEditParams(Interface *ip,IUtil *iu);

	virtual void Init(HWND hWnd);
	virtual void Destroy(HWND hWnd);

	// Singleton access
	static Lesson5a* GetInstance() { 
		static Lesson5a theLesson5a;
		return &theLesson5a; 
	}

private:

	static INT_PTR CALLBACK DlgProc(HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam);

	HWND			hPanel;
	IUtil			*iu;
	Interface		*ip;
};

extern TCHAR *GetString(int id);

extern HINSTANCE hInstance;


class Lesson5aClassDesc : public ClassDesc2 
{
public:
	virtual int IsPublic() 							{ return TRUE; }
	virtual void* Create(BOOL /*loading = FALSE*/) 	{ return Lesson5a::GetInstance(); }
	virtual const TCHAR *	ClassName() 			{ return GetString(IDS_CLASS_NAME); }
	virtual SClass_ID SuperClassID() 				{ return UTILITY_CLASS_ID; }
	virtual Class_ID ClassID() 						{ return Lesson5a_CLASS_ID; }
	virtual const TCHAR* Category() 				{ return GetString(IDS_CATEGORY); }

	virtual const TCHAR* InternalName() 			{ return _T("Lesson5a"); }	// returns fixed parsable name (scripter-visible name)
	virtual HINSTANCE HInstance() 					{ return hInstance; }					// returns owning module handle
};




