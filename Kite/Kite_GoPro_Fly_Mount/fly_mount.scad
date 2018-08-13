include <gopro_mounts_mooncactus.scad>
include <../../lib/mylib.scad>
  //rotate  ([0,90,180]) 
  gopro_connector("triple", withnut=true);

h = 14.7;
difference(){
    union(){
        hull(){
            translate([-h/2, 10,-h/2])  cube([h,5,h]);
            translate([20,40,-h/2]) cube([h,5,h]);
        }
        translate([25,30,-h/2]) cube([15,15,h]);
    }
    translate([32,30,0])  rotate([-90,0,0]) cylinder(30,3,3);
}