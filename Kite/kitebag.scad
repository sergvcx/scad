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
       }
       
       
       cube([xsize,ysize,zsize]);
   }
}
//chassis(100,100,100,12.1/2,5);

rotate ([0,-90,0]) chassis(120,130,130,12.2/2,6);
