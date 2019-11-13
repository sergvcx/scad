
include <../lib/mylib.scad>
include <../lib/tubes.scad>
//     | |
//     | |
//     / / r1
//    / /
//   / /
//   | |
//   | | r0

r0 = 25;
r1 = 15;
w  = 3;
tube_int(5,r0,r0,w);
translate([0,0,5]) tube_int(10,r0,r1,w);
translate([0,0,15]) tube_int(15,r1,r1,w);
