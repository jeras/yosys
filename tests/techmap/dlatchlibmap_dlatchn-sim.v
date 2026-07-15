module dlatchn(input ENA, D, output reg Q, output QN);

	always @*
		if (~ENA)  Q <= D;

	assign QN = ~Q;

endmodule
