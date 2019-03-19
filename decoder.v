module decoder(
	input [7:0] inCode,
	
	output reg [4:0] outLetter
	);
	
	always @(*) begin
		case (inCode)
			8'h1C: outLetter[4:0] = 5'd0;
			8'h32: outLetter[4:0] = 5'd1;
			8'h21: outLetter[4:0] = 5'd2;
			8'h23: outLetter[4:0] = 5'd3;
			8'h24: outLetter[4:0] = 5'd4;
			8'h2B: outLetter[4:0] = 5'd5;
			8'h34: outLetter[4:0] = 5'd6;
			8'h33: outLetter[4:0] = 5'd7;
			8'h43: outLetter[4:0] = 5'd8;
			8'h3B: outLetter[4:0] = 5'd9;
			8'h42: outLetter[4:0] = 5'd10;
			8'h4B: outLetter[4:0] = 5'd11;
			8'h3A: outLetter[4:0] = 5'd12;
			8'h31: outLetter[4:0] = 5'd13;
			8'h44: outLetter[4:0] = 5'd14;
			8'h4D: outLetter[4:0] = 5'd15;
			8'h15: outLetter[4:0] = 5'd16;
			8'h2D: outLetter[4:0] = 5'd17;
			8'h1B: outLetter[4:0] = 5'd18;
			8'h2C: outLetter[4:0] = 5'd19;
			8'h3C: outLetter[4:0] = 5'd20;
			8'h2A: outLetter[4:0] = 5'd21;
			8'h1D: outLetter[4:0] = 5'd22;
			8'h22: outLetter[4:0] = 5'd23;
			8'h35: outLetter[4:0] = 5'd24;
			8'h1A: outLetter[4:0] = 5'd25;
			8'h5A: outLetter[4:0] = 5'd26;
			default : outLetter [4:0] = 5'd27;
		endcase
	end
endmodule
