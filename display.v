module display(
    input clk, reset,
	input [3:0] state);
    
    localparam START	= 2'd0,
			   INGAME	= 2'd1,
			   WINGAME	= 2'd2,
			   LOSTGAME	= 2'd3;
	
	always @(*) begin
		case (state) begin
			START: clear(1);
	
	task clear;
		input reg clear;
		reg [8:0] x;
		reg [7:0] y;
		always @(posedge clk) begin
			if (clear) begin
				clear <= 1'b0;
				x <= 9'b0;
				y <= 8'b0;
			end
			else if (hc < hpixels - 1)
			hc <= hc + 1;
		else
		begin
			hc <= 0;
			if (vc < vlines - 1)
				vc <= vc + 1;
			else
				vc <= 0;
		end
endmodule
