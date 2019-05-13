

r=5;

module tablet(r0,r1){
    rotate_extrude(convexity = 10)
    translate([r0, 0, 0])
           circle(r1, $fn = 100);
    cylinder(r1*2,r0,r0,center=true);
}


    tablet(r+2,1.5);

if(0) difference(){
    translate([0,0,r]) cube(4*r,center=true);
    hull(){
    tablet(r+2,1.5);
    translate([20,0,0]) tablet(r+2,1.5);
}

if (0) difference(){
    cube(10,center=true);
}
//rotate([90,0,0]) cylinder(20,2,2,center=true);
if (1) hull(){
sphere(r);
translate([0,0,r]) sphere(r);
}
}
