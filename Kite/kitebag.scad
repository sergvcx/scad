//linear_extrude(80, twist=180,scale=[3,3]) translate([20,0,0]) 

//translate([-1000,0]) linear_extrude(3,  twist=1 ,scale=([1,1]),$fn=1000) translate([1000,0]) difference()
//{
//square([12,12]);
//translate([2,2]) square([8,8]);
//}
    ;
//cube([10,10,10]);

include <../lib/vector.scad>
include <../lib/maths.scad>
include <../lib/mylib.scad>
include <../lib/tubes.scad>


module bolt(r1,r2,h){
    cylinder(r1,r1,0);
    cylinder(h,r2,r2);
}
$fn=50;
//bolt(20,10,20);
module chassis(xsize,ysize,zsize,r,w){
        axisY=r+3;
        axisZ=r+3;
        intersection(){
        difference(){
           union(){
               difference(){
                cube([xsize,ysize,zsize]);
                translate([w,w,w]) cube([xsize,ysize,zsize]);
               }
               translate([xsize/2,axisY-r+(r+w-1)/sin(45),axisY-r+(r+w-1)/sin(45)])  rotate([45,0,0]) cube([xsize,w,38],center=true);
               translate([0,axisY,axisZ]) rotate([0,90,0]) cylinder(xsize,r+w,r+w);
//               cube_Z0();
                
           }
           
           #translate([0,axisY,axisZ])  rotate([0,90,0]) cylinder(xsize+1,r,r);
           #translate([xsize/2,axisY,axisZ])  rotate([-45+180,0,0]) cubeZ0(xsize,2*r,80);
		   //#translate([xsize/2,axisY,axisZ])  rotate([-45+180,0,0]) cubeZ0(xsize,2*r,100);
           rotate([0,90,0]) tube_int(xsize,ysize,ysize,60);       
           for (y=[15:20:ysize]){
            for (x=[10:20:xsize]){
              // translate([x,y,0]) cylinder(10,1.5,1.5); holes
            }
          }
          for (z=[15:20:zsize]){
            for (x=[10:20:xsize]){
            //   translate([x,0,z]) rotate([-90,0,0]) cylinder(10,1.5,1.5); holes
            }
          }
       }
       
       
          
       cube([xsize,ysize,zsize]);
   }
   translate([w,w,20]) faska(zsize-20,r);
   translate([w,20,w]) rotate([-90,0,0]) rotate([0,0,-90]) faska(ysize-20,r);
}

module faska(h,r){
    
    intersection(){
        cubeZ0(2*r,2*r,h);
        translate([r,r,0]) difference(){
            cubeZ0(2*r,2*r,h);
            cylinder(h+0.1,r,r);
        }
    }
}

//faska(10,3);
//chassis(100,100,100,12.1/2,5);

module box_int(x,y,h,w){
	difference(){
		cube([x+2*w,y+2*w,h]);
		#translate([w,w,0]) cube([x,y,h]);
	}
}

module box_intZ0(x,y,h,w){
	difference(){
		cubeZ0(x+2*w,y+2*w,h);
		translate([0,0,-0.01]) cubeZ0(x,y,h+0.02);
	}
}

module recttube_int(x,y,h,w){
	difference(){
		cubeZ0(x+2*w,y,h+2*w);
		translate([0,0,w]) cubeZ0(x,y+10,h);
	}
}
module recttube_ext(x,y,h,w){
	difference(){
		cubeZ0(x,y,h);
		translate([0,0,w]) cubeZ0(x-2*w,y+10,h-2*w);
	}
}

module chassis(){
	size=100;
	w0=3.6+1.3;
	w=w0*sin(55);
	w2=w0*sin(55);
	r=(13-0.0)/2;
	deep=r+r/2+2;
	clipseZ=25;
	clipseH=15;
	clipseW=1.4-0.4;
	rc=3; //round cube
	dd=0;
	translate([deep-(r+w0)/2,deep+r+w0-w0/4-1,1]) rotate([0,0,90]) cubeZ0(w0/2,(r+w0),size-2);
	translate([deep+r+w0-w0/4-1,deep-(r+w0)/2,1]) rotate([0,0,0]) cubeZ0(w0/2,(r+w0),size-2);

	difference(){
		union(){
			//cube([size,size,w]);
			//cube([w,size,size]);
			//cube([size,w,size]);
			difference(){
				translate([size/2,size/2,0])   rounded_cube(size,size,size,rc+w+1.0,rc+w+1.0,rc+w+1.0);
				//translate([size+w2,size+w2,w]) rounded_cube(2*size,2*size,2*size,rc+1,rc+1,rc+1);
				translate([size+w2,size+w2,w]) rounded_cube(2*size,2*size,2*size,rc+8,rc+8,rc+8);
			}
			//translate([deep,deep,0]) tube_int(size,r,r,w);
			// tube ext
			translate([deep,deep,0]) cylinder(size-1,r+w0-1,r+w0-1);
			// partition
			//translate([deep-(r+w0)/2,deep+r+w0/2,1]) rotate([0,0,90]) cubeZ0(w0,(r+w0),size-2);
			//#translate([deep+r+w0/2,deep-(r+w0)/2,1]) rotate([0,0,0]) cubeZ0(w0,(r+w0),size-2);
			// spacer
			translate([deep,deep,-0.6]) cylinder(0.6,r+5,r+5);
			//rotate([0,0,-45])cubeZ0(2*r+2*w0,2*deep/sin(45),size);
			//translate([deep+(r)*sin(45),deep+(r)*sin(45),0]) rotate([0,0,-45]) cubeZ0(20,w,size);
		}
		// low brick 
		translate([0,0,-1]) rotate([0,0,-45])cubeZ0(2*r,2*deep/sin(45),clipseZ+1);
		// low clipse hole
		translate([0.5,0.5,clipseZ]) rotate([0,0,-45]) recttube_ext(2*r+2*w+2*clipseW,2*(r/2+deep/sin(45)),clipseH,clipseW);
		// med brick 
		translate([0,0,clipseZ+clipseH]) rotate([0,0,-45]) cubeZ0(2*r,2*deep/sin(45),size-75);
		// high clipse hole
		translate([0.5,0.5,clipseZ+40]) rotate([0,0,-45]) recttube_ext(2*r+2*w+2*clipseW,2*(r/2+deep/sin(45)),clipseH,clipseW);
		// high brick 
		translate([0,0,clipseZ+40+clipseH]) rotate([0,0,-45]) cubeZ0(2*r,2*deep/sin(45),size-clipseZ-clipseH);
		
		
		//tube int 
		translate([deep,deep,-1]) cylinder(size+1,r,r);		
		// скос для входа
		translate([-1.9,-1.9,-1]) cubeZ0(2*(r+w)/sin(45),2*(r+w)/sin(45),size+1);		
		// ???
		//#translate([-100*sin(45)/2+7,7-100*sin(45)/2,50-1]) rotate([0,0,45]) cube([size,size,size+3],center=true);		
		
		//------ holes 
		translate([2*r+25,10,20])rotate([90,0,0]) cylinder(100,5/2,5/2);
		translate([2*r+25,10,65])rotate([90,0,0]) cylinder(100,5/2,5/2);
		translate([2*r+65,10,20])rotate([90,0,0]) cylinder(100,5/2,5/2);
		
		translate([-10,2*r+25,20])rotate([0,90,0]) cylinder(100,5/2,5/2);
		translate([-10,2*r+25,65])rotate([0,90,0]) cylinder(100,5/2,5/2);
		translate([-10,2*r+65,20])rotate([0,90,0]) cylinder(100,5/2,5/2);
		
		
	}
}
//recttube(10,20,15,1);
//box_intZ0(10,10,20,2);

if (0) for(x=[1:0.2:5]){
	translate([x*30,0,0]) cube([x,10,20]); 
}


//translate([11,0,0]) cube([3,10,20]);
//chassis();
if (1) intersection(){
	cylinder(100,75,75);
	translate([00,19,10]) rotate([0,90,0]) cylinder(200,65,65,center=true);
	rotate([0,90,30]) translate([00,0,-149]) cylinder(200,80,80);
	rotate([0,90,180-30]) translate([00,0,-149]) cylinder(200,80,80);
	translate([0,3,75])
	rotate([-35-90,0,0]) rotate([0,0,45]) chassis();
}


//18:54 23.06.2019
if (0) intersection(){
//	translate([0,0,60])
//	#cylinder(100,80,80);
	translate([0,0,78])
//	rotate ([45+180,32,0]) 
	chassis(120,130,130,(12.2+0.8)/2,2);
	//cubeZ0(185,1000,1000);
}
