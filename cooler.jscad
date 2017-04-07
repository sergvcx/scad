var model = new Array();

function mulc(vec,k){
	//var arr=[];
	var p=[];
	//var z=[];
	//for(i=0; i<poly.length; i++){
		//p=poly[i];
		p[0]=vec[0]*k;
		p[1]=vec[1]*k;
		p[2]=vec[2]*k;
	//	arr[i]=p;
	//}
	return p;
}


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
	if(line[0].length!=3) throw new Error("vec: Length should be 3!");
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
function ort(vec){
	if(vec.length!=3) throw new Error("ort: Length should be 3!");
	ort1= mulc(vec,1/len(vec));
	return ort1;
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
function centre1(p){
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
		sphere(r).translate(add(strt,vec))
		).setColor(clr);
		
}
function line(start1,end1,r,clr=[1,0,0]){
	if (start1.length!=3 || end1.length!=3) throw new Error("Line:Length should be 3!");
	//if (len(vec)==0) throw new Error("Zero vector");
	return 	union(
		cylinder({start: start1, end: end1, r1: r, r2: r, fn: 4}),
		//cylinder({start: add(start,vec), end: add(start,vec), r1: r+1, r2: 0, fn: 50})
		sphere(r).translate(end1)
		).setColor(clr);
		
}

//-----------------------------------------
function surface(poly, clockwise=false){
	var verts=[];
	polygons=[];
	if (clockwise){
		for(i=0;i<poly.length;i++){
			verts[i]=new CSG.Vertex(new CSG.Vector3D(poly[i]));
		}
	}
	else {
		for(i=0;i<poly.length;i++){
			verts[i]=new CSG.Vertex(new CSG.Vector3D(poly[poly.length-i-1]));
		}
	}
	polygon=new CSG.Polygon(verts);
	
	polygons.push(polygon);
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
		ring(R2-1-(border-2),R2-1,6).translate([0,0,1]),
		star(R2-3)
	);
}

function rodHi(rodx,rody,rodHi_z,w){
	w=w/2;
	var c0 = CAG.circle({radius: w});
    var rect=chain_hull( 
            c0.translate([w,w,0]),
            c0.translate([rodx-w,w,0]),
            c0.translate([rodx-w,rody-w,0]),
            c0.translate([w,rody-w,0]),
            c0.translate([w,w,0])
            );
	w=2*w;
	return union(
		//vector(	figureCentre([[w,w,0],[rodx-w,w,0]]),[0,0,rodHi_z],0.5),
		//vector(	figureCentre([[rodx-w,w,0],[rodx-w,rody-w,0]]),[0,0,rodHi_z],0.5),
		//vector(	figureCentre([[rodx-w,rody-w,0],[w,rody-w,0]]),[0,0,rodHi_z],0.5),
		//vector(	figureCentre([[w,rody-w,0],[w,w,0]]),[0,0,rodHi_z],0.5),
		rect.extrude({offset: [0,0,rodHi_z], twistangle: 0})
	).translate([0,-rody,]).rotateZ(60);
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
	var arr=[];
	for(i=0;i<poly.length;i++){
		p=poly[i];
		a=atan2(p[1],p[0]);
		a+=ang;
		r=sqrt(p[0]*p[0]+p[1]*p[1]);
		arr[i]=[r*cos(a),r*sin(a),p[2]];
	}
	return arr;
}

// тут проблема  с острым углом
function contract(poly,w) {
	var cont=[];
	for(i=0; i<poly.length; i++){
		var p0=poly[(i-1 +poly.length)%poly.length];
		var p1=poly[(i+0)%poly.length];
		var p2=poly[(i+1)%poly.length];
		var vec10=ort(sub(p0,p1));
		var vec12=ort(sub(p2,p1));
		var vec=add(vec10,vec12);
		var a=angle(vec10,vec);
		var l=len(vec);
		if(sin(a)==0) throw new Error("Zero!");
		vec=mulc(vec,w/l/sin(a));
		//model.push(vector(poly[i],vec,0.1));
		cont[i]=add(poly[i],vec);
	}
	return cont;
}

function createPolygonsFromTriangles(tri){
	
	var polygons=[];
	for(i=0;i<tri.length;i++){
		var verts=[];
		var tr=tri[i];
		verts[0]=new CSG.Vertex(new CSG.Vector3D(tr[0]));
		verts[1]=new CSG.Vertex(new CSG.Vector3D(tr[1]));
		verts[2]=new CSG.Vertex(new CSG.Vector3D(tr[2]));
		//var polygon=new CSG.Polygon(verts);
		//polygons.push(polygon);
		polygons[i]=new CSG.Polygon(verts);
	}
	return polygons;
	//return  CSG.fromPolygons(polygons);
}
function triangulate(poly,revert=false){
	var L=poly.length-1;
	var R=0;
	var triangles=[];
	var i=0;
	while(L-R>1){
		var distRL=distance(poly[R],poly[L-1]);
		var distLR=distance(poly[L],poly[R+1]);
		
		if (distRL<distLR){
			if (!revert)
				triangles[i]=[poly[L],poly[R],poly[L-1]];
			else 
				triangles[i]=[poly[L],poly[L-1],poly[R]];
			L--;
		}
		else {
			if (!revert)
				triangles[i]=[poly[L],poly[R],poly[R+1]];
			else 
				triangles[i]=[poly[L],poly[R+1],poly[R]];
			R++
		}
		i++;
	}
	return triangles;
}

function createPolygonsFromPoints(points,revert){
	triangles=triangulate(points,revert);
	return createPolygonsFromTriangles(triangles);
}


function sergoeder(poly0,poly1,autoAlign=false){
    var polygons = [];
    if (poly0.length>=3){
		polygons=createPolygonsFromPoints(poly0,true);
    }
    
    if (poly1.length>=3){
		hiPolygons=createPolygonsFromPoints(poly1,false);
		polygons=polygons.concat(hiPolygons);
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
	centre1=figureCentre(poly1);
	centre0=figureCentre(poly0);
	norm = sub(centre1,centre0);
	anchor=[0,0,0];
    //while((i0<=lastPair[0]) || (i1<=lastPair[1])){
	
	lastMidOrt=ort(vec(middleLine(poly1[(i1-1+poly1.length)%poly1.length],poly0[(i0-1+poly0.length)%poly0.length],poly1[(i1)%poly1.length])));
	for(k=0; k<8;k++){
		dist1=distance(poly0[i0%poly0.length],poly1[(i1+1)%poly1.length]);
		dist0=distance(poly1[i1%poly1.length],poly0[(i0+1)%poly0.length]);
		midLineV001=middleLine(poly1[i1%poly1.length],poly0[i0%poly0.length],poly1[(i1+1)%poly1.length]);
		midLineA001=middleLine(poly0[i0%poly0.length],poly1[i1%poly1.length],poly0[(i0+1)%poly0.length]);
		midLineV011=middleLine(poly1[i1%poly1.length],poly0[(i0+1)%poly0.length],poly1[(i1+1)%poly1.length]);
		midLineA011=middleLine(poly0[i0%poly0.length],poly1[(i1+1)%poly1.length],poly0[(i0+1)%poly0.length]);

		//model.push(line(midLineV001[0],midLineV001[1],0.1,[1,0,0]));
		//model.push(line(midLineA001[0],midLineA001[1],0.1,[1,1,0]));
		
		midOrtV001=ort(vec(midLineV001));
		midOrtA001=ort(vec(midLineA001));
		midOrtV011=ort(vec(midLineV011));
		midOrtA011=ort(vec(midLineA011));
		//dirVA=ort(sub(midOrtA011,midOrtV001));
		//dirAV=ort(sub(midOrtV011,midOrtA001));
		dirVA=ort(sub(midOrtA001,lastMidOrt));
		dirAV=ort(sub(midOrtV001,lastMidOrt));
		dirVAo=sub(anchor,midLineV001[1]);
		dirAVo=sub(anchor,midLineA001[1]);
		cosAVo=cosvec(dirAVo,dirAV);
		cosVAo=cosvec(dirVAo,dirVA);
		
		norm1=vecMul(vec(midLineV001),vec(midLineA011));
		norm0=vecMul(vec(midLineA001),vec(midLineV011));
		
		var use;
		//if (cosvec(norm0,norm1)>0){
		//	//model.push(vector
		//	if (dist1<dist0){
		//		use=1;
		//		model.push(vector(midLineV001[0],midLineV001[1],0.1));
		//	}
		//	else {
		//		use=0;
		//		model.push(vector(midLineA001[0],midLineA001[1],0.1));
		//	}
		//} 
		//else {
			//if (cosvec(norm1,norm)>0)
			
		
			if (cosAVo<cosVAo){
				use=1;
				model.push(line(midLineV001[0],midLineV001[1],0.1,[1,0,0]));
				//dirAVo=sub(anchor,midLineA001[1]);
				model.push(vector(midLineV001[1],dirVA,0.1,[1,0,0]));
				lastMidOrt=midOrtV001;
		
			}
			else {
				model.push(line(midLineA001[0],midLineA001[1],0.1,[1,1,0]));
				model.push(vector(midLineA001[1],dirAV,0.1,[1,1,0]));
				lastMidOrt=midOrtA001;
			//dirVAo=sub(anchor,midLineV001[1]);
		
				use=0;
			}
		//}
		
		//if (cosAVo>cosVAo)
		//		use=0;
		//	else 
		//		use=1;
		
		
		
		
		//if ( (use==1) && (i1<=lastPair[1])){
		if ( use==1){
            var verts=new Array;
            verts[0]=new CSG.Vertex(new CSG.Vector3D(poly0[i0%poly0.length]));
            verts[1]=new CSG.Vertex(new CSG.Vector3D(poly1[(i1+1)%poly1.length]));
            verts[2]=new CSG.Vertex(new CSG.Vector3D(poly1[i1%poly1.length]));
            polygon=new CSG.Polygon(verts);
            polygons.push(polygon);
			lastMidLine=middleLine(poly1[i1%poly1.length],poly0[i0%poly0.length],poly1[(i1+1)%poly1.length]);
            i1++;
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
        }
    }
    solid = CSG.fromPolygons(polygons);
    return solid;
}

function tube(rodSize,rodPos,ang,R,borderW,h,w){
	
	polyOutHi=[	[0,0,h],
				[rodSize[0],0,h],
				[rodSize[0],rodSize[1],h],
				[0,rodSize[1],h]];
				
	//polyOutHi=trans(polyOutHi,rodPos[0],rodPos[1],rodPos[2]);
	polyOutHi=trans(polyOutHi,0,-rodSize[1],0);
	polyOutHi=rot(polyOutHi,60);
	polyOutHi=trans(polyOutHi,rodPos[0],rodPos[1],0);
	polyOutLo=[];
	var i=0;
	for(a=ang[0];a<=ang[1];a+=10,i++){
		polyOutLo[i]=[(R)*cos(a),(R)*sin(a),0];
	}
	
	polyInLo=[];
	i=0;
	for(a=ang[0];a<=ang[1];a+=10,i++){
		polyInLo[i]=[(R-borderW)*cos(a),(R-borderW)*sin(a),0];
	}
	polyInHi=[sub(polyOutHi[2],[0,0,5]),[0,0,h-5],sub(polyOutHi[3],[0,0,5]),];
	//for(a=ang[1];a>=ang[0];a-=5,i++){
	//	polyOutLo[i]=[(R-borderW)*cos(a),(R-borderW)*sin(a),0];
	//}

	//polyInLo=contract(polyOutLo,1);
	//polyInHi=contract(polyOutHi,2);
	return	difference(
		sergoeder(polyOutLo,polyOutHi,true)
		//sergoeder(polyInLo,polyInHi,true)
	);
	//};
}

//========================================================
function main() {
    ShowPegGrid();

	
	//poly = [[10,10,0], [-10,10,0], [-10,-10,0],[0,-15,0],[10,0,0],[11,5,0]];
	//poly=[];
	//i=0;
	//R=30;
	//R2=20;
	//for(a =0 ;a<=180; a+=10,i++){
	//	poly[i]=[R*cos(a),R*sin(a),a/10];
	//}
	//for(a =180 ;a>=0; a-=10,i++){
	//	poly[i]=[R2*cos(a),R2*sin(a),0];
	//}
	//
	//polygons=createPolygonsFromPoints(poly,false);
	//model.push(  CSG.fromPolygons(polygons));//createPolygonsFromPoints(poly))); 
	//model.push(  CSG.fromPolygons(createPolygonsFromPoints(poly))); 
	//return model;
	//return surface(poly);
	//return solid1([[[10,10,0], [-10,10,0], [-10,-10,0]]]);
	//return triangulate(poly);
	//a=mulc(poly,2);
	
	//model.push(surface(poly,true));
	//model.push(surface(contract(poly,1),true));

	//return model;
	
//	return CAG.fromPoints(poly);
//	return CAG.fromPoints(poly);
	//return path;
	a = 1, b = 2;
	var dx0=10;
    var dx1=10;
    var dy0=10;
    var dy1=10;
    var h =30;
    var w=0.8;
    var rodx=11.2;
    var rody=14;
    var rod_z=60;
    var rodHi_z=40;
    var rodLo_z=rod_z-rodHi_z;
    var nozzleR=30; // 28/36
    var nozzleH=5;
    var nozzleR0=2;
    var round=3;
	var rodDx=17;
	var rodDy=-17;
	var borderW=7;
	var coolerR=16;
	//return rodHi(rodx,rody,rodHi_z,w);
	
	var tubeh=20;
	
	//model.push(cube({size:[66,5,1]}).center('x').translate([0,-25,0]));
//	model.push(rodHi(rodx,rody,rodHi_z,w).translate([rodDx,rodDy,0]));
//	model.push(rodHi(rodx,rody,rodHi_z,w).translate([rodDx,rodDy,0]).mirroredX());
  //return model;	
	
	
	//	poly0[i]=[-11,nozzleR/2-4,0];
	
	
	//var shape1 = CAG.fromPoints(poly0); 
	//var shape2 = CAG.fromPoints(poly1); 
	//var shapeIn1 = CAG.fromPoints(polyIn0); 
	//return shapeIn1;
	//model.push(sergoeder(poly0,poly1,false));
	//model.push(sergoeder(polyIn0,polyIn1,false));
	
	//model.push( tube([rodx-2*w,rody-2*w],[17+w+0.4,-17+0.2,0],[-70,20],nozzleR-1,borderW-2,20,1,false).translate([0,0,8]));
	model.push( tube([rodx-2*w,rody-2*w],[17+w+0.4,-17+0.2,0],[-70,20],nozzleR-1,borderW-2,20,1,false).translate([0,0,0]));
	return model;
	nozzIn =tube([rodx-2*w,rody-2*w],[17+w+0.4,-17+0.2,0],[-70,20],nozzleR-1,borderW-2,20,1,false).translate([0,0,8]);
	//return nozzIn;
	nozzOut=tube([rodx,rody],[17,-17,0],[-70-asin(1/nozzleR),20+asin(1/nozzleR)],nozzleR,borderW,20,1,false).translate([0,0,8]);
	nozz=difference(
			union(
				nozzOut,
				nozzOut.mirroredX(),
				coolerRing(coolerR,nozzleR,4,borderW)
			),
			nozzIn,
			nozzIn.mirroredX()
		);
	model.push(nozz);
	//model.push(nozz.mirroredX());
	//return model;
	
	model.push(rodHi(rodx,rody,rodHi_z,w).translate([rodDx,rodDy,28]));
	model.push(rodHi(rodx,rody,rodHi_z,w).translate([rodDx,rodDy,28]).mirroredX());
    
   // model.push(extruder());
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