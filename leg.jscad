// title      : OpenJSCAD.org Logo
// author     : Rene K. Mueller
// license    : MIT License
// revision   : 0.003
// tags       : Logo,Intersection,Sphere,Cube
// file       : logo.jscad
function distance(x,y){
    return sqrt((x[0]-y[0])*(x[0]-y[0])+(x[1]-y[1])*(x[1]-y[1])+(x[2]-y[2])*(x[2]-y[2]));
}
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
    
    while((i0<=lastPair[0]) || (i1<=lastPair[1])){
	//for(k=0; k<8;k++){
       dist1=distance(poly0[i0%poly0.length],poly1[(i1+1)%poly1.length]);
       dist0=distance(poly1[i1%poly1.length],poly0[(i0+1)%poly0.length]);
       
       if (i1>100 || i0>100)
            break;
            
       if ((dist1<=dist0) && (i0<=lastPair[0]+1) && (i1<=lastPair[1]))
       {
            var verts=new Array;
            verts[0]=new CSG.Vertex(new CSG.Vector3D(poly0[i0%poly0.length]));
            verts[1]=new CSG.Vertex(new CSG.Vector3D(poly1[(i1+1)%poly1.length]));
            verts[2]=new CSG.Vertex(new CSG.Vector3D(poly1[i1%poly1.length]));
            i1++;
            polygon=new CSG.Polygon(verts);
            polygons.push(polygon);
            continue;
        }
        //if ((dist0<=dist1) && (i1<=lastPair[1]+1) && (i0<=lastPair[0]))
		else
        {
            var verts=new Array;
            verts[0]=new CSG.Vertex(new CSG.Vector3D(poly0[i0%poly0.length]));
            verts[1]=new CSG.Vertex(new CSG.Vector3D(poly0[(i0+1)%poly0.length]));
            verts[2]=new CSG.Vertex(new CSG.Vector3D(poly1[i1%poly1.length]));
            i0++;
            polygon=new CSG.Polygon(verts);
            polygons.push(polygon);
            continue;
        }
        
        
    }
    solid = CSG.fromPolygons(polygons);
    return solid;
}


















function main(){
    r=20;
    l=60;
    h=150;

    circ=[];
    i=0;
    for(ang=-90+95; ang <-90+95+360; ang+=15,i++){
        circ[i]=[r*cos(ang),r*sin(ang),0];
   }
   
    //var u=sergoeder(   [[-r,-r,0],[r,-r,0],[r,r,0],[-r,r,0]],
    //                   [[-l,-r,h],[l,-r,h],[l,r,h],[-l,r,h]]);
    var u=sergoeder(   circ,
                       [[-l,-r,h],[l,-r,h],[l,r,h],[-l,r,h]],true);
   
   
    var w= difference(u,
                cylinder({r1:3,r2:3,h:h}).translate([l*3/4,0,0]),
                cylinder({r1:3,r2:3,h:h}).translate([-l*3/4,0,0]));
    return union(w,w.rotateZ(90));

}








































