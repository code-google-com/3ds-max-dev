//
// Copyright 2010 Autodesk, Inc.  All rights reserved.
//
// Use of this software is subject to the terms of the Autodesk license
// agreement provided at the time of installation or download, or which
// otherwise accompanies this software in either electronic or hard copy form.  
//

#pragma once

/**
 * Simplifies node picking by merging the responsibilities for both
 * PickNodeCallback and PickModeCallback, into a single virtual function 
 * that must be implemented (OnObjectPicked).
 */
class SingleObjectNodePicker : 
      public PickModeCallback,
      public PickNodeCallback 
{
private: 

    INode* hit;

public:     

    SingleObjectNodePicker() 
        : hit(NULL)
    { }

    ~SingleObjectNodePicker()
    { }

    BOOL HitTest(IObjParam *ip, HWND hWnd, ViewExp *vpt, IPoint2 m, int flags) { 
        return ip->PickNode(hWnd, m, this) ? TRUE : FALSE;
    }

    BOOL Pick(IObjParam *ip, ViewExp *vpt) {
        hit = vpt->GetClosestHit();
        OnObjectPicked(hit);
        return TRUE;
    }

    void EnterMode(IObjParam *ip) {
        hit = NULL;
		GetCOREInterface()->PushPrompt(_T("Select target"));
    }

    void ExitMode(IObjParam *ip) {
		GetCOREInterface()->PopPrompt();
    }

    BOOL RightClick(IObjParam *ip,ViewExp *vpt)  {
        return TRUE;
    }

    BOOL Filter(INode *node) {
        return node != NULL && node->GetObjectRef() != NULL;
    }

    PickNodeCallback *GetFilter() {
        return this;
    }

    BOOL AllowMultiSelect() {
        return FALSE;
    }

    INode* GetHitNode() {
        return hit;
    }

protected:

    virtual void OnObjectPicked(INode* hit) = 0;
};
