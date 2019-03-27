module hangman(
	input CLOCK_50,
	input PS2_DAT, PS2_CLK,
	input [0:0] KEY,
	input [3:0] SW,

	output [9:0] LEDR,
	output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4,
	output VGA_CLK, VGA_HS, VGA_VS, VGA_BLANK_N, VGA_SYNC_N,
	output [9:0] VGA_R, VGA_G, VGA_B);
	
	wire clk, reset;
	assign clk = CLOCK_50;
	assign reset = ~KEY[0];

	wire load;
	wire [4:0] pressedLetter;
	keyboard_handler k0(
		.clk(clk),
		.reset(reset),
		.PS2_DAT(PS2_DAT),
		.PS2_CLK(PS2_CLK),

		.pressed(load),
		.inputLetter(pressedLetter[4:0])
	);

	wire [29:0] word;
	wire [25:0] mask;
	reg [3:0] wrong_time;
	
	wire win_game, lost_game;

	wire [3:0] level_state;
	assign LEDR[3:0] = level_state;
	level_select l0(
		.clk(clk),
		.reset(reset),
		
		.start_game(((pressedLetter == 5'd26) && load)),
		.win_game(win_game),
		.lost_game((wrong_time == 1'b0)),
		.select(SW[3:0]),
		
		.word(word),
		.mask(mask),
		
		.current_state(level_state)
		);
	
	wire [25:0] state;
	wire wrong;
	game_state g0(
		.clk(clk),
		.reset(reset),
		.load(((level_state == 2'd1) && load)),
		.load_x(pressedLetter),
		
		.mask(mask),
		
		.win(win_game),
		.wrong(wrong),
		
		.current_state(state)
		);
	
	always @(negedge wrong, posedge reset) begin
		if (reset) 
			wrong_time <= 4'd4;
		else if(load)
			wrong_time <= wrong_time - 1'd1;
	end
	
	vga v0(
		.clk(clk),
		.reset(reset),
		.state(level_state[3:0]),
		.word(word),
		.mask(state),
		
		.VGA_CLK(VGA_CLK),
		.VGA_HS(VGA_HS),
		.VGA_VS(VGA_VS),
		.VGA_BLANK_N(VGA_BLANK_N),
		.VGA_SYNC_N(VGA_SYNC_N),
		.VGA_R(VGA_R[9:0]),
		.VGA_B(VGA_B[9:0]),
		.VGA_G(VGA_G[9:0])
		);
	
	hex_decoder h0(
		.hex_digit(pressedLetter[3:0]),
		.segments(HEX0[6:0])
		);
	
	hex_decoder h1(
		.hex_digit({3'b000, pressedLetter[4]}),
		.segments(HEX1[6:0])
		);
		
	hex_decoder h2(
		.hex_digit(state[3:0]),
		.segments(HEX2[6:0])
		);
	
	hex_decoder h3(
		.hex_digit(state[7:4]),
		.segments(HEX3[6:0])
		);
	
	hex_decoder h4(
		.hex_digit(wrong_time),
		.segments(HEX4[6:0])
		);
	
	assign LEDR[9] = load;
endmodule