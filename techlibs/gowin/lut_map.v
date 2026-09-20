`default_nettype none

module \$lut (A, Y);
	parameter WIDTH = 0;
	parameter LUT = 0;

	(* force_downto *)
	input [WIDTH-1:0] A;
	output Y;

	wire [1023:0] _TECHMAP_DO_01_ = "RECURSION; flatten;";

	generate case (WIDTH)
		1: LUT1 #(.INIT(LUT)) _TECHMAP_REPLACE_ (.F(Y), .I0(A[0]));
		2: LUT2 #(.INIT(LUT)) _TECHMAP_REPLACE_ (.F(Y), .I0(A[0]), .I1(A[1]));
		3: LUT3 #(.INIT(LUT)) _TECHMAP_REPLACE_ (.F(Y), .I0(A[0]), .I1(A[1]), .I2(A[2]));
		4: LUT4 #(.INIT(LUT)) _TECHMAP_REPLACE_ (.F(Y), .I0(A[0]), .I1(A[1]), .I2(A[2]), .I3(A[3]));
		5: LUT5 #(.INIT(LUT)) _TECHMAP_REPLACE_ (.F(Y), .I0(A[0]), .I1(A[1]), .I2(A[2]), .I3(A[3]), .I4(A[4]));
		6: LUT6 #(.INIT(LUT)) _TECHMAP_REPLACE_ (.F(Y), .I0(A[0]), .I1(A[1]), .I2(A[2]), .I3(A[3]), .I4(A[4]), .I5(A[5]));
		7: LUT7 #(.INIT(LUT)) _TECHMAP_REPLACE_ (.F(Y), .I0(A[0]), .I1(A[1]), .I2(A[2]), .I3(A[3]), .I4(A[4]), .I5(A[5]), .I6(A[6]));
		8: LUT8 #(.INIT(LUT)) _TECHMAP_REPLACE_ (.F(Y), .I0(A[0]), .I1(A[1]), .I2(A[2]), .I3(A[3]), .I4(A[4]), .I5(A[5]), .I6(A[6]), .I7(A[7]));
	endcase endgenerate
endmodule

module \$bmux (A, S, Y);
	parameter WIDTH = 0;
	parameter S_WIDTH = 0;

	input [WIDTH*2**S_WIDTH-1:0] A;
	input [S_WIDTH-1:0] S;
	output [WIDTH-1:0] Y;

	wire [1023:0] _TECHMAP_DO_ = "RECURSION; opt;";

	genvar i, j, k;
	generate
		for (i=0; i<WIDTH; i++) begin: index
			wire [2**S_WIDTH-1:0] AA;

			for (j=0; j<2**S_WIDTH; j++) begin: bitmap
				assign AA[j] = A[i+j*WIDTH];
			end

			case (S_WIDTH)
				1: MUX2  _TECHMAP_REPLACE_ (.O(Y[i]), .I0 (AA[ 0]), .I1 (AA[ 1]),                             .S0(S[0]));
				2: MUX4  _TECHMAP_REPLACE_ (.O(Y[i]), .I0 (AA[ 0]), .I1 (AA[ 1]), .I2 (AA[ 2]), .I3 (AA[ 3]), .S0(S[0]), .S1(S[1]));
				3: MUX8  _TECHMAP_REPLACE_ (.O(Y[i]), .I0 (AA[ 0]), .I1 (AA[ 1]), .I2 (AA[ 2]), .I3 (AA[ 3]), 
				                                      .I4 (AA[ 4]), .I5 (AA[ 5]), .I6 (AA[ 6]), .I7 (AA[ 7]), .S0(S[0]), .S1(S[1]), .S2(S[2]));
				4: MUX16 _TECHMAP_REPLACE_ (.O(Y[i]), .I0 (AA[ 0]), .I1 (AA[ 1]), .I2 (AA[ 2]), .I3 (AA[ 3]),
				                                      .I4 (AA[ 4]), .I5 (AA[ 5]), .I6 (AA[ 6]), .I7 (AA[ 7]),
				                                      .I8 (AA[ 8]), .I9 (AA[ 9]), .I10(AA[10]), .I11(AA[11]),
												      .I12(AA[12]), .I13(AA[13]), .I14(AA[14]), .I15(AA[15]), .S0(S[0]), .S1(S[1]), .S2(S[2]), .S3(S[3]));
				5: MUX32 _TECHMAP_REPLACE_ (.O(Y[i]), .I0 (AA[ 0]), .I1 (AA[ 1]), .I2 (AA[ 2]), .I3 (AA[ 3]),
				                                      .I4 (AA[ 4]), .I5 (AA[ 5]), .I6 (AA[ 6]), .I7 (AA[ 7]),
				                                      .I8 (AA[ 8]), .I9 (AA[ 9]), .I10(AA[10]), .I11(AA[11]),
												      .I12(AA[12]), .I13(AA[13]), .I14(AA[14]), .I15(AA[15]),
												      .I16(AA[16]), .I17(AA[17]), .I18(AA[18]), .I19(AA[19]),
				                                      .I20(AA[20]), .I21(AA[21]), .I22(AA[22]), .I23(AA[23]),
				                                      .I24(AA[24]), .I25(AA[25]), .I26(AA[26]), .I27(AA[27]),
												      .I28(AA[28]), .I29(AA[29]), .I30(AA[30]), .I31(AA[31]), .S0(S[0]), .S1(S[1]), .S2(S[2]), .S3(S[3]), .S4(S[4]));
				default: begin
					// TODO: causes segmentation fault
					wire [2**(S_WIDTH-5):0] YY;

					for (k=0; k<2**(S_WIDTH-5); k++) begin: segment
						\$bmux #(.WIDTH(1), .S_WIDTH(5)) mux (.A(AA[k*2**5+:2**5]), .S(S[4:0]), .Y(YY[k]));
					end

					\$bmux #(.WIDTH(1), .S_WIDTH(S_WIDTH-5)) mux (.A(YY), .S(S[S_WIDTH-1:5]), .Y(Y[i]));
				end
			endcase
		end
	endgenerate
endmodule
