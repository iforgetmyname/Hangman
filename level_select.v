module level_select(
	input clk, reset,
	
	input start_game, win_game, lost_game,

	output reg [3:0] current_state);
	
	reg [3:0] next_state;
	
	localparam START	= 2'd0,
			   INGAME	= 2'd1,
			   WINGAME	= 2'd2,
			   LOSTGAME	= 2'd3;

	
	always @(*) begin
		case (current_state)
			START: next_state = start_game ? INGAME : START;
			INGAME: begin
						if (win_game)
							next_state = WINGAME;
						else if (lost_game)
							next_state = LOSTGAME;
						else
							next_state = INGAME;
					end
			WINGAME: next_state = start_game ? START : WINGAME;
			LOSTGAME: next_state = start_game ? START : LOSTGAME;
			default: next_state = START;
		endcase
	end

	always @(posedge clk)
	begin
		if (reset) 
			current_state <= START;
		else
			current_state <= next_state;
	end
endmodule
