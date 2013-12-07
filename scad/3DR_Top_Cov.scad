module cori(){
	translate([103,26.5,0])
	rotate(150) import("stl/3DR_Top_Cov.stl");
}
//cori();
include <3DRAux.scad>


//Uncomment
//top_cov();

module top_cov_b(){
	difference(){
		linear_extrude(height=hTCov)auxbase();
		translate([tTCov,0,tTCov])
			linear_extrude(height=hTCov+sol)auxbase(tTCov);
		translate([vgx,0,-4*sol])
			cylinder(r=vgx-41,h=hTCov+8*sol);
	}
	intersection(){
		linear_extrude(height=hTCov)auxbase();
		difference(){
			translate([vgx,0,0])
				cylinder(r=vgx-41,h=hTCov);
			translate([vgx,0,-4*sol])
				cylinder(r=vgx-41-tTCov,h=hTCov+8*sol);
		}
	}	
}
module tcslot_guide(){
	intersection(){
		translate([0,-2*dSlot,0])
			cube([dSlot,4*dSlot,hTCov]);
		linear_extrude(height=hTCov+sol)auxbase();
	}	

}
module tcslo_h(e=kSlot){
	if(slot_ty=="tslot"){
		difference(){	
			linear_extrude(height=hTCov+4) ts20(v=[2,3],e=e);
			//%translate([0,dSlot/2-3+e/2,-sol]) cube([6-e,6-e,hBas-32]);
		translate([dSlot/2,dSlot/2+e*2,0])
				rotate([0,0,90])linear_extrude(height=tTCov+1) ts204(e);			
		}
	}
}


module tcrod_guide(){
	intersection(){
		linear_extrude(height=hTCov)auxbase();
		translate([4*dSlot/5,dBea-tTCov,0])
			cylinder(r=12,h=2*hTCov);
	}
}
module top_cov_nh(){
	top_cov_b();
	tcslot_guide();
	tcrod_guide();
	mirror([0,1,0]) tcrod_guide();
}
module top_cov(){
	difference(){
		top_cov_nh();
		translate([tTCov,-dSlot/2,tTCov])
			tcslo_h();
		translate([tTCov+dSlot,-dBea+tTCov,tTCov])
			cylinder(r=rRod,h=hTCov);
		translate([tTCov+dSlot,dBea-tTCov,tTCov])
			cylinder(r=rRod,h=hTCov);
		//Por parametrizar
		translate([-1.5*tTCov+dSlot-5,dBea-12-3,2*tTCov+1-sol])
			cube([18,6,30]);
	}
}
