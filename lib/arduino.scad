stepper_dim=[42,32,19.5];
module stepper(plusminus=0,tolerance=0){
	$fn=32;
	translate([0,-8,0]) rotate([0,90,0]){
		tl=tolerance;
		tz=tolerance;
		txy=tolerance;
		motorW=28+tl;
		motorH=19+tl;
		if (plusminus>0){
			translate([0,0, 35/2]) rotate([0,90,0])  cylinder(4,3.5/2,3.5/2);
			translate([0,0,-35/2]) rotate([0,90,0])  cylinder(4,3.5/2,3.5/2);
		}
		if (plusminus<0){
			translate([-5-0.111,8,0]) rotate([0,90,0])  cylinder(5+0.222,10/2,10/2);
		}
		// full motor view
		if (plusminus==0){
			difference(){
				union(){
					translate([0,0, 35/2]) rotate([0,90,0])  cylinder(1,7/2+txy,7/2+txy); // ear
					translate([0,0,-35/2]) rotate([0,90,0])  cylinder(1,7/2+txy,7/2+txy); // ear
					translate([0.5,0,0])   cube([1,7+2*txy,35], center=true); // ear box
				}
				translate([-0.111,0, 35/2]) rotate([0,90,0])  cylinder(4+0.222,3.5/2,3.5/2); // holes
				translate([-0.111,0,-35/2]) rotate([0,90,0])  cylinder(4+0.222,3.5/2,3.5/2); // holes
			}
			translate([0,0,0])   rotate([0,90,0])  cylinder(motorH,motorW/2,motorW/2); //motor
			translate([-2, 8,0]) rotate([0,90,0])  cylinder(2,10/2+txy,10/2+txy); 
			translate([-10,8,0]) rotate([0,90,0])  
				intersection(){
					cylinder(10,5/2+txy,5/2+txy);  //shaft
					rotate([0,0,90]) cubeZ0(5/2+2*txy,10,10);
				}
			translate([motorH/2,-18/2,0]) cube([motorH,18+txy,18+2*txy],center=true);
		}
	}
}

module stepper_holes(r=4.1/2,h=5){
	translate([0,-8,0]) rotate([0,90,0]) {
		translate([-0.111,0, 35/2]) rotate([0,90,0])  cylinder(h,r,r); // holes
		translate([-0.111,0,-35/2]) rotate([0,90,0])  cylinder(h,r,r); // holes
	}
}
/*
module stepper(feet_height, draw_pcb,draw_feet){
	pcb=  usb18650_pcb  ;
	hole= usb18650_hole;
	top=  usb18650_top  ;
	bot=  usb18650_bot  ;
	sw =  usb18650_sw  ;
	
	pcb_module(pcb,hole,hole_dia,bot,top,feet_height, draw_pcb,draw_feet);
	if (draw_pcb){
		color("Red") translate([pcb[0]/2-usb_out_dim[0]/2,-usb_out_dim[1]/2+1,pcb[2]]) cube(usb_out_dim);
		color("Red") translate([-pcb[0]/2+10,-pcb[1]/2,0]) rotate([0,0,90]) cubeZ0(usb_in_dim[0],usb_in_dim[1],-usb_in_dim[2]);
		color("Red") translate([pcb[0]/2-13,-pcb[1]/2,pcb[2]+1]) rotate([0,0,90]) cube(sw,center=true);
		color("Olive") % scale([0.5,0.5,1]) translate([0,0,pcb[2]+top[2]]) text("usb18650", halign="center", valign="center", font="Arial black");	
	}
}
*/


module stepper_(plusminus,tolerance=0){
		tl=tolerance;
		motorW=28+tl;
		motorH=19+tl;
		if (plusminus>0){
			translate([0,0, 35/2]) rotate([0,90,0])  cylinder(4,3.5/2,3.5/2);
			translate([0,0,-35/2]) rotate([0,90,0])  cylinder(4,3.5/2,3.5/2);
		}
		if (plusminus<0){
			translate([-5-0.111,8,0]) rotate([0,90,0])  cylinder(5+0.222,10/2,10/2);
		}
		if (plusminus==0){
			difference(){
				union(){
					translate([0,0, 35/2]) rotate([0,90,0])  cylinder(1,7/2,7/2);
					translate([0,0,-35/2]) rotate([0,90,0])  cylinder(1,7/2,7/2);
					translate([0.5,0,0])   cube([1,7,35], center=true);
				}
				translate([-0.111,0, 35/2]) rotate([0,90,0])  cylinder(4+0.222,3.5/2,3.5/2); // holes
				translate([-0.111,0,-35/2]) rotate([0,90,0])  cylinder(4+0.222,3.5/2,3.5/2); // holes
			}
			translate([0,0,0]) rotate([0,90,0])  cylinder(motorH,motorW/2,motorW/2); //motor
			translate([-2, 8,0]) rotate([0,90,0])  cylinder(2,10/2,10/2); 
			translate([-10,8,0]) rotate([0,90,0])  cylinder(10,5/2,5/2);  //shaft
			translate([motorH/2,-18/2,0]) cube([motorH,18,18],center=true);
		}
}
