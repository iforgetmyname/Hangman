module vga_handler(
	input clk, reset,
	input [1:0] game_state,
	input [29:0] word,
	input [25:0] mask, guessed_mask,
	input wrong,
	input [3:0] wrong_time,

	output VGA_CLK, VGA_HS, VGA_VS, VGA_BLANK_N, VGA_SYNC_N,
	output [9:0] VGA_R, VGA_G, VGA_B
);

	reg [2:0] colour, colour_in;
	reg [8:0] x, x_in, position_x;
	reg [7:0] y, y_in, position_y;
	reg [5:0] position;
	reg [5:0] letter;
	wire [63:0] letter_writeEn;
	reg writeEn, writeEn_in;

	vga_adapter VGA(
		.resetn(~reset),
		.clock(clk),
		.colour(colour_in),
		.x(x_in),
		.y(y_in),
		.plot(writeEn_in),

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
		colour = 3'b000;
		letter = 6'd36;
		position_x = 9'd0;
		position_y = 8'd0;
		position = 6'd0;
		writeEn = 1'b0;

		// Hangman title, always on
		// H
		if (((x >= 9'd29) && (x <= 9'd37)) && ((y >= 8'd10) && (y <= 8'd17))) begin
			letter = 6'd7;
			if (x >= 9'd30) begin
				position_x = x - 9'd30;
				position_y = 8'd17 - y;
				position = {position_y[2:0], position_x[2:0]};
				colour = 3'b111;
				writeEn = 1'b1;
			end
		end

		// A
		if (((x >= 9'd39) && (x <= 9'd47)) && ((y >= 8'd10) && (y <= 8'd17))) begin
			letter = 6'd0;
			if (x >= 9'd40) begin
				position_x = x - 9'd40;
				position_y = 8'd17 - y;
				position = {position_y[2:0], position_x[2:0]};
				colour = 3'b111;
				writeEn = 1'b1;
			end
		end

		// N
		if (((x >= 9'd49) && (x <= 9'd57)) && ((y >= 8'd10) && (y <= 8'd17))) begin
			letter = 6'd13;
			if (x >= 9'd50) begin
				position_x = x - 9'd50;
				position_y = 8'd17 - y;
				position = {position_y[2:0], position_x[2:0]};
				colour = 3'b111;
				writeEn = 1'b1;
			end
		end

		// G
		if (((x >= 9'd59) && (x <= 9'd67)) && ((y >= 8'd10) && (y <= 8'd17))) begin
			letter = 6'd6;
			if (x >= 9'd60) begin
				position_x = x - 9'd60;
				position_y = 8'd17 - y;
				position = {position_y[2:0], position_x[2:0]};
				colour = 3'b111;
				writeEn = 1'b1;
			end
		end

		// M
		if (((x >= 9'd69) && (x <= 9'd77)) && ((y >= 8'd10) && (y <= 8'd17))) begin
			letter = 6'd12;
			if (x >= 9'd70) begin
				position_x = x - 9'd70;
				position_y = 8'd17 - y;
				position = {position_y[2:0], position_x[2:0]};
				colour = 3'b111;
				writeEn = 1'b1;
			end
		end

		// A
		if (((x >= 9'd79) && (x <= 9'd87)) && ((y >= 8'd10) && (y <= 8'd17))) begin
			letter = 6'd0;
			if (x >= 9'd80) begin
				position_x = x - 9'd80;
				position_y = 8'd17 - y;
				position = {position_y[2:0], position_x[2:0]};
				colour = 3'b111;
				writeEn = 1'b1;
			end
		end

		// N
		if (((x >= 9'd89) && (x <= 9'd97)) && ((y >= 8'd10) && (y <= 8'd17))) begin
			letter = 6'd13;
			if (x >= 9'd90) begin
				position_x = x - 9'd90;
				position_y = 8'd17 - y;
				position = {position_y[2:0], position_x[2:0]};
				colour = 3'b111;
				writeEn = 1'b1;
			end
		end

		if (game_state == START) begin
			writeEn = 1'b1;

			// "press enter to start", clear out after START state
			// P
			if (((x >= 9'd29) && (x <= 9'd37)) && ((y >= 8'd20) && (y <= 8'd27))) begin
				letter = 6'd15;
				if (x >= 9'd30) begin
					position_x = x - 9'd30;
					position_y = 8'd27 - y;
					position = {position_y[2:0], position_x[2:0]};
					colour = 3'b111;
				end
			end

			// R
			if (((x >= 9'd39) && (x <= 9'd47)) && ((y >= 8'd20) && (y <= 8'd27))) begin
				letter = 6'd17;
				if (x >= 9'd40) begin
					position_x = x - 9'd40;
					position_y = 8'd27 - y;
					position = {position_y[2:0], position_x[2:0]};
					colour = 3'b111;
				end
			end

			// E
			if (((x >= 9'd49) && (x <= 9'd57)) && ((y >= 8'd20) && (y <= 8'd27))) begin
				letter = 6'd4;
				if (x >= 9'd50) begin
					position_x = x - 9'd50;
					position_y = 8'd27 - y;
					position = {position_y[2:0], position_x[2:0]};
					colour = 3'b111;
				end
			end

			// S
			if (((x >= 9'd59) && (x <= 9'd67)) && ((y >= 8'd20) && (y <= 8'd27))) begin
				letter = 6'd18;
				if (x >= 9'd60) begin
					position_x = x - 9'd60;
					position_y = 8'd27 - y;
					position = {position_y[2:0], position_x[2:0]};
					colour = 3'b111;
				end
			end

			// S
			if (((x >= 9'd69) && (x <= 9'd77)) && ((y >= 8'd20) && (y <= 8'd27))) begin
				letter = 6'd18;
				if (x >= 9'd70) begin
					position_x = x - 9'd70;
					position_y = 8'd27 - y;
					position = {position_y[2:0], position_x[2:0]};
					colour = 3'b111;
				end
			end

			// E
			if (((x >= 9'd89) && (x <= 9'd97)) && ((y >= 8'd20) && (y <= 8'd27))) begin
				letter = 6'd4;
				if (x >= 9'd90) begin
					position_x = x - 9'd90;
					position_y = 8'd27 - y;
					position = {position_y[2:0], position_x[2:0]};
					colour = 3'b111;
				end
			end

			// N
			if (((x >= 9'd99) && (x <= 9'd107)) && ((y >= 8'd20) && (y <= 8'd27))) begin
				letter = 6'd13;
				if (x >= 9'd100) begin
					position_x = x - 9'd100;
					position_y = 8'd27 - y;
					position = {position_y[2:0], position_x[2:0]};
					colour = 3'b111;
				end
			end

			// T
			if (((x >= 9'd109) && (x <= 9'd117)) && ((y >= 8'd20) && (y <= 8'd27))) begin
				letter = 6'd19;
				if (x >= 9'd110) begin
					position_x = x - 9'd110;
					position_y = 8'd27 - y;
					position = {position_y[2:0], position_x[2:0]};
					colour = 3'b111;
				end
			end

			// E
			if (((x >= 9'd119) && (x <= 9'd127)) && ((y >= 8'd20) && (y <= 8'd27))) begin
				letter = 6'd4;
				if (x >= 9'd120) begin
					position_x = x - 9'd120;
					position_y = 8'd27 - y;
					position = {position_y[2:0], position_x[2:0]};
					colour = 3'b111;
				end
			end

			// R
			if (((x >= 9'd129) && (x <= 9'd137)) && ((y >= 8'd20) && (y <= 8'd27))) begin
				letter = 6'd17;
				if (x >= 9'd130) begin
					position_x = x - 9'd130;
					position_y = 8'd27 - y;
					position = {position_y[2:0], position_x[2:0]};
					colour = 3'b111;
				end
			end

			// T
			if (((x >= 9'd29) && (x <= 9'd37)) && ((y >= 8'd30) && (y <= 8'd37))) begin
				letter = 6'd19;
				if (x >= 9'd30) begin
					position_x = x - 9'd30;
					position_y = 8'd37 - y;
					position = {position_y[2:0], position_x[2:0]};
					colour = 3'b111;
				end
			end

			// O
			if (((x >= 9'd39) && (x <= 9'd47)) && ((y >= 8'd30) && (y <= 8'd37))) begin
				letter = 6'd14;
				if (x >= 9'd40) begin
					position_x = x - 9'd40;
					position_y = 8'd37 - y;
					position = {position_y[2:0], position_x[2:0]};
					colour = 3'b111;
				end
			end

			// S
			if (((x >= 9'd59) && (x <= 9'd67)) && ((y >= 8'd30) && (y <= 8'd37))) begin
				letter = 6'd18;
				if (x >= 9'd60) begin
					position_x = x - 9'd60;
					position_y = 8'd37 - y;
					position = {position_y[2:0], position_x[2:0]};
					colour = 3'b111;
				end
			end

			// T
			if (((x >= 9'd69) && (x <= 9'd77)) && ((y >= 8'd30) && (y <= 8'd37))) begin
				letter = 6'd19;
				if (x >= 9'd70) begin
					position_x = x - 9'd70;
					position_y = 8'd37 - y;
					position = {position_y[2:0], position_x[2:0]};
					colour = 3'b111;
				end
			end

			// A
			if (((x >= 9'd79) && (x <= 9'd87)) && ((y >= 8'd30) && (y <= 8'd37))) begin
				letter = 6'd0;
				if (x >= 9'd80) begin
					position_x = x - 9'd80;
					position_y = 8'd37 - y;
					position = {position_y[2:0], position_x[2:0]};
					colour = 3'b111;
				end
			end

			// R
			if (((x >= 9'd89) && (x <= 9'd97)) && ((y >= 8'd30) && (y <= 8'd37))) begin
				letter = 6'd17;
				if (x >= 9'd90) begin
					position_x = x - 9'd90;
					position_y = 8'd37 - y;
					position = {position_y[2:0], position_x[2:0]};
					colour = 3'b111;
				end
			end

			// T
			if (((x >= 9'd99) && (x <= 9'd107)) && ((y >= 8'd30) && (y <= 8'd37))) begin
				letter = 6'd19;
				if (x >= 9'd100) begin
					position_x = x - 9'd100;
					position_y = 8'd37 - y;
					position = {position_y[2:0], position_x[2:0]};
					colour = 3'b111;
				end
			end
		end
		else begin
			// Clear out the message
			if (((x >= 9'd20) && (x <= 9'd137)) && ((y >= 8'd20) && (y <= 9'd37))) begin
				writeEn = 1'b1;
			end

			// First letter
			if ((x >= 9'd24) && (x <= 9'd32)) begin
				// Letter
				if ((y >= 8'd190) && (y <= 8'd197)) begin
					letter = {1'b0, word[29:25]} - 6'd1;
					if (x >= 9'd25) begin
						position_x = x - 9'd25;
						position_y = 8'd197 - y;
						position = {position_y[2:0], position_x[2:0]};
						if ((guessed_mask[letter[5:0]]) || (game_state > INGAME))
							colour = 3'b111;
						writeEn = 1'b1;
					end
				end
				// Dash
				if ((y >= 8'd200) && (y <= 8'd207)) begin
					letter = 6'd26;
					if (x >= 9'd25) begin
						position_x = x - 9'd25;
						position_y = 8'd207 - y;
						position = {position_y[2:0], position_x[2:0]};
						colour = 3'b111;
						writeEn = 1'b1;
					end
				end
			end

			// Second letter
			if ((x >= 9'd54) && (x <= 9'd62)) begin
				// Letter
				if ((y >= 8'd190) && (y <= 8'd197)) begin
					letter = {1'b0, word[24:20]} - 6'd1;
					if (x >= 9'd55) begin
						position_x = x - 9'd55;
						position_y = 8'd197 - y;
						position = {position_y[2:0], position_x[2:0]};
						if ((guessed_mask[letter[5:0]]) || (game_state > INGAME))
							colour = 3'b111;
						writeEn = 1'b1;
					end
				end
				// Dash
				if ((y >= 8'd200) && (y <= 8'd207)) begin
					letter = 6'd26;
					if (x >= 9'd55) begin
						position_x = x - 9'd55;
						position_y = 8'd207 - y;
						position = {position_y[2:0], position_x[2:0]};
						colour = 3'b111;
						writeEn = 1'b1;
					end
				end
			end

			// Third letter
			if ((x >= 9'd84) && (x <= 9'd92)) begin
				// Letter
				if ((y >= 8'd190) && (y <= 8'd197)) begin
					letter = {1'b0, word[19:15]} - 6'd1;
					if (x >= 9'd85) begin
						position_x = x - 9'd85;
						position_y = 8'd197 - y;
						position = {position_y[2:0], position_x[2:0]};
						if ((guessed_mask[letter[5:0]]) || (game_state > INGAME))
							colour = 3'b111;
						writeEn = 1'b1;
					end
				end
				// Dash
				if ((y >= 8'd200) && (y <= 8'd207)) begin
					letter = 6'd26;
					if (x >= 9'd85) begin
						position_x = x - 9'd85;
						position_y = 8'd207 - y;
						position = {position_y[2:0], position_x[2:0]};
						colour = 3'b111;
						writeEn = 1'b1;
					end
				end
			end

			// Forth letter
			if ((x >= 9'd114) && (x <= 9'd122)) begin
				// Letter
				if ((y >= 8'd190) && (y <= 8'd197)) begin
					letter = {1'b0, word[14:10]} - 6'd1;
					if (x >= 9'd115) begin
						position_x = x - 9'd115;
						position_y = 8'd197 - y;
						position = {position_y[2:0], position_x[2:0]};
						if ((guessed_mask[letter[5:0]]) || (game_state > INGAME))
							colour = 3'b111;
						writeEn = 1'b1;
					end
				end
				// Dash
				if ((y >= 8'd200) && (y <= 8'd207)) begin
					letter = 6'd26;
					if (x >= 9'd115) begin
						position_x = x - 9'd115;
						position_y = 8'd207 - y;
						position = {position_y[2:0], position_x[2:0]};
						colour = 3'b111;
						writeEn = 1'b1;
					end
				end
			end

			// Fifth letter
			if ((x >= 9'd144) && (x <= 9'd152)) begin
				// Letter
				if ((y >= 8'd190) && (y <= 8'd197)) begin
					letter = {1'b0, word[9:5]} - 6'd1;
					if (x >= 9'd145) begin
						position_x = x - 9'd145;
						position_y = 8'd197 - y;
						position = {position_y[2:0], position_x[2:0]};
						if ((guessed_mask[letter[5:0]]) || (game_state > INGAME))
							colour = 3'b111;
						writeEn = 1'b1;
					end
				end
				// Dash
				if ((y >= 8'd200) && (y <= 8'd207)) begin
					letter = 6'd26;
					if (x >= 9'd145) begin
						position_x = x - 9'd145;
						position_y = 8'd207 - y;
						position = {position_y[2:0], position_x[2:0]};
						colour = 3'b111;
						writeEn = 1'b1;
					end
				end
			end

			// Sixth letter
			if ((x >= 9'd174) && (x <= 9'd182)) begin
				// Letter
				if ((y >= 8'd190) && (y <= 8'd197)) begin
					letter = {1'b0, word[4:0]} - 6'd1;
					if (x >= 9'd175) begin
						position_x = x - 9'd175;
						position_y = 8'd197 - y;
						position = {position_y[2:0], position_x[2:0]};
						if ((guessed_mask[letter[5:0]]) || (game_state > INGAME))
							colour = 3'b111;
						writeEn = 1'b1;
					end
				end
				// Dash
				if ((y >= 8'd200) && (y <= 8'd207)) begin
					letter = 6'd26;
					if (x >= 9'd175) begin
						position_x = x - 9'd175;
						position_y = 8'd207 - y;
						position = {position_y[2:0], position_x[2:0]};
						colour = 3'b111;
						writeEn = 1'b1;
					end
				end
			end

			// vertical line
			if ((x >= 9'd240) && (x <= 9'd245)) begin
				letter = 6'd29;
				colour = 3'b111;
				writeEn = 1'b1;
			end

			// A state
			if (((x >= 9'd249) && (x <= 9'd257)) && ((y >= 8'd10) && (y <= 8'd17))) begin
				letter = 6'd0;
				if (x >= 9'd250) begin
					position_x = x - 9'd250;
					position_y = 8'd17 - y;
					position = {position_y[2:0], position_x[2:0]};
					if (guessed_mask[letter[5:0]])
						if (mask[letter[5:0])
							colour = 3'b010;
						else
							colour = 3'b100;
					else
						colour = 3'b010;
					writeEn = 1'b1;
				end
			end

			// B state
			if (((x >= 9'd249) && (x <= 9'd257)) && ((y >= 8'd20) && (y <= 8'd27))) begin
				letter = 6'd1;
				if (x >= 9'd250) begin
					position_x = x - 9'd250;
					position_y = 8'd27 - y;
					position = {position_y[2:0], position_x[2:0]};
					if (guessed_mask[letter[5:0]])
						if (mask[letter[5:0])
							colour = 3'b010;
						else
							colour = 3'b100;
					else
						colour = 3'b010;
					writeEn = 1'b1;
				end
			end

			// C state
			if (((x >= 9'd249) && (x <= 9'd257)) && ((y >= 8'd30) && (y <= 8'd37))) begin
				letter = 6'd2;
				if (x >= 9'd250) begin
					position_x = x - 9'd250;
					position_y = 8'd37 - y;
					position = {position_y[2:0], position_x[2:0]};
					if (guessed_mask[letter[5:0]])
						if (mask[letter[5:0])
							colour = 3'b010;
						else
							colour = 3'b100;
					else
						colour = 3'b010;
					writeEn = 1'b1;
				end
			end

			// D state
			if (((x >= 9'd249) && (x <= 9'd257)) && ((y >= 8'd40) && (y <= 8'd47))) begin
				letter = 6'd3;
				if (x >= 9'd250) begin
					position_x = x - 9'd250;
					position_y = 8'd47 - y;
					position = {position_y[2:0], position_x[2:0]};
					if (guessed_mask[letter[5:0]])
						if (mask[letter[5:0])
							colour = 3'b010;
						else
							colour = 3'b100;
					else
						colour = 3'b010;
					writeEn = 1'b1;
				end
			end

			// E state
			if (((x >= 9'd249) && (x <= 9'd257)) && ((y >= 8'd50) && (y <= 8'd57))) begin
				letter = 6'd4;
				if (x >= 9'd250) begin
					position_x = x - 9'd250;
					position_y = 8'd57 - y;
					position = {position_y[2:0], position_x[2:0]};
					if (guessed_mask[letter[5:0]])
						if (mask[letter[5:0])
							colour = 3'b010;
						else
							colour = 3'b100;
					else
						colour = 3'b010;
					writeEn = 1'b1;
				end
			end

			// F state
			if (((x >= 9'd249) && (x <= 9'd257)) && ((y >= 8'd60) && (y <= 8'd67))) begin
				letter = 6'd5;
				if (x >= 9'd250) begin
					position_x = x - 9'd250;
					position_y = 8'd67 - y;
					position = {position_y[2:0], position_x[2:0]};
					if (guessed_mask[letter[5:0]])
						if (mask[letter[5:0])
							colour = 3'b010;
						else
							colour = 3'b100;
					else
						colour = 3'b010;
					writeEn = 1'b1;
				end
			end

			// G state
			if (((x >= 9'd249) && (x <= 9'd257)) && ((y >= 8'd70) && (y <= 8'd77))) begin
				letter = 6'd6;
				if (x >= 9'd250) begin
					position_x = x - 9'd250;
					position_y = 8'd77 - y;
					position = {position_y[2:0], position_x[2:0]};
					if (guessed_mask[letter[5:0]])
						if (mask[letter[5:0])
							colour = 3'b010;
						else
							colour = 3'b100;
					else
						colour = 3'b010;
					writeEn = 1'b1;
				end
			end

			// H state
			if (((x >= 9'd249) && (x <= 9'd257)) && ((y >= 8'd80) && (y <= 8'd87))) begin
				letter = 6'd7;
				if (x >= 9'd250) begin
					position_x = x - 9'd250;
					position_y = 8'd87 - y;
					position = {position_y[2:0], position_x[2:0]};
					if (guessed_mask[letter[5:0]])
						if (mask[letter[5:0])
							colour = 3'b010;
						else
							colour = 3'b100;
					else
						colour = 3'b010;
					writeEn = 1'b1;
				end
			end

			// I state
			if (((x >= 9'd249) && (x <= 9'd257)) && ((y >= 8'd90) && (y <= 8'd97))) begin
				letter = 6'd8;
				if (x >= 9'd250) begin
					position_x = x - 9'd250;
					position_y = 8'd97 - y;
					position = {position_y[2:0], position_x[2:0]};
					if (guessed_mask[letter[5:0]])
						if (mask[letter[5:0])
							colour = 3'b010;
						else
							colour = 3'b100;
					else
						colour = 3'b010;
					writeEn = 1'b1;
				end
			end

			// J state
			if (((x >= 9'd249) && (x <= 9'd257)) && ((y >= 8'd100) && (y <= 8'd107))) begin
				letter = 6'd9;
				if (x >= 9'd250) begin
					position_x = x - 9'd250;
					position_y = 8'd107 - y;
					position = {position_y[2:0], position_x[2:0]};
					if (guessed_mask[letter[5:0]])
						if (mask[letter[5:0])
							colour = 3'b010;
						else
							colour = 3'b100;
					else
						colour = 3'b010;
					writeEn = 1'b1;
				end
			end

			// K state
			if (((x >= 9'd249) && (x <= 9'd257)) && ((y >= 8'd110) && (y <= 8'd117))) begin
				letter = 6'd10;
				if (x >= 9'd250) begin
					position_x = x - 9'd250;
					position_y = 8'd117 - y;
					position = {position_y[2:0], position_x[2:0]};
					if (guessed_mask[letter[5:0]])
						if (mask[letter[5:0])
							colour = 3'b010;
						else
							colour = 3'b100;
					else
						colour = 3'b010;
					writeEn = 1'b1;
				end
			end

			// L state
			if (((x >= 9'd249) && (x <= 9'd257)) && ((y >= 8'd120) && (y <= 8'd127))) begin
				letter = 6'd11;
				if (x >= 9'd250) begin
					position_x = x - 9'd250;
					position_y = 8'd127 - y;
					position = {position_y[2:0], position_x[2:0]};
					if (guessed_mask[letter[5:0]])
						if (mask[letter[5:0])
							colour = 3'b010;
						else
							colour = 3'b100;
					else
						colour = 3'b010;
					writeEn = 1'b1;
				end
			end

			// M state
			if (((x >= 9'd249) && (x <= 9'd257)) && ((y >= 8'd130) && (y <= 8'd137))) begin
				letter = 6'd12;
				if (x >= 9'd250) begin
					position_x = x - 9'd250;
					position_y = 8'd137 - y;
					position = {position_y[2:0], position_x[2:0]};
					if (guessed_mask[letter[5:0]])
						if (mask[letter[5:0])
							colour = 3'b010;
						else
							colour = 3'b100;
					else
						colour = 3'b010;
					writeEn = 1'b1;
				end
			end

			// N state
			if (((x >= 9'd269) && (x <= 9'd277)) && ((y >= 8'd10) && (y <= 8'd17))) begin
				letter = 6'd13;
				if (x >= 9'd270) begin
					position_x = x - 9'd270;
					position_y = 8'd17 - y;
					position = {position_y[2:0], position_x[2:0]};
					if (guessed_mask[letter[5:0]])
						if (mask[letter[5:0])
							colour = 3'b010;
						else
							colour = 3'b100;
					else
						colour = 3'b010;
					writeEn = 1'b1;
				end
			end

			// O state
			if (((x >= 9'd269) && (x <= 9'd277)) && ((y >= 8'd20) && (y <= 8'd27))) begin
				letter = 6'd14;
				if (x >= 9'd270) begin
					position_x = x - 9'd270;
					position_y = 8'd27 - y;
					position = {position_y[2:0], position_x[2:0]};
					if (guessed_mask[letter[5:0]])
						if (mask[letter[5:0])
							colour = 3'b010;
						else
							colour = 3'b100;
					else
						colour = 3'b010;
					writeEn = 1'b1;
				end
			end

			// P state
			if (((x >= 9'd269) && (x <= 9'd277)) && ((y >= 8'd30) && (y <= 8'd37))) begin
				letter = 6'd15;
				if (x >= 9'd270) begin
					position_x = x - 9'd270;
					position_y = 8'd37 - y;
					position = {position_y[2:0], position_x[2:0]};
					if (guessed_mask[letter[5:0]])
						if (mask[letter[5:0])
							colour = 3'b010;
						else
							colour = 3'b100;
					else
						colour = 3'b010;
					writeEn = 1'b1;
				end
			end

			// Q state
			if (((x >= 9'd269) && (x <= 9'd277)) && ((y >= 8'd40) && (y <= 8'd47))) begin
				letter = 6'd16;
				if (x >= 9'd270) begin
					position_x = x - 9'd270;
					position_y = 8'd47 - y;
					position = {position_y[2:0], position_x[2:0]};
					if (guessed_mask[letter[5:0]])
						if (mask[letter[5:0])
							colour = 3'b010;
						else
							colour = 3'b100;
					else
						colour = 3'b010;
					writeEn = 1'b1;
				end
			end

			// R state
			if (((x >= 9'd269) && (x <= 9'd277)) && ((y >= 8'd50) && (y <= 8'd57))) begin
				letter = 6'd17;
				if (x >= 9'd270) begin
					position_x = x - 9'd270;
					position_y = 8'd57 - y;
					position = {position_y[2:0], position_x[2:0]};
					if (guessed_mask[letter[5:0]])
						if (mask[letter[5:0])
							colour = 3'b010;
						else
							colour = 3'b100;
					else
						colour = 3'b010;
					writeEn = 1'b1;
				end
			end

			// S state
			if (((x >= 9'd269) && (x <= 9'd277)) && ((y >= 8'd60) && (y <= 8'd67))) begin
				letter = 6'd18;
				if (x >= 9'd270) begin
					position_x = x - 9'd270;
					position_y = 8'd67 - y;
					position = {position_y[2:0], position_x[2:0]};
					if (guessed_mask[letter[5:0]])
						if (mask[letter[5:0])
							colour = 3'b010;
						else
							colour = 3'b100;
					else
						colour = 3'b010;
					writeEn = 1'b1;
				end
			end

			// T state
			if (((x >= 9'd269) && (x <= 9'd277)) && ((y >= 8'd70) && (y <= 8'd77))) begin
				letter = 6'd19;
				if (x >= 9'd270) begin
					position_x = x - 9'd270;
					position_y = 8'd77 - y;
					position = {position_y[2:0], position_x[2:0]};
					if (guessed_mask[letter[5:0]])
						if (mask[letter[5:0])
							colour = 3'b010;
						else
							colour = 3'b100;
					else
						colour = 3'b010;
					writeEn = 1'b1;
				end
			end

			// U state
			if (((x >= 9'd269) && (x <= 9'd277)) && ((y >= 8'd80) && (y <= 8'd87))) begin
				letter = 6'd20;
				if (x >= 9'd270) begin
					position_x = x - 9'd270;
					position_y = 8'd87 - y;
					position = {position_y[2:0], position_x[2:0]};
					if (guessed_mask[letter[5:0]])
						if (mask[letter[5:0])
							colour = 3'b010;
						else
							colour = 3'b100;
					else
						colour = 3'b010;
					writeEn = 1'b1;
				end
			end

			// V state
			if (((x >= 9'd269) && (x <= 9'd277)) && ((y >= 8'd90) && (y <= 8'd97))) begin
				letter = 6'd21;
				if (x >= 9'd270) begin
					position_x = x - 9'd270;
					position_y = 8'd97 - y;
					position = {position_y[2:0], position_x[2:0]};
					if (guessed_mask[letter[5:0]])
						if (mask[letter[5:0])
							colour = 3'b010;
						else
							colour = 3'b100;
					else
						colour = 3'b010;
					writeEn = 1'b1;
				end
			end

			// W state
			if (((x >= 9'd269) && (x <= 9'd277)) && ((y >= 8'd100) && (y <= 8'd107))) begin
				letter = 6'd22;
				if (x >= 9'd270) begin
					position_x = x - 9'd270;
					position_y = 8'd107 - y;
					position = {position_y[2:0], position_x[2:0]};
					if (guessed_mask[letter[5:0]])
						if (mask[letter[5:0])
							colour = 3'b010;
						else
							colour = 3'b100;
					else
						colour = 3'b010;
					writeEn = 1'b1;
				end
			end

			// X state
			if (((x >= 9'd269) && (x <= 9'd277)) && ((y >= 8'd110) && (y <= 8'd117))) begin
				letter = 6'd23;
				if (x >= 9'd270) begin
					position_x = x - 9'd270;
					position_y = 8'd117 - y;
					position = {position_y[2:0], position_x[2:0]};
					if (guessed_mask[letter[5:0]])
						if (mask[letter[5:0])
							colour = 3'b010;
						else
							colour = 3'b100;
					else
						colour = 3'b010;
					writeEn = 1'b1;
				end
			end

			// Y state
			if (((x >= 9'd269) && (x <= 9'd277)) && ((y >= 8'd120) && (y <= 8'd127))) begin
				letter = 6'd24;
				if (x >= 9'd270) begin
					position_x = x - 9'd270;
					position_y = 8'd127 - y;
					position = {position_y[2:0], position_x[2:0]};
					if (guessed_mask[letter[5:0]])
						if (mask[letter[5:0])
							colour = 3'b010;
						else
							colour = 3'b100;
					else
						colour = 3'b010;
					writeEn = 1'b1;
				end
			end

			// Z state
			if (((x >= 9'd269) && (x <= 9'd277)) && ((y >= 8'd130) && (y <= 8'd137))) begin
				letter = 6'd25;
				if (x >= 9'd270) begin
					position_x = x - 9'd270;
					position_y = 8'd137 - y;
					position = {position_y[2:0], position_x[2:0]};
					if (guessed_mask[letter[5:0]])
						if (mask[letter[5:0])
							colour = 3'b010;
						else
							colour = 3'b100;
					else
						colour = 3'b010;
					writeEn = 1'b1;
				end
			end

			// The poor man
			if ((x >= 9'd99) && (x <= 9'd107)) begin
				//Cross or check over the head
				if ((y >= 8'd80) && (y <= 8'd87)) begin
					if (guessed_mask == 26'd0)
						letter = 6'd30;
					else 
						if (wrong) begin
							letter = 6'd27;
							colour = 3'b010;
						end
						else begin
							letter = 6'd28;
							colour = 3'b100;
						end
					if (x >= 9'd100) begin
						position_x = x - 9'd100;
						position_y = 8'd87 - y;
						position = {position_y[2:0], position_x[2:0]};
						writeEn = 1'b1;
					end
				end
				// Head
				if ((y >= 8'd92) && (y <= 8'd99)) begin
					letter = 6'd29;
					if (x >= 9'd100) begin
						position_x = x - 9'd100;
						position_y = 8'd99 - y;
						position = {position_y[2:0], position_x[2:0]};
						colour = 3'b111;
						writeEn = 1'b1;
					end
				end
				// Body
				if ((y >= 8'd100) && (y <= 8'd107)) begin
					letter = 6'd30 + {2'b00, wrong_time[3:0]};
					if (x >= 9'd100) begin
						position_x = x - 9'd100;
						position_y = 8'd107 - y;
						position = {position_y[2:0], position_x[2:0]};
						colour = 3'b111;
						writeEn = 1'b1;
					end
				end
			end

			if (game_state > INGAME) begin
				// Y
				if (((x >= 9'd69) && (x <= 9'd77)) && ((y >= 8'd110) && (y <= 8'd117))) begin
					letter = 6'd24;
					if (x >= 9'd70) begin
						position_x = x - 9'd70;
						position_y = 8'd117 - y;
						position = {position_y[2:0], position_x[2:0]};
						colour = 3'b111;
						writeEn = 1'b1;
					end
				end

				// O
				if (((x >= 9'd79) && (x <= 9'd87)) && ((y >= 8'd110) && (y <= 8'd117))) begin
					letter = 6'd14;
					if (x >= 9'd80) begin
						position_x = x - 9'd80;
						position_y = 8'd117 - y;
						position = {position_y[2:0], position_x[2:0]};
						colour = 3'b111;
						writeEn = 1'b1;
					end
				end

				// U
				if (((x >= 9'd89) && (x <= 9'd97)) && ((y >= 8'd110) && (y <= 8'd117))) begin
					letter = 6'd20;
					if (x >= 9'd90) begin
						position_x = x - 9'd90;
						position_y = 8'd117 - y;
						position = {position_y[2:0], position_x[2:0]};
						colour = 3'b111;
						writeEn = 1'b1;
					end
				end
			end

			if (game_state == WINGAME) begin
				// W
				if (((x >= 9'd109) && (x <= 9'd117)) && ((y >= 8'd110) && (y <= 8'd117))) begin
					letter = 6'd22;
					if (x >= 9'd110) begin
						position_x = x - 9'd110;
						position_y = 8'd117 - y;
						position = {position_y[2:0], position_x[2:0]};
						colour = 3'b111;
						writeEn = 1'b1;
					end
				end

				// I
				if (((x >= 9'd119) && (x <= 9'd127)) && ((y >= 8'd110) && (y <= 8'd117))) begin
					letter = 6'd8;
					if (x >= 9'd120) begin
						position_x = x - 9'd120;
						position_y = 8'd117 - y;
						position = {position_y[2:0], position_x[2:0]};
						colour = 3'b111;
						writeEn = 1'b1;
					end
				end

				// N
				if (((x >= 9'd129) && (x <= 9'd137)) && ((y >= 8'd110) && (y <= 8'd117))) begin
					letter = 6'd13;
					if (x >= 9'd130) begin
						position_x = x - 9'd130;
						position_y = 8'd117 - y;
						position = {position_y[2:0], position_x[2:0]};
						colour = 3'b111;
						writeEn = 1'b1;
					end
				end
			end

			if (game_state == LOSTGAME) begin
				// L
				if (((x >= 9'd109) && (x <= 9'd117)) && ((y >= 8'd110) && (y <= 8'd117))) begin
					letter = 6'd11;
					if (x >= 9'd110) begin
						position_x = x - 9'd110;
						position_y = 8'd117 - y;
						position = {position_y[2:0], position_x[2:0]};
						colour = 3'b111;
						writeEn = 1'b1;
					end
				end

				// O
				if (((x >= 9'd119) && (x <= 9'd127)) && ((y >= 8'd110) && (y <= 8'd117))) begin
					letter = 6'd14;
					if (x >= 9'd120) begin
						position_x = x - 9'd120;
						position_y = 8'd117 - y;
						position = {position_y[2:0], position_x[2:0]};
						colour = 3'b111;
						writeEn = 1'b1;
					end
				end

				// S
				if (((x >= 9'd129) && (x <= 9'd137)) && ((y >= 8'd110) && (y <= 8'd117))) begin
					letter = 6'd18;
					if (x >= 9'd130) begin
						position_x = x - 9'd130;
						position_y = 8'd117 - y;
						position = {position_y[2:0], position_x[2:0]};
						colour = 3'b111;
						writeEn = 1'b1;
					end
				end

				// E
				if (((x >= 9'd139) && (x <= 9'd147)) && ((y >= 8'd110) && (y <= 8'd117))) begin
					letter = 6'd4;
					if (x >= 9'd140) begin
						position_x = x - 9'd140;
						position_y = 8'd117 - y;
						position = {position_y[2:0], position_x[2:0]};
						colour = 3'b111;
						writeEn = 1'b1;
					end
				end
			end
		end
	end

	always @(posedge clk) begin
		if (reset) begin
			x_in <= 9'b0;
			y_in <= 8'b0;
			colour_in <= 3'b000;
			writeEn_in <= 1'b1;
		end
		else begin
			x_in <= x;
			y_in <= y;
			writeEn_in <= writeEn;
			colour_in <= ((letter < 6'd36) && (letter_writeEn[position[5:0]])) ? colour : 3'b000;
		end
	end

endmodule