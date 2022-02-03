include <../lib/mylib.scad>

module edge(R,dx){
    
    intersection(){
        translate([R-dx,0,0]) sphere(R);
        translate([-R+dx,0,0]) sphere(R);
        translate([ -dx,-R,0]) cube([2*dx,R*2,R]);
    }
}


hole=38/2;
holeR=2.45+0.1-0.2;
holeH=25;
width=60;
R=200;
dx=4.3+0.3;




$fn=150;		
module plavnik(){
	difference(){
		difference(){
		scale([1,1,1.0])
			hull(){
				translate([ 0,-width/2,0]) edge(R,dx);
				translate([ 0, width/2,0]) edge(R,dx);
			}
			
			//color("blue") cylinder_cut(10,140,1) ;
			translate([ 0,-hole,-0.01]) cylinder(holeH,holeR,holeR);
			translate([ 0,0,-0.01]) cylinder(holeH,holeR,holeR);
			//translate([ 0, hole,0]) edge(R,dx);
			translate([ 0, hole,-0.01]) cylinder(holeH,holeR,holeR);

		}

	rr= 200;
	k = 0.125;
	translate([0,0,1.25]) scale([1,1,k]) translate([0,0,-rr]) rotate([0,90,0]) cylinder(20,rr,rr,center=true);
	}

}

module shtift(){
	
	intersection(){
	#cubeZ0(6-0.6,10,100);
	difference(){
		union(){
			cylinder(4,6.18/2,6.18/2);
			cylinder(15,4.8/2,4.7/2);
		}
		//cubeZ0(10,1,1);
	}
	}
}
rotate([0,90,0]) shtift();

//plavnik();