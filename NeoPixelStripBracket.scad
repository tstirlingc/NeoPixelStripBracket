// 2015-09-12 Todd S. Coffey
// Bracket for mounting a neopixel strip under a cabinet. 
// 
// My Dotstar 60 pixel/meter strips have the following 
// approximate dimensions as measured with a caliper:
// width = 14.25mm
// height = 4.30mm

// All numbers below are in units of mm.

// I printed this with a PrintrBot Simple Metal in Cura
// 0.3mm layer height, 0.4mm shell thickness, 100% fill,
// and rotated on its side so no support is needed.

insideX = 15;  // 15
insideY = 15;  // 148 will fit on PrintrBot
insideZ = 4.75;  // 4.75
backThickness = 1.5;  // 2
sideThickness = 0.5; // 0.5
topThickness = 0.5; // 0.5

gapX = insideX-2.5;
screwHoles = 1; // number of screw holes
screwHoleD= 2; // 2
screwHeadZ = 2.5; // 2.5
screwHeadD = 6; // 6

sideSupportX = 1; // mm of wedge support on outside along rail
sideSupportZ0 = 0; 

topSupportZ = 0.5;

outsideX = insideX + 2*sideThickness;
outsideY = insideY;
outsideZ = backThickness+insideZ+topThickness+topSupportZ;
captureX = (outsideX - gapX)/2.0;

bracket();

module bracketBase() {
    cube([outsideX,outsideY,backThickness]);
    cube([sideThickness,outsideY,backThickness+insideZ+topThickness]);
    translate([outsideX-sideThickness,0,0]) { 
        cube([sideThickness,outsideY,backThickness+insideZ+topThickness]); 
        }
    translate([0,0,backThickness+insideZ]) { 
        cube([captureX,outsideY,topThickness]); 
        }
    translate([outsideX-captureX,0,backThickness+insideZ]) { 
        cube([captureX,outsideY,topThickness]); 
        }
}
module beveledHole(num) {
    for (s=[0:num-1]) {
        shiftX = outsideX/2;
        shiftY = (2*s+1)*outsideY/(2*num);
  translate([shiftX,shiftY,0]) { 
      cylinder(d=screwHoleD,h=backThickness,$fn=20); 
      }
  translate([shiftX,shiftY,backThickness-screwHeadZ]) { 
      cylinder(d1=screwHoleD,d2=screwHeadD,h=screwHeadZ,$fn=20); 
      }
  }
}
module bracket() {
    difference() {
        bracketBase();
        beveledHole(screwHoles);
    }
    supports();
       
} 
curveR = 1;
module cutoutShape() {
    intersection() {
        supportLeft();
        translate([0,0,outsideZ-curveR]) {
            cube([curveR,outsideY,curveR]);
        }
    }
}    
module smoothedEdge() {
    
}

module supports() {
  
    
//    intersection() {
//        translate([.5,0,0]) {
//            rotate(a=[270,0,0]) {
//                cylinder(r=outsideZ-0.2,h=outsideY,$fn=400);
//            }
//        }   
        supportLeft();
//    }
    supportRight();
}
module supportLeft() {
    sideSupportLeft();
    topSupportLeft();
}
module supportRight() {
    sideSupportRight();
    topSupportRight();
}
module sideSupportLeft() {
    p0 = [0,0,sideSupportZ0];
    p1 = [-sideSupportX,0,sideSupportZ0];
    p2 = [0,0,outsideZ];
    p3 = [0,outsideY,sideSupportZ0];
    p4 = [-sideSupportX,outsideY,sideSupportZ0];
    p5 = [0,outsideY,outsideZ];
    tri0 = [0,1,2];
    tri1 = [5,4,3];
    quad0 = [3,4,1,0];
    quad1 = [0,2,5,3];
    quad2 = [1,4,5,2];
    polyhedron(points=[p0,p1,p2,p3,p4,p5],faces=[tri0,tri1,quad0,quad1,quad2]);
}
module sideSupportRight() {
    translate([outsideX,0,0]) {
        mirror([1,0,0]) {
            sideSupportLeft();
        }
    }
}
module sideSupports() {
    if (sideSupportX > 0) {
        sideSupportLeft();
        sideSupportRight();
    }
}
module topSupportLeft() {
    p0 = [0,0,outsideZ-topSupportZ];
    p1 = [0,0,outsideZ];
    p2 = [captureX,0,outsideZ-topSupportZ];
    p3 = [0,outsideY,outsideZ-topSupportZ];
    p4 = [0,outsideY,outsideZ];
    p5 = [captureX,outsideY,outsideZ-topSupportZ];
    tri0 = [0,1,2];
    tri1 = [3,5,4];
    quad0 = [0,2,5,3];
    quad1 = [0,3,4,1];
    quad2 = [1,4,5,2];
    polyhedron(points=[p0,p1,p2,p3,p4,p5],faces=[tri0,tri1,quad0,quad1,quad2]);
}
module topSupportRight() {
    translate([outsideX,0,0]) {
        mirror([1,0,0]) {
            topSupportLeft();
        }
    }
}
module topSupports() {
    if (topSupportZ > 0) {
        topSupportLeft();
        topSupportRight();
    }
}

