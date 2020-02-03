module EQMI(
input [15:0] ACC_OUT,
output MI,
output EQ
);

assign MI = ACC_OUT[15];
assign EQ = ACC_OUT == 0;

endmodule