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
include <../lib/mylib.scad>
include <../lib/tubes.scad>


module bolt(r1,r2,h){
    cylinder(r1,r1,0);
    cylinder(h,r2,r2);
}
$fn=50;
//bolt(20,10,20);
module chassis(xsize,ysize,zsize,r,w){
        axisY=r+1;
        axisZ=r+1;
        intersection(){
        difference(){
           union(){
               difference(){
                cube([xsize,ysize,zsize]);
                translate([w,w,w]) cube([xsize,ysize,zsize]);
               }
               translate([xsize/2,axisY-r+(r+w-1)/sin(45),axisY-r+(r+w-1)/sin(45)])  rotate([45,0,0]) cube([xsize,w,38],center=true);
               translate([0,axisY,axisZ]) rotate([0,90,0]) cylinder(xsize,r+w,r+w);
//               cube_Z0();
                
           }
           
           translate([0,axisY,axisZ])  rotate([0,90,0]) cylinder(xsize+1,r,r);
           translate([xsize/2,axisY,axisZ])  rotate([-45+180,0,0]) cubeZ0(xsize,2*r,100);
           rotate([0,90,0]) tube_int(xsize,ysize,ysize,60);       
           for (y=[15:20:ysize]){
            for (x=[10:20:xsize]){
               translate([x,y,0]) cylinder(10,1.5,1.5);
            }
          }
          for (z=[15:20:zsize]){
            for (x=[10:20:xsize]){
               translate([x,0,z]) rotate([-90,0,0]) cylinder(10,1.5,1.5);
            }
          }
       }
       
       
          
       cube([xsize,ysize,zsize]);
   }
   translate([r,r,20]) faska(zsize-20,r);
   translate([r,20,r]) rotate([-90,0,0]) rotate([0,0,-90]) faska(ysize-20,r);
}

module faska(h,r){
    
    intersection(){
        cubeZ0(2*r,2*r,h);
        translate([r,r,0]) difference(){
            cubeZ0(2*r,2*r,h);
            cylinder(h+0.1,r,r);
        }
    }
}

//faska(10,3);
//chassis(100,100,100,12.1/2,5);


rotate ([0,-90,0]) chassis(120,130,130,12.2/2,6);
