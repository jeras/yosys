`default_nettype none

module \$lut (A, Y);
	parameter WIDTH = 0;
	parameter LUT = 0;

	(* force_downto *)
	input [WIDTH-1:0] A;
	output Y;

	generate case (WIDTH)
		1: begin
			LUT1 #(.INIT(LUT)) _TECHMAP_REPLACE_ (.F(Y), .I0(A[0]));
		end
		2: begin
			LUT2 #(.INIT(LUT)) _TECHMAP_REPLACE_ (.F(Y), .I0(A[0]), .I1(A[1]));
		end
		3: begin
			LUT3 #(.INIT(LUT)) _TECHMAP_REPLACE_ (.F(Y), .I0(A[0]), .I1(A[1]), .I2(A[2]));
		end
		4: begin
			LUT4 #(.INIT(LUT)) _TECHMAP_REPLACE_ (.F(Y), .I0(A[0]), .I1(A[1]), .I2(A[2]), .I3(A[3]));
		end
		5: begin
			wire f0, f1;
			\$lut #(.LUT(LUT[15: 0]), .WIDTH(4)) lut0 (.A(A[3:0]), .Y(f0));
			\$lut #(.LUT(LUT[31:16]), .WIDTH(4)) lut1 (.A(A[3:0]), .Y(f1));
			MUX2_LUT5 mux5(.I0(f0), .I1(f1), .S0(A[4]), .O(Y));
		end
		6: begin
			wire f0, f1;
			\$lut #(.LUT(LUT[31: 0]), .WIDTH(5)) lut0 (.A(A[4:0]), .Y(f0));
			\$lut #(.LUT(LUT[63:32]), .WIDTH(5)) lut1 (.A(A[4:0]), .Y(f1));
			MUX2_LUT6 mux6(.I0(f0), .I1(f1), .S0(A[5]), .O(Y));
		end
		7: begin
			wire f0, f1;
			\$lut #(.LUT(LUT[ 63:  0]), .WIDTH(6)) lut0 (.A(A[5:0]), .Y(f0));
			\$lut #(.LUT(LUT[127: 64]), .WIDTH(6)) lut1 (.A(A[5:0]), .Y(f1));
			MUX2_LUT7 mux7(.I0(f0), .I1(f1), .S0(A[6]), .O(Y));
		end
		8: begin
			wire f0, f1;
			\$lut #(.LUT(LUT[127:  0]), .WIDTH(7)) lut0 (.A(A[6:0]), .Y(f0));
			\$lut #(.LUT(LUT[255:128]), .WIDTH(7)) lut1 (.A(A[6:0]), .Y(f1));
			MUX2_LUT8 mux8(.I0(f0), .I1(f1), .S0(A[7]), .O(Y));
		end
		default: begin
			wire _TECHMAP_FAIL_ = 1;
		end
	endcase endgenerate
endmodule
