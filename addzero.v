module addzero(
input [15:0] ramout,
output [15:0] z
);

assign z[11:0] =  ramout[11:0];
assign z[15] = 0;
assign z[14] = 0;
assign z[13] = 0;
assign z[12] = 0;

endmodule