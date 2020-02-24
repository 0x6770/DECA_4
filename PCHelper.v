module PCHelper(
	input [11:0] norm,
	input P,
	input cnt_en, 
	output [11:0] op 
);
//	reg [11:0] one = 000000000001;
//	assign op = (P & cnt_en) ? (pipe + one) : norm;
	assign op = (P & cnt_en) ? (norm + 11'b000000000001) : norm;
endmodule
