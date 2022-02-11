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


X0= 45;
A0=cos(x0);
B0=sin(x0);
mX0 = [ 
		[ 1, 0,   0		,0],
		[ 0, A0,  -B0	,0],
		[ 0, B0,  A0	,0],
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

y0 =-45;
C0 = cos(y0);
D0 = sin(y0);
my0 = [ [ C0, 0,  D0,	0],
		[ 0,  1, 0,		0],
		[-D0, 0,  C0,	0],
		[  0,   0, 0, 	1]		
       ];

x0= 45;
a0=cos(x0);
b0=sin(x0);
mx0 = [ 
		[ 1, 0,   0,	0],
		[ 0, a0,  -b0,	0],
		[ 0, b0,  a0,	0],
		[  0,   0, 0, 	1]
       ];



v = [10,10,0];  
color("Red") vector(v);
//w = [10,0,0];

//echo("******\n",mrot_Y*mz0);



module vector(v){
	$fn=16;
	hull(){
		sphere(0.3);
		translate(v) sphere(0.3);
	} 
}

//multimatrix(m=mx0) cylinder(10,1,1);
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