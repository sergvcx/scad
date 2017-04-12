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

    out= 58;
    in = 38;
    rodz = 75;
    rodx = 10;
    rody = 11.2;
    dist =35;
    h = 8;
    
    
module extruder(){
    dz=4;
    translate([-8-4,-8,dz]) cube([16,16,11]);
    translate([0,0,-3+dz]) cylinder(3,2,2);
    translate([0,0,-5+dz]) cylinder(2,0,2);
}

module extruderPlus(){
    dz=4;
    translate([-9,-9-4,dz]) cube([18,18,11]);
}


function rect(dx,dy) = [
    [0,0],[dx,0],[dx,dy],[0,dy]
];

function rect3d(dx,dy,z) = [
    [0,0,z],[dx,0,z],[dx,dy,z],[0,dy,z]
];


module boxl_twist(size,w,center,tw){
    difference(){
        linear_extrude(size[2],center,twist=tw) polygon(rect(size[0],size[1]));    
        translate([w,w,-0.1]) linear_extrude(size[2]+0.1,center,twist=tw) polygon(rect(size[0]-2*w,size[1]-2*w));    
    }
}
 
//function 
//piza_boxl(10,20,30,1,0,0,30,30);
//boxl(10,20,0.4,1,0,0,30,0);
//extruder();
//tuberectc(20,10,20,2);


module connect() {
    difference(){
        children(0);
        intersection (){
            children(0);
            children(1);
        }
    }
}

module cooler1()
{
	box(out,out,1,15);  // bottom
    box(out,out,h,1);  // outer wall
    box(in,in,h,1);    // inner wall
    
	translate([0,0,1]) box(in,in,4,(in-14*2)/2,0,0);// medium
    //	
    
	
    
    //translate([dist/2, -17,0]) rotate([0,0,-30]) boxl(rodx,rody,rodz,1,1);
    
    translate([dist/2, -17,20+10])rotate([0,0,-30]) boxl(rodx,rody,20,1);
    translate([dist/2, -17,20]) rotate([0,0,0]) boxl_twist([rodx,rody,30],1,[0,0,0],30);;
    
    connect(){
    translate([0,0,h-1]) box(out,out,1,(out-in)/2); // top
    translate([20,0,0]) supertube(trans4([0,10,0],rect3d(rodx,rody*1.5,0)),rect3d(rodx,rody,20),1);
    }
    //translate([-dist/2,-17,0]) rotate([0,0, 30]) boxr(rodx,rody,rodz,1,1);
}

module cooler(){
    difference(){
        cooler1();
        for(i=[0:90:360]){
            #rotate([0,0,i]) translate([0,0,1]) cube([14,20,3]);
        }
    //    #translate([0,0,1]) box(out-2,out-2,h-2,(out-2-in-2+2)/2);
   /*     
        difference(){
            translate([-dist/2,-17,1]) rotate([0,0, 30]) boxr(rodx,rody,rodz);
            translate([-dist/2,-17,1]) rotate([0,0, 30]) boxr(rodx,rody,rodz,1);
        }
        difference(){      
            translate([dist/2,-17,1])  rotate([0,0,-30]) boxl(rodx,rody,rodz);
            translate([dist/2,-17,1])  rotate([0,0,-30]) boxl(rodx,rody,rodz,1);
        }
     */   
        //extruderPlus();
       
    }
}

//cooler();

module winder(h){
    ht=10;
    w=0.8;
    funh=80;
    gap =0.2;
    rodh=40;
    // смещение
    disp=dist/2-w-gap;
    rodx2=rodx+2*w+2*gap;
    rody2=rody+2*w+2*gap;
    
    RodLo= trans4([disp,-17,0],   rot4([0,0,-30],[[0,0,0],[rodx2,0,0],[rodx2,rody2,0],[0,rody2,0]]));
    RodHi= trans4([disp,-17,rodh],rot4([0,0,-30],[[0,0,0],[rodx2,0,ht],[rodx2,rody2,ht],[0,rody2,0]]));
    //points(RodHi);
    supertube(RodLo,RodHi,w);
    
    fun_points=[[-w/2,-20,funh],[20,-20,funh],[20,20,funh],[-w/2,20,funh]];
    supertube(RodHi,fun_points,w); 
  
   translate([0,0,-0.1])  
   
 
   difference(){
        translate(fun_points[1])  3dtriangle([0,0,0],[0,12,0],[-12,0,0],2);    
        translate([33/2,-33/2,75]) cylinder(10,1.5);
   }
   difference(){
        translate(fun_points[2])  rotate([0,0,90]) 3dtriangle([0,0,0],[0,12,0],[-12,0,0],2);    
        translate([33/2,33/2,75]) cylinder(10,1.5);
   }
}

translate([0,0,80-0.1]) box(40,40,2,1.5);
translate ([0,0,-40]) cooler();
winder(40);
mirror([10,0,0]) winder(40);

linear_extrude(10) union(){
hull(){
    circle(10);
    translate([20,0,0]) circle(10);
}
    translate([20,20,0]) circle(10);
}

