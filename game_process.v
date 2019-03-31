module game_process(
	input clk, reset,
	input load,
	input [4:0] load_x,
	input [25:0] mask,

	output reg win, wrong,
	output reg [25:0] current_mask
);

	reg [25:0] next_mask;

	always @(posedge clk) begin
		if (reset) begin
			current_mask <= 26'b0;
			next_mask <= 26'b0;
			win <= 1'b0;
			wrong <= 1'b0;
		end
		else begin
			next_mask <= current_mask;
			if (load) begin
				next_mask[load_x] = 1'b1;
				current_mask <= next_mask;
				wrong <= (mask[load_x] == 1'b1);
				win <= ((current_mask & ~mask) == ~mask);
			end
		end
	end

endmodule