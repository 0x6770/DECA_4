module addzero(
input [15:0] ramout,
input useAllBits,
output [15:0] z
);

//assign zero = 0;
//assign z[15:0] = useAllBits ? ramout : {zero,zero,zero,zero,ramout[11:0]};
assign z[15] = useAllBits & ramout[15];
assign z[14] = useAllBits & ramout[14];
assign z[13] = useAllBits & ramout[13];
assign z[12] = useAllBits & ramout[12];
assign z[11:0] = ramout[11:0];

endmodule