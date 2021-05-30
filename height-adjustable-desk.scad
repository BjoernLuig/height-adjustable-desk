//Schreibtischmodel

module schreibtisch(hub = 100) {

//Masse aus dem Baumarkt
stange = [45, 45, 2500];
brett = [200, 1200, 18];

//andere Masse
tp = [750, 1550, 30];					//Tischplatte
h = 800;								//Gesamthoehe
a = stange[0];							//Leistenbreite
d = 8;									//Durchmesser (Loecher)
u = [600, 1200, a];						//U (Rahmen oben und unten)
ec = [2 * a, brett[2], 2 * a];			//Ecke
ak = [75, 40, 550];						//Aktor
mt = [53, 26, 38.5];					//Metallteil
sc = [36, 12.7, 500 ];					//Schiene
bl = [brett[0], a, a];					//Block
ab = [									//Abdeckung
	brett[0],
	brett[2],
	h - (tp[2] + 2 * a) - 5
];

module Tischplatte() {
	color("BurlyWood") cube(tp);
}

module Winkel() {
	module Platte() {
		difference() {
			color("Silver") cube([a, a, 1]);
			color("Black") translate([0, 0, -1]){
				translate([a / 3, a / 3, 0]) cylinder(7, d = d);
				translate([a / 3, 2 * a / 3]) cylinder(7, d = d);
				translate([2 * a / 3, a / 3]) cylinder(7, d = d);
				translate([2 * a / 3, 2 * a / 3]) cylinder(7, d = d);
			}
		}
	}
	Platte();
	mirror([1, 0, -1]) Platte();
}

module U() {
	translate([(tp[0] - u[0]) / 2, (tp[1] - u[1]) / 2, 0]){
		color("BurlyWood") {
			cube([u[0], a, a]);
			translate([0, a, 0])
			cube([a, u[1] - a, a]);
			translate([0, u[1] - a, 0])
			cube([u[0], a, a]);
		}
		translate([a, a, a]) rotate([-90, 0, 0]) Winkel();
		translate([a, u[1] - a, 0]) rotate([90, 0, 0]) Winkel();
	}
}

module Aktor() {
	//Innen
	difference() {
		color("Silver")
		translate([0, 0, -8])
		cylinder(ak[2] + 8 + 9 + hub, d = 20);
		color("Black")
		union() {
			rotate([90, 0, 0])
			cylinder(20, d = 6.5, center = true);
			translate([0, 0, 550 + hub])
			rotate([90, 0, 0])
			cylinder(20, d = 6.5, center = true);
		}
	}
	//Aussen
	color("Silver")
	translate([0, 0, 36])
	cylinder(500, d = 35);
	//Block
	color("Gray")
	translate([17.5, -ak[1] / 2, 11])
	union() {
		translate([-ak[1] / 2, ak[1] / 2, 0])
		cylinder(25, d = ak[1]);
		translate([-ak[0] + ak[1] / 2, 0, 0])
		cube([ak[0] -ak[1], ak[1], 25]);
		translate([-ak[0] + ak[1] / 2, ak[1] / 2, 0])
		cylinder(25, d = ak[1]);
		}
	//Motor
	color("Silver")
	translate([17.5 - 75 + 19, 0, 36])
	cylinder(77, d = 38);
}

module Metallteil() {
	color("Silver")
	translate([8 - mt[0], mt[1] / 2, 0])
	rotate([90, 0, 0])
	difference() {
		linear_extrude(height = mt[1]) {
			union() {
				polygon([
					[0, 0],
					[mt[0], 0],
					[mt[0], mt[2]],
					[mt[0] - 8, mt[2]],
					[40, 44.7],
					[0, 11]
				]);
				translate([mt[0] - 8, mt[2], 0]) circle(d = 16);
			}
		}
		translate([-1, 3, 3])
		cube([mt[0] + 2, 45, mt[1] - 6]);
		translate([mt[0] - 8, mt[2], -1])
		cylinder(28, d = 6.5);
	}
}

module Schiene() {
	color("DarkSlateGray")
	cube(sc);
	color("SlateGray")
	translate([0, 0, sc[2]])
	cube([sc[0], sc[1], hub + 50]);
}

module Zwischenraum() {
	color("Cornsilk") cube([ab[0], sc[1], a]);
}

module Stuetze() {
	color("BurlyWood") cube(bl);
	//Motorik
	translate([ak[0] - 17.5 + 5, a / 2, bl[2]]) Metallteil();
	translate([ak[0] - 17.5 + 5, a / 2, h - (tp[2] + 2 * a) + hub])
		rotate([180, 0, 0]) Metallteil();
	translate([ak[0] - 17.5 + 5, a / 2, bl[2] + mt[2]]) Aktor();
	//Stuetze
	color("BurlyWood")
		translate([ab[0] - 2*a - sc[1],0, bl[2] + hub])
			cube([a, a, h - (tp[2] + bl[2] + 2 * a)]);
	translate([ab[0] - sc[1] - a, a, hub + h - (tp[2] + 2 * a)])
		rotate([180, 0, 0]) Winkel();
	//Schienen
	translate([ab[0] - (a + sc[0]) / 2 - sc[1] - a, -sc[1], bl[2]]) Schiene();
	translate([ab[0] - (a + sc[0]) / 2 - sc[1] - a, a, bl[2]]) Schiene();
	//Zwischenraum
	translate([0, -sc[1], -a]) Zwischenraum();
	translate([0, a, -a]) Zwischenraum();
	translate([0, -sc[1], 0]) Zwischenraum();
	translate([0, a, 0]) Zwischenraum();
	//Abdeckungen
	translate([0, -sc[1] - ab[1], - a]) color("BurlyWood") cube(ab);
	translate([0, a + sc[1], - a]) color("BurlyWood") cube(ab);
	translate([ab[0] -a, -sc[1], a])
		color("BurlyWood")
			cube([ab[1], a + 2 * sc[1], ab[2] - 3*a]);
	translate([-ab[1], -sc[1] - ab[1], ab[2]/2])
		color("BurlyWood") cube([ab[1], a + 2 * (ab[1] + sc[1]), 2 * a]);
}



//Anweisungen
translate([0, 0, 0]) U();
translate([0, tp[1], h - tp[2] + hub]) rotate([180, 0, 0]) U();
translate([tp[0] / 3 - ak[0], (tp[1] - u[1]) / 2, a]) Stuetze();
translate([tp[0] / 3 - ak[0], (tp[1] + u[1]) / 2  - a, a]) Stuetze();
translate([0, 0, h - tp[2] + hub]) Tischplatte();
}

translate([0, -1000, 0]) schreibtisch();






