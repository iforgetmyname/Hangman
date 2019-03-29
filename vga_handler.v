module vga_handler(
	input clk, reset,
	input [1:0] game_state,
	input [29:0] word,
	input [25:0] mask,

	output VGA_CLK, VGA_HS, VGA_VS, VGA_BLANK_N, VGA_SYNC_N,
	output [9:0] VGA_R,	VGA_G, VGA_B
);

	reg [2:0] colour;
	reg [8:0] x, position_x;
	reg [7:0] y, position_y;
	reg [5:0] position;
	reg [4:0] letter;
	wire [63:0] letter_writeEn;
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

	letter_ram lr0(
		.address(letter[4:0]),
		.clock(clk),
		.data(64'b0),
		.wren(1'b0),
		.q(letter_writeEn[63:0])
	);

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
	
	always @(posedge clk) begin
		case (game_state)
			START: begin
				colour <= 3'b000;
				writeEn <= 1'b1;
			end
			INGAME: begin
				colour <= 3'b111;
				writeEn <= 1'b0;

				// First letter
				if ((x >= 9'd20) && (x <= 9'd27)) begin
					if ((y >= 8'd20) && (y <= 8'd27)) begin
						letter <= 5'd26;
						position_x <= x - 9'd20;
						position_y <= y - 8'd20;
						position <= {position_y[2:0], position_x[2:0]};
						writeEn <= (letter_writeEn[position]);
					end
				end

				// Second letter
				if ((x >= 9'd50) && (x <= 9'd57)) begin

					// Dash
					if ((y >= 8'd50) && (y <= 8'd57)) begin
						letter <= 5'd26;
						position_x <= x - 9'd50;
						position_y <= y - 8'd50;
						position <= {position_y[2:0], position_x[2:0]};
						writeEn <= (letter_writeEn[position]);
					end
				end

				// Third letter
				if ((x >= 9'd80) && (x <= 9'd87)) begin

					// Dash
					if ((y >= 8'd80) && (y <= 8'd87)) begin
						letter <= 5'd26;
						position_x <= x - 9'd80;
						position_y <= y - 8'd80;
						position <= {position_y[2:0], position_x[2:0]};
						writeEn <= (letter_writeEn[position]);
					end
				end

				// Forth letter
				if ((x >= 9'd100) && (x <= 9'd107)) begin

					// Dash
					if ((y >= 8'd100) && (y <= 8'd107)) begin
						letter <= 5'd26;
						position_x <= x - 9'd100;
						position_y <= y - 8'd100;
						position <= {position_y[2:0], position_x[2:0]};
						writeEn <= (letter_writeEn[position]);
					end
				end

				// Fifth letter
				if ((x >= 9'd130) && (x <= 9'd137)) begin

					// Dash
					if ((y >= 8'd130) && (y <= 8'd137)) begin
						letter <= 5'd26;
						position_x <= x - 9'd130;
						position_y <= y - 8'd130;
						position <= {position_y[2:0], position_x[2:0]};
						writeEn <= (letter_writeEn[position]);
					end
				end

				// Sixth letter
				if ((x >= 9'd160) && (x <= 9'd167)) begin

					// Dash
					if ((y >= 8'd160) && (y <= 8'd167)) begin
						letter <= 5'd26;
						position_x <= x - 9'd160;
						position_y <= y - 8'd160;
						position <= {position_y[2:0], position_x[2:0]};
						writeEn <= (letter_writeEn[position]);
					end
				end
			end
			WINGAME: writeEn <= 1'b0;
			LOSTGAME: writeEn <= 1'b0;
			default: begin
				colour <= 3'b000;
				letter <= 5'd27;
				position_x <= 9'd0;
				position_y <= 8'd0;
				position <= 6'd0;
				writeEn <= 1'b0;
			end
		endcase
	end

endmodule