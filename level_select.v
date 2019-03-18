module level_select(
	input clk,
	input reset,
	
	input start_game,
	input lost_game,
	
	output reg [29:0] word,
	output reg [25:0] mask,
	output reg [3:0] current_state);
	
	reg [3:0] next_state;
	
	localparam LEVEL_1			= 4'b0,
			   LEVEL_2			= 4'b1;
	
	always @(posedge clk) begin
		if (reset) 
			current_state <= LEVEL_1;
		else begin
			case (current_state) 
				LEVEL_1: next_state <= lost_game ? DEAD : LEVEL_2;
				LEVEL_2: next_state <= lost_game ? DEAD : LEVEL_3;
			endcase
		end
	end
	
	always @(*) begin
		word <= 30'b0;
		mask <= 26'b0;
		
		if (reset) 
			word <= 30'b0;
			mask <= 26'b0;
		else begin
			case (current_state)
				LEVEL_1: begin
					word <= 30'b00101_01110_0011_00101_01100_10011;
					mask <= 26'b0000_1010_0001_0100_0010_0000_00;
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
