

module edge(R,dx){
    
    intersection(){
        translate([R-dx,0,0]) sphere(R);
        translate([-R+dx,0,0]) sphere(R);
        translate([ -dx,-R,0]) cube([2*dx,R*2,R]);
    }
}


hole=39/2;
holeR=2.45;
holeH=11;
width=60;
R=200;
dx=4;

difference(){
    hull(){
        translate([ 0,-width/2,0]) edge(R,dx);
        translate([ 0, width/2,0]) edge(R,dx);
    }
    translate([ 0,-hole,-0.01]) cylinder(holeH,holeR,holeR);
    translate([ 0, hole,-0.01]) cylinder(holeH,holeR,holeR);
    //translate([ 0, hole,0]) edge(R,dx);
    
}
$fn=150;		
