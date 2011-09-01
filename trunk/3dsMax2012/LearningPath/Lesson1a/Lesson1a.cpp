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
// DESCRIPTION: Appwizard generated plugin, Modified to prompt a message
// AUTHOR: Mo Alian and Christopher Diggins
//***************************************************************************/

#include "Lesson1a.h"

#define UtilitySample_CLASS_ID	Class_ID(0x6a287c04, 0x76533d11)


class SampleUtil : public UtilityObj 
{
public:
		
	//Constructor/Destructor
	SampleUtil();
	virtual ~SampleUtil();

	virtual void DeleteThis() { }		
	
	virtual void BeginEditParams(Interface *ip,IUtil *iu);
	virtual void EndEditParams(Interface *ip,IUtil *iu);

	virtual void Init(HWND hWnd);
	virtual void Destroy(HWND hWnd);
	
	// Singleton access
	static SampleUtil* GetInstance() { 
		static SampleUtil theUtilitySample;
		return &theUtilitySample; 
	}

private:

	static INT_PTR CALLBACK DlgProc(HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam);

	HWND			hPanel;
	IUtil			*iu;
	Interface		*ip;
};


class UtilitySampleClassDesc : public ClassDesc2 
{
public:
	virtual int IsPublic() 							{ return TRUE; }
	virtual void* Create(BOOL /*loading = FALSE*/) 	{ return SampleUtil::GetInstance(); }
	virtual const TCHAR *	ClassName() 			{ return GetString(IDS_CLASS_NAME); }
	virtual SClass_ID SuperClassID() 				{ return UTILITY_CLASS_ID; }
	virtual Class_ID ClassID() 						{ return UtilitySample_CLASS_ID; }
	virtual const TCHAR* Category() 				{ return GetString(IDS_CATEGORY); }

	virtual const TCHAR* InternalName() 			{ return _T("SampleUtil"); }	// returns fixed parsable name (scripter-visible name)
	virtual HINSTANCE HInstance() 					{ return hInstance; }			// returns owning module handle
	

};


ClassDesc2* GetUtilitySampleDesc() { 
	static UtilitySampleClassDesc UtilitySampleDesc;
	return &UtilitySampleDesc; 
}




//--- SampleUtil -------------------------------------------------------
SampleUtil::SampleUtil()
{
	iu = NULL;
	ip = NULL;	
	hPanel = NULL;
}

SampleUtil::~SampleUtil()
{

}

void SampleUtil::BeginEditParams(Interface* ip,IUtil* iu) 
{
	this->iu = iu;
	this->ip = ip;
	hPanel = ip->AddRollupPage(
		hInstance,
		MAKEINTRESOURCE(IDD_PANEL),
		DlgProc,
		GetString(IDS_PARAMS),
		0);
	ip->PushPrompt(_M("Hello World from Lesson 1. Called from BeginEditParams()"));
}
	
void SampleUtil::EndEditParams(Interface* ip,IUtil* iu) 
{
	this->iu = NULL;
	this->ip = NULL;
	ip->DeleteRollupPage(hPanel);
	hPanel = NULL;
	ip->PopPrompt();
}

void SampleUtil::Init(HWND hWnd)
{

}

void SampleUtil::Destroy(HWND hWnd)
{

}

INT_PTR CALLBACK SampleUtil::DlgProc(HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam)
{
	switch (msg) 
	{
		case WM_INITDIALOG:
			SampleUtil::GetInstance()->Init(hWnd);
			break;

		case WM_DESTROY:
			SampleUtil::GetInstance()->Destroy(hWnd);
			break;

		case WM_COMMAND:
			#pragma message(TODO("React to the user interface commands.  A utility plug-in is controlled by the user from here."))
			break;

		case WM_LBUTTONDOWN:
		case WM_LBUTTONUP:
		case WM_MOUSEMOVE:
			SampleUtil::GetInstance()->ip->RollupMouseMessage(hWnd,msg,wParam,lParam); 
			break;

		default:
			return 0;
	}
	return 1;
}
