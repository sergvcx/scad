include <lib/tubes.scad>


module toy_layer(angle,R00,R11,r,h,w,twi) {
    //a=atan2(h,abs(R1-R0));
    //w=ww*sin(a);
    k=R11/R00;
    m=(R11-w)/(R00-w);
    R0=R00-r;   // центр внешних кружков
    r0=R00-r;   // центр внутренних кругов
    R1=R11-r*k; // центр внешних кружков сверху
    r1=R11-w-(r-w)*m;   // центр внутренних круго сверху

    rr0=R0*cos(angle/2)+sqrt(r*r-pow(R0*sin(angle/2),2))-w;
    rr1=R1*cos(angle/2)+sqrt(pow(r*k,2)-pow(R1*sin(angle/2),2))-w;
    
    //m=(R1+r*k-(r-w)*k)/R0;
    //m=(R1+0.3)/R0;
    difference(){
        linear_extrude(height=h, twist=-twi, scale=[k,k] )
        {
            for(ang=[0:angle:360]){
                difference(){
                    translate([R0*cos(ang),R0*sin(ang),0]) circle (r);
                    circle(rr0);
                }
            }
        }
        if (1) translate([0,0,-0.01]) 
        linear_extrude(height=h+0.02, twist=-twi, scale=[m,m] )
        {
     
            for(ang=[0:angle:360]){
                difference(){
                    translate([(r0)*cos(ang),(r0)*sin(ang),0]) circle (r-w);
                    circle(rr0-w);
                }
            }
            
        }
        //circle(rr);
        translate([0,0,-0.01]) cylinder(h+0.02,rr0,rr1);
    }
}
$fn=40;		
module toy(H,r,angle,w){
    dz=1;
    //tw=360*dz/H/360;
    tw=angle/(H/dz);
    pi=180;
    for(z=[0:dz:H/1-0.1])
    //z=dz;//2*dz;
    //z=0;
    //z=2*dz;
    {
       R0=1+r*sin(z*pi/H);
       R1=1+r*sin((z+dz)*pi/H);
       translate ([0,0,z]) rotate([0,0,tw*(z/dz)]) toy_layer(30,R0,R1,R0/4,dz,w,tw);
    }
}
d=7;
h=12;
H=46;

module power_bank(){
    difference(){
        union(){
            cylinder(H,12,12);
            translate([0,0,H]) cylinder(4,12,10/2);
           
        }
        //battary holes
        translate([-10.5/2,0,2]) cylinder(146,10.5/2,10.5/2);
        translate([10.5/2,0,2]) cylinder(146,10.5/2,10.5/2);
        // switcher
        translate([-20,0,H]) rotate([90,0,90]) linear_extrude(100) polygon([[-d,0],[d,0],[0,h]]);
        // led holes
        translate([-1.5,0,-2]) cylinder(10,1/2,1/2);
        translate([ 1.5,0,-2]) cylinder (10,1/2,1/2);
        
    }
}
//toy(80,16,360,0.4);
toy(80,16,360,1);
translate([0,0,81]) difference(){
    translate([-1,0,0]) rotate([0,90,0]) tube_int(2,1,1,2);
    translate([0,0,-4]) cylinder(5,3,0);    
}
