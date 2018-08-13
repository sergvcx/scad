//use <../gopro/gopro.scad>


include <gopro_mounts_mooncactus.scad>

$fn=20;
//$fn=60;  //probably shouldn't use this for tweaking
strut_radius=70;
height=50;
thick=5;

slice=60;

strap_height=4+thick;
strap_slot=3;
strap_block=30;
strap_w = 30;
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

			translate([0,7.5+strap_height,13])
			rotate([0,90,180])
			gopro_connector_taper();
		}
		straps();
	}
    
    translate ([0,17,0]) rotate  ([0,90,180]) gopro_connector("triple", withnut=true);
}

assembly();
