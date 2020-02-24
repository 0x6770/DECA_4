module state_machine(input EXTRA,
                     input P,
                     output FETCH,
                     output EXEC1,
                     output EXEC2,
                     output [2:0] N,
                     input [2:0] s);

    assign N[2]  = 0;
    assign N[1]  = s[0] & EXTRA;
    assign N[0]  = (!s[2] & !s[1] & !s[0]) | (s[0] & !EXTRA & P) | (s[1] & !EXTRA & P);
    assign FETCH = !s[2] & !s[1] & !s[0];
    assign EXEC1 = !s[2] & !s[1] & s[0];
    assign EXEC2 = !s[2] &  s[1] & !s[0];

endmodule
