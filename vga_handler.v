module vga_handler(
	input clk, reset,
	input [1:0] game_state,
	input [29:0] word,
	input [25:0] mask,
	input [3:0] wrong_time,

	output VGA_CLK, VGA_HS, VGA_VS, VGA_BLANK_N, VGA_SYNC_N,
	output [9:0] VGA_R,	VGA_G, VGA_B
);

	reg [2:0] colour, colour_in;
	reg [8:0] x, x_in, x_tmp, position_x;
	reg [7:0] y, y_in, y_tmp, position_y;
	reg [5:0] position;
	reg [5:0] letter;
	wire [63:0] letter_writeEn;
	reg writeEn;

	vga_adapter VGA(
		.resetn(~reset),
		.clock(clk),
		.colour(colour_in),
		.x(x_in),
		.y(y_in),
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
		.address(letter[5:0]),
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
	
	always @(*) begin
		case (game_state)
			START: begin
				colour = 3'b000;
				letter = 6'd35;
				position = 6'd0;
			end
			INGAME: begin
				colour = 3'b111;
				letter = 6'd35;
				position = 6'd0;

				// First letter
				if ((x >= 9'd25) && (x <= 9'd32)) begin
					// Letter
					if ((y >= 8'd190) && (y <= 8'd197)) begin
						letter = {1'b0, word[29:25]} - 6'd1;
						if (mask[letter[5:0]]) begin
							position_x = x - 9'd25;
							position_y = 8'd197 - y;
							position = {position_y[2:0], position_x[2:0]};
						end else
							letter = 6'd35;
					end
					// Dash
					if ((y >= 8'd200) && (y <= 8'd207)) begin
						letter = 6'd26;
						position_x = x - 9'd25;
						position_y = 8'd207 - y;
						position = {position_y[2:0], position_x[2:0]};

					end
				end

				// Second letter
				if ((x >= 9'd65) && (x <= 9'd72)) begin
					// Letter
					if ((y >= 8'd190) && (y <= 8'd197)) begin
						letter = {1'b0, word[24:20]} - 6'd1;
						if (mask[letter[5:0]]) begin
							position_x = x - 9'd65;
							position_y = 8'd197 - y;
							position = {position_y[2:0], position_x[2:0]};
						end else
							letter = 6'd35;
					end
					// Dash
					if ((y >= 8'd200) && (y <= 8'd207)) begin
						letter = 6'd26;
						position_x = x - 9'd65;
						position_y = 8'd207 - y;
						position = {position_y[2:0], position_x[2:0]};
					end
				end

				// Third letter
				if ((x >= 9'd105) && (x <= 9'd112)) begin
					// Letter
					if ((y >= 8'd190) && (y <= 8'd197)) begin
						letter = {1'b0, word[19:15]} - 6'd1;
						if (mask[letter[5:0]]) begin
							position_x = x - 9'd105;
							position_y = 8'd197 - y;
							position = {position_y[2:0], position_x[2:0]};
						end else
							letter = 6'd35;
					end
					// Dash
					if ((y >= 8'd200) && (y <= 8'd207)) begin
						letter = 6'd26;
						position_x = x - 9'd105;
						position_y = 8'd207 - y;
						position = {position_y[2:0], position_x[2:0]};
					end
				end

				// Forth letter
				if ((x >= 9'd145) && (x <= 9'd152)) begin
					// Letter
					if ((y >= 8'd190) && (y <= 8'd197)) begin
						letter = {1'b0, word[14:10]} - 6'd1;
						if (mask[letter[5:0]]) begin
							position_x = x - 9'd145;
							position_y = 8'd197 - y;
							position = {position_y[2:0], position_x[2:0]};
						end else
							letter = 6'd35;
					end
					// Dash
					if ((y >= 8'd200) && (y <= 8'd207)) begin
						letter = 6'd26;
						position_x = x - 9'd145;
						position_y = 8'd207 - y;
						position = {position_y[2:0], position_x[2:0]};
					end
				end

				// Fifth letter
				if ((x >= 9'd185) && (x <= 9'd192)) begin
					// Letter
					if ((y >= 8'd190) && (y <= 8'd197)) begin
						letter = {1'b0, word[9:5]} - 6'd1;
						if (mask[letter[5:0]]) begin
							position_x = x - 9'd185;
							position_y = 8'd197 - y;
							position = {position_y[2:0], position_x[2:0]};
						end else
							letter = 6'd35;
					end
					// Dash
					if ((y >= 8'd200) && (y <= 8'd207)) begin
						letter = 6'd26;
						position_x = x - 9'd185;
						position_y = 8'd207 - y;
						position = {position_y[2:0], position_x[2:0]};
					end
				end

				// Sixth letter
				if ((x >= 9'd225) && (x <= 9'd232)) begin
					// Letter
					if ((y >= 8'd190) && (y <= 8'd197)) begin
						letter = {1'b0, word[4:0]} - 6'd1;
						if (mask[letter[5:0]]) begin
							position_x = x - 9'd225;
							position_y = 8'd197 - y;
							position = {position_y[2:0], position_x[2:0]};
						end else
							letter = 6'd35;
					end
					// Dash
					if ((y >= 8'd200) && (y <= 8'd207)) begin
						letter = 6'd26;
						position_x = x - 9'd225;
						position_y = 8'd207 - y;
						position = {position_y[2:0], position_x[2:0]};
					end
				end

				// The poor man
				if ((x >= 9'd140) && (x <= 9'd147)) begin
					// Head
					if ((y >= 8'd92) && (y <= 8'd99)) begin
						letter = 6'd29;
						position_x = x - 9'd140;
						position_y = 8'd99 - y;
						position = {position_y[2:0], position_x[2:0]};
					end
					// Body
					if ((y >= 8'd100) && (y <= 8'd107)) begin
						letter = 6'd30 + {2'b00, wrong_time[3:0]};
						position_x = x - 9'd140;
						position_y = 8'd107 - y;
						position = {position_y[2:0], position_x[2:0]};
					end
				end
						
			end
		endcase
	end

	always @(posedge clk) begin
		if (reset) begin
			x_in <= 9'b0;
			x_tmp <= 9'b0;
			y_in <= 8'b0;
			y_tmp <= 9'b0;
			colour_in <= 3'b000;
			writeEn <= 1'b1;
		end
		else begin
			x_tmp <= x;
			y_tmp <= y;
			x_in <= x_tmp;
			y_in <= y_tmp;
			writeEn <= 1'b1;
			if (letter < 6'd35)
				colour_in <= (letter_writeEn[position]) ? 3'b111 : 3'b000;
			else
				colour_in <= 3'b000;
		end
	end

endmodule