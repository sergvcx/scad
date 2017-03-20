

module pin(x0,y0,z0, x1,y1,z1,pinr)
{
    len=sqrt((x1-x0)*(x1-x0)+(y1-y0)*(y1-y0)+(z1-z0)*(z1-z0));
    ro=atan2(y1-y0,x1-x0);
    r = sqrt((x1-x0)*(x1-x0)+(y1-y0)*(y1-y0));
    phi=atan2(z1-z0,r);
    translate([x0,y0,z0]) rotate([0,90-phi,ro]) cylinder(len,pinr,pinr);
    translate([x0,y0,z0]) sphere(pinr);
    translate([x1,y1,z1]) sphere(pinr);
    //translate([x0,y0,z0]) rotate([0,-phi,ro]) translate([len/2,0,0]) cube([len,3,3],true);
}

pin(0,0,-10,10,10,20);

module ball(r,n,pinr)
{
    Ro =rands(0,360,n);
    Fi=rands(-90,90,n);
    for(i=[2:1:n-1]){
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
ball(30,300,1);
