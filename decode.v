module decode(input FETCH,                // first cycle of state machine
              input EXEC1,                // second cycle of state machine
              input EXEC2,                // third cycle of state machine
              input EQ,                   // whether value in ACC == N
              input MI,                   // whether value in ACC is minus
              input clk,                  // clk signal for DFF
              input [3:0] IR,             // opcode of instruction
              output EXTRA,               // control line to state machine for whether EXEC2 is needed
              output Wren,                // Wren for RAM
              output MUX1,
              output MUX3,
              output PC_sload,
              output PC_cnt_en,
              output ACC_EN,
              output ACC_LOAD,
              output ACC_SHIFTIN,
              output ADDSUB,
              output MUX3_useAllBits,
	      output P
);
    wire LDA, LDI, ADD, SUB, LSR, ASR, JMI, JEQ;
	 
    assign LDA = !IR[3] & !IR[2] & !IR[1] & !IR[0];
    assign STA = !IR[3] & !IR[2] & !IR[1] & IR[0];
    assign ADD = !IR[3] & !IR[2] & IR[1] & !IR[0];
    assign SUB = !IR[3] & !IR[2] & IR[1] & IR[0];
    assign JMP = !IR[3] & IR[2] & !IR[1] & !IR[0];
    assign JMI = !IR[3] & IR[2] & !IR[1] & IR[0];
    assign JEQ = !IR[3] & IR[2] & IR[1] & !IR[0];
    assign STP = !IR[3] & IR[2] & IR[1] & IR[0];
    assign LDI = IR[3] & !IR[2] & !IR[1] & !IR[0];
    assign LSR = IR[3] & !IR[2] & IR[1] & !IR[0];
    assign ASR = IR[3] & !IR[2] & IR[1] & IR[0];

    assign P 		   = LDA | LDI | ADD | SUB | LSR | ASR | JMP | JMI | JEQ;

    assign EXTRA           = LDA & EXEC1 | ADD & EXEC1 | SUB & EXEC1;
    assign Wren            = STA & EXEC1;
    assign MUX1            = LDA & EXEC1 | STA & EXEC1 | ADD & EXEC1 | SUB & EXEC1;
    assign MUX3            = LDA & EXEC2 | LDI & EXEC1;
    assign PC_sload        = JMP & EXEC1 | JMI & EXEC1 & MI | JEQ & EXEC1 & EQ;
    assign PC_cnt_en       = LDA & EXEC2 | STA & EXEC1 | ADD & EXEC2 | SUB & EXEC2 | JMI & EXEC1 & !MI | JEQ & EXEC1 & !EQ | LDI & EXEC1 | LSR & EXEC1 | ASR & EXEC1;
    assign ACC_EN          = LDA & EXEC2 | ADD & EXEC2 | SUB & EXEC2 | LDI & EXEC1 | LSR & EXEC1 | ASR & EXEC1;
    assign ACC_LOAD        = LDA & EXEC2 | ADD & EXEC2 | SUB & EXEC2 | LDI & EXEC1;
    assign ADDSUB          = ADD & EXEC2;
    // assign ACC_SHIFTIN     = LSR & EXEC1;
    assign ACC_SHIFTIN_np     = ASR & EXEC1 & MI;
    assign ACC_SHIFTIN_p      = ASR & FETCH & MI;
    assign ACC_SHIFTIN        = BeenPipelined ?  ACC_SHIFTIN_p : ACC_SHIFTIN_np;
    // assign ACC_SHIFTIN     = 0;
    assign MUX3_useAllBits_np = LDA & EXEC2 | LSR & EXEC1 | ASR & EXEC1;
    assign MUX3_useAllBits_p  = LDA & EXEC1 | LSR & FETCH | ASR & FETCH;
    assign MUX3_useAllBits    = BeenPipelined ?  MUX3_useAllBits_p : MUX3_useAllBits_np;
    // debug for the value of pipeline state
    assign BeenPipelined_state = BeenPipelined;
    assign canPipeline_state   = canPipeline;
endmodule
    // Verilog code for D Flip FLop
    module RisingEdge_DFF(D,clk,Q);
        input D; // Data input
        input clk; // clock input
        output reg Q; // output Q
        always @(posedge clk)
        begin
            Q <= D;
        end
    endmodule
