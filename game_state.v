module game_state(
    input clk, reset, load,
    input [4:0] load_x,
    input [25:0] mask,

	output reg wrong,
    output reg [25:0] current_state);

    reg [25:0] next_state;
	
	always @(*) begin
		if (reset)
			next_state = 26'b0;
		else begin
			next_state = current_state;

			if (load) begin
				next_state[load_x] = 1'b1;
			end
		end
	end
	
	always @(posedge clk) begin
		if (reset) begin
			current_state <= 26'b0;
			wrong <= 1'b1;
		end
		else if (load) begin
			current_state <= next_state;
			wrong <= (mask[load_x] == 1'b1);
		end
	end
endmodule