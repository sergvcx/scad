include <lib/tubes.scad>
include <lib/mylib.scad>
include <lib/arduino.scad>

watchH = 10;
watchR = 45/2;
beltR  = 70/2;
beltW  = 28;

baseH  = beltR*2+8;
baseR  = beltR+10;
module watch(){
    translate([0,0,beltR-watchH])  cylinder(watchH,watchR,watchR);
	translate([-beltW/2,0,0]) rotate([0,90,0])  cylinder(beltW,beltR,beltR);
}
module watchdiff(){
	translate([0,0,beltR-watchH])  cylinder(watchH,watchR,watchR);
	translate([-beltW/2,0,0]) rotate([0,90,0])  cylinder(beltW,beltR,beltR);
	cubeZ0(beltW,beltR*2,beltR);
}
module base(){
	
	
	difference(){
		union(){
		
			translate([0,0,baseR-10]) cylinder(baseH-baseR+10,baseR,baseR); //base tube
			cylinder(baseR-10,11,baseR); //base tube
		}
		translate([0,0,baseH-2*beltR+0.1]) 	translate([0,0,beltR]) watchdiff();
		stepper(0,0.2);
		//cubeZ0(baseR*2,baseR*2,baseR-10);
	}
	%color("blue") translate([0,0,10+beltR+0.1]) watch();
	%color("blue") stepper(0,0.2);
	
}
//watchdiff();
//rotate([0,45,0]) base();
difference(){
	hull(){
		translate([-26,0,-28]) cubeYZ0(113,(baseR+3)*2,3);
		rotate([0,45,0]) translate([0,0,8]) cylinder(70,baseR+3,baseR+3);
	}
	hull(){
		translate([-26+2,0,-28+2]) cubeYZ0(111-4,(baseR+3)*2-4,3);
		rotate([0,45,0]) translate([0,0,8]) cylinder(68,baseR+1,baseR+1);
	}
	//translate([55,0,55]) rotate([0,45,0]) cubeZ0(baseR*3,baseR*3,baseR*3);
	rotate([0,45,0]) translate([0,0,12]) cylinder(100,baseR+1,baseR+1);
	rotate([0,45,0]) translate([0,0,0]) cylinder(12, 25,baseR+1);
}
