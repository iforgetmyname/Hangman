module keyboard_handler(
    input clk, reset,
    input PS2_DAT, PS2_CLK,

    output pressed,
    output reg [4:0] inputLetter
);

    wire [7:0] keyboardOutCode;
	wire valid;

    keyboard_press_driver kDriver0(
        .CLOCK_50(clk),
		.valid(valid),
        .makeBreak(pressed),
        .outCode(keyboardOutCode[7:0]),

        .PS2_DAT(PS2_DAT),
        .PS2_CLK(PS2_CLK),

        .reset(reset)
    );

    always @(*) begin
		case (keyboardOutCode[7:0])
			8'h1C: inputLetter[4:0] = 5'd0;   // A
			8'h32: inputLetter[4:0] = 5'd1;
			8'h21: inputLetter[4:0] = 5'd2;
			8'h23: inputLetter[4:0] = 5'd3;
			8'h24: inputLetter[4:0] = 5'd4;
			8'h2B: inputLetter[4:0] = 5'd5;
			8'h34: inputLetter[4:0] = 5'd6;
			8'h33: inputLetter[4:0] = 5'd7;
			8'h43: inputLetter[4:0] = 5'd8;
			8'h3B: inputLetter[4:0] = 5'd9;
			8'h42: inputLetter[4:0] = 5'd10;
			8'h4B: inputLetter[4:0] = 5'd11;
			8'h3A: inputLetter[4:0] = 5'd12;
			8'h31: inputLetter[4:0] = 5'd13;
			8'h44: inputLetter[4:0] = 5'd14;
			8'h4D: inputLetter[4:0] = 5'd15;
			8'h15: inputLetter[4:0] = 5'd16;
			8'h2D: inputLetter[4:0] = 5'd17;
			8'h1B: inputLetter[4:0] = 5'd18;
			8'h2C: inputLetter[4:0] = 5'd19;
			8'h3C: inputLetter[4:0] = 5'd20;
			8'h2A: inputLetter[4:0] = 5'd21;
			8'h1D: inputLetter[4:0] = 5'd22;
			8'h22: inputLetter[4:0] = 5'd23;
			8'h35: inputLetter[4:0] = 5'd24;
			8'h1A: inputLetter[4:0] = 5'd25;  // Z
			8'h5A: inputLetter[4:0] = 5'd26;  // Enter
			default : inputLetter [4:0] = 5'd27;
		endcase
	end

endmodule