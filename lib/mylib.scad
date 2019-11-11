/*
module rounded_cube(dx,dy,dz,r){
    union(){
        translate ([r,0,0]) cube([dx-2*r,dy,dz]);
        translate ([0,r,0]) cube([dx,dy-2*r,dz]);
        translate ([r,r,0]) cylinder(dz,r,r);
        translate ([dx-r,r,0]) cylinder(dz,r,r);
        translate ([r,dy-r,0]) cylinder(dz,r,r);
        translate ([dx-r,dy-r,0]) cylinder(dz,r,r);
    }
}
*/

module torus(R,r) {
    rotate_extrude(convexity = 10)
    translate([R, 0, 0]) circle(r = r, $fn = 100);
}

module disk(R,r){
    rotate_extrude(convexity = 10)
    { 
        intersection(){
            union(){
                translate([R-r, 0, 0]) circle(r = r, $fn = 100);
                translate([(R-r)/2,0]) square([R-r,r*2],center=true);        
            }
            translate([0,-r,0]) square([R,2*r]);            
        }
    }
}


module rounded_cylinder(h,r,rb,rt){
    rotate_extrude(convexity = 10) 
    mirror() rotate([0,0,90])
    intersection(){
        square([h,r]);
        union(){
            translate([h-rt,0,0]) square([rt,r-rt]);
            translate([h-rt,r-rt,0]) 
            intersection(){
                circle(rt);
                square(rt*2);
            }
            square([rb,r-rb]);
            translate([0,r-rb,0]) intersection(){
                translate([rb,0,0]) circle(rb);
                translate([-rb,0,0]) square(rb*2);
            }    
            translate([rb,0,0]) square([h-rt-rb,r]);
        }
    }
    /*
    translate([0,0,h-rt]) disk(r,rt);
    translate([0,0,rb]) cylinder(h-rb-rt,r,r);
    translate([0,0,rb]) disk(r,rb);
    */
}

module rounded_cube(w,l,h,rv,rb,rt){
	hull(){
		translate([-w/2+rv,-l/2+rv,0]) rounded_cylinder(h,rv,rb,rt);
		translate([-w/2+rv,+l/2-rv,0]) rounded_cylinder(h,rv,rb,rt);
		translate([+w/2-rv,+l/2-rv,0]) rounded_cylinder(h,rv,rb,rt);
		translate([+w/2-rv,-l/2+rv,0]) rounded_cylinder(h,rv,rb,rt);
	}
    
   /* 
    minkowski(){
        cube([w-2*rv,l-2*rv,h-rb-rt],center=true) ;
        //rounded_cylinder(rb+rt,rv,rb,rt);
        rounded_cylinder(7,10,5,2);
    }
    */
    
}

module cubeZ0(xSize,ySize,zSize){
    translate([0,0,zSize/2]) cube([xSize,ySize,zSize],center=true);
}
module cubeYZ0(xSize,ySize,zSize){
    translate([0,-ySize/2,0]) cube([xSize,ySize,zSize]);
}
module cubeXZ0(xSize,ySize,zSize){
    translate([-xSize/2,0,0]) cube([xSize,ySize,zSize]);
}
module cubeYZ0(xSize,ySize,zSize){
    translate([0,-ySize/2,0]) cube([xSize,ySize,zSize]);
}

module skiletZ0(xSize,ySize,zSize,step=0.8,w=0.1){
    for(y=[-ySize/2:step:ySize/2]){
		for(x=[-xSize/2:step:xSize/2]){
			translate([x,y,0]) cubeZ0(w,w,zSize);
		}
    }

}


module arced_cube(xSize,ySize,zCube){
	radius = xSize/2;
	cubeZ0(ySize,radius*2,zCube);
	
	translate([0,0,zCube]) intersection(){
		cubeZ0(ySize,radius*2,radius);
		rotate([0,90,0]) translate([0,0,-ySize/2]) cylinder(ySize,radius,radius);
	}
	
}

module prism(l, w, h){
       polyhedron(
               points=[[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]],
               faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
               );
       
    /*   // preview unfolded (do not include in your function
       z = 0.08;
       separation = 2;
       border = .2;
       translate([0,w+separation,0])
           cube([l,w,z]);
       translate([0,w+separation+w+border,0])
           cube([l,h,z]);
       translate([0,w+separation+w+border+h+border,0])
           cube([l,sqrt(w*w+h*h),z]);
       translate([l+border,w+separation+w+border+h+border,0])
           polyhedron(
                   points=[[0,0,0],[h,0,0],[0,sqrt(w*w+h*h),0], [0,0,z],[h,0,z],[0,sqrt(w*w+h*h),z]],
                   faces=[[0,1,2], [3,5,4], [0,3,4,1], [1,4,5,2], [2,5,3,0]]
                   );
       translate([0-border,w+separation+w+border+h+border,0])
           polyhedron(
                   points=[[0,0,0],[0-h,0,0],[0,sqrt(w*w+h*h),0], [0,0,z],[0-h,0,z],[0,sqrt(w*w+h*h),z]],
                   faces=[[1,0,2],[5,3,4],[0,1,4,3],[1,2,5,4],[2,0,3,5]]
                   );
				   */
       }
       
module cylinder_xyz(x,y,z,r0,r1){
    h = sqrt(x*x+y*y+z*z);
    rotate([0,acos(z/h),atan2(y,x)]) cylinder(h,r0,r1);
}       
module cylinder_2xyz(x0,y0,z0,x1,y1,z1,r0,r1){
    dx=x1-x0;
    dy=y1-y0;
    dz=z1-z0;
    translate([x0,y0,z0]) cylinder_xyz(dx,dy,dz,r0,r1);

}
       $fn=100;
//cylinder_xyz( 20,20,20,1);
//cylinder_2xyz(10,10,10,1, 20,20,20,1,1);

//      b1 ------- b2 
//     /          /|
//    b0 -------- b3
//    |          |
//
//                |
//    |         | |
//    | a1------+-a2 
//    |/        |/
//    a0------- a3

module poly8(a0,a1,a2,a3,
             b0,b1,b2,b3)
{
    polyhedron(points=[a0,a1,a2,a3, b0,b1,b2,b3],
               faces = [[0,3,2,1],[4,4+1,4+2,4+3],[0,1,4+1,4],[1,2,4+2,4+1],[3,4+3,4+2,2],[0,4,4+3,3]]);
    
    
}

//poly8 ([0,0,0],[0,0,1],[1,0,1],[1,1,0],  [0,20,0],[0,20,1],[1,20,1],[1,19,0] );

/*
intersection(){
    cube(10);
    poly8 ([0,0,0],[0,3,0],[3,3,0],[3,0,0],        [0,0,3],[0,1,3],[1,1,3],[1,0,3]);
}
*/
//    poly8 ([0,0,0],[0,3,0],[3,3,0],[3,0,0],        [0,0,3],[0,1,3],[1,1,3],[1,0,3]);




module rounded_arc_int_(h,rb,wb,rbint,rbext,
                          rt,wt,rtint,rtext, ang)  
{
    difference(){
        rotate_extrude(angle=ang) 
        hull(){
            translate([rb+rbint,rbint]) circle(rbint);
            translate([rb+wb-rbext,rbext]) circle(rbext);
            
            translate([rt+rtint,h-rtint]) circle(rtint);
            translate([rt+wt-rtext,h-rtext]) circle(rtext);
        }   
    }

          
}
module rounded_arc_int(h,rb,wb,rbint,rbext,
                         rt,wt,rtint,rtext, ang, roundendface=false)  
 {
    
    if (roundendface){
        difference(){
            rounded_arc_int_(h,rb,wb,rbint,rbext, rt,wt,rtint,rtext, ang);  
            rotate ([0,0,ang]) 
                mirror([0,1,0]) 
                    poly8(  [rb,0,0],[rb,rbint,0],[rb+wb,rbext,0],[rb+wb,0,0],
                            [rt,0,h],[rt,rtint,h],[rt+wt,rtext,h],[rt+wt,0,h]);
            poly8(  [rb,0,0],[rb,rbint,0],[rb+wb,rbext,0],[rb+wb,0,0],
                    [rt,0,h],[rt,rtint,h],[rt+wt,rtext,h],[rt+wt,0,h]);
          
        
        }
    }
    else {
           rounded_arc_int_(h,rb,wb,rbint,rbext, rt,wt,rtint,rtext, ang);  
    }
    
    if (roundendface){
        hull(){
            translate([rb+rbint,rbint,rbint]) sphere (rbint);
            translate([rb-rbext+wb,rbext,rbext]) sphere (rbext);
            translate([rt+rtint,rtint,h-rtint]) sphere (rtint);
            translate([rt-rtext+wt,rtext,h-rtext]) sphere (rtext);
           // cylinder_2xyz(rb+roundb,roundb,roundb,rb-roundb+wb,roundb,roundb,roundb,roundb);
           // cylinder_2xyz(rb+roundb,roundb,roundb,rt+roundt,roundt,h-roundt,roundb,roundt);
           // cylinder_2xyz(0,0,0,10,10,10,roundb,roundb);
       }
        hull(){
            rotate([0,0,ang]) translate([rb+rbint,-rbint,rbint]) sphere (rbint);
            rotate([0,0,ang]) translate([rb-rbext+wb,-rbext,rbext]) sphere (rbext);
            rotate([0,0,ang]) translate([rt+rtint,-rtint,h-rtint]) sphere (rtint);
            rotate([0,0,ang]) translate([rt-rtext+wt,-rtext,h-rtext]) sphere (rtext);
           
           
           // cylinder_2xyz(rb+roundb,roundb,roundb,rb-roundb+wb,roundb,roundb,roundb,roundb);
           // cylinder_2xyz(rb+roundb,roundb,roundb,rt+roundt,roundt,h-roundt,roundb,roundt);
           // cylinder_2xyz(0,0,0,10,10,10,roundb,roundb);
       }

    }
}

//rounded_arc_int(10,20,10,1,2,                    20,10,3,4,90,false);
