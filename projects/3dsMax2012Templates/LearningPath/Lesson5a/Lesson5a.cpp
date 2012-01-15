#include "Lesson5a.h"
#include "SampleGeometricObject.h"

ClassDesc2* GetLesson5aDesc() { 
	static Lesson5aClassDesc Lesson5aDesc;
	return &Lesson5aDesc; 
}

//--- Lesson5a -------------------------------------------------------
Lesson5a::Lesson5a()
{
	iu = NULL;
	ip = NULL;	
	hPanel = NULL;
}

Lesson5a::~Lesson5a()
{
}

void Lesson5a::BeginEditParams(Interface* ip,IUtil* iu) 
{
	this->iu = iu;
	this->ip = ip;
	hPanel = ip->AddRollupPage(
		hInstance,
		MAKEINTRESOURCE(IDD_PANEL),
		DlgProc,
		GetString(IDS_PARAMS),
		0);

	// Create an object 
	SampleGObject* myGeomObj = new SampleGObject();
	INode* node = ip->CreateObjectNode(myGeomObj);
	TimeValue t (0);
	Matrix3 tm(1);
	node->SetNodeTM(t,tm);
}
	
void Lesson5a::EndEditParams(Interface* ip,IUtil* iu) 
{
	this->iu = NULL;
	this->ip = NULL;
	ip->DeleteRollupPage(hPanel);
	hPanel = NULL;
}

void Lesson5a::Init(HWND hWnd)
{

}

void Lesson5a::Destroy(HWND hWnd)
{

}

INT_PTR CALLBACK Lesson5a::DlgProc(HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam)
{
	switch (msg) 
	{
	case WM_INITDIALOG:
		Lesson5a::GetInstance()->Init(hWnd);
		break;

	case WM_DESTROY:
		Lesson5a::GetInstance()->Destroy(hWnd);
		break;

	case WM_COMMAND:
#pragma message(TODO("React to the user interface commands.  A utility plug-in is controlled by the user from here."))
		break;

	case WM_LBUTTONDOWN:
	case WM_LBUTTONUP:
	case WM_MOUSEMOVE:
		Lesson5a::GetInstance()->ip->RollupMouseMessage(hWnd,msg,wParam,lParam); 
		break;

	default:
		return 0;
	}
	return 1;
}
