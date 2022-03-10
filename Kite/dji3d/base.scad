
include <../../lib/pcb.scad>
include <../../lib/arduino.scad>
include <../../lib/nuts_and_bolts.scad>
render = 0;







////////// -  Box parameters - /////////////

/* [Box dimensions] */
// - Epaisseur - Wall thickness  
  Thick         = 2.2-0.4;//[2:5]  
// - Longueur - Length  
//  Length        = usb18650_pcb[0]+nodeMCU_pcb[0]+17;       
//  Length        = nodeMCU_pcb[0]+sd1306_pcb[1]+17;       
  Length        = 120;       
// - Largeur - Width
  Width         = 92; //nodeMCU_pcb[1]+4*Thick;                     
// - Hauteur - Height  
  Height        = 35;  
  
/* [Box options] */
// Pieds PCB - PCB feet (x4) 
  PCBFeet       = 1;// [0:No, 1:Yes]
// - Decorations to ventilation holes
  Vent          = 0;// [0:No, 1:Yes]
// - Decoration-Holes width (in mm)
  Vent_width    = 1.5;   
// - Text you want
  txt           = "NMC RELAY";           
// - Font size  
  TxtSize       = 3;                 
// - Font  
  Police        ="Arial Black"; 
// - Diamètre Coin arrondi - Filet diameter  
  Filet         = 2;//[0.1:12] 
// - lissage de l'arrondi - Filet smoothness  
  Resolution    = 10;//[1:100] 
// - Tolérance - Tolerance (Panel/rails gap)
  m             = 0.2;
  
/* [PCB_Feet--the_board_will_not_be_exported) ] */
//All dimensions are from the center foot axis
// - Coin bas gauche - Low left corner X position
PCBPosX         = 5;
// - Coin bas gauche - Low left corner Y position
PCBPosY         = 5;
// - Longueur PCB - PCB Length
PCBLength       = 61;
// - Largeur PCB - PCB Width
PCBWidth        = 39;
// - Heuteur pied - Feet height


/* [STL element to export] */
//Coque haut - Top shell
  TShell        = 0;// [0:No, 1:Yes]
//Coque bas- Bottom shell
  BShell        = 1;// [0:No, 1:Yes]
//Panneau arrière - Back panel  
  BPanel        = 0;// [0:No, 1:Yes]
//Panneau avant - Front panel
  FPanel        = 0;// [0:No, 1:Yes]
//Texte façade - Front text
  Text          = 0;// [0:No, 1:Yes]


  
/* [Hidden] */
// - Couleur coque - Shell color  
Couleur1        = "Orange";       
// - Couleur panneaux - Panels color    
Couleur2        = "OrangeRed";    
// Thick X 2 - making decorations thicker if it is a vent to make sure they go through shell
Dec_Thick       = Vent ? Thick*2 : Thick; 
// - Depth decoration
Dec_size        = Vent ? Thick*2 : 0.8;

//////////////////// Oversize PCB limitation -Actually disabled - ////////////////////
//PCBL= PCBLength+PCBPosX>Length-(Thick*2+7) ? Length-(Thick*3+20+PCBPosX) : PCBLength;
//PCBW= PCBWidth+PCBPosY>Width-(Thick*2+10) ? Width-(Thick*2+12+PCBPosY) : PCBWidth;
PCBL=PCBLength;
PCBW=PCBWidth;
//echo (" PCBWidth = ",PCBW);

/*
 module electro (draw_pcb,draw_feet, draw_top, draw_bot){
	translate([9,Thick,0])
	translate([usb18650_pcb[0],nodeMCU_pcb[1]/2,0])
	{
		if (draw_bot){
			translate([-usb18650_pcb[0]/2,-0.7,3+Thick]) 	usb18650(3,draw_pcb,draw_feet);
			translate([nodeMCU_pcb[0]/2,0.2,3+Thick])  		rotate([180,0,0]) nodeMCU (-3,draw_pcb,draw_feet);
		}
		if (draw_top)
			translate([nodeMCU_pcb[0]/2,-0,Height-Thick-sd1306_pcb[2]-1.6]) rotate([0,0,90]) sd1306(-1.6,draw_pcb,draw_feet);
	}
	
}
*/


 module electro (draw_pcb,draw_feet){
	//translate([9,Thick,0])
	
	inbox=[Length - 6*Thick, Width - 2*Thick, Height-2*Thick];
	//{
	//	translate([nodeMCU_pcb[0]/2,nodeMCU_pcb[1]/2,Height-Thick-nodeMCU_pcb[2]-5])  nodeMCU (-5,draw_pcb,draw_feet);
	//	translate([-sd1306_pcb[1]/2,nodeMCU_pcb[1]/2,Height-Thick-sd1306_pcb[2]-1.6])  	rotate([0,0,90]) sd1306(-1.6,draw_pcb,draw_feet);
	//}
	if (BShell){
		translate([3*Thick,Thick,Thick]){
			translate([usb18650_pcb[0]/2+1,	usb18650_pcb[1]/2+0.5, 5]) usb18650(5,draw_pcb,draw_feet);
			translate([nodeMCU_pcb[1]/2,	inbox[1]-nodeMCU_pcb[0]/2,8]) rotate([180,0,90]) nodeMCU (-8,draw_pcb,draw_feet);
			translate([inbox[0]-stepper_controller_pcb[0]/2-1 ,inbox[1]-stepper_controller_pcb[1]/2-1,5])  stepper_controller (5,draw_pcb,draw_feet);
		}
		if (draw_pcb){
			translate([Length/2-1, Width/2, Thick-4]) rotate([0,180,180]) stepper ();
			translate([Length/2-1, Width/2, Thick-4]) rotate([0,180,180]) stepper_holes (r=1.5,h=15);
		}
	}

	//translate([sd1306_pcb[0]+6,nodeMCU_pcb[1]/2+2*Thick,0])
	//translate([Length-6,0,0])
	//translate([-nodeMCU_pcb[0],nodeMCU_pcb[1]/2+2*Thick,0])
	//rotate([0,0,0])
	//{
	//	translate([nodeMCU_pcb[0]/2,0,Height-Thick-nodeMCU_pcb[2]-5])  nodeMCU (-5,draw_pcb,draw_feet);
	//	translate([-sd1306_pcb[1]/2,0,Height-Thick-sd1306_pcb[2]-1.6])  	rotate([0,0,180+90]) sd1306(-1.6,draw_pcb,draw_feet);
	//}
	
}


//usb18650(3,true,true);



/////////// - Boitier générique bord arrondis - Generic Fileted box - //////////

module RoundBox($a=Length, $b=Width, $c=Height){// Cube bords arrondis
                    $fn=Resolution;            
                    translate([0,Filet,Filet]){  
                    minkowski (){                                              
                        cube ([$a-(Length/2),$b-(2*Filet),$c-(2*Filet)], center = false);
                        rotate([0,90,0]){    
                        cylinder(r=Filet,h=Length/2, center = false);
                            } 
                        }
                    }
                }// End of RoundBox Module

      
////////////////////////////////// - Module Coque/Shell - //////////////////////////////////         

module Coque(){//Coque - Shell  
    Thick = Thick*2;  
    difference(){    
        difference(){//sides decoration
            union(){    
                     difference() {//soustraction de la forme centrale - Substraction Fileted box
                      
                        difference(){//soustraction cube median - Median cube slicer
                            union() {//union               
                            difference(){//Coque    
                                RoundBox();
                                translate([Thick/2,Thick/2,Thick/2]){     
                                        RoundBox($a=Length-Thick, $b=Width-Thick, $c=Height-Thick);
                                        }
                                        }//Fin diff Coque                            
                                difference(){//largeur Rails        
                                     translate([Thick+m,Thick/2,Thick/2]){// Rails
                                          RoundBox($a=Length-((2*Thick)+(2*m)), $b=Width-Thick, $c=Height-(Thick*2));
                                                          }//fin Rails
                                     translate([((Thick+m/2)*1.55),Thick/2,Thick/2+0.1]){ // +0.1 added to avoid the artefact
                                          RoundBox($a=Length-((Thick*3)+2*m), $b=Width-Thick, $c=Height-Thick);
                                                    }           
                                                }//Fin largeur Rails
                                    }//Fin union                                   
                               translate([-Thick,-Thick,Height/2]){// Cube à soustraire
                                    cube ([Length+100, Width+100, Height], center=false);
                                            }                                            
                                      }//fin soustraction cube median - End Median cube slicer
                               translate([-Thick/2,Thick,Thick]){// Forme de soustraction centrale 
                                    RoundBox($a=Length+Thick, $b=Width-Thick*2, $c=Height-Thick);       
                                    }                          
                                }                                          


                difference(){// Fixation box legs
                    union(){
                        translate([3*Thick +5,Thick,Height/2]){
                            rotate([90,0,0]){
                                    $fn=6;
                                    cylinder(d=16,Thick/2);
                                    }   
                            }
                            
                       translate([Length-((3*Thick)+5),Thick,Height/2]){
                            rotate([90,0,0]){
                                    $fn=6;
                                    cylinder(d=16,Thick/2);
                                    }   
                            }

                        }
                            translate([4,Thick+Filet,Height/2-57]){   
                             rotate([45,0,0]){
                                   cube([Length,40,40]);    
                                  }
                           }
                           translate([0,-(Thick*1.46),Height/2]){
                                cube([Length,Thick*2,10]);
                           }
                    } //Fin fixation box legs
            }

        union(){// outbox sides decorations
            //if(Thick==1){Thick=2;
            if (0) for(i=[0:Thick:Length/4]){

                // Ventilation holes part code submitted by Ettie - Thanks ;) 
                    translate([10+i,-Dec_Thick+Dec_size,1]){
                    cube([Vent_width,Dec_Thick,Height/4]);
                    }
                    translate([(Length-10) - i,-Dec_Thick+Dec_size,1]){
                    cube([Vent_width,Dec_Thick,Height/4]);
                    }
                    translate([(Length-10) - i,Width-Dec_size,1]){
                    cube([Vent_width,Dec_Thick,Height/4]);
                    }
                    translate([10+i,Width-Dec_size,1]){
                    cube([Vent_width,Dec_Thick,Height/4]);
                    }
  
                
                    }// fin de for
               // }
                }//fin union decoration
            }//fin difference decoration


            union(){ //sides holes
                $fn=50;
                translate([3*Thick+5,20,Height/2+4]){
                    rotate([90,0,0]){
                    cylinder(d=2,20);
                    }
                }
                translate([Length-((3*Thick)+5),20,Height/2+4]){
                    rotate([90,0,0]){
                    cylinder(d=2,20);
                    }
                }
                translate([3*Thick+5,Width+5,Height/2-4]){
                    rotate([90,0,0]){
                    cylinder(d=2,20);
                    }
                }
                translate([Length-((3*Thick)+5),Width+5,Height/2-4]){
                    rotate([90,0,0]){
                    cylinder(d=2,20);
                    }
                }
            }//fin de sides holes

        }//fin de difference holes
}// fin coque 

////////////////////////////// - Experiment - ///////////////////////////////////////////


///////////////////////////////// - Module Front/Back Panels - //////////////////////////
                            
module Panels(){//Panels
	my_delta_front_back_panel=0;
    color(Couleur2){
        translate([Thick+m,m/2,m/2]){
             difference(){
                  translate([0-my_delta_front_back_panel,Thick,Thick]) RoundBox(Length,Width-((Thick*2)+m),Height-((Thick*2)+m));
                  translate([Thick+my_delta_front_back_panel,-5,0])    cube([Length,Width+10,Height]);}
                     
                }
         }
}



///////////////////////////////////// - Main - ///////////////////////////////////////

extusb_in_dim =[15,12,7];



//usb_holder(true,true);


if(BPanel==1){
//Back Panel
	difference(){
		union() {
			translate ([-m/2,0,0])	Panels();
			
		}	
		
		
		
		//translate([-10,22, 5]) cube([20,15,8]);
	}

}

if(FPanel==1){
//Front Panel
	difference(){
		union(){
			rotate([0,0,180]){
				translate([-Length-m/2,-Width,0]) {
					Panels();
				}
			}
		}
		electro(draw_pcb=true,draw_feet=false, draw_top=false, draw_bot=true);
	}
}

if(Text==1)
// Front text
color(Couleur1){     
     translate([Length-(Thick),Thick*4,(Height-(Thick*4+(TxtSize/2)))]){// x,y,z
          rotate([90,0,90]){
              linear_extrude(height = 0.25){
              text(txt, font = Police, size = TxtSize,  valign ="center", halign ="left");
                        }
                 }
         }
}


if(BShell==1){
	// Coque bas - Bottom shell
	difference(){
		union(){
			color(Couleur1)	Coque();
			difference(){
				translate([Length/2-1, Width/2+8, Thick-4]) cylinder(10,21,21);
				translate([Length/2-1, Width/2+8, Thick-4]) cubeYZ0(10,21,21);
			}
			
			
		}
	
		electro(draw_pcb=true,draw_feet=false);
	}
	electro(draw_pcb=false,draw_feet=true);
}

if(TShell==1){
// Coque haut - Top Shell
	d =30;
	difference(){
		color( Couleur1,1){
			translate([0,Width,Height+0.2]){
				rotate([0,180,180]){
						Coque();
						
				}
			}
			translate([Length/2,Width/2,Height]){
				translate([d,-d, 0]) 	rotate([180,0,0]) cylinder(h=8,r=8);	
				translate([d,d,  0]) 	rotate([180,0,0]) cylinder(h=8,r=8);	
				translate([-d,d, 0]) 	rotate([180,0,0]) cylinder(h=8,r=8);	
				translate([-d,-d,0]) 	rotate([180,0,0]) cylinder(h=8,r=8);	

			}
		}
		translate([Length/2,Width/2,Height-8-0.1]){
				translate([d,-d, 0]) 	rotate([180,0,0]) hex_bolt_m7(-100);	
				translate([d,d,  0]) 	rotate([180,0,0]) hex_bolt_m7(-100);	
				translate([-d,d, 0]) 	rotate([180,0,0]) hex_bolt_m7(-100);	
				translate([-d,-d,0]) 	rotate([180,0,0]) hex_bolt_m7(-100);	
		}
		//electro(draw_pcb=true,draw_feet=false);
		//translate([50,10, 10]) cube([20,50,30]);
		//translate ([13,8,Height-Thick-extusb_in_dim[0]/2])	rotate([0,90,90]) usb_holder(false,true);
	}
	//electro(draw_pcb=false,draw_feet=true);
	//translate ([13,8,Height-Thick-extusb_in_dim[0]/2])	rotate([0,90,90]) usb_holder(true,false);
}
if (1)
	//translate([9,Thick,Thick])
	electro(draw_pcb=true,draw_feet=true);

//electro(draw_pcb=true,draw_feet=false, draw_top=true, draw_bot=true);
//if (PCBFeet==0)
// Feet
//translate([PCBPosX,PCBPosY,0]){ 
//Feet();
// }
 


