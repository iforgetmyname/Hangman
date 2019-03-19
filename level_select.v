module level_select(
	input clk,
	input reset,
	
	input start_game,
	input lost_game,
	
	output reg [29:0] word,
	output reg [25:0] mask,
	output reg [3:0] current_state);
	
	reg [3:0] next_state;
	
	localparam LEVEL_1			= 4'd0,
			   LEVEL_2			= 4'd1,
			   LEVEL_3			= 4'd2,
			   DEAD				= 4'd3;

	
	always @(*) begin
		case (current_state) 
			LEVEL_1: next_state = lost_game ? DEAD : LEVEL_2;
			LEVEL_2: next_state = lost_game ? DEAD : LEVEL_1;
			DEAD: next_state = LEVEL_1;
			default: next_state = LEVEL_1;
		endcase
	end
	
	always @(*) begin
		word <= 30'b0;
		mask <= 26'b0;
		
		if (reset) begin
			word <= 30'b0;
			mask <= 26'b0;
		end
		else begin
			case (current_state)
				LEVEL_1: begin
					word <= 30'b00101_01110_0011_00101_01100_10011;
					mask <= 26'b1111_1110_1111_0101_1110_1011_11;
				end
			endcase
		end
	end
	
	always @(posedge clk) begin
		if (reset) 
			current_state <= LEVEL_1;
		else 
			if (start_game)
				current_state <= next_state;
			else
				current_state <= current_state;
	end
endmodule
