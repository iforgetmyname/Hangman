module game_process(
	input clk, reset,
	input load,
	input [4:0] load_x,
	input [25:0] mask,

	output reg win, wrong,
	output reg [25:0] current_state
);

	reg [25:0] next_state;

	always @(posedge clk) begin
		if (reset) begin
			current_state <= 26'b0;
			next_state <= 26'b0;
			wrong <= 1'b0;
		end
		else begin
			next_state <= current_state;
			if (load) begin
				next_state[load_x] = 1'b1;
				current_state <= next_state;
				wrong <= (mask[load_x] == 1'b1);
				win <= ((current_state & ~mask) == ~mask);
			end
		end
	end

endmodule