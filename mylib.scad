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

module tube(h,r1,r2)
{
    difference(){
        cylinder(h,r2,r2);
        translate([0,0,-0.1]) cylinder(h+0.2,r1,r1);
    }
}

module boxl(x,y,z,w,down,up){
    difference(){
        translate([0,0,0])      cube([x,y,z]);
        translate([w,w,-0.1])   cube([x-w-w,y-w-w,z+0.2]);
    }
    if (down) {
        translate([0,0,0])   cube([x,y,w]);
    }
    if (up){
        translate([0,0,z-w]) cube([x,y,w]);
    }
}

module boxr(x,y,z,w,down,up){
    translate([-x,0,0]) boxl(x,y,z,w,down,up);
}


module box(x,y,z,w,down,up){
    translate([-x/2,-y/2,0]) boxl(x,y,z,w,down,up);
}

module 3dtriangle(A,B,C,h){
    z=cross(B-A,C-A);
    H=h*z/norm(z);
     //                0 1 2   3   4   5
    polyhedron(points=[A,B,C, A+H,B+H,C+H],faces=[[0,1,2],[0,3,4,1],[1,4,5,2],[2,5,3,0],[5,4,3]]);
}

module supertube(a,b,w)
{
    size=len(a);
    for(i=[0:size-2]){
        A0=a[i];
        A1=a[i+1];
        B0=b[i];
        B1=b[i+1];
        //echo(A0, A1);
        3dtriangle(A0,B0,A1,w);
        3dtriangle(B0,B1,A1,w);
    }
    3dtriangle(a[size-1],b[size-1],a[0],w);
    3dtriangle(b[size-1],b[0],a[0],w);
    
    //3dtriangle(a[len]A0,B0,A1,1);
    //polyhedron(points=[a[0],a[1],b[0],b[1], a[0]+w[0],a[1]+w[1],b[0]+w[0],b[1]+w[1]],
   // polyhedron(points=arr,
   //         faces=[[0,0+size,1],[0+size,1+size,1]]);
   
}


function mulmv (M,V) = [
	M[0][0]*V[0]+M[0][1]*V[1]+M[0][2]*V[2],
	M[1][0]*V[0]+M[1][1]*V[1]+M[1][2]*V[2],
	M[2][0]*V[0]+M[2][1]*V[1]+M[2][2]*V[2]
];

function rot(ang,p) = mulmv(transform_rotz(ang[2]),mulmv(transform_roty(ang[1]),mulmv(transform_rotx(ang[0]),p)));
function trans(disp,p) = [p[0]+disp[0],p[1]+disp[1],p[2]+disp[2]];

function rot4(ang,pixs) =[
	rot(ang,pixs[0]),
	rot(ang,pixs[1]),
	rot(ang,pixs[2]),
	rot(ang,pixs[3])
];

function trans4(disp,pixs) =[
	trans(disp,pixs[0]),
	trans(disp,pixs[1]),
	trans(disp,pixs[2]),
	trans(disp,pixs[3])
];


module points(pixs,radius=1){
    for (i=[0:1:len(pixs)-1]){
        translate(pixs[i]) sphere(radius);
    }
}

