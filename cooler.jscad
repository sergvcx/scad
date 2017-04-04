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
//-----------------------------------------
function sergoeder(poly0,poly1){
    var polygons = [];
    if (poly0.length>=3){
        var verts0=[];
        for(i=0;i<poly0.length;i++){
            verts0[i]=new CSG.Vertex(new CSG.Vector3D(poly0[poly0.length-i-1]));
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
    
    var minDistance=distance(poly0[0],poly1[0]);
    var minPair=[0,0];
    
    for(i=0;i<poly1.length;i++){
        newDistance=distance(poly0[0],poly1[i]);
        if (newDistance<minDistance){
            minDistance=newDistance;
            minPair=[0,i];
        }
    }
    i0=minPair[0];
    i0last=i0+poly0.length-1;
    i1=minPair[1];
    i1last=i1+poly1.length-1;
    while((i0<=i0last) || (i1<=i1last)){
       dist1=distance(poly0[i0%poly0.length],poly1[(i1+1)%poly1.length]);
       dist0=distance(poly1[i1%poly1.length],poly0[(i0+1)%poly0.length]);
       
       if (i1>100 || i0>100)
            break;
            
       if ((dist1<=dist0) && (i1<=i1last))
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
        if ((dist0<=dist1) && (i0<=i0last))
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
//========================================================
function main() {
    ShowPegGrid();

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
	model.push(coolerRing(17,nozzleR,4,7));
    model.push(extruder());
   // model.push(sergoeder(lo4,hi5));
    

    return model;

    
    var c0 = CAG.circle({radius: w});
    var rect=chain_hull( 
            c0.translate([w,w,0]),
            c0.translate([rodx-w,w,0]),
            c0.translate([rodx-w,rody-w,0]),
            c0.translate([w,rody-w,0]),
            c0.translate([w,w,0])
            );


    rodHi = rect.extrude({offset: [0,0,rodHi_z], twistangle: 0});
    rodHi = rotate([0,0,-30],rodHi);
    rodHi = rodHi.translate([0,0,rod_z-rodHi_z]);
    model.push(rodHi);
    rod   = rect.extrude({offset: [0,0,rodLo_z], twistangle: -30, twiststeps: 100});


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

