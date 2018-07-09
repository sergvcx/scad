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