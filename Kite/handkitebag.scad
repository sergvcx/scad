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
	w0=3.6+1.2;
	w=w0*sin(55);
	w2=w0*sin(55);
	r=(3.2-0.0)/2;
	
	//deep=w2*2;
	deep=8.5;
	clipseZ=25;
	clipseH=15;
	clipseW=1.4-0.4;
	spring_r=9/2;
	rc=4; //round cube
	rcext=rc+1.6*w2;
	dd=0;
	//translate([deep-(r+w0)/2,deep+r+w0-w0/4-1,1]) rotate([0,0,90]) cubeZ0(w0/2,(r+w0),size-2);
	//translate([deep+r+w0-w0/4-1,deep-(r+w0)/2,1]) rotate([0,0,0]) cubeZ0(w0/2,(r+w0),size-2);
	arch=25;
	arcr=56/2;
	//color ("blue") translate([deep,deep,w2+1])  cylinder(arch-2*w2-2,arcr-2,arcr-2);

	difference(){
		union(){
			
			//cube([size,size,w]);
			//cube([w,size,size]);
			translate([deep,deep,w2]) sphere (spring_r+w2);
			// усилитель боковины
			difference(){
				translate([arcr/2+10,arcr/2+10,0]) rounded_cube(arcr+20,arcr+20,10,spring_r+w2,1,1);
				translate([size+w2,size+w2,w]) rounded_cube(2*size,2*size,2*size,rc,rc,rc);
			}
			// cube walls
			difference(){
				translate([size/2,size/2,0])   rounded_cube(size,size,size,rcext,rcext,rcext);
				translate([size+w2,size+w2,w]) rounded_cube(2*size,2*size,2*size,rc,rc,rc);
			}
			intersection(){
				translate([size/2,size/2,0])   rounded_cube(size,size,size,rcext,rcext,rcext);
				union(){
					// arc ext
					translate([deep,deep,0]) cylinder(arch,arcr,arcr);
					// spring ext
				}
			}
					translate([deep,deep,5])  cylinder(size-7+20,spring_r+w2,spring_r+w2);
		}
		
		
		//tube int (nail)
		#translate([deep,deep,-2]) cylinder(size+1,r,r);		
		
		// wheel
		difference(){
			translate([deep,deep,w2]) cylinder(arch-2*w2,arcr-w2,arcr-w2);
			translate([deep,deep,w2]) cylinder(1,spring_r+w2,spring_r+w2);
			translate([deep,deep,arch-w2-1]) cylinder(1,spring_r+w2,spring_r+w2);
		}
		translate([deep,deep,w2]) cylinder(1,r,r+1);
		// spring hole
		translate([deep,deep,arch+5]) cylinder(150,spring_r,spring_r);
		translate([deep,deep,arch+5]) sphere(spring_r);
		translate([deep,deep,arch]) cylinder(4,r,spring_r);
			
		
		//------ holes 
		translate([25,10,65])rotate([90,0,0]) cylinder(100,5/2,5/2);
		translate([65,10,25])rotate([90,0,0]) cylinder(100,5/2,5/2);
		
		translate([-10,25,65])rotate([0,90,0]) cylinder(100,5/2,5/2);
		translate([-10,65,25])rotate([0,90,0]) cylinder(100,5/2,5/2);
		
		translate([65,25,-10])rotate([0,0,90]) cylinder(100,5/2,5/2);
		translate([25,65,-10])rotate([0,0,90]) cylinder(100,5/2,5/2);

		//nail 
		translate([-0,r+1,arch+3])rotate([0,90,45]) cylinder(100,1/2,1/2);
		translate([-0,r+1.5,arch+5])rotate([0,90,45]) cylinder(100,1/2,1/2);
		translate([-0,r+1.5,arch+7])rotate([0,90,45]) cylinder(100,1/2,1/2);
		//#translate([-0,r+1.5,arch+9])rotate([0,90,45]) cylinder(100,1/2,1/2);
		
		translate([-0,-r+-1.5,arch+4])rotate([0,90,45]) cylinder(100,1/2,1/2);
		translate([-0,-r+-1.5,arch+6])rotate([0,90,45]) cylinder(100,1/2,1/2);
		//#translate([-0,-r+-1.5,arch+8])rotate([0,90,45]) cylinder(100,1/2,1/2);
		
	}
}
//recttube(10,20,15,1);
//box_intZ0(10,10,20,2);


if (0) for(x=[1:0.2:5]){
	translate([x*30,0,0]) cube([x,10,20]); 
}

module wheel(){
	}
//translate([11,0,0]) cube([3,10,20]);

module final(){
 intersection(){
	cylinder(100,85,75);
	//#translate([00,-30,30]) rotate([90-30,0,0]) cylinder(200,85,85,center=true);
	translate([00,27,0]) rotate([0,90,0]) cylinder(200,65,65,center=true);
	rotate([0,90,30]) translate([00,0,-158]) cylinder(200,80,80);
	rotate([0,90,180-30]) translate([00,0,-158]) cylinder(200,80,80);
	translate([0,3,61])	rotate([-35-90,0,0]) rotate([0,0,45]) chassis();
}
}
module final_plus(){

	difference(){
		
	
	}
}

final(1);