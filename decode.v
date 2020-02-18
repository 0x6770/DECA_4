module decode(input FETCH,             // first cycle of state machine
              input EXEC1,             // second cycle of state machine
              input EXEC2,             // third cycle of state machine
              input EQ,                // whether value in ACC == N
              input MI,                // whether value in ACC is minus
              input clk,               // clk signal for DFF
              input [3:0] IR,          // opcode of instruction
              output EXTRA,            // control line to state machine for whether EXEC2 is needed
              output Wren,             // Wren for RAM
              output MUX1,
              output MUX3,
              output PC_sload,         // PC = N
              output PC_cnt_en,        // PC + = 1
              output ACC_EN,           // enable ACC for shift and load
              output ACC_LOAD,         // when ACC_EN is high, do shift if ACC_LOAD = 0, do load if ACC_LOAD = 1
              output ACC_SHIFTIN,      // value append when shifting value of ACC
              output ADDSUB,           // 1 for add, 0 for sub
              output MUX3_useAllBits); // whether all 16bits from RAM need to be loaded to ACC
    // assign value for opcode
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
    // assign pipeline related var
    assign canPipeline = LDA & EXEC2 | LDI & EXEC1 | ADD & EXEC2 | SUB & EXEC2 | LSR & EXEC1 | ASR & EXEC1;
    // instantiate 1-bit DFF for pipeline state
    RisingEdge_DFF pipelineState(
    .D (canPipeline),
    .clk (clk),
    .Q (BeenPipelined)
    );
    // assign conditions for each control line
    assign EXTRA           = LDA & EXEC1 | ADD & EXEC1 | SUB & EXEC1;
    assign Wren            = STA & EXEC1;
    assign MUX1            = LDA & EXEC1 | STA & EXEC1 | ADD & EXEC1 | SUB & EXEC1;
    assign MUX3            = LDA & EXEC2 | LDI & EXEC1;
    assign PC_sload        = JMP & EXEC1 | JMI & EXEC1 & MI | JEQ & EXEC1 & EQ;
    assign PC_cnt_en       = LDA & EXEC2 | STA & EXEC1 | ADD & EXEC2 | SUB & EXEC2 | JMI & EXEC1 & !MI | JEQ & EXEC1 & !EQ | LDI & EXEC1 | LSR & EXEC1 | ASR & EXEC1;
    assign ACC_EN          = LDA & EXEC2 | ADD & EXEC2 | SUB & EXEC2 | LDI & EXEC1 | LSR & EXEC1 | ASR & EXEC1;
    assign ACC_LOAD        = LDA & EXEC2 | ADD & EXEC2 | SUB & EXEC2 | LDI & EXEC1;
    assign ADDSUB          = ADD & EXEC2;
    // assign ACC_SHIFTIN  = LSR & EXEC1;
    assign ACC_SHIFTIN     = ASR & EXEC1 & MI;
    // assign ACC_SHIFTIN  = 0;
    assign MUX3_useAllBits = LDA & EXEC2 | LSR & EXEC1 | ASR & EXEC1;
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
