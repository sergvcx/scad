module SG90_(with_holes=false){
    //colore verde-main color
	$fn =16;
    color("Blue",0.8){ 
    //corpo principale
    cube([11.8,22.7,22.5]); 
    //ali di fissaggio
    difference(){    
		translate([0,4.3,-4.7]) cube([11.8,2.5,31.9]); 
        
        if (! with_holes){
			translate([5.9,7.3,-2.4])rotate([90,0,0])
			cylinder(r=1,h=3.5);
			translate([5.9,7.3,24.9])rotate([90,0,0])
			cylinder(r=1,h=3.5);
			translate([5.25,4,25.6])cube([1.3,3.2,2.3]);
			translate([5.25,4,-4.7])cube([1.3,3.2,2.3]);
		}
        
		
        
    }
    //cilindro ghiera
    translate([5.9,0,16.6]) rotate([90,0,0])
        cylinder(r=5.9,h=4);
	translate([5.9,0,16.6-6]) rotate([90,0,0])
        cylinder(r=6/2,h=4);
    
    }
	
    //cilindro rotante  
    translate([5.9,-4,16.6]) rotate([90,0,0])
        color("White",0.8)cylinder(r=2.3+0.1,h=3.2+1);       
		
	if (with_holes){
		translate([5.9,7.3,-2.4]) rotate([90,0,0])
		cylinder(r=1,h=8);
		translate([5.9,7.3,24.9])rotate([90,0,0])
		cylinder(r=1,h=8);
	}
}

module SG90(with_holes=false,center=true)
{
	if (center)
		rotate([0,0,180]) translate([-5.9,4,-16.6]) SG90_(with_holes);
	else 
		SG90_();

}
//SG90();


module sg90connector(){
	$fn=10;
	hull(){
		cylinder(4.8,r=(7)/2);
		translate([14.5,0,0]) cylinder(4.8,r=4/2);
		translate([-14.5,0,0]) cylinder(4.8,r=4/2);
	}
	translate([10.5,0,0]) cylinder(10,r=1);
	translate([-10.5,0,0]) cylinder(10,r=1);
}