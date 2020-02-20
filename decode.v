module decode(input FETCH,
              input EXEC1,
              input EXEC2,
              input EQ,
              input MI,
              input [3:0] IR,
              input clk,
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
              output MUX3_useAllBits,
              output P,
              output afterE2,
              output TF);
    
    assign P = LDI | LDA | ADD | SUB | LSR;
    
    assign JMP = !IR[3] & IR[2] & !IR[1] & !IR[0];      //* 2
    assign JEQ = !IR[3] & IR[2] & IR[1] & !IR[0];       //* 2
    assign JMI = !IR[3] & IR[2] & !IR[1] & IR[0];       //* 2
    assign LDA = !IR[3] & !IR[2] & !IR[1] & !IR[0];     //* 3
    assign LDI = IR[3] & !IR[2] & !IR[1] & !IR[0];      //! 2
    assign STA = !IR[3] & !IR[2] & !IR[1] & IR[0];      //* 2
    assign ADD = !IR[3] & !IR[2] & IR[1] & !IR[0];      //* 3
    assign SUB = !IR[3] & !IR[2] & IR[1] & IR[0];       //* 3
    assign STP = !IR[3] & IR[2] & IR[1] & IR[0];        //* 2
    assign LSR = IR[3] & !IR[2] & IR[1] & !IR[0];       //! 2
    assign ASR = IR[3] & !IR[2] & IR[1] & IR[0];        //! 2
    
    // instantiate 1-bit DFF for pipeline state
    RisingEdge_DFF pipelineState(
    .D (EXEC2),
    .clk (clk),
    .Q (afterE2)
    );
    
    assign TF = afterE2 & EXEC1 & (LDI | STA | JMP | JMI | JEQ);
    
    assign EXTRA           = LDA & EXEC1 | ADD & EXEC1 | SUB & EXEC1;
    assign Wren            = STA & EXEC1;
    assign MUX1            = LDA & EXEC1 | STA & EXEC1 | ADD & EXEC1 | SUB & EXEC1;
    assign MUX3            = LDA & EXEC2 | LDI & EXEC1;
    assign PC_sload        = JMP & EXEC1 | JMI & EXEC1 & MI | JEQ & EXEC1 & EQ;
    // assign PC_cnt_en    = LDA & EXEC2 | STA & EXEC1 | ADD & EXEC2 | SUB & EXEC2 | JMI & EXEC1 & !MI | JEQ & EXEC1 & !EQ | LDI & EXEC1 | LSR & EXEC1 | ASR & EXEC1;
    assign PC_cnt_en       = FETCH | EXEC1 & (LDA | ADD | SUB) | afterE2 & EXEC1 & (LDI | STA);
    assign ACC_EN          = LDA & EXEC2 | ADD & EXEC2 | SUB & EXEC2 | LDI & EXEC1 | LSR & EXEC1 | ASR & EXEC1;
    assign ACC_LOAD        = LDA & EXEC2 | ADD & EXEC2 | SUB & EXEC2 | LDI & EXEC1;
    assign ADDSUB          = ADD & EXEC2;
    // assign ACC_SHIFTIN  = LSR & EXEC1;
    assign ACC_SHIFTIN     = ASR & EXEC1 & MI;
    // assign ACC_SHIFTIN  = 0;
    assign MUX3_useAllBits = LDA & EXEC2 | LDA & EXEC2 | LSR & EXEC1 | ASR & EXEC1;
    
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
