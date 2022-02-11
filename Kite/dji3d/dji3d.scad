include <../../lib/mylib.scad>
include <../../lib/gopro.scad>
include <../../lib/microservo_SG90.scad>
include <../../lib/arduino.scad>
include <../../lib/tubes.scad>

module axis(){
	$fn=16;
	rotate([90,0,0]) cylinder(h=200,r=1.5,center=true); // y-axis
	rotate([0,90,0]) cylinder(h=200,r=1.5,center=true); // x-axis
	rotate([0,0,90]) cylinder(h=98,r=1.5,center=true); // z-axis
}


dji_pos=[5,0,0];
//================== skirt ===============================
//cam = hero3_base_dim;
cam = dji_base_dim;
thick = 6;
skirt_thick =thick;
skirt_ext_dim=[10,cam[1]+2*thick,cam[2]+2*skirt_thick];


module skirt(){
	$fn=16;
	dim=skirt_ext_dim;
	difference(){
		union(){
			cube(dim,center=true);
			translate([0,dim[1]/2,-dim[2]/2])
			cubeYZ0(dim[0],-13,-10); // hears
		}
		translate(dji_pos) dji();
		translate([0,dim[1]/2-skirt_thick,-dim[2]/2]) cubeY0(20,-2,20);
		translate([0,dim[1]/2-skirt_thick,-dim[2]/2-5]){
			rotate([90,0,0]) cylinder(20,1.5,1.5,center=true);

			$fn=6;
			translate([0,-6.5,0]) rotate([90,0,0]) cylinder(4,r=5.5/sin(60)/2); // nut
		}
		#translate([0,-dim[1]/2,0]) rotate([-90,90,0]) sg90connector();
		// закладная
		translate([-skirt_ext_dim[0]/2+1,skirt_ext_dim[1]/2-skirt_thick/2,0]) cylinder(100,r=1.5,center=true);
		axis();
	}
}

module skirt_hw(){
	if (draw_hw){
		skirt();
		color("gray") translate(dji_pos) dji();
	}
	else difference(){
		skirt();
		color("gray") translate(dji_pos) dji();
	}
}



//================== yu horizont ===============================
cam_yr=sqrt(cam[0]*cam[0]+cam[2]*cam[2])/2;
y_radius = cam_yr+5;
yu_thick=10;
yu_width=20;
yu_int_dim=[2*y_radius,skirt_ext_dim[1]+0.1,yu_width+0.1];
yu_ext_dim=[2*y_radius+2*yu_thick,yu_int_dim[1]+2*yu_thick,yu_width];


module yu(){
	
	dim = yu_ext_dim;	
	skirt=skirt_ext_dim;
	//%rotate([90,0,0]) cylinder(0.1,dim[0]/2-yu_thick,dim[0]/2-yu_thick,center=true);
	difference(){
		union(){
			difference(){
				cube(yu_ext_dim,center=true);
				cube(yu_int_dim,center=true);
				translate([-5,10,0]) cubeXY0(100,100,100);
			}
			translate([-5,yu_int_dim[1]/2,0]) rotate([-90,0,0]) cylinder(yu_thick,yu_width/2,yu_width/2); 	
		}
		translate([-dim[0]/2+2,0,0]) cylinder(h=20,r=1,center=false); // под фикс винт оси
		//translate([dim[0]/2+2,0,0]) rotate() () cylinder(h=20,r=1,center=false); // под фикс винт оси
		
		// закладные 
		torus_r = (zu_thick+yu_thick)/2-1;
		translate([yu_ext_dim[0]/2,0,torus_r+3]) difference(){  
			rotate([90,0,0]) torus(torus_r,3.75/2);
			cubeZ0(100,100,100);
		}
		translate([yu_ext_dim[0]/2,0,0]) sphere(5);
		
		
		

		tr = (yu_int_dim[1]/2+yu_thick/2)/2;
		$fn =16;
		translate([yu_int_dim[0]/2,-tr,yu_width/2-1.5]) 
			difference(){
				scale([0.70,1,1])torus(tr,2);
				cubeX0(-100,100,100);
			}
		//translate([0, yu_int_dim[1]/2+yu_width/2,yu_thick/2-1.5]) rotate([0,90,0]) cylinder(yu_int_dim[0],r=2,center=true); 
		translate([0,-yu_int_dim[1]/2-yu_thick/2,yu_width/2-1.5]) rotate([0,90,0]) cylinder(yu_int_dim[0],r=2,center=true); 
		
		
		translate([-yu_int_dim[0]/2,-yu_int_dim[1]/2,yu_width/2-1.5])	intersection(){
			torus(yu_thick/2,2);
			cubeXY0(-100,-100,100);
		}

		translate([-yu_int_dim[0]/2-yu_thick/2,0,yu_width/2-1.5]) rotate([90,0,0]) cylinder(yu_int_dim[1],r=2,center=true); 
		
		translate([-yu_int_dim[0]/2, yu_int_dim[1]/2,yu_width/2-1.5])	intersection(){
			torus(yu_thick/2,2);
			cubeXY0(-100,100,100);
		}
		
		translate([-yu_int_dim[0]/2, yu_int_dim[1]/4,yu_width/2-1.5])	intersection(){
			torus(yu_thick/2,2);
			cubeXY0(-100,100,100);
		}
		
		translate([0,yu_int_dim[1]/2+yu_thick/2,yu_width/2-1.5]) rotate([0,90,0]) cylinder(yu_int_dim[0],r=2,center=true); 
				
		translate([-dim[0]/2,0,0]) rotate([90,0,90]) sg90connector();
		// закладная
		
		axis();
		}

		
	//translate([0-7, yu_int_dim[1]/2,0]) rotate([90,0,0]) cylinder(40,r=2,center=true) ;
	
	
}
module yu_hw(){
	if (draw_hw){
		yu();
		translate([0,-skirt_ext_dim[1]/2+0.5,0]) rotate([0,90,0]) SG90(with_holes=false);
	}
	else difference(){
		yu();
		translate([0,-skirt_ext_dim[1]/2+0.5,0]) rotate([0,90,0]) SG90(with_holes=true);
	}
}


//================== zu vertical U ===============================
SG90_dim=[12,28,40];
zu_thick=10;
zu_width=20;
x_radius = yu_int_dim[1]/2+SG90_dim[1]+3;
zu_int_dim=[yu_ext_dim[0]+0.1, zu_width+0.1,x_radius*2];
zu_ext_dim=[zu_int_dim[0]+zu_thick*2,zu_width,zu_int_dim[2]+zu_thick*2];
module zu(){
	dim = zu_ext_dim;
	//%rotate([0,90,0]) cylinder(0.1,r=x_radius,center=true);
	difference(){
		cube(zu_ext_dim,center=true);
		cube(zu_int_dim,center=true);
		translate([0,0,-13]) cubeZ0(200,200,-100);
		translate([0,0,zu_ext_dim[2]/2-6])  rotate([90,0,0]) cylinder(100,r=1,center=true);
		translate([0,-8,zu_ext_dim[2]/2-3])  tube_int(10,28/2,28/2,7);
		//translate([0,-8,zu_ext_dim[2]/2])  torus(35/2,6/2);
		$fn=6;
		translate([zu_int_dim[0]/2,0,0]) rotate([90,0,90]) cylinder(3,5.5/sin(60)/2,5.5/sin(60)/2); // nut
		$fn=16;
		//#translate([0,0,zu_int_dim[2]/2]) rotate([0,0,0]) cylinder(2,5.5/sin(60)/2,5.5/sin(60)/2); // nut
		
		translate([-23,0,dim[2]/2-1.5]) rotate([0,-90,0]) cylinder (dim[0],r=3.75/2); // верхняя закладная
		translate([0,-11,dim[2]/2-1.5])  rotate([0,0,0]) torus(27,3.75/2);
		translate([23,0,dim[2]/2-1.5]) rotate([0,90,0]) cylinder (dim[0],r=3.75/2); // верхняя закладная
		translate([dim[0]/2-1.5,0,torus_r+2])  cylinder (dim[2]/2,r=3.75/2); // закладная
		translate(-[dim[0]/2+1.5,0,0])  cylinder (dim[2]/2,r=3.75/2); // закладная
		
		torus_r = (zu_thick+yu_thick)/2-1;
		translate([yu_ext_dim[0]/2,0,torus_r+3]) difference(){  
			rotate([90,0,0]) torus(torus_r,3.75/2);
			cubeZ0(100,100,100);
		}
		translate([yu_ext_dim[0]/2,0,0]) sphere(5);

		axis();
	}
}
module zu_hw(){
	if (draw_hw){
		color("gray") translate([0,0,zu_ext_dim[2]/2]) rotate([0,180,0]) stepper();
		zu();
		translate([-yu_ext_dim[0]/2+0.5,0,0]) rotate([0,180,-90]) SG90(with_holes=false);
	}
	else difference(){
		zu();
		color("gray") translate([0,0,zu_ext_dim[2]/2]) rotate([0,180,0]) stepper();
		translate([-yu_ext_dim[0]/2+0.5,0,0]) rotate([0,180,-90]) SG90(with_holes=true);
	}
}

module hw(with_holes){
	
}
//=============== all togeter =================================


difference(){
	difference(){
		union(){
			if (draw_skirt) {
				if (print)
					translate([0,0,skirt_ext_dim[0]/2]) rotate([0,90,0]) skirt_hw();
				else 
					skirt_hw();
				
			}

			if (draw_yu) { 
				translate([0,0,yu_width/2]) yu_hw();
			}
			if (draw_zu) { 
				if (print)
					translate([0,0,zu_width/2]) rotate([90,0,0]) zu_hw();
				else 
					zu_hw();
			}
		}
		
		
		//if draw_hw()
		//{
		//	hw(with_holes=true);
		//}

	}
}





print = 0;
draw_all    = 1;
draw_skirt 	= draw_all || 1;
draw_yu 	= draw_all || 1;
draw_zu 	= draw_all || 1;
draw_hw 	= draw_all || 0;