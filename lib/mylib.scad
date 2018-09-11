/*
module rounded_cube(dx,dy,dz,r){
    union(){
        translate ([r,0,0]) cube([dx-2*r,dy,dz]);
        translate ([0,r,0]) cube([dx,dy-2*r,dz]);
        translate ([r,r,0]) cylinder(dz,r,r);
        translate ([dx-r,r,0]) cylinder(dz,r,r);
        translate ([r,dy-r,0]) cylinder(dz,r,r);
        translate ([dx-r,dy-r,0]) cylinder(dz,r,r);
    }
}
*/

module torus(R,r) {
    rotate_extrude(convexity = 10)
    translate([R, 0, 0]) circle(r = r, $fn = 100);
}

module disk(R,r){
    rotate_extrude(convexity = 10)
    { 
        intersection(){
            union(){
                translate([R-r, 0, 0]) circle(r = r, $fn = 100);
                translate([(R-r)/2,0]) square([R-r,r*2],center=true);        
            }
            translate([0,-r,0]) square([R,2*r]);            
        }
    }
}


module rounded_cylinder(h,r,rb,rt){
    rotate_extrude(convexity = 10) 
    mirror() rotate([0,0,90])
    intersection(){
        square([h,r]);
        union(){
            translate([h-rt,0,0]) square([rt,r-rt]);
            translate([h-rt,r-rt,0]) 
            intersection(){
                circle(rt);
                square(rt*2);
            }
            square([rb,r-rb]);
            translate([0,r-rb,0]) intersection(){
                translate([rb,0,0]) circle(rb);
                translate([-rb,0,0]) square(rb*2);
            }    
            translate([rb,0,0]) square([h-rt-rb,r]);
        }
    }
    /*
    translate([0,0,h-rt]) disk(r,rt);
    translate([0,0,rb]) cylinder(h-rb-rt,r,r);
    translate([0,0,rb]) disk(r,rb);
    */
}

module rounded_cube(w,l,h,rv,rb,rt){
    
    hull(){
        translate([-w/2+rv,-l/2+rv,0]) rounded_cylinder(h,rv,rb,rt);
        translate([-w/2+rv,+l/2-rv,0]) rounded_cylinder(h,rv,rb,rt);
        translate([+w/2-rv,+l/2-rv,0]) rounded_cylinder(h,rv,rb,rt);
        translate([+w/2-rv,-l/2+rv,0]) rounded_cylinder(h,rv,rb,rt);
    }
    
   /* 
    minkowski(){
        cube([w-2*rv,l-2*rv,h-rb-rt],center=true) ;
        //rounded_cylinder(rb+rt,rv,rb,rt);
        rounded_cylinder(7,10,5,2);
    }
    */
    
}

module cubeZ0(xSize,ySize,zSize){
    translate([0,0,zSize/2]) cube([xSize,ySize,zSize],center=true);
}
module cubeYZ0(xSize,ySize,zSize){
    translate([0,-ySize/2,0]) cube([xSize,ySize,zSize]);
}
module cubeXZ0(xSize,ySize,zSize){
    translate([-xSize/2,0,0]) cube([xSize,ySize,zSize]);
}

module skiletZ0(xSize,ySize,zSize,step=0.8,w=0.1){
    for(y=[-ySize/2:step:ySize/2]){
		for(x=[-xSize/2:step:xSize/2]){
			translate([x,y,0]) cubeZ0(w,w,zSize);
		}
    }

}