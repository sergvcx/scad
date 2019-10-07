//include <gopro_mounts_mooncactus.scad>
include <../../lib/mylib.scad>
use <gopro_mounts_mooncactus.scad>
//gopro_connector("triple");
$fn=100;
h = 14.7;
ang = 35;
rod = 30;

 rotate([0,0,-(90-ang)])  translate([0,-11,0])        gopro_connector("triple", withnut=true);
  
if (1) difference(){
    union(){
        hull(){
            //translate([-h/2, 10,-h/2])  
            rotate([0,0,-(90-ang)]) cube([h,1,h],center=true);            
            //translate([-h/2, 10,-h/2])  cube([h,5,h]);            
            translate([rod*cos(ang),rod*sin(ang),0]) rotate([0,0,90]) cube([h/cos(ang),1,h],center=true);
        }
        translate([rod*cos(ang)+h/2,rod*sin(ang),0])  cube([h,h/cos(ang),h],center=true);
        //translate([25,30,-h/2]) );
    }
    //translate([rod*cos(ang),rod*sin(ang),0]) rotate([0,0,90]) cube([h,2,h],center=true);
    translate([rod*cos(ang)+h/2,rod*sin(ang),0])   rotate([-90,0,0]) cylinder(30,2.75,2.75,center=true);

    //translate([0,0,-13/2]skiletZ0(16,16,13,1.2); 
}

   
