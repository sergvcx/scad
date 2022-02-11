/*
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

/*
module rounded_cylinder(h,r,rb,rt){
    rotate_extrude(convexity = 10) 
    //mirror() 
	rotate([0,0,90])
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
}*/
module rounded_cylinder(h,rb,rt,rrb,rrt,center=1){
    
	
	translate([0,0,-h/2*(1-center)+(h-abs(h))/2]) 
	rotate_extrude(convexity = 10) 
		difference(){
			hull(){
				square([0.1,abs(h)]);
				translate([rt-rrt,abs(h)-rrt]) circle(rrt);
				translate([rb-rrb,       rrb]) circle(rrb);
			}
			translate([-rrb-rrt,0]) square([rrb+rrt,abs(h)]);
			
		}

	
}

module rounded_cube(w,l,h,rv,rb,rt){
	hull(){
		translate([-w/2+rv,-l/2+rv,0]) rounded_cylinder(h,rv,rv,rb,rt);
		translate([-w/2+rv,+l/2-rv,0]) rounded_cylinder(h,rv,rv,rb,rt);
		translate([+w/2-rv,+l/2-rv,0]) rounded_cylinder(h,rv,rv,rb,rt);
		translate([+w/2-rv,-l/2+rv,0]) rounded_cylinder(h,rv,rv,rb,rt);
	}
	//cubeZ0(w,l-2*rv,h);
	//cubeZ0(w-2*rv,l,h);
    
   /* 
    minkowski(){
        cube([w-2*rv,l-2*rv,h-rb-rt],center=true) ;
        //rounded_cylinder(rb+rt,rv,rb,rt);
        rounded_cylinder(7,10,5,2);
    }
    */
    
}

module cubeY0(xSize,ySize,zSize){
	translate([0,ySize/2,0]) cube([abs(xSize),abs(ySize),abs(zSize)],center=true);
	
}
module cubeX0(xSize,ySize,zSize){
	translate([xSize/2,0,0]) cube([abs(xSize),abs(ySize),abs(zSize)],center=true);
	
}

module cubeZ0(xSize,ySize,zSize){
	translate([0,0,zSize/2]) cube([abs(xSize),abs(ySize),abs(zSize)],center=true);
	
}
module cubeXZ0(xSize,ySize,zSize){
    translate([xSize/2,0,zSize/2]) cube([abs(xSize),abs(ySize),abs(zSize)],center=true);
}
module cubeYZ0(xSize,ySize,zSize){
    translate([0,ySize/2,zSize/2]) cube([abs(xSize),abs(ySize),abs(zSize)],center=true);
}
module cubeXYZ0(xSize,ySize,zSize){
	translate([xSize/2,ySize/2,zSize/2]) cube([abs(xSize),abs(ySize),abs(zSize)],center=true);
}

module cubeXY0(xSize,ySize,zSize){
	translate([xSize/2,ySize/2,0]) cube([abs(xSize),abs(ySize),abs(zSize)],center=true);
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


module honey_cylinder(h,r){
	$fn=6;
	cylinder(h,r,r);
}

module honey_cube(sx,sy,sz,d,w,inv=true){
	$fn=6;
	dy = w+d*sin(60);
	dx = 3/2*d+2*w*sin(60);

	{
		if (inv){
			intersection(){
				cubeZ0(sx,sy,sz);
			
				union(){
					for(y=[-round(sy/2/dy)*dy-dy:dy:sy/2+dy]){
						for(x=[-round(sx/2/dx)*dx-dx:dx:sx/2+dx]){
							translate([x,y,-1]) honey_cylinder(sz+2,d/2);
						}
					}
					for(y=[-round(sy/2/dy)*dy+d*sin(60)/2+w*sin(30)-dy:dy:sy/2+dy]){
						for(x=[-round(sx/2/dx)*dx+d/2+d/4+w*cos(30)-dx:dx:sx/2+dx]){
							translate([x,y,-1]) honey_cylinder(sz+2,d/2);
						}
					}
				}
			}
		}
		else {
			difference(){
				cubeZ0(sx,sy,sz);
			
					for(y=[-round(sy/2/dy)*dy-dy:dy:sy/2+dy]){
						for(x=[-round(sx/2/dx)*dx-dx:dx:sx/2+dx]){
							translate([x,y,-1]) honey_cylinder(sz+2,d/2);
						}
					}
					for(y=[-round(sy/2/dy)*dy+d*sin(60)/2+w*sin(30)-dy:dy:sy/2+dy]){
						for(x=[-round(sx/2/dx)*dx+d/2+d/4+w*cos(30)-dx:dx:sx/2+dx]){
							translate([x,y,-1]) honey_cylinder(sz+2,d/2);
						}
					}
			}
		}
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

module leg(x,y,z,rb,rt,rw){
	difference(){
		cube([x,y,z]);
		
		//translate() 
		hull(){
				translate([x,0,rb]) rotate([-90,0,0]) cylinder(y,rb,rb);
				translate([rt,0,z]) rotate([-90,0,0]) cylinder(y,rt,rt);
				translate([x,0,z]) cube([rb,y,rt]);
		}
		hull(){
			translate([x,0,rw]) sphere(rw);
			translate([rw,0,rw]) sphere(rw);
			translate([rw,0,z]) sphere(rw);
		}
		
	}
		
		
	
}
module nut(h,size){
	$fn=6;
	rotate([0,0,0]) cylinder(h,size/sin(60)/2,size/sin(60)/2);
}

module cylinder_connector(h,rbot,rtop,r){
	alpha=atan(h/(rbot-rtop));
	dz=r*cos(alpha);
	dy=r*sin(alpha);
	difference(){
		hull(){
			torus(rbot-r,r);
			translate([0,0,h-dz-0.1])  cylinder(0.1,rtop+(r-r*sin(alpha)),rtop+(r-r*sin(alpha)));
		}
		cubeZ0(rbot*2,rbot*2,-2*r);
	}
	difference(){
		translate([0,0,h-dz])  cylinder(dz,rtop+(r-r*sin(alpha)),rtop);
		translate([0,0,h])  torus(rtop+r,r);
	}
	
}

module sector(h,rbot,rtop,ang){
	rotate_extrude(angle=ang) polygon( points=[[0,0],[rbot,0],[rtop,h],[0,h]] );
	
	//cylinder(h,r0,r1);
}


module cylinder_cut(cylinder_height,horda, cut) {
    //(R-cut)^2+(horda/2)^2=R^2;
	$fn=1000;
	R=(horda*horda/4+cut*cut)/2/cut;
	intersection(){
		translate([0,0,-R+cut]) rotate([0,90,0]) cylinder(cylinder_height,R,R,center=true);
		cubeZ0(cylinder_height,horda,cut);
	}
	
}

module frame_ext(x,y,z,t,r,center=true){
	if (center)
		linear_extrude(height = z, twist = 0, slices = 60) {
			difference() {
				offset(r) square([x-2*r,y-2*r], center=true);
				rint = r-t;
				offset(rint) square([x-2*t-2*rint,y-2*t-2*rint], center=true);
		    }
		}
	else
		linear_extrude(height = z, twist = 0, slices = 60) {
			translate([x/2,y/2,0])
			difference() {
				offset(r) square([x-2*r,y-2*r], center=true);
				rint = r-t;
				offset(rint) square([x-2*t-2*rint,y-2*t-2*rint], center=true);
		    }
		}

}
module frame_int(x,y,z,t,r,center=true){
	if (center)
		frame_ext(x+2*t,y+2*t,z,t,t+r,true);
	else 
		translate([x/2,y/2,0]) frame_ext(x+2*t,y+2*t,z,t,t+r,true);
	
}
//leg (50,50,50,2,2,2);
	
//rounded_arc_int(10,20,10,1,2,                    20,10,3,4,90,false);
module rounded_tube(h,r_bot_int,r_bot_ext,r_top_int,r_top_ext,rr){

	rotate_extrude(convexity=10)
	hull(){
		//translate([0,5,0]) circle (2);
		//translate([10,h-rr,0]) circle (rr);
		translate([r_top_int+rr,h-rr,0]) circle (rr);
		translate([r_top_ext-rr,h-rr,0]) circle (rr);
		
		translate([r_bot_int+rr,rr,0]) circle (rr);
		translate([r_bot_ext-rr,rr,0]) circle (rr);
	}
}
module my_cylinder(h,rbot,rtop,center=false){
	if (h>0)
		cylinder(h,rbot,rtop,center);
	else 
		translate([0,0,h]) cylinder(-h,rbot,rtop,center);
}
