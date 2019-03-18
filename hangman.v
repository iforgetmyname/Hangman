module hangman(
	input CLOCK_50,
   input PS2_DAT, PS2_CLK
	input KEY,
	input SW,
	
	output LEDR);
	
	wire [29:0] word;
	wire [25:0] mask;
	wire clk;
	assign clk = CLOCK_50;
	
	
	level_select l0(
		.clk(clk),
		.reset(~KEY[0]),
		
		.start_game(SW[0]),
		.lost_game(SW[1])
		
		.word(word),
		.mask(mask)
		.current_state(LEDR[3:0])
		);
	
	wire valid, makeBreak;
	wire [7:0] outCode;
	
	keyboard_press_driver k0(
		.valid(valid),
		.makeBreak(makeBreak),
		.outCode(outCode),
		
		.reset(~KEY[0]),
		);
	
	wire [4:0] outLetter;
	decoder d0(
		.inCode(outCode),
		
		.outLetter(outLetter)
		);

endmodule
		
	