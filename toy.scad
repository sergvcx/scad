


module toy_layer(R,h,w) {
	linear_extrude(height=h ){
		difference(){
		for(ang=[0:15:360]){
			translate([R*cos(ang),R*sin(ang),0]) circle (10);
        }
		for(ang=[0:15:360]){
			translate([(R-w)*cos(ang),(R-w)*sin(ang),0]) circle (10);
        }
		}
	}
}
		
		
for(z=[1:1:2]){
	translate ([0,0,z]) rotate([0,0,5*i]) toy_layer(30,1);
}
