module dlatchsr(input ENA, D, CLEAR, PRESET, output reg Q, output QN);

	always @*
		if (PRESET & CLEAR) Q <= 1'bx;
		else if (PRESET)    Q <= 1'b1;
		else if (CLEAR)     Q <= 1'b0;
		else if (ENA)       Q <= D;

	assign QN = ~Q;

endmodule
