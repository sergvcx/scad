
include <lib/mylib.scad>
include <lib/tubes.scad>

//r=7;

module tablet(r0,r1){
    cube(20,center=true);
    hull(){
    rotate_extrude(convexity = 10)
        translate([r0, 0, 0])
           circle(r1, $fn = 100);
    
    translate([10,0,0]) rotate_extrude(convexity = 10)
        translate([r0, 0, 0])
           circle(r1, $fn = 100);
    }
    //cylinder(r1*2,r0,r0,center=true);
}

module tablet2(r,l,w,h){
    difference(){
        cubeZ0(l,w,h);
        translate([0,0,-1]) cylinder(2*h,r,r);
       // cubeZ0(l,0.1,h);
        translate([0,w/4,h/2]) rotate([0,90,0]) cylinder(20,1.8/2,1.9/2);
    }
    
}

h=4;
   

//tablet2(5.1,21,14,h);

module capsule(r){
    translate([0,0,3*r-2]) sphere(r);
    translate([0,0,r])  cylinder(2*r,r,r);
    translate([0,0,r])  sphere(r);
    
}


module cuber(r,size,h){
    difference(){
        cubeZ0(size,size,size);
        //translate([0,0,0.8]) capsule(r);
        //translate([0,0,r]) cubeZ0(size+1,14.5,h);
        //#translate([-size/2,size/4+2,3]) rotate([0,90,0]) cylinder(size,1.9/2,1.9/2);
    }
}
r=5.5;

cuber(5.5,22,4);
translate([0,0,r+0.3]) #tablet2(5.5,22,14,4-0.6);


if(0) difference(){
    translate([0,0,r]) cube(4*r,center=true);
    hull(){
        tablet(r+2,1.5);
        translate([20,0,0]) tablet(r+2,1.5);
    }
}

if (0) difference(){
    cube(10,center=true);
}
//rotate([90,0,0]) cylinder(20,2,2,center=true);
if (0) hull(){
    sphere(r);
    translate([0,0,r]) sphere(r);
}

