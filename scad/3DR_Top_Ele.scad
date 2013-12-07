
module tori(){
	translate([46,-89.5,0])rotate(30) import("stl/3DR_Top_Ele.stl");
}
//tori();
include <3DRaux.scad>
//Uncomment
//top_ele();

module top(){
	difference(){
		linear_extrude(height=hTop)auxbase();
		translate([tTop,0,tTop-3])
			linear_extrude(height=hTop+sol)auxbase(tTop);
	}	
}
module card_h(){	
	lEy=2*(sumY(vL,vAn,2)-tTop)-tTop/sqrt(2);
	lE=[0,lEy,lCov/2,lEy+lCov/2];
	aE=[0,270,330,90];
	points=[sumP(lE,aE,0),sumP(lE,aE,1),sumP(lE,aE,2),sumP(lE,aE,3)];
	translate([sumP(vL,vAn,2)[0]-tTop/3,sumP(vL,vAn,2)[1]-tTop*sqrt(2),0]){
		polygon(points=points);
		//color("red") testPoints(lE,aE);
	}
}
module cylh(re=4,ri=1.5,h=hT){
	difference(){
		cylinder(r=re,h=h);
		translate([0,0,-sol]) cylinder(r=ri,h=h+2*sol);
	}
}
module card_guide(vLEle=vLRamps,re=4,ri=1.5,h=hT){
	//Tarjeta en un lateral,girada 30.Mas limpio,pero no cabe la rumba
	/*translate([vgx,0,0]) for(i=[0:2])
			rotate(120*i+30) translate([0,lCov/2-2*tTop,0]){*/
	translate([vgx,0,0]) for(i=[0:2]) rotate(120*i) {
		translate([vLEle[0][0],vLRamps[0][1],0])
			cylh(re=re,ri=ri,h=h);
		translate([vLEle[1][0],vLRamps[1][1],0])
			cylh(re=re,ri=ri,h=h);
		translate([vLEle[2][0],vLRamps[2][1],0])
			cylh(re=re,ri=ri,h=h);
		translate([vLEle[3][0],vLRamps[3][1],0])
			cylh(re=re,ri=ri,h=h);
			}	
}

module card_sup(vLEle=vLRamps,re=4,ri=1.5,h=hT){	
	intersection(){
		linear_extrude(height=hTop)auxbase();
		if(elec_ty=="RAMPS")card_guide(vLEle=vLRamps,re=4,ri=1.5,h=h);
	}
}

/*Modulo para dimensiones de RAMPS y sus agujeros.
module car_t(){
vLEle=[[13.97-108/2,2.54-53/2],[96.52-108/2,2.54-53/2],
			[15.24-108/2,50.8-53/2],[90.17-108/2,50.8-53/2]];

	difference(){
		cube([128,53,2],center=true);
		translate([vLEle[0][0],vLEle[0][1],0])
			cylinder(r=1.5,h=10,$fn=3);
		translate([vLEle[1][0],vLEle[1][1],0])
			cylinder(r=1.5,h=10,$fn=3);
		translate([vLEle[2][0],vLEle[2][1],0])
			cylinder(r=1.5,h=10,$fn=3);
		translate([vLEle[3][0],vLEle[3][1],0])
			cylinder(r=1.5,h=10,$fn=3);
	}
}*/
itr=0; //Rotacion de la RAMPS para comprobar agujeros
//%translate([vgx-vtr*cos(itr*120),-vtr*sin(itr*120),hT]) rotate(120*itr)car_t();
//El otro metodo de card guide,tarjeta en el lateral
//%translate([vgx,0,hT]) rotate(120*2+30) translate([0,lCov/2-2*tTop,0])car_t();

vLT=[tTop,dSlot,2.5,5,32.5];
module tslot_guide(){
	xts=dSlot+tTop+7;
	yts=2*dSlot;	
	intersection(){
		translate([0,-yts,0])
			cube([sumV(v=vLT,i=3),4*dSlot,hTop]);
		linear_extrude(height=hTop+sol)auxbase();
	}	
	translate([sumV(v=vLT,i=3),dBea-6,0])
		cube([tTop,12,hTop]);
	translate([sumV(v=vLT,i=3),-dBea-6,0])
		cube([tTop,12,hTop]);
	translate([sumV(v=vLT,i=3),-15,0])
		cube([vLT[4],30,tTop+1]);
	translate([sumV(v=vLT,i=4),-3,0])
		cube([sumX(vL,vAn,4)-sumV(v=vLT,i=4)-sol,6,tTop+1]);
}
module tslo_h(){
	if(slot_ty=="tslot"){
		difference(){	
			linear_extrude(height=hTop+3) ts20(v=[1,3]);
			translate([0,dSlot/2-3,-sol]) cube([6,6,hTop-15]);
			/*translate([dSlot/2,dSlot/2,0])
				linear_extrude(height=hTop-8) ts204();*/
		}
	}
}

module endstop_sup(){
//TODO
}

module top_ele_nh(){
	top();
	tslot_guide();
	card_sup(vLEle=vLRamps,re=4,ri=1.5,h=hT-sol);
}
module top_ele(){
	difference(){
		top_ele_nh();
		auxHole(num=2,tra=rCov/4,ra=2,hh=hTopHol);
		auxHole(num=2,tra=rCov/2,ra=8,hh=hT);
		auxHole(num=2,tra=3*rCov/4,ra=2,hh=hTopHol);
		auxHole(num=3,tra=lBos/4,ra=2,hh=hTopHol);
		auxHole(num=6,tra=rCov/4,ra=2,hh=hTopHol);
		auxHole(num=6,tra=3*rCov/4,ra=2,hh=hTopHol);
		auxHole(num=6,tra=rCov/2,ra=8,hh=hT);
		translate([0,0,hT]) linear_extrude(height=hTop-hT+2*sol) card_h();
		translate([-sol,0,9]) rotate([0,90,0]) 
			cylinder(r=2.5,h=tTop+2*sol);		
		translate([tTop,-10,-2*sol]) tslo_h();
		translate([sumV(v=vLT,i=2),-dBea,-sol])
			cylinder(r=rRod,h=hTop+2*sol);
		translate([sumV(v=vLT,i=2),dBea,-sol])
			cylinder(r=rRod,h=hTop+2*sol);
		translate([sumV(v=vLT,i=2),-10,-2*sol])
			cube([16.5,20,hTop+4*sol]);
		translate([sumV(v=vLT,i=3)+tTop+sol,-dBea,hTop/2])
			rotate([0,-90,0])cylinder(r=2,h=tTop+rRod+2*sol);
		translate([sumV(v=vLT,i=3)+tTop+sol,dBea,hTop/2])
			rotate([0,-90,0])cylinder(r=2,h=tTop+rRod+2*sol);
		translate([sumV(v=vLT,i=2)+tTop+sol,-dBea-7/2,hTop/2-7])
			cube([4,7,hTop]);
		translate([sumV(v=vLT,i=2)+tTop+sol,dBea-7/2,hTop/2-7])
			cube([4,7,hTop]);
	}
}


module cTop(){
	//color("green")
	 translate([-132.53*0,0,0]) top_ele();
	//color("white")
	 translate([vx,-vy,0]) rotate(120) top_ele();
	//color("red")
	 translate([vx,vy,0]) rotate(-120) top_ele();
}
//cTop();
//translate([vgx,0,0])top_bos();
