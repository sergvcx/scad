include <mylib.scad>
include <microservo_SG90.scad>

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

dji_base_dim=[67,26.3,42];
dji_lense_dim=[31,9,0];
dji_lense_pos=[67/2-14,0,42/2-14];

module dji(){

}

hero3();

cam = hero3_base_dim;
thick =5;
skirt_base_dim=[10,cam[1]+2*thick,cam[2]+2*thick];

module skirt(){
	difference(){
		cube(skirt_base_dim,center=true);
		hero3();
	}
}

cam_yr=sqrt(cam[0]*cam[0]+cam[2]*cam[2])/2;
yu_thick=10;
yu_width=10;
yu_dim=[2*cam_yr+2*yu_thick,skirt_base_dim[1]+2*yu_thick,yu_width];

module yu(){
	
	skirt=skirt_base_dim;
	
	difference(){
		cube(yu_dim,center=true);
		cube([2*cam_yr,skirt[1],10+0.1],center=true);
		//cubeX0(100,100,100);
	}
	difference(){
		rotate([90,0,0]) cylinder(yu_dim[1],yu_width/2,yu_width/2,center=true);
		cube([2*cam_yr,skirt[1],10],center=true);
		
	}	
}
color("green") skirt();

#yu();

translate([0,-skirt_base_dim[1]/2,0]) SG90();

translate([-yu_dim[0]/2,0,0]) rotate([0,0,-90]) SG90();

SG90_dim=[12,30,40];
zu_thick=10;
zu_width=10;
zu_dim=[yu_dim[0]+2*zu_thick,zu_width,yu_dim[1]+2*SG90_dim[1]];
module zu(){
	difference(){
		cube(zu_dim,center=true);
		cube([zu_dim[0]-20, zu_dim[1]+0.1, zu_dim[2]-20],center=true);
	}
}

zu();
