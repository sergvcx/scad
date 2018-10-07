//linear_extrude(80, twist=180,scale=[3,3]) translate([20,0,0]) 

//translate([-1000,0]) linear_extrude(3,  twist=1 ,scale=([1,1]),$fn=1000) translate([1000,0]) difference()
//{
//square([12,12]);
//translate([2,2]) square([8,8]);
//}
    ;
//cube([10,10,10]);

include <lib/vector.scad>
include <lib/maths.scad>

include <../lib/tubes.scad>
include <../lib/mylib.scad>


$fn=100;
module wheel(h,r0,r1,w){
    tireH=0;
    tube_int(h,r0,r0,w);
    tube_ext(h,r1,r1,w);
    for(ang=[0:20:360]){
        rotate([0,0,ang]) translate([0,r0,0]) cubeXZ0(2,r1-r0,h);
    }
    //for(ang=[0:5:360]){
    //    rotate([0,0,ang]) translate([0,r1,0]) cubeXZ0(1.2,tireH,h);
    //}
    
    //wall=1.2;
    tube_int(1.2,r0,r0,r1-r0+tireH);
    translate([0,0,h-1.2]) tube_int(1.2,r0,r0,r1-r0+tireH);
}
wheel(20,15/2,100/2,5,5,5);