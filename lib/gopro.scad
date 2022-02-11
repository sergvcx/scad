include <mylib.scad>

hero3_base_dim=[59,21.12,41];
hero3_lense_dim=[23,7,0];
hero3_lense_pos=[59/2-15,21.12/2,41/2-14];
module hero3(){
	base = hero3_base_dim;
	translate([0,0,-base[2]/2]) rounded_cube(base[0],base[1],base[2],1,1,1);
	
	lens = hero3_lense_dim;
	lpos = hero3_lense_pos;
	translate (lpos) rotate([-90,0,0]) cylinder(lens[1],lens[0]/2,lens[0]/2);
}

dji_base_dim=[66,26.3,42];
dji_lense_dim=[31,9,0];
dji_lense_pos=[-dji_base_dim[0]/2+14,dji_base_dim[1]/2,dji_base_dim[2]/2-14];
module dji(){
	$fn=16;
	base = dji_base_dim;
	translate([0,0,-base[2]/2]) rounded_cube(base[0],base[1],base[2],1,1,1);
	translate([0,0,base[2]/2]) cubeZ0(55,12,1); // buttons
	
	lens = dji_lense_dim;
	lpos = dji_lense_pos;
	translate (lpos) rotate([-90,0,0]) cylinder(lens[1],lens[0]/2,lens[0]/2);
	
}

//dji();