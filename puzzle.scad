include <lib/tubes.scad>

module toy_layer(angle,R0,R1,r,h,w,twi) {
        
        k=R1/R0;
        m=(R1-w)/(R0-w);
		difference(){
            linear_extrude(height=h, twist=-twi, scale=[k,k] ){
                for(ang=[0:angle:360]){
                    translate([R0*cos(ang),R0*sin(ang),0]) circle (r);
                }
            }
            translate ([0,0,-0.001])  cylinder(h+0.002,R0,R1);  
            translate ([0,0,-0.001]) 
            linear_extrude(height=h+0.002, twist=-twi,  scale=[m,m] ){
               for(ang=[0:angle:360]){
                    translate([R0*cos(ang),R0*sin(ang),0]) circle (r-w);
                }
            }
              
		}
        
	
}
$fn=20;		
module toy(H,r,tw,w){
    dz=5;
    pi=180;
    for(z=[0:dz:H-0.1]){
       R0=1+r*sin(z*pi/H);
       R1=1+r*sin((z+dz)*pi/H);
       translate ([0,0,z]) rotate([0,0,tw*(z/dz)]) toy_layer(30,R0,R1,R0/2,dz,w,tw);
    }
}

w =1;
dx = 100;
dy =20;
h =10;
//tube_ext(10,5,5,w);


module puzzle_y(size,rInt,rExt,shiftInt, shiftExt, h){
    dr=0.2;
    difference(){
        translate([-size/2,-size/2,0]) cube([size,size,h]);    
    
        translate([size/2-shiftInt,0,0])   cylinder(h/2,rInt,rInt+dr);    
        translate([size/2-shiftInt,0,h/2]) cylinder(h/2,rInt+dr,rInt);    
    
        translate([-size/2+shiftInt,0,0])   cylinder(h/2,rInt,rInt+dr);    
        translate([-size/2+shiftInt,0,h/2]) cylinder(h/2,rInt+dr,rInt);    
    }
    translate([0,size/2+shiftExt,0])   cylinder(h/2,rExt,rExt+dr);    
    translate([0,size/2+shiftExt,h/2]) cylinder(h/2,rExt+dr,rExt);    
    
    translate([0,-size/2-shiftExt,0])   cylinder(h/2,rExt,rExt+dr);    
    translate([0,-size/2-shiftExt,h/2]) cylinder(h/2,rExt+dr,rExt);    
    
    
}

module puzzle_x(size,rInt,rExt,shiftInt, shiftExt, h){
    dr=0.2;
    difference(){
        translate([-size/2,-size/2,0]) cube([size,size,h]);    
    
        translate([size/2-shiftInt,0,0])   cylinder(h/2,rInt,rInt+dr);    
        translate([size/2-shiftInt,0,h/2]) cylinder(h/2,rInt+dr,rInt);    
    
        translate([0,-size/2+shiftInt,0])   cylinder(h/2,rInt,rInt+dr);    
        translate([0,-size/2+shiftInt,h/2]) cylinder(h/2,rInt+dr,rInt);    
    }
    translate([0,size/2+shiftExt,0])   cylinder(h/2,rExt,rExt+dr);    
    translate([0,size/2+shiftExt,h/2]) cylinder(h/2,rExt+dr,rExt);    
    
    translate([-size/2-shiftExt,0,0])   cylinder(h/2,rExt,rExt+dr);    
    translate([-size/2-shiftExt,0,h/2]) cylinder(h/2,rExt+dr,rExt);    
}


module puzzle_x_cut(size,r,shift,h,w){
    difference(){
        puzzle_x(size,r,r,shift,shift,h);
        puzzle_x(size-2*w,r+w,r-w,shift-w,shift+w,h);
    }
}

module puzzle_y_cut(size,r,shift,h,w){
    difference(){
        puzzle_y(size,r,r,shift,shift,h);
        puzzle_y(size-2*w,r+w,r-w,shift-w,shift+w,h);
    }
}

//puzzle_x_cut(20,3,1,2,0.1);
//translate([0,20+0.1,0])  puzzle_x_cut(20,3,1,2,0.1);

module puzzleBlock(blockSizeX,blockSizeY,puzzleSize,r,shift,h,w){
    for(y=[0:puzzleSize:blockSizeY]){
        for(x=[0:puzzleSize:blockSizeX]){
            translate([x,y,0]) rotate([0,0,90*x/puzzleSize+90*y/puzzleSize]) puzzle_y_cut(puzzleSize,r,shift,h,w);
        }
    }
}
/*
translate([0,0,0]){
    puzzle_y_cut(20,3,1,2,0.1);
    translate([0,20,0])  rotate([0,0,90]) puzzle_y_cut(20,3,1,2,0.1);
    translate([20,0,0])  rotate([0,0,90]) puzzle_y_cut(20,3,1,2,0.1);
    translate([20,20,0])   puzzle_y_cut(20,3,1,2,0.1);
}
*/
difference(){
    cube([100,100,2]);
    puzzleBlock(100,100,20,3,1,2,0.1);
}

//puzzle_y_cut(20,3,1,2,0.1);
//translate([0,210,0]) rotate([0,0,90]) puzzle_cut(20,3,1,2,0.1);
//toy(80,12,20,0.7);
//translate([0,0,81])


/*
R0=20;
R1=30;

translate ([0,0,-6]) toy_layer(30,R0,R0,R0/2,dz,2,0);
                     toy_layer(30,R0,R1,R0/2,dz,2,0);
translate ([0,0,6])  toy_layer(30,R1,R1,R1/2,dz,2,0);
//translate ([0,0,0])  toy_layer(30,20,8,10,1,0);
	*/