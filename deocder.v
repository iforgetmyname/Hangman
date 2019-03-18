module decoder(
	input [7:0] inCode,
	
	output [4:0] outLetter
	);
	
	always @(*) begin
		case (inCode)
			2'h1C: outLetter = 2'd0;
			2'h32: outLetter = 2'd1;
			2'h21: outLetter = 2'd2;
			2'h23: outLetter = 2'd3;
			2'h24: outLetter = 2'd4;
			2'h2B: outLetter = 2'd5;
			2'h34: outLetter = 2'd6;
			2'h33: outLetter = 2'd7;
			2'h43: outLetter = 2'd8;
			2'h3B: outLetter = 2'd9;
			2'h42: outLetter = 2'd10;
			2'h4B: outLetter = 2'd11;
			2'h3A: outLetter = 2'd12;
			2'h31: outLetter = 2'd13;
			2'h44: outLetter = 2'd14;
			2'h4D: outLetter = 2'd15;
			2'h15: outLetter = 2'd16;
			2'h2D: outLetter = 2'd17;
			2'h1B: outLetter = 2'd18;
			2'h2C: outLetter = 2'd19;
			2'h3C: outLetter = 2'd20;
			2'h2A: outLetter = 2'd21;
			2'h1D: outLetter = 2'd22;
			2'h22: outLetter = 2'd23;
			2'h35: outLetter = 2'd24;
			2'h1A: outLetter = 2'd25;
			2'h5A: outLetter = 2'd26;
		endcase
	end
endmodule
