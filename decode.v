module decode(
 input FETCH, EXEC1, EXEC2, EQ, MI,
 input [3:0] IR,
 output EXTRA,
 output Wren,
 output MUX1,
 output MUX3,
 output PC_sload,
 output PC_cnt_en,
 output ACC_EN,
 output ACC_LOAD,
 output ACC_SHIFTIN,
 output ADDSUB,
 output MUX3_useAllBits
);

assign LDA = !IR[3] & !IR[2] & !IR[1] & !IR[0];
assign STA = !IR[3] & !IR[2] & !IR[1] & IR[0];
assign ADD = !IR[3] & !IR[2] & IR[1] & !IR[0];
assign SUB = !IR[3] & !IR[2] & IR[1] & IR[0];
assign JMP = !IR[3] & IR[2] & !IR[1] & !IR[0];
assign JMI = !IR[3] & IR[2] & !IR[1] & IR[0];
assign JEQ = !IR[3] & IR[2] & IR[1] & !IR[0];
assign STP = !IR[3] & IR[2] & IR[1] & IR[0];
assign LDI = IR[3] & !IR[2] & !IR[1] & !IR[0];

assign EXTRA = LDA & EXEC1 | ADD & EXEC1 | SUB & EXEC1;
assign Wren = STA & EXEC1;
assign MUX1 = LDA & EXEC1 | STA & EXEC1 | ADD & EXEC1 | SUB & EXEC1;
assign MUX3 = LDA & EXEC2 | LDI & EXEC1;
assign PC_sload = JMP & EXEC1 | JMI & EXEC1 & MI | JEQ & EXEC1 & EQ;
assign PC_cnt_en = LDA & EXEC2 | STA & EXEC1 | ADD & EXEC2 | SUB & EXEC2 | JMI & EXEC1 & !MI | JEQ & EXEC1 & EQ | LDI & EXEC1;
assign ACC_EN = LDA & EXEC2 | ADD & EXEC2 | SUB & EXEC2 | LDI & EXEC1;
assign ACC_LOAD = LDA & EXEC2 | ADD & EXEC2 | SUB & EXEC2 | LDI & EXEC1;
assign ADDSUB = ADD & EXEC2;
assign ACC_SHIFTIN = 0;
assign MUX3_useAllBits = LDA & EXEC2;

endmodule