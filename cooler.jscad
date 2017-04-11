var model = new Array();

function mulc(vec,k){
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

function centre2(p0,p1){
	return [(p0[0]+p1[0])/2,
			(p0[1]+p1[1])/2,
			(p0[2]+p1[2])/2];
}
function middleLine(p0,p1,p2){
	return [centre2(p0,p1),centre2(p1,p2)];
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
	if (p0.length!=p1.length) throw new Error("add: Length should be equal!");
	if (p0.length!=3) throw new Error("add: Length should be 3!");
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
function angle3(A,B,C){
	return angle(sub(A,B),sub(C,B));
}

function vecMul(vec0,vec1){
	if(vec0.length!=3 || vec1.length!=3) throw new Error("vecMul:Length should be 3!");
	var a=vec0[1]*vec1[2]-vec0[2]*vec1[1];
	var b=vec0[2]*vec1[0]-vec0[0]*vec1[2];
	var c=vec0[0]*vec1[1]-vec0[1]*vec1[0];
	return [a,b,c];
}
function centre(p){
	var cent=p[0];
	for(i=1;i<p.length;i++){
		cent=add(cent,p[i]);
	}
	return [cent[0]/p.length,
			cent[1]/p.length,
			cent[2]/p.length];
}
function centr(p){
	var cent=p[0];
	for(i=1;i<p.length;i++){
		cent=add(cent,p[i]);
	}
	return [cent[0]/p.length,
			cent[1]/p.length,
			cent[2]/p.length];
}


function centre3(p0,p1,p2){
	var cent=add(add(p0,p1),p2);
	return [cent[0]/3,
			cent[1]/3,
			cent[2]/3];
}
function centre2(p0,p1){
	var cent=add(p0,p1);
	return [cent[0]/2,
			cent[1]/2,
			cent[2]/2];
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

function vector(strt,vec,r=0.1,clr=[1,0,0]){
	if (strt.length!=3 || vec.length!=3) throw new Error("vector:Length should be 3!");
	if (len(vec)==0) throw new Error("Zero vector");
	return 	union(
		cylinder({start: strt, end: add(strt,vec), r1: r, r2: r, fn: 4}),
		//cylinder({start: add(start,vec), end: add(start,vec), r1: r+1, r2: 0, fn: 50})
		sphere({r:r,fn:8}).translate(add(strt,vec))
		).setColor(clr);
		
}
function line(start1,end1,r=0.1,clr=[1,0,0]){
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
		if (p[0]==0 && p[1]==0){
			arr[i]=p;
		}
		else {
			a=atan2(p[1],p[0]);
			a+=ang;
			r=sqrt(p[0]*p[0]+p[1]*p[1]);
			arr[i]=[r*cos(a),r*sin(a),p[2]];
		}
	}
	return arr;
}

function rot1(p,ang){
	var a=atan2(p[1],p[0]);
	a+=ang;
	r=sqrt(p[0]*p[0]+p[1]*p[1]);
	rr=[r*cos(a),r*sin(a),p[2]];
	return rr;
}

// тут проблема  с острым углом
function contract(poly,w,r=2) {
	var cont=[];
	var prevPoint=poly[(i-1 +poly.length)%poly.length];
	j=0;
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
		var m = vecMul(vec10,vec12);
		if (m[2]>0)	l=-l;
		vec=mulc(vec,w/l/sin(a));
		//model.push(vector(poly[i],vec,0.1));
		var newPoint=add(poly[i],vec);
		if (distance(newPoint,prevPoint)>r){
			cont[j]=newPoint;
			prevPoint=newPoint;
			j++
		}
	}
	return cont;
}

function createPolygonsFromPoints(points,revert){
	triangles=triangulate(points,revert);
	return createPolygonsFromTriangles(triangles);
}

function perimetr3(A,B,C){
	var AB=distance(A,B);
	var BC=distance(B,C);
	var AC=distance(A,C);
	var p = (AB+BC+AC);
	return p;
}

function perimetr(poly){
	var len=0;
	for(i=0; i<poly.length-1; i++){
		len=len+distance(poly[i],poly[i+1]);
	}
	return len;
}
function area(A,B,C){
	var AB=distance(A,B);
	var BC=distance(B,C);
	var AC=distance(A,C);
	var p = (AB+BC+AC)/2;
	var S = sqrt(p*(p-AC)*(p-BC)*(p-AB));
	return S;
}
function volume(A,B,C,X){
	var AB=distance(A,B);
	var BC=distance(B,C);
	var AC=distance(A,C);
	var norm=ort(vecMul(sub(B,A),sub(C,A)));
	var dirx=sub(X,centre3(A,B,C));
	var normD= -norm[0]*A[0]-norm[1]*A[1]-norm[2]*A[2];	
	//var h = abs(norm[0]*X[0] + norm[1]*X[1]+norm[2]*X[2]+normD)/sqrt(norm[0]*norm[0]+norm[1]*norm[1]+norm[2]*norm[2]);
	var h = (norm[0]*X[0] + norm[1]*X[1]+norm[2]*X[2]+normD)/sqrt(norm[0]*norm[0]+norm[1]*norm[1]+norm[2]*norm[2]);
	var p = (AB+BC+AC)/2;
	var S = sqrt(p*(p-AC)*(p-BC)*(p-AB));
	var V = S*h/3;
	c=cosvec(norm,dirx);
	return V;
}
function is_inside_angle(BA,BC,BX){
	var abx=angle(BA,BX);
	var cbx=angle(BC,BX);
	var abc=angle(BA,BC);
	return (abx+cbx<=abc);
}
function createPolygonsFromTriangles(tri){
	var i;
	var polygons=[];
	for(i=0;i<tri.length;i++){ // WTH if i<41
	
	//for(i=0;i<41;i++){
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
	var triangles=[];
	var minAng=angle3(poly[poly.length-1],poly[0],poly[1]);
	var minIdx=0;
	var i=0;
	for(i=1;i<poly.length-1;i++){ // !!!
		ang=angle3(poly[i-1],poly[i],poly[i+1]);
		if (ang<minAng){
			minAng=ang;
			minIdx=i;
		}
	}
	i=0;
	var L=(minIdx-1+poly.length)%poly.length;
	var R=(minIdx+1)%poly.length;
	if (!revert)
		triangles[i++]=[poly[L],poly[minIdx],poly[R]];
	else 
		triangles[i++]=[poly[R],poly[minIdx],poly[L]];
	
	//model.push(vector(poly[minIdx],[0,0,1],0.1,[1,0,0]));
		
	//while(abs(L-R)>=2){
	for(j=0;j<poly.length-3;j++){
		var LL=(L-1+poly.length)%poly.length;
		var RR=(R+1)%poly.length;
		angleL = angle3(poly[LL],poly[L],poly[R]);
		angleR = angle3(poly[L],poly[R],poly[RR]);
		if (angleL<angleR){
			if (!revert)
				triangles[i++]=[poly[LL],poly[L],poly[R]];
			else 
				triangles[i++]=[poly[R],poly[L],poly[LL]];
			//model.push(line(poly[LL],poly[R],0.1,[1,1,0]));
			
			L=(L-1+poly.length)%poly.length;
			//model.push(vector(poly[L],[0,0,1],0.1,[1,1,0]));
			
		}
		else {
			if (!revert)
				triangles[i++]=[poly[L],poly[R],poly[RR]];
			else 
				triangles[i++]=[poly[RR],poly[R],poly[L]];
			//model.push(line(poly[RR],poly[L],0.1,[0,1,0]));
			//model.push(vector(poly[R],[0,0,1],0.1,[0,1,0]));
			
			//model.push(line(poly[RR],poly[L],0.1,[0,1,0]));
			R=(R+1)%poly.length;
			//model.push(vector(poly[R],[0,0.5,1],0.1,[0,1,0]));
		}
	}
	
	//while(L-R>1){
	//	var distRL=distance(poly[R],poly[L-1]);
	//	var distLR=distance(poly[L],poly[R+1]);
	//	
	//	if (distRL<distLR){
	//		if (!revert)
	//			triangles[i]=[poly[L],poly[R],poly[L-1]];
	//		else 
	//			triangles[i]=[poly[L],poly[L-1],poly[R]];
	//		L--;
	//	}
	//	else {
	//		if (!revert)
	//			triangles[i]=[poly[L],poly[R],poly[R+1]];
	//		else 
	//			triangles[i]=[poly[L],poly[R+1],poly[R]];
	//		R++
	//	}
	//	i++;
	//}
	return triangles;
}

function triangulate_wall(poly0,poly1,X){
	var i0=0;
	var i1=0;
	var previ0=999;
	var previ1=999;
	var wall=[];
	var i=0;
	var	nextMove1=[0,0,1];//vecMul(Xa,vecAB);
	var nextMove0=[0,0,1];//vecMul(Xc,vecCD);
	var	prevMove1=[0,0,1];//vecMul(Xa,vecAB);
	var prevMove0=[0,0,1];//vecMul(Xc,vecCD);
	var i0enabled=true;
	var i1enabled=true;
	while(true){
		if (i>400) break;
		if (i0==poly0.length && i1==poly1.length )
			break;
		
		var a=poly1[(i1-1+poly1.length)%poly1.length];
		var A=poly1[(i1+0)%poly1.length];
		var B=poly1[(i1+1)%poly1.length];
		var E=poly1[(i1+2)%poly1.length];
		
		var c=poly0[(i0-1+poly0.length)%poly0.length];
		var C=poly0[(i0+0)%poly0.length];
		var D=poly0[(i0+1)%poly0.length];
		var F=poly0[(i0+2)%poly0.length];
		
		var vecAB=sub(B,A);
		var vecCD=sub(D,C);
		var lenAB=len(vecAB);
		var lenCD=len(vecCD);
		if (lenAB<lenCD){
			var cd=mulc(vecCD,lenAB/lenCD);
			d=add(C,cd);
			b=B;
		}
		else {
			var ab=mulc(vecAB,lenCD/lenAB);
			b=add(A,ab);
			d=D;
		}
			
		
		var BE=sub(E,B);
		var DF=sub(F,D);
		
		var Xa=sub(a,X);
		var Xc=sub(c,X);
		var XA=sub(A,X);
		var XB=sub(B,X);
		var XC=sub(C,X);
		var XD=sub(D,X);
		
		
			
		//model.push(vector(C,nextMove0));
		//angCXA=acos()
		
		//ABE
		//CDF
		var midLineV =middleLine(B,C,A);
		var midLineVA=middleLine(C,B,D);
		var midLineVV=middleLine(B,C,E);
		var midLineA =middleLine(D,A,C);
		var midLineAV=middleLine(A,D,B);
		var midLineAA=middleLine(D,A,F);
		
		var ortMidLineV =ort(vec(midLineV ));
		var ortMidLineVA=ort(vec(midLineVA));
		var ortMidLineVV=ort(vec(midLineVV));
		var ortMidLineA =ort(vec(midLineA ));
		var ortMidLineAV=ort(vec(midLineAV));
		var ortMidLineAA=ort(vec(midLineAA));
		
		//var BC=sub(B,C);
		//var ortCB=ort(BC);
		//var V_CB =vecMul(ortCB,vecMul(ortMidLineV,ortCB));
		//var VA_CB=vecMul(vecMul(ortCB,ortMidLineVA),ortCB);
        //
		//var DA=sub(A,D);
		//var ortDA=ort(DA);		
		//var A_DA=vecMul(ortDA,vecMul(ortDA,ortMidLineA));
		//var AV_DA=vecMul(vecMul(ortDA,ortMidLineAV),ortDA);
        //
		////var dirVA=add(VA_CB,V_CB);
		////var dirAV=add(A_DA,AV_DA);
		//var dirVA=add(ortMidLineV,ortMidLineVA);
		//var dirAV=add(ortMidLineA,ortMidLineAV);
		
		
		
		//var xVA=add(midLineV[1],dirVA);
		//var xAV=add(midLineA[1],dirAV);
		
		//var k=1;
		//var xAV=add(midLineA[1],sub(mulc(ort(vec(midLineAV)),k),mulc(ort(vec(midLineA)),k)));
		//var xVA=add(midLineV[1],sub(mulc(ort(vec(midLineVA)),k),mulc(ort(vec(midLineV)),k)));
		
		var vVX =volume(A,b,C,X);
		var vVAX=volume(C,b,d,X);
		var vV=abs(vVX)+abs(vVAX);
		
		var vAX =volume(C,A,d,X);
		var vAVX=volume(A,d,b,X);
		var vA=abs(vAX)+abs(vAVX);
		

		var dirAV=add(ortMidLineAV,ortMidLineA);
		var dirAA=add(ortMidLineAA,ortMidLineA);
		var dirVA=add(ortMidLineVA,ortMidLineV);
		var dirVV=add(ortMidLineVV,ortMidLineV);
		var xAV=ort(add(midLineA[1],ort(dirAV)));
		var xAA=ort(add(midLineA[1],ort(dirAA)));
		var xVA=ort(add(midLineV[1],ort(dirVA)));
		var xVV=ort(add(midLineV[1],ort(dirVV)));
		//model.push(vector(midLineA[1],ort(dirAV),0.1,[1,0,0]));
		//model.push(vector(midLineV[1],ort(dirVA),0.1,[1,1,0]));
		
		
			
		//var 
		//model.push(vector(midLineV[0],dirVA,0.1,[1,1,0]));
		//var xAV=add(midLineA[0],mulc(dirAV,1/len(DA)));
		//var xAA=add(midLineA[0],mulc(dirAA,1/len(DA)));
		//var xVA=add(midLineV[0],mulc(dirVA,1/len(BC)));
		//var xVV=add(midLineV[0],mulc(dirVV,1/len(BC)));
		
		xA=min(distance(xAV,X),distance(xAA,X));
		xV=min(distance(xVV,X),distance(xVA,X));
		//if min)
		//var xAV=add(midLineA[1],sub((vec(midLineAV)),(vec(midLineA))));
		//var xVA=add(midLineV[1],sub((vec(midLineVA)),(vec(midLineV))));
		//model.push(line(X,xAV,0.1,[0,1,1]));
		//if (distance(X,xVA)<distance(X,xAV) && i1<poly1.length){
		if (vA>vV && i1<poly1.length){
			useV=false;
			useA=true;
		}
		else if (i0<poly0.length)
		{
			useV=true;
			useA=false;
		}
		//if (angle(vec(midLineA),
		
		//useA=i0enabled && (i0<poly0.length);
		//useV=i1enabled && (i1<poly1.length);
		////if (useA && useV){
		useA=true;
		useV=true;
		
		
		if ( !i1enabled || i1>=poly1.length)	
			useV= false ;
		
		if ( !i0enabled || i0>=poly0.length)	
			useA= false;

		if (useA && useV){
			useV= (vV>=vA);
			useA= (vV<vA);
		}
		
		//}
				
		if (useV){
			wall[i]=[A,C,B]; // V
			i++;
			i1++;
			prevMove1=nextMove1;
			nextMove1=vecMul(XB,BE);
			
			if (prevMove1[2]*nextMove1[2]<0){
			//if (nextMove1[2]<0){
				i1enabled=false;
				//model.push(vector(B,[1,0,10]));	
				//model.push(vector(B,BE,0.1,[1,0,1]));
				//model.push(vector(X,XB,0.1,[1,0,1]));
				//model.push(vector([0,0,0],nextMove1,0.1,[1,1,0]));
			}
		}
		if (useA){
			wall[i]=[D,A,C]; // A
			i++;
			i0++;
			prevMove0=nextMove0;
			nextMove0=vecMul(XD,DF);
			if (prevMove0[2]*nextMove0[2]<0){
				i0enabled=false;
				//model.push(vector(D,[0,0,-2]));
			}
		}
		if (!i1enabled && !i0enabled){
			i1enabled=true;
			i0enabled=true;
		}
    }
	return wall;
}
function sergoeder(poly0,poly1,X){
    var polygons = [];
    if (poly0.length>=3){ // bottom
		polygons=createPolygonsFromPoints(poly0,true);
    }
    if (poly1.length>=3){ //top
		hiPolygons=createPolygonsFromPoints(poly1,false);
		polygons=polygons.concat(hiPolygons);
    }
	wall=triangulate_wall(poly0,poly1,X);
	for(i=0; i<wall.length; i++ ){
		var verts=new Array;
		var tri=wall[i];
		//model.push(line(tri[0],tri[1]));
		verts[0]=new CSG.Vertex(new CSG.Vector3D(tri[0]));
		verts[1]=new CSG.Vertex(new CSG.Vector3D(tri[1]));
		verts[2]=new CSG.Vertex(new CSG.Vector3D(tri[2]));
		polygon=new CSG.Polygon(verts);
		polygons.push(polygon);
	}
    solid = CSG.fromPolygons(polygons);
    return solid;
}
function wall2solid(wall){
	var polygons = [];
	var bt=wall2bottomtop(wall);
	
	if (bt[0].length>=3){ // bottom
		polygons=createPolygonsFromPoints(bt[0],true);
    }
	if (bt[1].length>=3){ // top
		hiPolygons=createPolygonsFromPoints(bt[1],false);
		polygons=polygons.concat(hiPolygons);
    }
	
    for(i=0; i<wall.length; i++ ){
		var verts=new Array;
		var tri=wall[i];
		//model.push(line(tri[0],tri[1]));
		verts[0]=new CSG.Vertex(new CSG.Vector3D(tri[0]));
		verts[1]=new CSG.Vertex(new CSG.Vector3D(tri[1]));
		verts[2]=new CSG.Vertex(new CSG.Vector3D(tri[2]));
		polygon=new CSG.Polygon(verts);
		polygons.push(polygon);
	}
    solid = CSG.fromPolygons(polygons);
    return solid;
}
function split_wall(trigs,k=0.5){
	var hi=[];
	var lo=[];
	var l=0;
	var h=0;
	for(i=0;i<trigs.length; i++){
		var t=trigs[i];
		var mid=middleLine(t[0],t[1],t[2]);
		if (t[1][2]>(mid[0][2]+mid[1][2])/2){
			var mid=[add(t[1],mulc(sub(t[0],t[1]),(1-k))),
					 add(t[1],mulc(sub(t[2],t[1]),(1-k)))];
			//       t[1]
			//   mid[1] mid[0]
			//  t[2]      t[0]
			hi[h++]=[mid[0],t[1],mid[1]];	// A
			lo[l++]=[mid[1],t[2],mid[0]]; 	// V			
			lo[l++]=[t[0],mid[0],t[2]];		// A
        
		}
		else {
			var mid=[add(t[1],mulc(sub(t[0],t[1]),(k))),
					 add(t[1],mulc(sub(t[2],t[1]),(k)))];
			//  t[0]        t[2]
			//   mid[0]  mid[1]]
			//         t[1] 
			hi[h++]=[t[0],mid[0],t[2]];		// V
			hi[h++]=[mid[1],t[2],mid[0]]; 	// A
			lo[l++]=[mid[0],t[1],mid[1]];	// A
		}
	}
	return [lo,hi];
}
function wall2bottomtop(triangles){
	var top=[];
	var bottom=[];
	var t=0;
	var b=0;
	var tri=triangles[0];
	var c=centre3(tri[0],tri[1],tri[2]);
	if (tri[1][2]>c[2]){
		top[t++]   =tri[1]; // A
		bottom[b++]=tri[2];
		bottom[b++]=tri[0];
	}
	else {
		top[t++]   =tri[0];	// V
		top[t++]   =tri[2];	// V
		bottom[b++]=tri[1];
	}
	for (i=1;i<triangles.length;i++){
		tri=triangles[i];
		c=centre3(tri[0],tri[1],tri[2]);
		if (tri[1][2]>c[2]){
			if (distance(tri[0],bottom[0])>0.01)
				bottom[b++]=tri[0]; 	// A
		}
		else if (distance(tri[2],top[0])>0.01)
			top[t++]=tri[2];	// V
	}
	return [bottom,top];
}
function solid_wall(poly0,poly1,X,w){
	outWall    =triangulate_wall(poly0,poly1,X);
	outWallLoHi=split_wall(outWall,0.8);
	outPolyBTLo=wall2bottomtop(outWallLoHi[0]);
	inPoly0    =contract(poly0,w);
	inPolyMid  =contract(outPolyBTLo[1],w);
	inPoly1    =contract(poly1,w);

	X =[12,-9,10];
	X0=rot1([20.1,0,0],-30);
	X1=rot1([20.1,0,20],-30);
	//model.push(vector([0,0,0],X,0.1,[0,0,1]));
	
	return union(
		difference(
			wall2solid(outWallLoHi[1]),
			sergoeder(inPolyMid,inPoly1,X1).translate([0,0,0.0])
			//sergoeder(inPoly0,inPolyMid,X0)
			
		).translate([0,0,0]),
		difference(
			wall2solid(outWallLoHi[0]),
			sergoeder(inPoly0,inPolyMid,X0)
		)
	);
}
function tube(rodSize,rodPos,ang,R,borderW,h,w){
	r=19;
	a=-45;
	X= [r*cos(a),r*sin(a),10];
	polyOutHi=[	
				[0,0,h],
				[0,rodSize[1],h],
				//[-rodSize[0]/2,rodSize[1],h],
				[-rodSize[0],rodSize[1],h],
				[-rodSize[0],0,h]
				//,[0,-1,h+1]
				];
				
	polyOutHi=rot(polyOutHi,-30-90);
	polyOutHi=trans(polyOutHi,rodPos[0],rodPos[1],0);			

	var polyOutLo=[];
	var i=0;
	for(a=ang[0];a<=ang[1]+20;a+=5,i++){
		polyOutLo[i]=[(R)*cos(a),(R)*sin(a),0];
	}
	for(a=ang[1];a>=ang[0];a-=5,i++){
		polyOutLo[i]=[(R-borderW)*cos(a),(R-borderW)*sin(a),0];
	}
	polyHolerLo=trans(polyOutLo,0,0,-2);
	
	holer= sergoeder(contract(polyHolerLo,w),contract(polyOutLo,w),centre(polyHolerLo));
	//return holer;
	return [solid_wall(polyOutLo,polyOutHi,X,w),holer];
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
	
	//model.push( tube([rodx-2*w,rody-2*w],[17+w+0.4,-17+0.2,0],[-70,20],nozzleR-1,borderW-2,20,1,false).translate([0,0,8]));
	//model.push(
	//nozzOut=tube([rodx-2*w,rody-2*w],[17+w+0.4,-17+0.2,0],[-70,20],nozzleR-1,borderW-2,20,1,false).translate([0,0,0]);
	//!nozzOut=tube([rodx,rody],[17+w+0.4,-17+0.2,0],[-70,20],nozzleR-1,borderW-2,20,1,false).translate([0,0,0]);
	nozzOut=tube([rodx,rody],[17,-17,0],[-70,20],nozzleR,borderW,20,1,false).translate([0,0,8]);
	 //return nozzOut;
	//nozzIn =tube([rodx-2*w,rody-2*w],[17+w+0.4,-17+0.2,0],[-70,20],nozzleR-1,borderW-2,20,1,false).translate([0,0,8]);
	//return model;
	//return nozzIn;
	//nozzOut=tube([rodx,rody],[17,-17,0],[-70-asin(1/nozzleR),20+asin(1/nozzleR)],nozzleR,borderW,20,1,false).translate([0,0,8]);
	nozz=difference(
			union(
				nozzOut[0],
				nozzOut[0].mirroredX(),
				difference(
				coolerRing(coolerR,nozzleR,4,borderW),
				nozzOut[1])
			)
			//nozzIn,
			//nozzIn.mirroredX()
		);
	model.push(nozz);
	
	model.push(rodHi(rodx,rody,rodHi_z,w).translate([rodDx,rodDy,28]));
	model.push(rodHi(rodx,rody,rodHi_z,w).translate([rodDx,rodDy,28]).mirroredX());
    
	return model;

}
