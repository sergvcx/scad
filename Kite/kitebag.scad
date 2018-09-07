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
include <mylib.scad>


module chassis(xsize,ysize,zsize,r,w){
        difference(){
           union(){
               cube([xsize,ysize,zsize]);
                rotate([0,90,0]) cylinder(xsize,r/2+w,r/2+w);
               cube_Z0();
        
           }
           translate([w,w,w]) cube([xsize,ysize,zsize]);
           rotate([0,90,0]) cylinder(xsize,r/2,r/2);
       }
}
chassis(100,100,100,5,5);