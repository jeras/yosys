`default_nettype none

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
				1: \$_MUX_   _TECHMAP_REPLACE_ (.A (AA[ 0]), .B (AA[ 1]),                            .S(S[0]), .Y(Y));
				2: \$_MUX4_  _TECHMAP_REPLACE_ (.A (AA[ 0]), .B (AA[ 1]), .C (AA[ 2]), .D (AA[ 3]), .S(S[0]), .T(S[1]), .Y(Y));
				3: \$_MUX8_  _TECHMAP_REPLACE_ (.A (AA[ 0]), .B (AA[ 1]), .C (AA[ 2]), .D (AA[ 3]), 
				                                .E (AA[ 4]), .F (AA[ 5]), .G (AA[ 6]), .H (AA[ 7]), .S(S[0]), .T(S[1]), .U(S[2]), .Y(Y));
				4: \$_MUX16_ _TECHMAP_REPLACE_ (.A (AA[ 0]), .B (AA[ 1]), .C (AA[ 2]), .D (AA[ 3]),
				                                .E (AA[ 4]), .F (AA[ 5]), .G (AA[ 6]), .H (AA[ 7]),
				                                .I (AA[ 8]), .J (AA[ 9]), .K (AA[10]), .L (AA[11]),
												.M (AA[12]), .N (AA[13]), .O (AA[14]), .P (AA[15]), .S(S[0]), .T(S[1]), .U(S[2]), .V(S[3]), .Y(Y));
				5: \$_MUX32_ _TECHMAP_REPLACE_ (.A (AA[ 0]), .B (AA[ 1]), .C (AA[ 2]), .D (AA[ 3]),
				                                .E (AA[ 4]), .F (AA[ 5]), .G (AA[ 6]), .H (AA[ 7]),
				                                .I (AA[ 8]), .J (AA[ 9]), .K (AA[10]), .L (AA[11]),
												.M (AA[12]), .N (AA[13]), .O (AA[14]), .P (AA[15]),
												.QA(AA[16]), .QB(AA[17]), .QC(AA[18]), .QD(AA[19]),
				                                .QE(AA[20]), .QF(AA[21]), .QG(AA[22]), .QH(AA[23]),
				                                .QI(AA[24]), .QJ(AA[25]), .QK(AA[26]), .QL(AA[27]),
												.QM(AA[28]), .QN(AA[29]), .QO(AA[30]), .QP(AA[31]), .S(S[0]), .T(S[1]), .U(S[2]), .V(S[3]), .W(S[4]), .Y(Y));
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

//module \$_MUX_ (input A, B, input S, output Y);
////	\$lut #(.WIDTH(3), .INIT(8'b1100_1010)) lut (.A({S, B, A}), .Y(Y));
//	LUT3 #(.INIT(8'b1100_1010)) mux2 (.F(Y), .I0(A), .I1(B), .I2(S));
//endmodule

module \$_MUX4_ (input A, B, C, D, input S, T, output Y);
	wire y0, y1;
//	\$_MUX_ mux2_0 (.A(A), .B(B), .S(S), .Y(y0));
//	\$_MUX_ mux2_1 (.A(C), .B(D), .S(S), .Y(y1));
	LUT3 #(.INIT(8'b1100_1010)) mux2_0 (.F(y0), .I0(A), .I1(B), .I2(S));
	LUT3 #(.INIT(8'b1100_1010)) mux2_1 (.F(y1), .I0(C), .I1(D), .I2(S));
	MUX2_LUT5 mux2_mux4 (.O(Y), .I0(y0), .I1(y1), .S0(T));
endmodule

module \$_MUX8_ (input A, B, C, D, E, F, G, H, input S, T, U, output Y);
	wire y0, y1;
	\$_MUX4_ _TECHMAP_REPLACE_mux4_0 (.A(A), .B(B), .C(C), .D(D), .S(S), .T(T), .Y(y0));
	\$_MUX4_ _TECHMAP_REPLACE_mux4_1 (.A(E), .B(F), .C(G), .D(H), .S(S), .T(T), .Y(y1));
	MUX2_LUT6 _TECHMAP_REPLACE_mux2_mux8 (.O(Y), .I0(y0), .I1(y1), .S0(U));
endmodule

module \$_MUX16_ (input A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, input S, T, U, V, output Y);
	wire y0, y1;
	\$_MUX8_ _TECHMAP_REPLACE_mux8_0 (.A(A), .B(B), .C(C), .D(D), .E(E), .F(F), .G(G), .H(H), .S(S), .T(T), .U(U), .Y(y0));
	\$_MUX8_ _TECHMAP_REPLACE_mux8_1 (.A(I), .B(J), .C(K), .D(L), .E(M), .F(N), .G(O), .H(P), .S(S), .T(T), .U(U), .Y(y1));
	MUX2_LUT7 _TECHMAP_REPLACE_mux2_mux16 (.O(Y), .I0(y0), .I1(y1), .S0(V));
endmodule

module \$_MUX32_ (input A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, QA, QB, QC, QD, QE, QF, QG, QH, QI, QJ, QK, QL, QM, QN, QO, QP, input S, T, U, V, W, output Y);
	wire y0, y1;
	\$_MUX16_ _TECHMAP_REPLACE_mux16_0 (.A( A), .B( B), .C( C), .D( D), .E( E), .F( F), .G( G), .H( H), .I( I), .J( J), .K( K), .L( L), .M( M), .N( N), .O( O), .P( P), .S(S), .T(T), .U(U), .U(V), .Y(y0));
	\$_MUX16_ _TECHMAP_REPLACE_mux16_1 (.A(QA), .B(QB), .C(QC), .D(QD), .E(QE), .F(QF), .G(QG), .H(QH), .I(QI), .J(QJ), .K(QK), .L(QL), .M(QM), .N(QN), .O(QO), .P(QP), .S(S), .T(T), .U(U), .U(V), .Y(y1));
	MUX2_LUT8 _TECHMAP_REPLACE_mux2_mux32 (.O(Y), .I0(y0), .I1(y1), .S0(W));
endmodule
