

module edge(R,dx){
    
    intersection(){
        translate([R-dx,0,0]) sphere(R);
        translate([-R+dx,0,0]) sphere(R);
        translate([ -dx,-R,0]) cube([2*dx,R*2,R]);
    }
}


hole=20;
holeR=2.5;
holeH=20;
width=100;
R=90;
dx=5;

difference(){
    hull(){
        translate([ 0,-width/2,0]) edge(R,dx);
        translate([ 0, width/2,0]) edge(R,dx);
    }
    translate([ 0,-hole,-0.01]) cylinder(holeH,holeR,holeR);
    translate([ 0, hole,-0.01]) cylinder(holeH,holeR,holeR);
    //translate([ 0, hole,0]) edge(R,dx);
    
}
$fn=90;		
