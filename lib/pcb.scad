include <../lib/mylib.scad>
foot_dia = 3.5;
hole_dia = 2;
hole_len = 5;
usb18650_pcb=  [99.14,29.5,1.6];
usb18650_hole=[94.54,24.5,hole_len];
usb18650_top=  [78.5,23,21];
usb18650_bot=  [94,25,3];
usb18650_sw =  [9,10,7];


usb_out_dim=[14.2,14.5,6.7];
usb_in_dim =[10+2,7.5+1,2+1];



sd1306_pcb=  [25,27,1.2];
sd1306_hole= [20.5,22.7,hole_len];
sd1306_top=  [25+0.4,16.52,1.6];
sd1306_bot=  [25,16,1];


nodeMCU_pcb=  [58,31.3,1.6];
nodeMCU_hole=[52,25,hole_len];
nodeMCU_top=  [48,30,3];
nodeMCU_bot=  [48,28,0.1];
nodeMCU_led=  [-58/2+6.5,31.3/2-9.64,0];



/////////////////////// - Foot with base filet - /////////////////////////////
module foot(FootDia,FootHole,FootHeight){
	
	Filet=1;
    color("Orange")   
    //translate([0,0,Filet])
    difference(){
		difference(){
			cylinder(d=FootDia+Filet,FootHeight, $fn=100);
			rotate_extrude($fn=100){
				translate([(FootDia+Filet*2)/2,Filet,0]){
					minkowski(){
						square(20);
						circle(Filet, $fn=20);
					}
				}
			}
		}
		translate([0,0,-0.01]) cylinder(d=FootHole,FootHeight+1, $fn=100);
	}	
}// Fin module foot
  
//foot(5,2,10)  ;

 
 
module pcb_module(pcb_dim,hole_dim, hole_dia, bot_dim, top_dim,  feet_height, draw_pcb,draw_feet ){
	
	if (draw_feet){
		if (feet_height<0){
			translate([ hole_dim[0]/2, hole_dim[1]/2, pcb_dim[2]+abs(feet_height)]) mirror([0,0,1]) foot(foot_dia,hole_dia,abs(feet_height));
			translate([-hole_dim[0]/2, hole_dim[1]/2, pcb_dim[2]+abs(feet_height)]) mirror([0,0,1]) foot(foot_dia,hole_dia,abs(feet_height));
			translate([ hole_dim[0]/2,-hole_dim[1]/2, pcb_dim[2]+abs(feet_height)]) mirror([0,0,1]) foot(foot_dia,hole_dia,abs(feet_height));
			translate([-hole_dim[0]/2,-hole_dim[1]/2, pcb_dim[2]+abs(feet_height)]) mirror([0,0,1]) foot(foot_dia,hole_dia,abs(feet_height));
		}
		if (feet_height>0) { 
			translate([ hole_dim[0]/2, hole_dim[1]/2, -feet_height]) foot(foot_dia,hole_dia,feet_height);
			translate([-hole_dim[0]/2, hole_dim[1]/2, -feet_height]) foot(foot_dia,hole_dia,feet_height);
			translate([ hole_dim[0]/2,-hole_dim[1]/2, -feet_height]) foot(foot_dia,hole_dia,feet_height);
			translate([-hole_dim[0]/2,-hole_dim[1]/2, -feet_height]) foot(foot_dia,hole_dia,feet_height);
		}
	}
	if (draw_pcb)
	color("Blue")   difference(){
		union(){
			cubeZ0(pcb_dim[0],pcb_dim[1],pcb_dim[2]);
			cubeZ0(bot_dim[0],bot_dim[1],-bot_dim[2]);
			translate([0,0,pcb_dim[2]]) cubeZ0(top_dim[0],top_dim[1],top_dim[2]);
		}
		translate([ hole_dim[0]/2, hole_dim[1]/2,pcb_dim[2]/2])  cylinder(10,hole_dia/2,hole_dia/2,true);
		translate([-hole_dim[0]/2, hole_dim[1]/2,pcb_dim[2]/2])  cylinder(10,hole_dia/2,hole_dia/2,true);
		translate([ hole_dim[0]/2,-hole_dim[1]/2,pcb_dim[2]/2])  cylinder(10,hole_dia/2,hole_dia/2,true);
		translate([-hole_dim[0]/2,-hole_dim[1]/2,pcb_dim[2]/2])  cylinder(10,hole_dia/2,hole_dia/2,true);
	}

	
	
}

module usb18650(feet_height, draw_pcb,draw_feet){
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
module nodeMCU(feet_height, draw_pcb,draw_feet){

	hole=nodeMCU_hole;
	pcb=  nodeMCU_pcb  ;
	top=  nodeMCU_top  ;
	bot=  nodeMCU_bot  ;
	led=  nodeMCU_led  ;
	pcb_module(pcb,hole,hole_dia,bot,top,feet_height,draw_pcb,draw_feet);
	color("Olive") % scale([0.5,0.5,1]) translate([0,0,pcb[2]+top[2]]) text("nodeMCU", halign="center", valign="center", font="Arial black");
	color("Green") if (draw_pcb){
		translate([pcb[0]/2,0,pcb[2]]) cubeZ0(usb_in_dim[0],usb_in_dim[1],usb_in_dim[2]);
		translate([led[0],led[1],0])  cylinder(10,1.5,1.5) ;
		translate([0,pcb[1]/2,0])  	cubeYZ0(38,-2.5,-17);
		translate([0,-pcb[1]/2,0])  	cubeYZ0(38,2.5,-17);
	}
}
module sd1306(feet_height, draw_pcb,draw_feet){
	hole= sd1306_hole;
	pcb=  sd1306_pcb  ;
	top=  sd1306_top  ;
	bot=  sd1306_bot  ;
	pcb_module(pcb,hole,hole_dia,bot,top,feet_height,draw_pcb,draw_feet);
	color("Olive") % scale([0.3,0.3,1]) translate([0,0,pcb[2]+top[2]+5]) text("sd1306", halign="center", valign="center", font="Arial black");
	color("Green") if (draw_pcb){
		 hull(){
			translate([0,pcb[1]/2-5.1,pcb[2]+top[2]])  		cubeYZ0(pcb[0],-13.9,0.1);
			translate([0,pcb[1]/2-5.1+5,pcb[2]+top[2]+5]) cubeYZ0(pcb[0]+10,-13.9-10,0.1);
		}
		
		translate([0,pcb[1]/2,0]) cubeYZ0(10,-2.5,-18);
			
		extra_drill_height=pcb[2]+top[2]+1.2;
		{
			translate([ hole[0]/2, hole[1]/2, 0])  cylinder(extra_drill_height,hole_dia/2,hole_dia/2);
			translate([-hole[0]/2, hole[1]/2, 0])  cylinder(extra_drill_height,hole_dia/2,hole_dia/2);
			translate([ hole[0]/2,-hole[1]/2, 0])  cylinder(extra_drill_height,hole_dia/2,hole_dia/2);
			translate([-hole[0]/2,-hole[1]/2, 0])  cylinder(extra_drill_height,hole_dia/2,hole_dia/2);
		}

	}
	
}


stepper_controller_pcb=  [34.65,32,1.53];	
stepper_controller_hole= [29.5,29.5,hole_len]; 	
stepper_controller_top=  [27,30,8.7];
stepper_controller_bot=  [24,24,0.5];

module stepper_controller(feet_height, draw_pcb,draw_feet){
	hole= stepper_controller_hole;
	pcb=  stepper_controller_pcb  ;
	top=  stepper_controller_top  ;
	bot=  stepper_controller_bot  ;
	pcb_module(pcb,hole,hole_dia,bot,top,feet_height,draw_pcb,draw_feet);
	color("Olive") % scale([0.3,0.3,1]) translate([0,0,pcb[2]+top[2]+5]) text("step ctrl", halign="center", valign="center", font="Arial black");

}





//translate([0,40,0]) usb18650(invert_feet=true,only_feet=true);
//sd1306(-1,true,true);
//translate([0,-40,0])  nodeMCU(3,true,true);
