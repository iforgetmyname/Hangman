module game_handler(
	input clk, reset,
	input load,
	input [4:0] load_x,
	input [25:0] mask,

	output reg [25:0] guessed_mask,
	output [1:0] game_state,
	output reg [3:0] wrong_time
);

	localparam START	= 2'd0,
			   INGAME	= 2'd1,
			   WINGAME	= 2'd2,
			   LOSTGAME	= 2'd3;

	wire win, wrong;

	always(@negedge wrong, posedge reset) begin
		if (reset)
			wrong_time <= 4'd10;
		else if (load)
			wrong_time <= wrong_time - 1'd1;
	end

	game_status status0(
		.clk(clk),
		.reset(reset),

		.start_game((load_x[4:0] == 5'd26) && load),
		.win_game(win),
		.lost_game(wrong_time[4:0] == 1'd0),

		.current_state(game_state[1:0])
	);

	game_process process0(
		.clk(clk),
		.reset(reset),

		.load(((game_state[1:0] == INGAME) && load)),
		.load_x(load_x[4:0]),
		.mask(mask[25:0]),

		.win(win),
		.wrong(wrong),
		.current_state(guessed_mask[25:0])
	);

endmodule