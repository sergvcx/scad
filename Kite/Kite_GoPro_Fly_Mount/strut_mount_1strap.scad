//use <../gopro/gopro.scad>

use  <../../lib/gears.scad>


//#translate([ 0,    0, 0]) rotate([0,0, $t*360/n1])                 color([1.00,0.75,0.75]) #gear(mm_per_tooth,n1,thickness,hole);

include <gopro_mounts_mooncactus.scad>

$fn=20;
//$fn=60;  //probably shouldn't use this for tweaking
strut_radius=93/2;
height=45;
thick=5;

slice=80;

strap_height=4+thick;
strap_slot=3.5;
strap_block=30;
strap_w = 26;
strap_offset=0;

module body() {
	difference() {
		translate([0,-strut_radius,0])
		rotate_extrude()
		translate([strut_radius, 0, 0])
		hull() {
		    translate([0,height/2-thick/2,0]) circle(r=thick/2);
		    translate([0,-(height/2-thick/2),0]) circle(r=thick/2);	
		}


		union() {
		 	translate([0,-strut_radius,-(height+10)/2])
		    rotate([0,0,-slice/2])
		    cube([strut_radius*2+thick,strut_radius*2,height+10]);

			translate([0,-strut_radius,-(height+10)/2])
		    rotate([0,0,90+slice/2])
		    cube([strut_radius*2+thick,strut_radius*2,height+10]);

			translate([0,-strut_radius*2,0])
		    cube([strut_radius*2+thick,strut_radius*2,height+10],center=true);

		}
	}

}


module base() {
    translate([-strap_block/2,0,-height/2]) {
		hull() {
			translate([strap_block-thick/2,strap_height-thick,thick/2]) sphere(r=thick/2);
			translate([strap_block-thick/2,strap_height-thick,height-thick/2]) sphere(r=thick/2);
			translate([thick/2,strap_height-thick,thick/2]) sphere(r=thick/2);
			translate([thick/2,strap_height-thick,height-thick/2]) sphere(r=thick/2);
			translate([0,-(strap_height-thick),0]) {
				translate([strap_block-thick/2,strap_height-thick,thick/2]) sphere(r=thick/2);
				translate([strap_block-thick/2,strap_height-thick,height-thick/2]) sphere(r=thick/2);
				translate([thick/2,strap_height-thick,thick/2]) sphere(r=thick/2);
				translate([thick/2,strap_height-thick,height-thick/2]) sphere(r=thick/2);
			}
		}
	}
}

module straps() {
	module strap() {
		translate([0,-strut_radius,0])
		rotate_extrude()
		translate([strut_radius+thick-1.5, 0, 0])
		square([strap_slot,strap_w],center=true);		
	}
	translate([0,0,strap_offset]) strap();
}


module assembly() {
    difference() {
		union() {
			body();
			base();

			//translate([0,7.5+strap_height,13])
             //   rotate([0,90,180])
               //     gopro_connector_taper();
		}
		straps();
	}
    
    //translate ([0,17,0]) rotate  ([0,90,180]) gopro_connector("triple", withnut=true);
}

module nut(size,h){
    x=$fn;
    $fn=6;    
    cylinder(h,size/sin(60)/2,size/sin(60)/2);
}
//gaika(100,20,8);

$fn=26;

ang = 15;
//translate([20,20,20]) gaika(10,20,10);
if (1) difference(){
    
    union(){
        translate([0,0,-height/2+3]) assembly();
        hull(){
			translate([0,7,38]) rotate([0,90,0]) cylinder(20,1,1,center=true);
			rotate([ang*2,0,0]) translate([0,7,-38]) rotate([0,90,0]) cylinder(20,1,1,center=true);
			translate([0,7,-38]) rotate([0,90,0]) cylinder(20,1,1,center=true);
		}
		//{
        //    translate([0,6,0]) cube([20,1,height*1.3],center=true);
        //    #translate([0,12,5]) rotate([ang,0,0]) cube([15,12,15],center=true);
        //}
        translate([0,0,+height/2-3]) assembly();
    }
    //#translate([0,-10,-5]) rotate([-90+ang,0,0]) 
    translate([0,0,-28]) rotate([-90+ang,0,0]) translate([0,0,6])
		union(){
			#cylinder(100,2.45,2.45);
			//translate([0,25-15/2-4.2,0]) rotate([-90,0,0]) nut(8,20);    
			//#translate([0,-13,-5]) rotate([-90+ang,0,0]) cylinder(17,15,0);    
			#translate([0,0,0]) cylinder(5,5,0);    
			translate([0,0,0]) rotate([0,180,0]) cylinder(30,5,5);    
			
		}

    translate([0,0,30]) rotate([-90+ang,0,0]) translate([0,0,5])
	union(){
		#cylinder(100,3.1/2,3.1/2);
		//translate([0,25-15/2-4.2,0]) rotate([-90,0,0]) nut(8,20);    
		//#translate([0,-13,-5]) rotate([-90+ang,0,0]) cylinder(17,15,0);    
		translate([0,0,0]) rotate([0,180,0]) cylinder(30,6/2,6/2);    
		
	}
}
if (1){
	color([0,0.75,0.75]) translate([0,0,-28]) rotate([-90+ang,0,0]) translate([0,0,26])  rotate([0,0,90]) gear(3,102,3,3);

	color([0,0.55,0.75]) translate([0,0,-28]) rotate([-90+ang,0,0]) translate([0,0,26+2])  rotate([0,0,90]) gear(3,36,3,4.9);

	color([1.00,0.75,0.75]) translate([0,0,30]) rotate([-90+ang,0,0]) translate([0,0,11+2]) rotate([0,0,2]) gear(3,14,3,2.9);
	
	color([1.00,0.75,0.75]) translate([0,0,30]) rotate([-90+ang,0,0]) translate([0,0,11+2]) rotate([0,0,2]) gear(3,80,3,2.9);
}
