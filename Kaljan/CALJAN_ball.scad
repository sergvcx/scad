use <../lib/curvedPipe.scad>   // Author: Juan Gonzalez-Gomez, GPL

w= 2;
tube_d=18-0.2;
r_mine=6.8;
$fn=100;
rr=11.0;
//translate([-12,0,0]) 
/*
curvedPipe([
                [0,rr,44],
				[0,rr,-22.5],
                [-rr+2,rr-2,-22.5],
                
				[-rr,0,-22.5],
                [-rr,0,0],
                [-rr-6,0,10],
				[-rr-6,0,45],
                [-rr-6,0,49],
                [-rr-10,5,49],
				
			   ],
	            8,
				[5,5,5,5,5,5,4,0,0],
			    7,
*/

module smoke_cylinder(r,h,w){
        difference(){
            union(){
            
                tube(h,r,r,w);
                translate([0,0,45]) cylinder(w,r,r);
                translate([0,0,h]) cylinder(w,r,r);
                translate([0,0,h/2]) cube([1,r*2,h],center=true);
                //tube(2, 0,0,10);
                
            }
            //translate([-r/3,r/3,h-0.1])  cylinder(2*w,r/3,r/3);
            
        }
}

module pipe(r1,r2,h,d){
curvedPipe([
                [d/2,d/2,h-13],
				[d/2,d/2,h*2/3],
                [d/2,0,20],
                [d/2,0,0],
                [0,1,0],
                [-d/2,0,0],
                [-d/2,0,20],
                [-d/2,d/2,h*2/3],
                [-d/2,d/2,h],
			   ],
	            8,
				[4,4,4,4,4,4,4],
			    r1,
				r2);
}
                
module piper(r1,r2,h,d){
    pipe(r1,r2,h,d);
    difference(){
        union(){
            translate([0,8,20]) smoke_cylinder(11,70,2);
            translate([0,0,3])cube(18,center=true);
        }
        //pipe(r1,0,h,d);
    }
    
}


    
module tube(h,r1,r2,width) {
	difference(){
		cylinder(h,r1,r2);
        translate([0,0,-0.01]) cylinder(h+0.02,r1-width,r2-width);
	}
}

module tube_in(h,r1,r2,width) {
	difference(){
		cylinder(h,r1+width,r2+width);
        translate([0,0,-0.01]) cylinder(h+0.02,r1,r2);
	}
}

//tube(24,15/2,20/2,2);

module kalian(){
    difference(){
        union(){
            //translate([0,-0,-20]) cube([20,26,2],center=true);
            
            //translate([0,0,60])  tube(20,tube_d/2,tube_d/2,2); //up tube
            translate([0,0,60])  tube_in(20,r_mine,r_mine,2); //up tube
            difference(){
                union(){
                    //tube(60,59/2,tube_d/2,1.6); // конус
                    tube_in(60,59/2-w,r_mine,w); // конус
                    translate([17,0,15]) rotate([0,25,0]) tube(24,15/2,20/2,2); // smoke  in
                   // translate([-17.0,0,45])  tube_in(10,2.5,12,1.5); //smoke out
                   // translate([-17.0,0,55])  tube_in(12,12,7,1.5); //smoke out
                }
                 cylinder(60,59/2-w,r_mine); // ball

                cylinder(100,r_mine,r_mine); //up tube
            }
            
            
            
           translate([0,0,-2])  tube(w,59/2,59/2,15); // base
           translate([0,0,-26]) tube(26,31.5/2,31.5/2,1.6); // tube cponnector
            
           //translate([0,0,-26]) cylinder (26,31.5/2,31.5/2); // tube cponnector
            
           //
            //translate([-21,0,5]) rotate([0,0,0]) tube_in(50,2,4,1.5); //out
            
            //translate([-25,0,0]) rotate([0,8,0]) tube_in(63,3,6,1.5); //out
            
            
          // rotate([0,0,90]) translate([0,10,-20]) piper(7,5,80,8);
            
            translate([0,0,-26])  tube_in(2,15/2,15/2,w);
            
                             translate([11,-0,-25]) cube([7,2,2],center=true);
            rotate ([0,0,90]) translate([11,-0,-25]) cube([7,2,2],center=true);
            rotate ([0,0,180]) translate([11,-0,-25]) cube([7,2,2],center=true);
            rotate ([0,0,270]) translate([11,-0,-25]) cube([7,2,2],center=true);
            
            rotate([0,0,180]) translate([22,0,24]) rotate([0,0,0]) tube(24,15/2,20/2,2); // smoke  in
            
            rotate([0,0,180]) translate([22,0,0])  rotate([0,0,0]) tube(24,15/2,15/2,2); // smoke  in
            //rotate([0,0,180]) translate([23,0,22]) cylinder (2,15/2-2,15/2-2); // smoke  in
            
        }
                       
        translate([17,0,15]) rotate([0,25,0]) cylinder(24,15/2-2,20/2-2);
        rotate([0,0,180]) translate([12,0,24]) rotate([0,90,0]) cylinder(10,3,3);
        rotate([0,0,180]) translate([22,0,24]) rotate([0,0,0]) cylinder(24,15/2-2,20/2-2);
        
        
        //translate([-30,-12,70-0.1]) cube(12);        
        //translate([-5,3,52]) rotate([90,0,-90]) cylinder(25,2,2,center=true);    
        //translate([-20,-4.5,49]) rotate([90,0,-90]) cylinder(7,1.2,1.2,center=true);    
        //translate([0,0,-30]) cylinder(100,tube_d/2-w,tube_d/2-w);
        //translate([0,0,-30]) cylinder(23,tube_d/2-1.6,tube_d/2-1.6);
        //translate([0,0,-30]) tube_in(26,31.5/2,31.5/2,10); // tube cponnector
        
        //rotate([0,0,90]) translate([0,10,-20]) pipe(7,4,80,8);
        //translate([-17,0,22]) cylinder(100,2.5,2.5);
        //translate([-21,0,5]) rotate([0,-5,0]) cylinder(35,4,6,1.5);
    }
    
}

kalian();