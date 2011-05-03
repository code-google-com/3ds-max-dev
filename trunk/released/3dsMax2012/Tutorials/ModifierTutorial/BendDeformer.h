//
// Copyright 2010 Autodesk, Inc.  All rights reserved.
//
// Use of this software is subject to the terms of the Autodesk license
// agreement provided at the time of installation or download, or which
// otherwise accompanies this software in either electronic or hard copy form.  
//

#pragma once

/**
 * Manages the deformation of control points for the BendModifier. 
 */
class BendDeformer
    : public Deformer 
{
	public:
		Matrix3 tm,invtm, tmAbove, tmBelow;
		Box3 bbox;
		TimeValue time;
		float r, from, to;
		int doRegion;
		
        BendDeformer()
            : tm(1), invtm(1), tmAbove(1), tmBelow(1), time(0)
        { }

		BendDeformer(TimeValue t, ModContext &mc,
			float angle, float dir, int naxis, 
			float from, float to, int doRegion, 
			Matrix3& modmat, Matrix3& modinv)
        {
	        this->doRegion = doRegion;
	        this->from = from;
	        this->to   = to;
	        Matrix3 mat;
	        Interval valid;	
	        time   = t;	

	        tm = modmat;
	        invtm = modinv;
	        mat.IdentityMatrix();
        	
	        switch (naxis) 
            {
		        case 0: mat.RotateY( -HalfPi() );	 break; //X
		        case 1: mat.RotateX( HalfPi() );  break; //Y
		        case 2: break;  //Z
		    }
	        mat.RotateZ(DegToRad(dir));	
	        SetAxis(mat);	
	        assert (mc.box);
	        bbox = *mc.box;
	        CalcR(naxis,DegToRad(angle));
        	
	        // Turn this off for a sec.
	        this->doRegion = FALSE;
        		
	        float len  = to-from;
	        float rat1, rat2;
	        if (len==0.0f) {
		        rat1 = rat2 = 1.0f;
	        } else {
		        rat1 = to/len;
		        rat2 = from/len;
		    }
	        Point3 pt;
	        tmAbove.IdentityMatrix();
	        tmAbove.Translate(Point3(0.0f,0.0f,-to));
	        tmAbove.RotateY(DegToRad(angle * rat1));
	        tmAbove.Translate(Point3(0.0f,0.0f,to));
	        pt = Point3(0.0f,0.0f,to);
	        tmAbove.Translate((Map(0,pt*invtm)*tm)-pt);

	        tmBelow.IdentityMatrix();
	        tmBelow.Translate(Point3(0.0f,0.0f,-from));
	        tmBelow.RotateY(DegToRad(angle * rat2));	
	        tmBelow.Translate(Point3(0.0f,0.0f,from));
	        pt = Point3(0.0f,0.0f,from);
	        tmBelow.Translate((Map(0,pt*invtm)*tm)-pt);	
        	
	        this->doRegion = doRegion;
        }
		
        void SetAxis(Matrix3 &tmAxis)
        {
	        Matrix3 itm = Inverse(tmAxis);
	        tm = tm * tmAxis;
	        invtm =	itm * invtm;
        }

		void CalcR(int axis, float angle)
        {
	        float len = float(0);
	        if (!doRegion) 
            {
		        switch (axis) 
                {
			        case 0: 
                        len = bbox.pmax.x - bbox.pmin.x; 
                        break;
			        case 1:	
                        len = bbox.pmax.y - bbox.pmin.y; 
                        break;
			        case 2: 
                        len = bbox.pmax.z - bbox.pmin.z; 
                        break;
                }
		    }
	        else 
            {
		        len = to-from;
		    }

            r = SafeDivide(len, angle);
    	}
		
        // This method gets called for each point. 
		Point3 Map(int i, Point3 p)
        {
	        float x, y, c, s, yr;
	        if (r==0 && !doRegion) return p;
	        
            // The point is first transformed by the tm.  This is typical
	        // for all modifiers. 
	        p = p * tm;
	        if (doRegion) {
		        if (p.z<from) {
			        return tmBelow * p * invtm;			
		        } else 
		        if (p.z>to) {
			        return tmAbove * p * invtm;
			    }
		    }	
	        
            if (r==0) 
                return p * invtm;
	        
            x = p.x;
	        y = p.z;
	        yr = y/r;
	        
            c = cos(Pi() - yr);
	        s = sin(Pi() - yr);
	        
            p.x = r*c + r - x*c;
	        p.z = r*s - x*s;

	        // The point is finally transformed by the inverse of the tm.
	        p = p * invtm;
	        return p;
	    }
};

