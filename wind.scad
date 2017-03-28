//linear_extrude(80, twist=180,scale=[3,3]) translate([20,0,0]) 

//translate([-1000,0]) linear_extrude(3,  twist=1 ,scale=([1,1]),$fn=1000) translate([1000,0]) difference()
//{
//square([12,12]);
//translate([2,2]) square([8,8]);
//}
    ;
//cube([10,10,10]);
module extruder(){
    dz=4;
    translate([-8-4,-8,dz]) cube([16,16,11]);
    translate([0,0,-3+dz]) cylinder(3,2,2);
    translate([0,0,-5+dz]) cylinder(2,0,2);
}

module extruderSpace(){
    dz=3;
    translate([-9-4,-9,dz]) cube([18,18,11]);
}


module tube(h,r1,r2)
{
    difference(){
        cylinder(h,r2,r2);
        translate([0,0,-0.1]) cylinder(h+0.2,r1,r1);
    }
}

module box(x,y,z,w,down,up) {
    if (down) {
        translate([-x/2,-y/2,0]) cube([x,y,w]);
    }
    if (up){
        translate([-x/2,-y/2,z-w]) cube([x,y,w]);
    }
    translate([-x/2,y/2-w,0]) cube([x,w,z]);
    translate([-x/2,-y/2,0]) cube([x,w,z]);
    
    translate([-x/2,-y/2,0]) cube([ w,y,z]);
    translate([ x/2-w,-y/2,0]) cube([w,y,z]);
}
extruder();

module coller(){
    difference(){
        union(){
            box(40,40,1,10,0,0); // base
            translate([0,0,1]) box(30,30,5,10,0,0); // wind roof
            box(30,30,10,1,0,0); // inner walls
            box(40,40,10,1,0,0); // outer walls
            translate([0,0,8]) box(40,40,2,5,0,0); //outer roof
        }
        extruderSpace();
        
        for(i=[0:90:360]){
            #rotate([0,0,i]) translate([0,0,1]) cube([10,15.1,3]);
        }
        
        
    }
}

intersection(){
coller();
//#tube(20,24,25);
}

translate([0,17,10]) box(10,6,20,1,0,0);
translate([0,-17,10]) box(10,6,20,1,0,0);
//#translate([0,17,27]) box(10+1,6+1,10,1,0,0);
//#translate([0,-17,27]) box(10+1,6+1,10,1,0,0);

//translate([-15,0,9]) rotate([0,60,0]) translate([-30,-20,0]) cube([30,40,1]);

//translate([0,0,1]) box(30,30,5,7,0,0);
for(i=[0:90:360]){
    //rotate([0,0,i]) translate([-2,10,0]) cube([1,5,3]);
}

//translate([-7,-14,0]) box(4,3,2,7,0,0);
//box



//tube(12,15,16);
//tube(1,12,16);
//cube([16,1,10]);