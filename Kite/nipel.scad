
include <../lib/mylib.scad>
include <../lib/tubes.scad>
//     | |
//     | |
//     / / r1
//    / /
//   / /
//   | |
//   | | r0

//r0 = 23/2; // => 23.0-23.30 = 23.15
r0min = (23-0.3)/2; // => 2323.30
r0max = (23-0.1)/2; // => 23.41
r1min = (20-0.2+0.1)/2;
r1max = (20)/2;
w  = 2;


translate([0,0,-2]) tube_ext(10,r0min,r0max,w);
translate([0,0,8]) tube_ext(6,r0max,r1max,w);
translate([0,0,14]) tube_ext(16+2,r1max,r1min,w);
translate([0,0,14]) tube_ext(2,r1min,r1min+1,w);
difference(){
	translate([0,0,14+2+7])rotate([0,90,0]) cylinder(r1max*2+4,2,2,center=true);
	cylinder(100,r1max-2,r1max-2);
}

translate([0,11,12]) 
rotate ([0,90,0]) difference() {
	cylinder(2,3,3);
	cylinder(2.1,1,1);
}
	