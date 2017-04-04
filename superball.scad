

module pin(x0,y0,z0, x1,y1,z1,pinr)
{
    len=sqrt((x1-x0)*(x1-x0)+(y1-y0)*(y1-y0)+(z1-z0)*(z1-z0));
    ro=atan2(y1-y0,x1-x0);
    r = sqrt((x1-x0)*(x1-x0)+(y1-y0)*(y1-y0));
    phi=atan2(z1-z0,r);
    translate([x0,y0,z0]) rotate([0,90-phi,ro]) cylinder(len,pinr,pinr);
    //translate([x0,y0,z0]) sphere(pinr);
    //translate([x1,y1,z1]) sphere(pinr);
    //translate([x0,y0,z0]) rotate([0,-phi,ro]) translate([len/2,0,0]) cube([len,2,2],true);
}



///function sign(arg,n) = (n%1 )

module ball0(r,n,pinr)
{
    Ro =rands(0,45,n);
    Fi =rands(-90,90,n);
    sinFi =rands(-1,1,n);
    for(i=[2:1:n-1]){
        Fi=asin(sinFi[i]);
        r0= r*cos(Fi[i-1]);
        x0=r0*cos(Ro[i-1]);
        y0=r0*sin(Ro[i-1]);
        z0= r*sin(Fi[i-1]);
        
        r1= r*cos(Fi[i]);
        x1=r1*cos(Ro[i]);
        y1=r1*sin(Ro[i]);
        z1= r*sin(Fi[i]);
        //pin(x0,y0,z0,x1,y1,z1);
        pin(x0,y0,z0,x1,y1,z1,pinr);
        
       // echo(x0,x1);
        
        //y0=y1;
        //z0=z1;
    }
}
module ball(r,n,pinr)
{
    Ro =rands(0,360,n);
    Fi =rands(-90,90,n);
    sinFi =rands(-1,1,n);
    for(i=[2:1:n-1]){
        Fi0=asin(sinFi[i-1]);
        Fi1=asin(sinFi[i]);
        r0= r*cos(Fi0);
        x0=r0*cos(Ro[i-1]);
        y0=r0*sin(Ro[i-1]);
        z0= r*sin(Fi0);
        
        r1= r*cos(Fi1);
        x1=r1*cos(Ro[i]);
        y1=r1*sin(Ro[i]);
        z1= r*sin(Fi1);
        //pin(x0,y0,z0,x1,y1,z1);
        pin(x0,y0,z0,x1,y1,z1,pinr);
        
       // echo(x0,x1);
        
        //y0=y1;
        //z0=z1;
    }
}


module sky(r,n,pinr)
{
    Ro =rands(0,360,n);
    sinFi =rands(-1,1,n);
    for(i=[2:1:n-1]){
        Fi0=asin(sinFi[i-1]);
        r0= r*cos(Fi0);
        x0=r0*cos(Ro[i-1]);
        y0=r0*sin(Ro[i-1]);
        z0= r*sin(Fi0);
        translate([x0,y0,z0]) sphere(pinr);
    }
}

module H(x,y,dx,dy)
{
    H=30;
    for(i=[0:0.2:1]){
        pin(0,0,0,x,y+i*dy,H);    
    }
    for(i=[0:0.2:1]){
        pin(0,0,0,x+dx,y+i*dy,H);    
    }
   
    for(i=[0:0.2:1]){
        pin(0,0,0,x+i*dx,y+dy/2,H);    
    }
}

module A(x,y,dx,dy)
{
    H=30;
    for(i=[0:0.2:1]){
        pin(0,0,0,x+i/2*dx,y+i*dy,H);    
    }
    for(i=[0:0.2:1]){
        pin(0,0,0,x-i/2*dx+dx,y+i*dy,H);    
    }
   
    for(i=[dx*1/4:2:dx*3/4]){
        pin(0,0,0,x+i,y+dy*2/5,H);    
    }
}

module D(x,y,dx,dy)
{
    
    H=30;
    for(i=[1/6:0.2:1]){
        pin(0,0,0,x+dx/6,y+i*dy,H);    
        pin(0,0,0,x+dx*5/6,y+i*dy,H);    
    }
    for(i=[0:2:dy/6]){
        pin(0,0,0,x,y+i,H);    
        pin(0,0,0,x+dx,y+i,H);    
    }
   
    for(i=[0:0.2:1]){
       pin(0,0,0,x+i*dx,y+dy/6,H);    
    }
    
    for(i=[1/6:0.2:1*5/6]){
       pin(0,0,0,x+i*dx,y+dy,H);    
    }
    
}

module Y(x,y,dx,dy)
{
    
    H=30;
    for(i=[0:0.2:1]){
        pin(0,0,0,x+dx,y+i*dy,H);    
    }
    for(i=[1/2:0.2:1]){
        pin(0,0,0,x,y+i*dy,H);    
    }    
    for(i=[0:0.2:1]){
        pin(0,0,0,x+i*dx,y+dy,H);    
        pin(0,0,0,x+i*dx,y+dy/2,H);    
    }
    for(i=[0:0.2:1]){
        pin(0,0,0,x+i*dx,y+i*dy/2,H);    
    }
   
    
}



module text()
{
    
    
    
   
}
difference()
{
translate([-20,-8,0]) cube([40,16,15]);
z=5;    
H(z-40,-10,10,20);
A(z-20,-10,12,20);
D(z+0,-10,12,20);
#Y(z+ 20,-10,10,20);
}

text();
difference(){
   // ball(30,300,1);
//sky(10,10000,0.1);
   // pin(0,0,-50,0,0,50,1);
}

