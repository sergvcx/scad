//------------------------------------- start direction  -----------------------------------
//module (aX0,az0,ay0,ax0){
aX0= 0;
//az0=-15;
az0=0;
//ay0=-25;
ay0=0;
ax0= 30;

k0=cos(aX0);
n0=sin(aX0);
mX0 = [ 
		[ 1, 0,   0		,0],
		[ 0, k0,  -n0	,0],
		[ 0, n0,  k0	,0],
		[ 0,  0,   0,   ,1]
       ];

e0=cos(az0);
f0=sin(az0);
mz0 = [ [ e0, -f0, 0 ,0],
        [ f0,  e0, 0, 0],
        [  0,   0, 1, 0],
        [  0,   0, 0, 1]
      ];

c0 = cos(ay0);
d0 = sin(ay0);
my0 = [ [ c0, 0,  d0,	0],
		[  0, 1,   0,	0],
		[-d0, 0,  c0,	0],
		[  0, 0,   0, 	1]		
       ];

a0=cos(ax0);
b0=sin(ax0);
mx0 = [ 
		[ 1, 0,   0,	0],
		[ 0, a0,-b0,	0],
		[ 0, b0, a0,	0],
		[ 0,  0,  0, 	1]
       ];

echo ("mX0=",mX0);
echo ("mx0=",mx0);
echo ("my0=",my0);
echo ("mz0=",mz0);

echo ("---------------- deviation -------------------");

aX1= aX0+30;
az1= az0;
ay1= ay0;
ax1= ax0;


k1=cos(aX1);
n1=sin(aX1);
mX1 = [ 
		[ 1, 0,   0		,0],
		[ 0, k1, -n1	,0],
		[ 0, n1,  k1	,0],
		[ 0,  0,   0,   ,1]
       ];

e1=cos(az1);
f1=sin(az1);
mz1 = [ [ e1, -f1, 0 ,0],
        [ f1,  e1, 0, 0],
        [  0,   0, 1, 0],
        [  0,   0, 0, 1]
      ];

c1 = cos(ay1);
d1 = sin(ay1);
my1 = [ [ c1, 0,  d1,	0],
		[  0, 1,   0,	0],
		[-d1, 0,  c1,	0],
		[  0, 0,   0, 	1]		
       ];

a1=cos(ax1);
b1=sin(ax1);
mx1 = [ 
		[ 1, 0,   0,	0],
		[ 0, a1,-b1,	0],
		[ 0, b1, a1,	0],
		[ 0,  0,  0, 	1]
       ];

//-------------------------------------
T = [ 
		[ e0*c0, 	e0*d0*b0-f0*a0,		e0*d0*a0+f0*b0,	0],
		[ f0*c0,	f0*d0*b0+e0*a0, 	f0*d0*a0-e0*b0,	0],
		[ -d0, 		c0*b0, 				c0*a0,			0],
		[ 0,  		0,  				0, 				1]
    ];


echo ("mX1=",mX1);
echo ("mx1=",mx1);
echo ("my1=",my1);
echo ("mz1=",mz1);
echo ("-------------------- compensation ------------------------------");


D1  = f0*c0*(n1*k0-k1*n0)+d0*(n0*n1+k0*k1); 	// sin(ay2)
C1  = sqrt(1-D1*D1);							// cos(ay2)
ay2 = asin(D1);
echo("ay2=",ay2);
echo("C1=",C1);
E1 = e0*c0/C1;
F1 = +sqrt(1-E1*E1);
//F1 = -sqrt(1-E1*E1);

az2 = asin(F1);
echo("az2=",az2);

//x2= 4.2-10;//asin(c0/C1*b0) ;
q = e0*d0*a0+f0*b0;
echo("q=",q);
a = E1*D1;
b = F1;

// q = a*sqrt(1-s*s)+b*s
// q - b*s = a*sqrt(1-s*s)
// q*q - 2*q*b*s + b*b*s*s = a*a*(1-s*s)
// q*q - 2*q*b*s + b*b*s*s = a*a*-a*a*s*s
// b*b*s*s - 2*q*b*s + q*q - a*a*+a*a*s*s=0

// Имеем квадратнео уравнение
// (a*a+b*b)*s*s - 2*q*b*s + q*q-a*a=0
echo("a=",a);
echo("b=",b);
echo("q=",q);
echo("a*a+b*b=",a*a+b*b);
echo("q*q-a*a=",q*q-a*a);
//if (a*a+b*b==0){
	// Решаем для  (a*a+b*b)==0
	//  - 2*q*b*s + q*q-a*a=0
	//  s  = (q*q-a*a)/2*q*b*
	//s = (q*q-a*a)/2*q*b;
//}

//else {
// Решаем квардратное уравнение для  (a*a+b*b)!=0
// (a*a+b*b)*s*s - 2*q*b*s + q*q-a*a=0
// s = 2*q*b +- sqrt(4*q*q*b*b-4*(a*a+b*b)*(q*q-a*a))/(2*(a*a+b*b))
// s = q*b +- sqrt(q*q*b*b-(a*a+b*b)*(q*q-a*a))/(a*a+b*b)
// s = q*b +- sqrt(q*q*b*b-a*a*q*q+a^4-b*b*q*q+b*b*a*a))/(a*a+b*b)
// s = q*b +- sqrt(-a*a*q*q+a^4+b*b*a*a))/(a*a+b*b)

 //s  = (q*b + a*sqrt(-q*q+a*a+b*b))/(a*a+b*b);
 //s_ = (q*b - a*sqrt(-q*q+a*a+b*b))/(a*a+b*b);
//}
echo("s+=",s);
//echo("s-=",s_);



// t*t = 1-s*s
//s = (q*b-a*sqrt(q*q+a*a+b*b))/(a*a+b*b);
t= sqrt(1-s*s);
err=E1*D1*t+F1*s-q;
echo("err=",err);
ax2= asin(s) ;
echo("ax2=",ax2);

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

// ---------------- start direction -----------------------
color ("Red")    multmatrix(m=mX0*mz0*my0*mx0) dji();
//rotate([X0,0, 0]) rotate([0,0, z0]) rotate([0,y0, 0]) rotate([x0,0,0]) dji();


// ---------------- deviation ------------------------
color ("Green") multmatrix(m=mX1*mz1*my1*mx1) dji();

//color ("Orange") multmatrix(m=mX0*T) dji();
//rotate([X1,0, 0]) rotate([0,0, z1]) rotate([0,y1, 0]) rotate([x1,0,0]) dji();

// ----------------- compensation --------------------
//color ("Blue") rotate([aX1,0, 0]) rotate([0,0, az2]) rotate([0,ay2, 0]) rotate([ax2,0,0]) dji();
// or 

//color ("Blue ") multmatrix(m=mX1*mz2*my2*mx2) dji();

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