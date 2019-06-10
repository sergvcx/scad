include <lib/tubes.scad>
include <lib/mylib.scad>

watchH = 10;
watchR = 45/2;
beltR=70/2;
beltW=28;

baseH= 10+beltR*2;
baseR = beltR+10;
module watch(){
    translate([0,0,beltR-watchH])  cylinder(watchH,watchR,watchR);
	translate([-beltW/2,0,0]) rotate([0,90,0])  cylinder(beltW,beltR,beltR);
}
module watchdiff(){
	translate([0,0,beltR-watchH])  cylinder(watchH,watchR,watchR);
	translate([-beltW/2,0,0]) rotate([0,90,0])  cylinder(beltW,beltR,beltR);
	cubeZ0(beltW,beltR*2,beltR);
}
module base(){
	difference(){
		cylinder(baseH,baseR,baseR); //base tube
		translate([0,0,10+beltR+0.1]) watchdiff();
		
	}
	%color("blue") translate([0,0,10+beltR+0.1]) watch();
	
}
//watchdiff();

base();

    boxLength=100;
    boxWidth =100;
    boxHeight=100;
Thick=2;
module box(){
    difference(){
        cubeZ0(boxLength,boxWidth,boxHeight);  
        translate([0,0,Thick]) cubeZ0(boxLength-Thick*2,boxWidth-Thick*2,boxHeight-Thick*2);  
    }
    //cube([])
}
//base();
//box();