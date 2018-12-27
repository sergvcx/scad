//linear_extrude(80, twist=180,scale=[3,3]) translate([20,0,0]) 

//translate([-1000,0]) linear_extrude(3,  twist=1 ,scale=([1,1]),$fn=1000) translate([1000,0]) difference()
//{
//square([12,12]);
//translate([2,2]) square([8,8]);
//}
    ;
//cube([10,10,10]);

include <../lib/vector.scad>
include <../lib/maths.scad>
include <../lib/honeycomb.thingiverse.scad>
include <../lib/tubes.scad>
include <../lib/mylib.scad>


$fn=150;

module wheel(h,r0,r1,w){
    tireH=0.5;
    //tube_int(h,r0,r0,w);
    tube_int(h,r0,r0,r1-r0);
   // tube_ext(h,r1,r1,w);
   // for(ang=[0:20:360]){
   //     rotate([0,0,ang]) translate([0,r0,0]) cubeXZ0(2,r1-r0,h);
   // }
    /*
    for(ang=[0:3:360]){
        for(y=[1:2:h-1]){
            rotate([0,0,ang+y/2]) translate([0,r1,y]) rotate([-90,0,0])  cubeZ0(0.4,0.4,0.8);
            //cylinder(1,0.4,0);
        }
    }
    //for(ang=[0:5:360]){
    //    rotate([0,0,ang]) translate([0,r1,0]) cubeXZ0(1.2,tireH,h);
    //}
    
    //wall=1.2;
    tube_int(1.2,r0,r0,r1-r0+tireH);
    translate([0,0,h-1.2]) tube_int(1.2,r0,r0,r1-r0+tireH);
    */
   // translate([0,0,h])     tube_int(1.2,r0,r0,10);
    
    
    
    base_plate_thickness=0;	// [0:0.1:15]

    cell_size=3;                    // [0.3:0.1:20]

    columns=2*r1/cell_size/1.5;			// [2:255]

    rows=2*r1/cell_size/2/sin(60);         		// [2:255]

    height=h;			// [0.2:0.1:200]

    fill=0.8*10;				// [1:99]


    //intersection(){
    //    tube_int(h,r0,r0,r1-r0);
    //translate([-r1,-r1,0]) 
    //    honeycomb(columns, rows, base_plate_thickness, cell_size, h, fill);
    //}
    
}

h=20;
R= 110/2;
r= 12.35/2;

// honeycomb(10, 10, 0, 10, 20, 50);

RR = 30;
difference()
{
    wheel(h,r,R,3);
    for(ang=[0:120:360]){
        rotate([0,0,ang]) translate([sqrt(RR*RR+10*10),0,h+RR-8])  rotate([0,0,20]) resize([RR+10,2*RR,2*RR]) sphere(RR);
    }
    for(ang=[60:120:360+60]){
        rotate([0,0,ang]) translate([sqrt(RR*RR+10*10),0,-(RR-8)]) rotate([0,0,20])  resize([RR+10,2*RR,2*RR]) sphere(RR);
    }
}

difference(){
    //translate([0,0,h]) tube_ext(10,R,R,15);
    //translate([0,0,h-0.1]) tube_ext(10.01,R-10,R-5,20);
    translate([0,0,h-10]) tube_int(15,R-19,R-4,15);
    translate([0,0,0]) tube_int(h+10,R,R,20);
}