module tube_ext(h,r1,r2,width) {
	difference(){
		cylinder(h,r1,r2);
        translate([0,0,-0.01]) cylinder(h+0.02,r1-width,r2-width);
	}
}

module tube_int(h,r1,r2,width) {
	difference(){
		cylinder(h,r1+width,r2+width);
        translate([0,0,-0.01]) cylinder(h+0.02,r1,r2);
	}
}
