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
$fn=100;		
module toy(H,r,tw,w){
    dz=5;
    pi=180;
    for(z=[0:dz:H-0.1]){
       R0=1+r*sin(z*pi/H);
       R1=1+r*sin((z+dz)*pi/H);
       translate ([0,0,z]) rotate([0,0,tw*(z/dz)]) toy_layer(30,R0,R1,R0/2,dz,w,tw);
    }
}

toy(80,12,20,0.7);
translate([0,0,81])

difference(){
    translate([-1,0,0]) rotate([0,90,0]) tube_int(2,1,1,2);
    translate([0,0,-4]) cylinder(6,3,0);    
}
/*
R0=20;
R1=30;

translate ([0,0,-6]) toy_layer(30,R0,R0,R0/2,dz,2,0);
                     toy_layer(30,R0,R1,R0/2,dz,2,0);
translate ([0,0,6])  toy_layer(30,R1,R1,R1/2,dz,2,0);
//translate ([0,0,0])  toy_layer(30,20,8,10,1,0);
	*/