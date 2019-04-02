module hangman(
	input CLOCK_50,
	input PS2_DAT, PS2_CLK,
	input [0:0] KEY,
	input [3:0] SW,

	output [2:0] LEDR,
	output [6:0] HEX0,
	output VGA_CLK, VGA_HS, VGA_VS, VGA_BLANK_N, VGA_SYNC_N,
	output [9:0] VGA_R, VGA_G, VGA_B
);

	wire clk, reset;
	wire load;
	reg [3:0] word_select;
	wire [29:0] word;
	wire [25:0] mask, guessed_mask;
	wire [4:0] pressedLetter;
	wire [1:0] game_state;
	wire wrong;
	wire [3:0] wrong_time;
	assign clk = CLOCK_50;
	assign reset = ~KEY[0];

	always @(posedge clk) begin
		if (game_state == 2'd0)
			word_select <= SW[3:0];
		else
			word_select <= word_select;
	end
	
	word_ram wr0(
		.clock(clk),

		.address(word_select[3:0]),
		.data(56'd0),
		.wren(1'b0),

		.q({word[29:0], mask[25:0]})
	);

	keyboard_handler k0(
		.clk(clk),
		.reset(reset),

		.PS2_DAT(PS2_DAT),
		.PS2_CLK(PS2_CLK),

		.pressed(load),
		.inputLetter(pressedLetter[4:0])
	);

	game_handler g0(
		.clk(clk),
		.reset(reset),

		.load(load),
		.load_x(pressedLetter[4:0]),
		.mask(mask[25:0]),

		.guessed_mask(guessed_mask[25:0]),
		.game_state(game_state[1:0]),
		.wrong(wrong),
		.wrong_time(wrong_time[3:0])
	);

	vga_handler v0(
		.clk(clk),
		.reset(reset),

		.game_state(game_state[1:0]),
		.word(word[29:0]),
		.mask(mask[25:0]),
		.load(load),
		.guessed_mask(guessed_mask[25:0]),
		.wrong_time(wrong_time[3:0]),
		
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
		.hex_digit(wrong_time[3:0]),
		.segments(HEX0[6:0])
	);

	assign LEDR[1:0] = game_state[1:0];
	assign LEDR[2] = load;
endmodule