module addzero(
input [15:0] ramout,
input useAllBits,
output [15:0] z
);

assign zero = 0;
assign z[11:0] = useAllBits ? ramout : {zero,zero,zero,zero,ramout[11:0]};
//assign z[15] = 0;
//assign z[14] = 0;
//assign z[13] = 0;
//assign z[12] = 0;

endmodule