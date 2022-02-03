//include <gopro_mounts_mooncactus.scad>
include <../../lib/mylib.scad>
use <gopro_mounts_mooncactus.scad>
use  <../../lib/gears.scad>
use  <../../lib/tubes.scad>
//gopro_connector("triple");
$fn=100;
h = 14.7;
ang = 35+30;
rod = 30+10;

module gopro_rod(){
 rotate([0,0,-(90)])  translate([0,-11,0])        gopro_connector("triple", withnut=true);
 hull()
	 {
	 translate([-0.5,-h/2,-h/2]) cube([3,h,h]);
	 translate([h,35,-h/2]) cube([2,20,h]);
	 }
difference(){	 
	translate([h,35,-h/2]) cube([h,20,h]);
   #translate([h+h/2,35,0])   rotate([-90,0,0]) cylinder(300,2.75,2.75,center=true);
 }

}

module big_gear(){
difference(){
if (1){

	color([0,0.75,0.75])
	translate([h+h/2,0,0])  rotate([0,0,90])

	gear(3,102,4,6);
	
	
	}
translate([0,0,53]) rotate ([-90,0,0]) gopro_rod();

}
}

module small_gear(){
	color([1.00,0.75,0.75]) translate([0,0,0])  gear(3,14,5,2.9);

//	difference(){
//	translate([0,0,2.5]) cylinder(2,8.2,10);
//	cylinder(10,3/2,3/2);
//	}
//difference(){
//   for(ang=[0:60:360])
//	translate([0,0,3]) rotate([0,0,ang]) cubeZ0(1,60,20);
//	cylinder(10,3,3);
//	}
//   }

color([1.00,0.75,0.75]) translate([0,0,-4])  gear(3,80,3,2.9);
}   
   
 //  small_gear();
gopro_rod();
//tube_int(1.5+0.4,14,14,1);
// gear(3,35,3-0.4,5);

