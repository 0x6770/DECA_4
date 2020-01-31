module state_machine(
	input EXTRA,
	input [2:0] s,
	output FETCH,
	output EXEC1,
	output EXEC2,
	output [2:0] N
);

assign N2 = 0;
assign N1 = (s[0] & EXTRA);
assign N0 = (~s[2]&~s[1]&~s[0]);
assign FETCH = ~s[2] & ~s[1] & ~s[0];
assign EXEC1 = ~s[2] & ~s[1] & s[0];
assign EXEC2 = ~s[2] & s[1] & ~s[0];

endmodule