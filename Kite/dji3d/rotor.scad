if (0) rotate([0,0,30]) 
rotate([0,30,0]) 
rotate([40,0,0]) 
cylinder(100,2,1);

//rotate([40,30,30]) cylinder(50,3,3);

angle = 115;

color ("Red")
if (0) multmatrix(m = [ [cos(angle), -sin(angle), 0, 0],
                 [sin(angle),  cos(angle), 0, 0],
                 [         0,           0, 1, 0],
                 [         0,           0, 0,  1]
              ]) 
   cylinder(r=1.0,h=10,center=false);


X0= 15;
k0=cos(X0);
n0=sin(X0);
mX0 = [ 
		[ 1, 0,   0		,0],
		[ 0, k0,  -n0	,0],
		[ 0, n0,  k0	,0],
		[ 0,  0,   0,   ,1]
       ];

z0 =-15;
e0=cos(z0);
f0=sin(z0);
mz0 = [ [ e0, -f0, 0 ,0],
        [ f0,  e0, 0, 0],
        [  0,   0, 1, 0],
        [  0,   0, 0, 1]
      ];

y0 =-25;
c0 = cos(y0);
d0 = sin(y0);
my0 = [ [ c0, 0,  d0,	0],
		[  0, 1,   0,	0],
		[-d0, 0,  c0,	0],
		[  0, 0,   0, 	1]		
       ];

x0= 15;
a0=cos(x0);
b0=sin(x0);
mx0 = [ 
		[ 1, 0,   0,	0],
		[ 0, a0,-b0,	0],
		[ 0, b0, a0,	0],
		[ 0,  0,  0, 	1]
       ];

//===================================

X1= X0+10;


k1=cos(X1);
n1=sin(X1);
mX1 = [ 
		[ 1, 0,   0		,0],
		[ 0, k1, -n1	,0],
		[ 0, n1,  k1	,0],
		[ 0,  0,   0,   ,1]
       ];


x1 =x0;
z1 =z0;
y1 =y0;


e1=cos(z1);
f1=sin(z1);
mz1 = [ [ e1, -f1, 0 ,0],
        [ f1,  e1, 0, 0],
        [  0,   0, 1, 0],
        [  0,   0, 0, 1]
      ];

c1 = cos(y1);
d1 = sin(y1);
my1 = [ [ c1, 0,  d1,	0],
		[  0, 1,   0,	0],
		[-d1, 0,  c1,	0],
		[  0, 0,   0, 	1]		
       ];

a1=cos(x1);
b1=sin(x1);
mx1 = [ 
		[ 1, 0,   0,	0],
		[ 0, a1,-b1,	0],
		[ 0, b1, a1,	0],
		[ 0,  0,  0, 	1]
       ];


T = [ 
		[ e0*c0, 	e0*d0*b0-f0*a0,		e0*d0*a0+f0*b0,	0],
		[ f0*c0,	f0*d0*b0+e0*a0, 	f0*d0*a0-e0*b0,	0],
		[ -d0, 		c0*b0, 				c0*a0,			0],
		[ 0,  		0,  				0, 				1]
    ];
	   


D1 = f0*c0*(n1*k0-k1*n0)+d0*(n0*n1+k0*k1);
y2 = asin(D1);
echo("y2=",y2);
C1 = sqrt(1-D1*D1);
E1 = e0*c0/C1;
F1 = -sqrt(1-E1*E1);
//z2 = -acos(E1);
z2 = asin(F1);
echo("z2=",z2);

//x2= 4.2;//asin(c0/C1*b0) ;
q = e0*d0*a0+f0*b0;
a = E1*D1;
b = F1;
s = (q*b+a*sqrt(q*q+a*a+b*b))/(a*a+b*b);
echo("s=",s);
x2= asin(s) ;
echo("x2=",x2);

module vector(v){
	$fn=16;
	hull(){
		sphere(0.3);
		translate(v) sphere(0.3);
	} 
}


$fn =32;
module dji(){
	rotate([0,90,0]) cylinder(10,0.25,0.05);
	rotate([0,0 ,0]) cylinder(10,0.25,0.05);
}
//multmatrix(m=mz0) dji();
color ("Red") multmatrix(m=mX0*mz0*my0*mx0) dji();
//rotate([X0,0, 0]) rotate([0,0, z0]) rotate([0,y0, 0]) rotate([x0,0,0]) dji();


color ("Green") multmatrix(m=mX1*mz1*my1*mx1) dji();

//color ("Orange") multmatrix(m=mX0*T) dji();
//rotate([X1,0, 0]) rotate([0,0, z1]) rotate([0,y1, 0]) rotate([x1,0,0]) dji();

rotate([X1,0, 0]) rotate([0,0, z2]) rotate([0,y2, 0]) rotate([x2,0,0]) dji();

//rotate([X0,0, 0]) rotate([0,0, z0]) rotate([0,y0, 0]) rotate([x0,0,0]) dji();

//color ("Green") multmatrix(m=mz0*my0*mx0) dji();

//#cube(mx0*v);
//color ("Red") 	vector(mx0*v);
//color ("Green") vector(my0*mx0*v);
//color ("Blue") 	vector(mz0*my0*mx0*v);
//#cube(my0*mx0*v);
//#cube(mz0*mrot_y*mx0*v);
//color("Red") vector(mz0*mrot_y*mx0*v);
//color("Green") vector(mrot_yy*mrot_yyy*mz0*mrot_y*mx0*v);
//color("Green") vector(mrot_yy*mz0*mrot_y*mx0*v);


/*
multmatrix(m = [ [cos(angle), -sin(angle), 1, 10],
                 [sin(angle),  cos(angle), 0, 20],
                 [         0,           0, 1, 30],
                 [         0,           0, 0,  1]
              ]) union() {
   cylinder(r=10.0,h=10,center=false);
   cube(size=[10,10,10],center=false);
}*/