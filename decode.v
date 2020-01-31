module decode(
 input FTECH, EXEC1, EXEC2, EQ, MI,
 input [3:0] IR,
 output EXTRA,
 output Wren,
 output MUX1,
 output MUX3,
 output PC_sload,
 output PC_cnt_en,
 output ACC_EN,
 output ACC_LOAD
);


assign EXTRA = (~IR[0] & ~IR[1] & ~IR[2] & ~IR[3] & ~FTECH & EXEC1 & ~EXEC2) + (~IR[0] & ~IR[1] & IR[2] & ~IR[3] & ~FTECH & EXEC1 & ~EXEC2) + (~IR[0] & ~IR[1] & IR[2] & IR[3] & ~FTECH & EXEC1 & ~EXEC2);
assign Wren = (~IR[0] & ~IR[1] & ~IR[2] & IR[3] & ~FTECH & EXEC1 & ~EXEC2);
assign MUX1 = (~IR[0] & ~IR[1] & ~IR[2] & ~IR[3] & ~FTECH & EXEC1 & ~EXEC2) + (~IR[0] & ~IR[1] & ~IR[2] & IR[3] & ~FTECH & EXEC1 & ~EXEC2) + (~IR[0] & ~IR[1] & IR[2] & ~IR[3] & ~FTECH & EXEC1 & ~EXEC2) + (~IR[0] & ~IR[1] & IR[2] & IR[3] & ~FTECH & EXEC1 & ~EXEC2);
assign MUX3 = (~IR[0] & ~IR[1] & ~IR[2] & ~IR[3] & ~FTECH & ~EXEC1 & EXEC2) + (IR[0] & ~IR[1] & ~IR[2] & ~IR[3] & ~FTECH & EXEC1 & ~EXEC2);
assign PC_sload = (~IR[0] & IR[1] & ~IR[2] & ~IR[3] & ~FTECH & EXEC1 & ~EXEC2) + (~IR[0] & IR[1] & ~IR[2] & IR[3] & ~FTECH & EXEC1 & ~EXEC2 & MI) + (~IR[0] & IR[1] & IR[2] & ~IR[3] & ~FTECH & EXEC1 & ~EXEC2 & EQ);
assign PC_cnt_en = (~IR[0] & ~IR[1] & ~IR[2] & ~IR[3] & ~FTECH & ~EXEC1 & EXEC2) + (~IR[0] & ~IR[1] & ~IR[2] & IR[3] & ~FTECH & EXEC1 & ~EXEC2) + (~IR[0] & ~IR[1] & IR[2] & ~IR[3] & ~FTECH & ~EXEC1 & EXEC2) + (~IR[0] & ~IR[1] & IR[2] & IR[3] & ~FTECH & ~EXEC1 & EXEC2) + (~IR[0] & IR[1] & ~IR[2] & IR[3] & ~FTECH & EXEC1 & ~EXEC2 & ~MI) + (~IR[0] & IR[1] & IR[2] & ~IR[3] & ~FTECH & EXEC1 & ~EXEC2 & ~EQ & ~MI) + (IR[0] & ~IR[1] & ~IR[2] & ~IR[3] & ~FTECH & EXEC1 & ~EXEC2);
assign ACC_EN = (~IR[0] & ~IR[1] & IR[2] & ~IR[3] & ~FTECH & ~EXEC1 & EXEC2) + (IR[0] & ~IR[1] & ~IR[2] & ~IR[3] & ~FTECH & EXEC1 & ~EXEC2);
assign ACC_LOAD = (~IR[0] & ~IR[1] & IR[2] & ~IR[3] & ~FTECH & ~EXEC1 & EXEC2) + (IR[0] & ~IR[1] & ~IR[2] & ~IR[3] & ~FTECH & EXEC1 & ~EXEC2);

endmodule