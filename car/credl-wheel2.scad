//include <lib/tubes.scad>
include <../lib/vector.scad>
include <../lib/maths.scad>
include <../lib/mylib.scad>
include <../lib/tubes.scad>
include <../lib/3dplot.scad>
include <../lib/splines.scad>
include <../lib/spline.scad>
include <../lib/scad-utils/spline.scad>

include <../lib/dotSCAD/src/line3d.scad>;
include <../lib/dotSCAD/src/polyline3d.scad>;
include <../lib/dotSCAD/src/bezier_curve.scad>;
include <../lib/dotSCAD/src/function_grapher.scad>;
include <../lib/dotSCAD/src/bezier_surface.scad>;

function myspline(pt,dt) =
    let(spl=spline_args(pt,  closed=false))
		[for( t=[0:dt:len(pt)]) 	spline(spl, t)];
		

module surfaceData(M, center=false, convexity=10){
  n = len(M);
  m = len(M[0]);
  miz  = min([for(Mi=M) min(Mi)]);
  minz = miz<0? miz-1 : -1;
  ctr  = center ? [-(m-1)/2, -(n-1)/2, 0]: [0,0,0];
  points = [ // original data points
             for(i=[0:n-1])for(j=[0:m-1]) [j, i, M[i][j]] +ctr,
             [   0,   0, minz ] + ctr, 
             [ m-1,   0, minz ] + ctr, 
             [ m-1, n-1, minz ] + ctr, 
             [   0, n-1, minz ] + ctr,
             // additional interpolated points
             // the points bellow with undef coordinates are not used by faces
             for(i=[0:n-1])for(j=[0:m-1])
               let( med = (M[i][j]+M[i+1][j]+M[i+1][j+1]+M[i][j+1])/4 )
               [j+0.5, i+0.5, med] + ctr
           ];
  faces = [ // faces connecting data points to interpolated ones
            for(i=[0:n-2])
              for(j=[i*m:i*m+m-2]) 
                each [ [   j+1,     j, j+n*m+4 ], 
                       [     j,   j+m, j+n*m+4 ], 
                       [   j+m, j+m+1, j+n*m+4 ], 
                       [ j+m+1,   j+1, j+n*m+4 ] ] ,
            // lateral and bottom faces
            [ for(i=[0:m-1])           i, n*m+1,   n*m ], 
            [ for(i=[m-1:-1:0]) -m+i+n*m, n*m+3, n*m+2 ], 
            [ for(i=[n-1:-1:0])      i*m,   n*m, n*m+3 ], 
            [ for(i=[0:n-1])     i*m+m-1, n*m+2, n*m+1 ],
            [n*m, n*m+1, n*m+2, n*m+3 ]
        ];
  polyhedron(points, faces, convexity);
}


module upper_lips(){
	R=50;
	r=3;
	h=5;
	d=20;
	MY=1.5;
	hr=12;
	difference(){
	if (1) intersection(){
		translate([0,-15,-R/2]) cubeXZ0(R*2,R*5,R);
		if (1) difference(){
			union(){
				hull(){
					translate([-d,0,h]) sphere (r);
					translate([ d,0,h])sphere (r);
					translate([ -d,2*d,h])  sphere (r);
					translate([ d, 2*d,h]) sphere (r);

					scale([1,MY,(h+3)/R]) sphere(R);
				}
				translate([0,0,-15]) scale([1,MY,1]) cylinder(15,R,R);
			}
			translate([0,20,0]){
				translate ([-hr,-hr,h+r-5.5]) cylinder (6,12.8/2,12.4/2);
				translate ([-hr, hr,h+r-5.5]) cylinder (6,12.8/2,12.4/2);
				translate ([ hr, hr,h+r-5.5]) cylinder (6,12.8/2,12.4/2);
				translate ([ hr,-hr,h+r-5.5]) cylinder (6,12.8/2,12.4/2);
			}
			translate([0,20,0]){
				translate ([-hr,-hr,-15]) cylinder (50,2,2);
				translate ([-hr, hr,-15]) cylinder (50,2,2);
				translate ([ hr, hr,-15]) cylinder (50,2,2);
				translate ([ hr,-hr,-15]) cylinder (50,2,2);
			}
			// hole
			translate([0,2,-2]){
				translate([-R,0,1.5]) rotate([0,90,0]) cylinder(2*R,2.5,2.5);
				translate([R-37,-20,-1])  cube([37,0+20,1]);
				mirror([1,0,0]) 
				translate([R-37, -20,-1])  cube([37,0+20,1]);
			}
		}
		
		//DD=nSpline(transpose(E),16);
		//SS=nSpline(transpose(S),16);
		
	}
	//curv= [-10,-5,-8/2,-7/2,-6/2,-5/2,-4/2,-3/2,-2/2,-1/2,0];
	//cc=smooth(curv,3);
	////echo ("cc=",cc);
	//i=0;
	//v= [for (i = [0 : len(curv) - 1]) [cc[i],cc[i]+2,cc[i]+2.01,cc[i]]];
	
	//echo("v==",v);


	//AA=nSpline(transpose(v),10);
//	AAA=transpose(AA);
	//AAA= nSpline(transpose(AA),10);

	
	//echo (AAA);

	//!scale([2*R/10,2*R/10,1]) surfaceData(AAA);
		
	z0 = -10;
	
	y1 = 2;
	z1 = -6;
	
	y2 = 20;
	z2 = 0;
	dz = 2;
	
	z3 = -4;
	translate([-R,0,-3]){
		//ctrl_pts = [
		//	[[0, -y1/2,2*z0], 	[2*R/3, -y1/2,2*z0+dz],   [4*R/3, -y1/2,   2*z0+dz],    [2*R, -y1/2,   2*z0]],
		//	[[0, 0,  z0], 		[2*R/3, 0,   z0+dz],   [4*R/3, 0,   z0+dz],    [2*R, 0,   z0]],
		//	[[0, y1, z1], 		[2*R/3, y1,  z1+dz],   [4*R/3, y1,  z1+dz],    [2*R, y1,  z1]],
		//	[[0, y2, z2], 		[2*R/3, y2,  z2+dz],   [4*R/3, y2,  z2+dz],    [2*R, y2,  z2]],
		//	[[0, R*MY, 0], 		[2*R/3, R*MY, dz],   [4*R/3, R*MY, dz],    [2*R, R*MY, 0]],
		//	[[0, R*4, 0], 		[2*R/3, R*4, dz],   [4*R/3, R*4, dz],    [2*R, R*4, 0]]
		//	
		//];

	//	[[0, 0,  z0], 		   [0, 0,   0],   [0, 0,   z0+dz],    [0, y1,   z1]],
		//[[0, y1, z1], 		   [0, R*MY,   z0+dz],   [0, 0,   z0+dz],    [0, R*MY,   0]]
		
		
		ctrl_pts = [
			[[0, -y1,2*z0], 	[2*R/3, -y1,2*z0+dz],[4*R/3, -y1,   2*z0+dz],    [2*R, -y1,   2*z0]],
			[[0, 0,  z0], 		[2*R/3, 0,   z0+dz],   [4*R/3, 0,   z0+dz],    [2*R, 0,   z0]],
			[[0, y1, z1], 		[2*R/3, y1,  z1+dz],   [4*R/3, y1,  z1+dz],    [2*R, y1,  z1]],
			[[0, y2, z2], 		[2*R/3, y2,  z2+dz],   [4*R/3, y2,  z2+dz],    [2*R, y2,  z2]],
			[[0, R*MY, z3], 		[2*R/3, R*MY, z3+dz],     [4*R/3, R*MY, z3+dz],    [2*R, R*MY, z3]]
			//[[0, R*4, 0], 		[2*R/3, R*4, dz],      [4*R/3, R*4, dz],    [2*R, R*4, 0]]
			
		];
		
		pts = [
			[[0, 0,  z0], 		[2*R/3, 0,   z0+dz],   [4*R/3, 0,   z0+dz],    [2*R, 0,   z0]],
			[[0, y1, z1], 		[2*R/3, y1,  z1+dz],   [4*R/3, y1,  z1+dz],    [2*R, y1,  z1]],
			[[0, y2, z2], 		[2*R/3, y2,  z2+dz],   [4*R/3, y2,  z2+dz],    [2*R, y2,  z2]],
			[[0, R*MY, 0], 		[2*R/3, R*MY, dz],     [4*R/3, R*MY, dz],    [2*R, R*MY, 0]],
			[[0, R*4, -1], 		[2*R/3, R*4, -1+dz],      [4*R/3, R*4, -1+dz],    [2*R, R*4, -1]]
			
		];
		
		
		
		//__s = spline_args(pts[0], v1=[0,0,10], v2=[0,-10,0], closed=false);
		
		//__s = spline_args(pts[0],  closed=false);
		//v=[for(i=[0:len(pts)-1])
		//echo (spline(__s, 0.02));
		
		//my=myspline(pts[0],0.1);
		//echo("my=",my);
		ptst= transpose(ctrl_pts);
		
		vv= [for (i=[0:len(ptst)-1] ) myspline(ptst[i],0.1)];
				//translate(spline(__s, t))	cube([0.2,0.2,0.2], center=true);
				//echo ("***");
		//echo(len(vv));
		//function_grapher(vv, 1); 				
		//for (i=[0:len(vv)-1])echo (i,vv[i]);
		
		gg = [for(j = [0:len(vv[0]) - 1]) 	myspline([for(i = [0:len(vv) -1]) vv[i][j]],0.1)];
		
		//for (i=[0:len(gg)-1]){
		//	echo (gg[i]);
		//}
		function_grapher(gg, 20); 	
		//echo ("vv=",vv);	
		//];
		
		
	//	[[0, -y1/2,2*z0], 	[2*R/3, -y1/2,2*z0+dz],[R, -y1/2,2*z0+dz], [4*R/3, -y1/2,   2*z0+dz],    [2*R, -y1/2,   2*z0]],
		
		//ctrl_pts = [
		//	[[0, 0,  z0], 		[2*R/3, 0,   z0+dz],   [R, 0,   z0+dz],   	[4*R/3, 0,   z0+dz],    [2*R, 0,   z0]],
		//	[[0, y1, z1], 		[2*R/3, y1,  z1+dz],   [R, y1,  z1+dz],   	[4*R/3, y1,  z1+dz],    [2*R, y1,  z1]],
		//	[[0, y2, z2], 		[2*R/3, y2,  z2+dz],   [R, y2,  z2+dz],   	[4*R/3, y2,  z2+dz],    [2*R, y2,  z2]],
		//	[[0, R*MY, 0], 		[2*R/3, R*MY, dz],     [R, R*MY, dz],   	[4*R/3, R*MY, dz],    [2*R, R*MY, 0]],
		//	[[0, R*4, 0], 		[2*R/3, R*4, dz],      [R, R*4, dz],   	[4*R/3, R*4, dz],    [2*R, R*4, 0]]
		//	
		//];

		//ctrl_pts = [
		//	[[0, -y1/2,2*z0], 	[R, -y1/2,2*z0+dz], [2*R, -y1/2,   2*z0]],
		//	[[0, 0,  z0], 		[R, 0,   z0+dz],   	[2*R, 0,   z0]],
		//	[[0, y1, z1], 		[R, y1,  z1+dz],   	[2*R, y1,  z1]],
		//	[[0, y2, z2], 		[R, y2,  z2+dz],   	[2*R, y2,  z2]],
		//	[[0, R*MY, 0],	 	[R, R*MY, dz],   	[2*R, R*MY, 0]],
		//	[[0, R*4, 0], 		[R, R*4, dz],   	[2*R, R*4, 0]]
		//	
		//];

		$fn= 50;
		if (0) for (y=[0:len(ctrl_pts)-1]){
			for (x=[0:len(ctrl_pts[y])-1]){
				color("blue") translate(ctrl_pts[y][x]) sphere(1);
			}
		}
		thickness = 2;
		t_step = 0.25;
		
		if (0){
			g_pts = [for(i = [0:len(ctrl_pts) - 1]) 
				bezier_curve(t_step, ctrl_pts[i])
				
			]; 
			for (i=[0:len(g_pts)-1]){
				
				polyline3d(g_pts[i]);
			}
			//function_grapher(g_pts, thickness);
		}
		if (0){
			bezier_pts = [for(i = [0:len(ctrl_pts) - 1]) 
				bezier_curve(t_step, ctrl_pts[i])
				
			]; 
			for(i = [0:len(bezier_pts) - 1]) {
			   polyline3d(bezier_pts[i], thickness);
			}
			
			g_pts = [for(j = [0:len(bezier_pts[0]) - 1]) 
				bezier_curve(t_step, 
					[for(i = [0:len(bezier_pts) - 1]) bezier_pts[i][j]]
				) 
			];
			
			function_grapher(g_pts, thickness);
			
			for(i = [0:len(g_pts) - 1]) {
			   polyline3d(g_pts[i], thickness);
			}
		}
		if (0){
		
			g = bezier_surface(t_step, ctrl_pts);
			function_grapher(g, thickness); 
		}
	}
	}

}




module lower_lips(){
	x_size=100;
	R = 3;
	r=1;
	difference(){
    union(){
		hull(){
			translate([0,R,80]) 	rotate([0,90,0]) translate([0,0,-x_size/2]) rounded_cylinder(x_size,R,r,r);
			translate([0,R,15+R])  	rotate([0,90,0]) translate([0,0,-x_size/2]) rounded_cylinder(x_size,R,r,r);
		}
		hull()
		{
			translate([0,R,23+R])    rotate([0,90,0]) translate([0,0,-x_size/2]) rounded_cylinder(x_size,R,r,r);
			translate([0,R-7,15+R])  rotate([0,90,0]) translate([0,0,-x_size/2]) rounded_cylinder(x_size,R,r,r);
			
			translate([0,0,-16+2*R]) union(){
				translate([0,R,12+R])    rotate([0,90,0]) translate([0,0,-x_size/2]) rounded_cylinder(x_size,R,r,r);
				translate([0,R-7,10+R])  rotate([0,90,0]) translate([0,0,-x_size/2]) rounded_cylinder(x_size,R,r,r);
			}
		}
		//translate([0,-15+R,-15+R])  rotate([0,90,0]) translate([0,0,-x_size/2]) rounded_cylinder(x_size,R,r,r);
		//translate([0,-15+R,5+R])  rotate([0,90,0]) translate([0,0,-x_size/2]) rounded_cylinder(x_size,R,r,r);
        //translate([0,6,0]) rounded_cube(x_size,8,80,2,2,2);
        //#translate([0,0,0])  rounded_cube(x_size,18,17,2,2,2);
		//translate([0,17,0]) rotate([0,90,0]) translate([0,0,-x_size/2]) rounded_cylinder(x_size,3,2,2);
		//translate([0,0,0]) rotate([0,90,0]) translate([0,0,-x_size/2]) rounded_cylinder(x_size,3,2,2);
		//translate([0,-17,0]) rotate([0,90,0]) translate([0,0,-x_size/2]) rounded_cylinder(x_size,3,2,2);
		//translate([0,-17,0]) rotate([0,90,0]) translate([0,0,-x_size/2]) rounded_cylinder(x_size,3,2,2);
    }
    //translate([-x_size/2+35/2,0,0])  cubeZ0(35,0.8,15);
    //translate([ x_size/2-35/2,0,0])  cubeZ0(35,0.8,15);
    // hole
			#translate([0,0,18]){
				translate([-x_size/2,0,0]) rotate([0,90,0]) cylinder(2*x_size/2,2,2);
				translate([(x_size/2-37),-2,-20])
				cube([37,1,20]);
				mirror([1,0,0]) 
				translate([(x_size/2-37),-2,-20])  cube([37,1,20]);
			}
 
	}
}

module wall(){
	hr=10;
	w=6;
	h=5;
	r=4;
	difference(){
		rounded_cube(w,45,70,1,2,2);
		translate([0,0,50]) rotate([0,90,0]){
			translate([0,0,0]){
				translate ([-hr,-hr,0]) cylinder (6,12.8/2,12.2/2);
				translate ([-hr, hr,0]) cylinder (6,12.8/2,12.2/2);
				translate ([ hr, hr,0]) cylinder (6,12.8/2,12.2/2);
				translate ([ hr,-hr,0]) cylinder (6,12.8/2,12.2/2);
			}
			translate([0,0,0]){
				translate ([-hr,-hr,-15]) cylinder (50,2,2);
				translate ([-hr, hr,-15]) cylinder (50,2,2);
				translate ([ hr, hr,-15]) cylinder (50,2,2);
				translate ([ hr,-hr,-15]) cylinder (50,2,2);
			}
		}
		translate ([0,-10,0]) cylinder (10,1,1);
		translate ([0, 10,0]) cylinder (10,1,1);
		cubeZ0(50,50,1.5)	;
	}
}

wall();
//rotate([90,0,0]) upper_lips();
//rotate([90,0,0])
//translate([0,25,-17]) lower_lips();

//if (0){
//	points2d= [[0,10], [1,0],[2,-5],[5,-3],[6,3]];
//	ss=spline_args(points2d);
//	echo("len=",len(ss));
//	for(t=[0:0.1:len(ss)]) {
//		//translate(spline(__s, t))	cube([0.2,0.2,0.2], center=true);
//		translate(spline(ss, t)) circle(0.4);
//		echo (t,spline(ss, t));
//		
//	}
//	for(i=[0:len(points2d)-1]){
//		color("blue") translate(points2d[i]) circle(1);
//	}
//}
//	
//if (0){
//	
//	points= [[0,10,0], [10,0,0],[0,-5,2],[-3,-3,0]];
//	__s = spline_args(points, v1=[0,0,100], v2=[-1,0,0], closed=false);
//	for(t=[0:0.01:len(__s)]) {
//		translate(spline(__s, t))	cube([0.2,0.2,0.2], center=true);
//		
//	}
//	for(i=[0:len(points)-1]){
//		translate(points[i])	cube([1,1,1], center=true);
//	}
//}



//https://openhome.cc/eGossip/OpenSCAD/BezierSurface.html

//ctrl_pts = [
//    [[0, 0, 20],  [60, 0, -35],   [90, 0, 60],    [200, 0, 5]],
//    [[0, 50, 30], [100, 60, -25], [120, 50, 120], [200, 50, 5]],
//    [[0, 100, 0], [60, 120, 35],  [90, 100, 60],  [200, 100, 45]],
//    [[0, 150, 0], [60, 150, -35], [90, 180, 60],  [200, 150, 45]]
//];


