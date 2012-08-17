module fastspk_sanger(clkOut, sysClk);
	input sysClk;
	output clkOut;

	wire clkOut, sysClk;
	wire inv1, inv2, inv3, inv4, inv5, inv6, inv7, inv8, trig;
	reg sp1, sp2;
	//synthesis attribute keep of inv1 is "true";
	//synthesis attribute keep of inv2 is "true";
	//synthesis attribute keep of inv3 is "true";
	//synthesis attribute keep of inv4 is "true";
	//synthesis attribute keep of clkOut is "true";
	//synthesis attribute keep of trig is "true";

	//make sure the oscillator is running
	reg [7:0] watchdog, spCtr, spCtrSaved;
	reg autoReset;
	always @(posedge sysClk) watchdog <= watchdog + 1;
	always @(negedge watchdog[7]) spCtrSaved <= spCtr ;
	always @(posedge watchdog[7]) autoReset <= (spCtrSaved == spCtr) ? 1 : 0;
	always @(posedge clkOut) spCtr <= spCtr + 1;

	//delayed feedback
	assign inv1 = ~clkOut;
	assign inv2 = ~inv1;
	assign inv3 = ~inv2;
	assign inv4 = ~inv3;
	assign trig = (autoReset & (watchdog[7:6] == 2'b10)) ? sysClk : inv4; //delay should be at least 2x spikewidth

	pulseToSpike pts2(clkOut, trig);  //this is just a delayed feedback loop around spike generator
			//duty cycle is determined by spike width


endmodule


//
// convert a risking edge to a quick pulse/spike
//
module pulseToSpike(spike_out, trigger_in);
	input trigger_in;
	output spike_out;

	//
	//spike generation
	//
	wire inv1, inv2;
	reg sp1, sp2;
	//synthesis attribute keep of inv1 is "true";
	//synthesis attribute keep of inv2 is "true";
	//synthesis attribute keep of sp1 is "true";
	//synthesis attribute keep of sp2 is "true";
	//synthesis attribute keep of spike_out is "true";

	assign inv1 = ~trigger_in;
	assign inv2 = ~inv1;
	always @(posedge trigger_in) sp1 <= ~sp2;  //delay sets spikewidth
	always @(posedge spike_out) sp2 <= sp1;

	assign spike_out = sp2 ^ sp1;

endmodule


module fastspk(spike_out, reset) /* synthesis syn_noprune=1 */ ;
    input   reset;
    output  spike_out;
          
    reg     t2;
    reg     t1;
    always @(negedge spike_out or posedge reset) begin
        if (reset) begin
            if (~spike_out) begin
                t1 <= ~t2;
            end
        end
        else begin
            if (~spike_out) t1 <= ~t2;
        end
    end    
        
    always @(posedge spike_out) begin
        t2 <= t1;

    end
//    wire t1 = (spike_out) ? ~t1 : t1;
//    wire t2 = (~spike_out) ? ~t2 : t2;
    
    assign    spike_out = t1 ^ t2;


endmodule

