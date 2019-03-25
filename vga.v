module vga(
		input clk, reset,
		input [3:0] state,
		
		output VGA_CLK, VGA_HS, VGA_VS, VGA_BLANK_N, VGA_SYNC_N,
		output [9:0] VGA_R, VGA_G, VGA_B);

	// Create the colour, x, y and writeEn wires that are inputs to the controller.
	reg [2:0] colour;
	reg [8:0] x;
	reg [7:0] y;
	reg writeEn;

	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(reset),
			.clock(clk),
			.colour(colour),
			.x(x),
			.y(y),
			.plot(writeEn),
			/* Signals for the DAC to drive the monitor. */
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
		defparam VGA.BACKGROUND_IMAGE = "init_vag.mif";
			
	// Put your code here. Your code should produce signals x,y,colour and writeEn/plot
	// for the VGA controller, in addition to any other functionality your design may require.

	always @(posedge clk) begin
		if (reset) begin
			x <= 9'b0;
			y <= 8'b0;
		end
		else begin
			if (x < 319) 
				x <= x + 1;
			else begin
				x <= 0;
				if (y < 239)
					y <= y + 1;
				else
					y <= 0;
			end
		end
	end

    localparam START	= 2'd0,
			   INGAME	= 2'd1,
			   WINGAME	= 2'd2,
			   LOSTGAME	= 2'd3;
	
	always @(*) begin
		case (state) begin
			START: begin
				colour <= 3'b000;
				writeEn <= 1'b1;
			end
			INGAME: begin
			end
			WINGAME:
			LOSTGAME:
		end
	end

endmodule
