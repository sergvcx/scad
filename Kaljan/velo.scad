
difference(){
  
    translate([0,0,0]) cube([62+20,42,30],center=true);
    cylinder(31,35/2,35/2,center=true);
      //cylinder(30,45,45);
    translate([62/2,50,0]) rotate([90,0,0]) cylinder(100,10/2,10/2);
    translate([-62/2,50,0]) rotate([90,0,0]) cylinder(100,10/2,10/2);
    cube([90,8,40],center=true);
    
    translate([0,50,0]) cube([100,100,100],center=true);
    }
    