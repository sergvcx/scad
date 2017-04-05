var model = new Array();

function ShowPegGrid(Space = 10.0,Size = 1.0) {

   RangeX = floor(100 / Space);
   RangeY = floor(125 / Space);
   for( var i=0;i<10;i++){
        var c=cube(1);
        model.push(c.translate([i*10,0,0]));
   }
   for( var i=0;i<10;i++){
        var c=cube(1);
        model.push(c.translate([0,i*10,0]));
   }
} 

//------------------------------------------------------
function pyramide(dx0,dy0,dx1,dy1,h,shift){
    var polygons = [];
    var lo=[[0,0,0],[dx0,0,0],[dx0,dy0,0],[0,dy0,0]];
    var hi=[[0,0,h],[dx1,0,h],[dx1,dy1,h],[0,dy1,h]];
    
    polygons.push(new CSG.Polygon([
          new CSG.Vertex(new CSG.Vector3D(lo[0])),
          new CSG.Vertex(new CSG.Vector3D(lo[1])),
          new CSG.Vertex(new CSG.Vector3D(lo[2])),
          new CSG.Vertex(new CSG.Vector3D(lo[3]))
       ])
    );
    polygons.push(new CSG.Polygon([
          new CSG.Vertex(new CSG.Vector3D(hi[0])),
          new CSG.Vertex(new CSG.Vector3D(hi[1])),
          new CSG.Vertex(new CSG.Vector3D(hi[2])),
          new CSG.Vertex(new CSG.Vector3D(hi[3]))
       ])
    );
    for (i=0;i<4;i++){
        polygons.push(new CSG.Polygon([
              new CSG.Vertex(new CSG.Vector3D(lo[i%4])),
              new CSG.Vertex(new CSG.Vector3D(lo[(i+1)%4])),
              new CSG.Vertex(new CSG.Vector3D(hi[(i+1)%4])),
              new CSG.Vertex(new CSG.Vector3D(hi[i%4]))
           ])
        );
    }
    solid = CSG.fromPolygons(polygons);
    return solid;
}
function distance(x,y){
    return sqrt((x[0]-y[0])*(x[0]-y[0])+(x[1]-y[1])*(x[1]-y[1])+(x[2]-y[2])*(x[2]-y[2]));
}

function centre(p0,p1){
	return [(p0[0]+p1[0])/2,
			(p0[1]+p1[1])/2,
			(p0[2]+p1[2])/2];
}
function middleLine(p0,p1,p2){
	return [centre(p0,p1),centre(p1,p2)];
}
function sub(p0,p1){
	return [(p0[0]-p1[0]),
			(p0[1]-p1[1]),
			(p0[2]-p1[2])];
}

function neg(p1){
	return [(-p1[0]),
			(-p1[1]),
			(-p1[2])];
}

function vec(line){
	if(line.length!=2) throw new Error("Length should be 2!");
	if(line[0].length!=3) throw new Error("Length should be 3!");
	return [(line[1][0]-line[0][0]),
			(line[1][1]-line[0][1]),
			(line[1][2]-line[0][2])];
}
function add(p0,p1){
	if (p0.length!=p1.length) throw new Error("Length should be equal!");
	return [(p0[0]+p1[0]),
			(p0[1]+p1[1]),
			(p0[2]+p1[2])];
}
function len(vec){
	return sqrt(vec[0]*vec[0]+vec[1]*vec[1]+vec[2]*vec[2]);
}
function cosvec(vec0,vec1){
	return ((vec0[0]*vec1[0]+vec0[1]*vec1[1]+vec0[2]*vec1[2])/len(vec0)/len(vec1));
}
function angle(vec0,vec1){
	return acos(cosvec(vec0,vec1));
}

function vecMul(vec0,vec1){
	if(vec0.length!=3 || vec1.length!=3) throw new Error("Length should be 3!");
	var a=vec0[1]*vec1[2]-vec0[2]*vec1[1];
	var b=vec0[2]*vec1[0]-vec0[0]*vec1[2];
	var c=vec0[0]*vec1[1]-vec0[1]*vec1[0];
	return [a,b,c];
}
function figureCentre(p){
	var cent=p[0];
	for(i=1;i<p.length;i++){
		cent=add(cent,p[i]);
	}
	return [cent[0]/p.length,
			cent[1]/p.length,
			cent[2]/p.length];
}
function vector(strt,vec,r,clr=[1,0,0]){
	if (strt.length!=3 || vec.length!=3) throw new Error("Length should be 3!");
	if (len(vec)==0) throw new Error("Zero vector");
	return 	union(
		cylinder({start: strt, end: add(strt,vec), r1: r, r2: r, fn: 4}),
		//cylinder({start: add(start,vec), end: add(start,vec), r1: r+1, r2: 0, fn: 50})
		sphere(r*2).translate(add(strt,vec))
		).setColor(clr);
		
}
//-----------------------------------------
function sergoeder(poly0,poly1,autoAlign=false){
    var polygons = [];
    if (poly0.length>=3){
        var verts0=[];
        for(i=0;i<poly0.length;i++){
            verts0[i]=new CSG.Vertex(new CSG.Vector3D(poly0[poly0.length-i-1]));
			//verts0[i]=new CSG.Vertex(new CSG.Vector3D(poly0[i]));
        }
        polygon0=new CSG.Polygon(verts0);
        polygons.push(polygon0);
    }
   
    if (poly1.length>=3){
        var verts1=[];
        for(i=0; i<poly1.length;i++){
            verts1[i]=new CSG.Vertex(new CSG.Vector3D(poly1[i]));
        }
        polygon1=new CSG.Polygon(verts1);
        polygons.push(polygon1);
    }

	var firstPair=[0,0];
	var lastPair=[poly0.length-1,poly1.length-1];
	
	if (autoAlign){
		var minDistance=distance(poly0[0],poly1[0]);
	
		for(i=0;i<poly1.length;i++){
			newDistance=distance(poly0[0],poly1[i]);
			if (newDistance<minDistance){
				minDistance=newDistance;
				firstPair=[0,i];
			}
		}
		lastPair[1]=firstPair[1]+poly1.length-1;
	}
    i0=firstPair[0];
    i1=firstPair[1];

	//centre(poly0[1],poly0[2]);
    //middleLine(poly0[1],poly1[2],poly0[1]);
	midLineL1=middleLine(poly1[(i1-1+poly1.length)%poly1.length], poly0[i0], poly1[i1] );
	midLineL0=middleLine(poly0[(i0-1+poly0.length)%poly0.length],poly1[i1],poly0[i0]);
	midLineR1=middleLine(poly1[i1],poly0[i0],poly1[(i1+1)%poly1.length]);
	midLineR0=middleLine(poly0[i0],poly1[i1],poly0[(i0+1)%poly0.length]);
	
	//model.push(vector(midLineL0[0],vec(midLineL0),0.5));
	//model.push(vector(midLineR0[0],vec(midLineR0),0.5));
	//model.push(vector(midLineR1[0],vec(midLineR1),0.5));
	
	ang11=angle(neg(vec(midLineL1)),vec(midLineR1));
	ang10=angle(neg(vec(midLineL1)),vec(midLineR0));
	ang01=angle(neg(vec(midLineL0)),vec(midLineR1));
	ang00=angle(neg(vec(midLineL0)),vec(midLineR0));
	
	maxAng=ang11;
	maxPair=1;
	if (maxAng<ang10){
		maxAng=ang10;
		maxPair=0;
	}
	if (maxAng<ang01){
		maxAng=ang01;
		maxPair=1;
	}
	if (maxAng<ang00){
		maxAng=ang00;
		maxPair=0;
	}
	
	lastMidLine=[];
	if (maxPair==1){
		var verts=new Array;
		verts[0]=new CSG.Vertex(new CSG.Vector3D(poly0[i0%poly0.length]));
		verts[1]=new CSG.Vertex(new CSG.Vector3D(poly1[(i1+1)%poly1.length]));
		verts[2]=new CSG.Vertex(new CSG.Vector3D(poly1[i1%poly1.length]));
		polygon=new CSG.Polygon(verts);
		polygons.push(polygon);
		lastMidLine=middleLine(poly1[i1],poly0[i0],poly1[(i1+1)%poly1.length]);
		i1++;
	}
	else{
		var verts=new Array;
		verts[0]=new CSG.Vertex(new CSG.Vector3D(poly0[i0%poly0.length]));
		verts[1]=new CSG.Vertex(new CSG.Vector3D(poly0[(i0+1)%poly0.length]));
		verts[2]=new CSG.Vertex(new CSG.Vector3D(poly1[i1%poly1.length]));
		polygon=new CSG.Polygon(verts);
		polygons.push(polygon);
		lastMidLine=middleLine(poly0[i0],poly1[i1],poly0[(i0+1)%poly0.length]);
		i0++;
	}
       	
	centre1=figureCentre(poly1);
	centre0=figureCentre(poly0);
	norm = sub(centre1,centre0);
	model.push(vector(centre1,norm,1));
	model.push(vector(lastMidLine[0],vec(lastMidLine),0.4));
    //while((i0<=lastPair[0]) || (i1<=lastPair[1])){
	for(k=0; k<9;k++){
		dist1=distance(poly0[i0%poly0.length],poly1[(i1+1)%poly1.length]);
		dist0=distance(poly1[i1%poly1.length],poly0[(i0+1)%poly0.length]);
		midLine1=middleLine(poly1[i1%poly1.length],poly0[i0%poly0.length],poly1[(i1+1)%poly1.length]);
		midLine0=middleLine(poly0[i0%poly0.length],poly1[i1%poly1.length],poly0[(i0+1)%poly0.length]);

		
		norm1=vecMul(vec(lastMidLine),vec(midLine1));
		norm0=vecMul(vec(lastMidLine),vec(midLine0));
		
		model.push(vector(midLine0[0],vec(midLine0),0.3,[0,1,0]));
		model.push(vector(midLine1[0],vec(midLine1),0.3,[0,0,1]));

		
		
		model.push(vector(midLine0[0],norm0,0.1,[0,1,0])); //0-G
		model.push(vector(midLine1[0],norm1,0.1,[0,0,1])); //1-B
		
		
		ang1=cosvec(norm,norm1);
		ang0=cosvec(norm,norm0);
		if (ang0<0) throw new Error("eng <0","asdas");
		
		
		//ang1=angle(lastMidLine,midLine1);
		//ang0=angle(lastMidLine,midLine0);

		
       if ((dist1<dist0)  && (i0<=lastPair[0]+1) && (i1<=lastPair[1]))
       {
            var verts=new Array;
            verts[0]=new CSG.Vertex(new CSG.Vector3D(poly0[i0%poly0.length]));
            verts[1]=new CSG.Vertex(new CSG.Vector3D(poly1[(i1+1)%poly1.length]));
            verts[2]=new CSG.Vertex(new CSG.Vector3D(poly1[i1%poly1.length]));
            polygon=new CSG.Polygon(verts);
            polygons.push(polygon);
			lastMidLine=middleLine(poly1[i1%poly1.length],poly0[i0%poly0.length],poly1[(i1+1)%poly1.length]);
            i1++;
            continue;
        }
        //if ((dist0<=dist1) && (i1<=lastPair[1]+1) && (i0<=lastPair[0]))
		else
        {
            var verts=new Array;
            verts[0]=new CSG.Vertex(new CSG.Vector3D(poly0[i0%poly0.length]));
            verts[1]=new CSG.Vertex(new CSG.Vector3D(poly0[(i0+1)%poly0.length]));
            verts[2]=new CSG.Vertex(new CSG.Vector3D(poly1[i1%poly1.length]));
            polygon=new CSG.Polygon(verts);
            polygons.push(polygon);
			lastMidLine=middleLine(poly0[i0%poly0.length],poly1[i1%poly1.length],poly0[(i0+1)%poly0.length]);
            i0++;
            continue;
        }
        
        
    }
    solid = CSG.fromPolygons(polygons);
    return solid;
}

//---------------------------------------------
function roundBox(r,h,round,roundBottom=false,roundTop=false){
    if (roundBottom)
        z=r;
    else 
        z=r-round;
    rc1=CSG.roundedCube({ // rounded cube
            center: [0, 0, z],
            radius: r,
            roundradius: round});

    if (roundTop)
        z=-r+h;
    else 
        z=-r+h+round;
    rc2=CSG.roundedCube({ // rounded cube
            center: [0, 0, z],
            radius: r,
            roundradius: round});
    rc3=cube({size:[r*2,r*2,h],center:[true,true,false]})
    rc=intersection(rc1,rc2,rc3);
    return rc;
}

//-------------------------------------------------
function roundRectTor(r0,r1,h,round,roundBottom=false,roundTop=false){
    return difference(roundBox(r1,h,round,roundBottom,roundTop),cube({size:r0*2,center:[true,true,false]}));
}
//---------------------------------------------------
function rectTor(r0,r1,h){
    return difference(cube({size:[r0*2,r0*2,h],center:[true,true,false]}),cube({size:r0,center:[true,true,false]}));
}

//
    
function extruder(){
   dz=4;
	return 	union(
	    cube([16,16,11]).translate([-8-4,-8,dz]),
		cylinder({h:30,r1:2,r2:2}).translate([0,0,-3+dz]),
		cylinder({r2:2,r1:0,h:2}).translate([0,0,-5+dz])
	).setColor([0.9,0,0,0.4]);
}

function star(R){
	var star=cube({size:1});
    for(i=0;i<360;i+=10) {
        star=star.union(cube({size:[R,2.5,2]}).translate([0,5,1]).rotateZ(i));
		star=star.union(cube({size:[R,2.5,2]}).translate([0,5,0]).rotateY(-5).rotateZ(i));
    }
    return star;//=intersection(nozzleIn,star);
}
function ring(R1,R2,h){
	return difference(
		cylinder({r1:R2,r2:R2,h:h}),
		cylinder({r1:R1,r2:R1,h:h})
	);
}
		
function coolerRing(R1,R2,h,border){
   dz=4;
	return 	difference(
	    union(
			cylinder({r1:R2,r2:R2,h:h}),
			ring(R2-border,R2,4).translate([0,0,h])
		),
		cylinder({r1:R1,r2:R1,h:h}),
		ring(R2-1-(border-2),R2-1,7).translate([0,0,1]),
		star(R2-3)
	);
}

function rodHi(rodx,rody,rodHi_z,w){
	var c0 = CAG.circle({radius: w});
    var rect=chain_hull( 
            c0.translate([w,w,0]),
            c0.translate([rodx-w,w,0]),
            c0.translate([rodx-w,rody-w,0]),
            c0.translate([w,rody-w,0]),
            c0.translate([w,w,0])
            );

    return rect.extrude({offset: [0,0,rodHi_z], twistangle: 0}).rotateZ(0);
    //rodHi = rotate([0,0,-30],rodHi);
    //rodHi = rodHi.translate([0,0,rod_z-rodHi_z]);
    //model.push(rodHi);
    //rod   = rect.extrude({offset: [0,0,rodLo_z], twistangle: -30, twiststeps: 100});
	
	
}

function trans(poly,dx,dy,dz){
	arr=[];
	for(i=0;i<poly.length;i++){
		p=poly[i];
		arr[i]=[p[0]+dx,p[1]+dy,p[2]+dz];
	}
	return arr;
}
function rot(poly,ang){
	arr=[];
	for(i=0;i<poly.length;i++){
		p=poly[i];
		a=atan2(p[1],p[0]);
		a+=ang;
		r=sqrt(p[0]*p[0]+p[1]*p[1]);
		arr[i]=[r*cos(a),r*sin(a),p[2]];
	}
	return arr;
}
function tube(rodSize,rodPos,ang,R,borderW,h,w){
	
	polyOutHi=[	[0,0,h],
				[rodSize[0],0,h],
				[rodSize[0],rodSize[1],h],
				[0,rodSize[1],h]];
				
	//polyOutHi=trans(polyOutHi,rodPos[0],rodPos[1],rodPos[2]);
	polyOutHi=rot(polyOutHi,-30);
	polyOutHi=trans(polyOutHi,rodPos[0],rodPos[1],0);
	polyOutLo=[];
	var i=0;
	for(a=ang[0];a<=ang[1];a+=15,i++){
		polyOutLo[i]=[(R)*cos(a),(R)*sin(a),0];
	}

	//polyIn1=[[0,0,h],[0,rody,tubeh]];
	//polyIn0=[];
	//i=0;
	//for(ang=-90;ang<=angMax;ang+=15,i++){
	//	polyIn0[i]=[(nozzleR-borderW)*cos(ang),(nozzleR-borderW)*sin(ang),0];
	//}
	
	
	//return difference(){
	return 	sergoeder(polyOutLo,polyOutHi,true);
	//	sergoeder(polyIn,PolyUp,false)
	//};
}
//========================================================
function main() {
    ShowPegGrid();

	a = 1, b = 2;
	var dx0=10;
    var dx1=10;
    var dy0=10;
    var dy1=10;
    var h =30;
    var w=0.5;
    var rodx=10;
    var rody=20;
    var rod_z=60;
    var rodHi_z=20;
    var rodLo_z=rod_z-rodHi_z;
    var nozzleR=28;
    var nozzleH=5;
    var nozzleR0=15;
    var round=3;
	var rodDx=17;
	var rodDy=-17;
	var borderW=4;
	//return rodHi(rodx,rody,rodHi_z,w);
	
	var tubeh=20;
	
	
	
	//	poly0[i]=[-11,nozzleR/2-4,0];
	
	
	//var shape1 = CAG.fromPoints(poly0); 
	//var shape2 = CAG.fromPoints(poly1); 
	//var shapeIn1 = CAG.fromPoints(polyIn0); 
	//return shapeIn1;
	//model.push(sergoeder(poly0,poly1,false));
	//model.push(sergoeder(polyIn0,polyIn1,false));
	model.push(tube([rodx,rody],[17,-17,0],[-90,45],nozzleR+20,5,20,1,false));
	return model;
	
	model.push(rodHi(rodx,rody,rodHi_z,w).translate([rodDx,rodDy,30]));
    model.push(coolerRing(17,nozzleR,4,7));
    model.push(extruder());
   // model.push(sergoeder(lo4,hi5));
    

    return model;

    
    



    nozzleOut= roundBox(nozzleR,nozzleH,round,true,false);
    nozzleIn = roundBox(nozzleR-1,nozzleH-2,round-1).translate([0,0,1]);

   
    nozzleCube = cube({size:nozzleR0*2,center:[true,true,false]});
    border = roundRectTor(41/2,nozzleR,4,round).translate([0,0,4]);
    nozzle= difference(union(nozzleOut,border),
                star,
                nozzleCube,
                roundRectTor(nozzleR-5,nozzleR-1,6,round-1,false).translate([0,0,1]),// emptity
                roundRectTor(42/2,nozzleR-1,3,round-1).translate([0,0,4]) );


    model.push(nozzle);
    return model;

}
/*
var lo2=[[0,0,0],[dx0,2,0]];
    var lo3=[[0,0,0],[dx0,2,0],[dx0,dy0,0]];
    var lo4=[[0,0,0],[dx0,2,0],[dx0,dy0,0],[0,dy0,0]];
    var lo5=[[0,0,0],[dx0,2,0],[dx0,dy0,0],[0,dy0,0],[-5,5,0]];
    //var hi=[[0,0,h],[dx1,0,h],[dx1,dy1,h],[2,dy1,h]];
    var hi5=[[0,0,h],[dx1,0,h],[dx1,dy1,h],[0,dy1,h],[-5,5,h]];
    var hi4=[[0,0,h],[dx1,0,h],[dx1,dy1,h],[0,dy1,h]];
    var hi3=[[0,0,h],[dx1,0,h],[dx1,dy1,h]];
    var hi2=[[0,0,h],[dx1,0,h]];
    var tri=[[0,0,h],[dx1,0,h],[dx1,dy1,h]];
    var circ=[];
    for(i=0 ;i<15; i++){
        circ[i]=[10*cos(i*360/15),10*sin(i*360/15),10+i];
    }
    var circlo=[];
    for(i=0 ;i<15; i++){
        circlo[i]=[10*cos(i*360/15),10*sin(i*360/15),0];
    }
	//model.push(star(nozzleR-1,2));
	*/