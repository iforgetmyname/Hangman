module vga(
	input clk, reset,
	input [3:0] state,

	output VGA_CLK, VGA_HS, VGA_VS, VGA_BLANK_N, VGA_SYNC_N,
	output [9:0] VGA_R,	VGA_G, VGA_B);
	
	reg [2:0] colour;
	reg [8:0] x;
	reg [7:0] y;
	reg writeEn;

	vga_adapter VGA(
		.resetn(~reset),
		.clock(clk),
		.colour(colour),
		.x(x),
		.y(y),
		.plot(writeEn),

		.VGA_R(VGA_R),
		.VGA_G(VGA_G),
		.VGA_B(VGA_B),
		.VGA_HS(VGA_HS),
		.VGA_VS(VGA_VS),
		.VGA_BLANK(VGA_BLANK_N),
		.VGA_SYNC(VGA_SYNC_N),
		.VGA_CLK(VGA_CLK));
	defparam VGA.RESOLUTION = "320x240";
	defparam VGA.MONOCHROME = "FALSE";
	defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
	defparam VGA.BACKGROUND_IMAGE = "init_vga.mif";

	always @(posedge clk) begin
		if (reset) begin
			x <= 9'b0;
			y <= 8'b0;
		end
		else begin
			if (x < 9'd319) 
				x <= x + 1'b1;
			else begin
				x <= 9'b0;
				if (y < 8'd239)
					y <= y + 1'b1;
				else
					y <= 8'b0;
			end
		end
	end

    localparam START	= 2'd0,
			   INGAME	= 2'd1,
			   WINGAME	= 2'd2,
			   LOSTGAME	= 2'd3;
	
	always @(*) begin
		case (state)
			START: begin
				colour = 3'b000;
				writeEn = 1'b1;
			end
			INGAME: begin
				colour = 3'b111;
				writeEn = 1'b1;
			end
			WINGAME: writeEn = 1'b0;
			LOSTGAME: writeEn = 1'b0;
			default: begin
				colour = 3'b000;
				writeEn = 1'b0;
			end
		endcase
	end

endmodule