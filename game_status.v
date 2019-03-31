module game_status(
	input clk, reset,
	input start_game, win_game, lost_game,

	output reg [1:0] current_state
);

	localparam START	= 2'd0,
			   INGAME	= 2'd1,
			   WINGAME	= 2'd2,
			   LOSTGAME	= 2'd3;

	reg [1:0] next_state;
	reg [27:0] rate_divider;
	reg start_rate_divider;

	always @(*) begin
		start_rate_divider = 1'b0;
		case (current_state)
			START: next_state = start_game ? INGAME : START;
			INGAME: begin
						if (win_game) begin
							next_state = WINGAME;
							start_rate_divider = 1'b1;
						end
						else if (lost_game) begin
							next_state = LOSTGAME;
							start_rate_divider = 1'b1;
						end
						else
							next_state = INGAME;
					end
			WINGAME: next_state = (rate_divider == 28'd0) ? START : WINGAME;
			LOSTGAME: next_state = (rate_divider == 28'd0) ? START : LOSTGAME;
			default: next_state = START;
		endcase
	end

	always @(posedge clk) begin
		if (start_rate_divider)
			rate_divider <= 28'd249999999;
		else if (rate_divider > 28'd0)
			rate_divider <= rate_divider - 28'd1;
	end
	
	always @(posedge clk) begin
		if (reset) 
			current_state <= START;
		else
			current_state <= next_state;
	end

endmodule
