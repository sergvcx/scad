module Stepper(plusminus,tolerance=0){
	tl=tolerance;
	motorW=28+tl;
	motorH=19+tl;
	if (plusminus>0){
		translate([0,0, 35/2]) rotate([0,90,0])  cylinder(4,3.5/2,3.5/2);
		translate([0,0,-35/2]) rotate([0,90,0])  cylinder(4,3.5/2,3.5/2);
	}
	if (plusminus<0){
		translate([-5-0.111,8,0]) rotate([0,90,0])  cylinder(5+0.222,10/2,10/2);
	}
	if (plusminus==0){
		difference(){
			union(){
				translate([0,0, 35/2]) rotate([0,90,0])  cylinder(1,7/2,7/2);
				translate([0,0,-35/2]) rotate([0,90,0])  cylinder(1,7/2,7/2);
				translate([0.5,0,0])   cube([1,7,35], center=true);
			}
			translate([-0.111,0, 35/2]) rotate([0,90,0])  cylinder(4+0.222,3.5/2,3.5/2); // holes
			translate([-0.111,0,-35/2]) rotate([0,90,0])  cylinder(4+0.222,3.5/2,3.5/2); // holes
		}
		translate([0,0,0]) rotate([0,90,0])  cylinder(motorH,motorW/2,motorW/2); //motor
		translate([-2, 8,0]) rotate([0,90,0])  cylinder(2,10/2,10/2); 
		translate([-10,8,0]) rotate([0,90,0])  cylinder(10,5/2,5/2);  //shaft
		translate([motorH/2,-18/2,0]) cube([motorH,18,18],center=true);
    }
}
