# DECA lab 4

![4zm8oP](https://cdn.jsdelivr.net/gh/Ouikujie/image@master/Mac/4zm8oP.png)

## 1. MU0 Control Path Design

### 1.1. Implementing the Control Path schematic blocks

##### Task 1. Place the blocks from Figure 2, as required to implement the control path schematic on a new schematic sheet (MU0CPU). If you get this wrong you can always add/delete later.

![006tNbRwgy1gbbhby36a8j31hc0swgot](https://cdn.jsdelivr.net/gh/Ouikujie/image@master/Mac/006tNbRwgy1gbbhby36a8j31hc0swgot-20200312014912563.jpg)



##### Task 2. Configure the properties of each of the blocks you are using, and connect up your mega- function block busses as per the schematic. Where an input bus comes from the Datapath, not yet implemented, connect it to GND so that the circuit will simulate. See Appendix A for help in connecting busses and control signals.

![006tNbRwgy1gbbjgglvp4j31hc0swtcq](https://cdn.jsdelivr.net/gh/Ouikujie/image@master/Mac/006tNbRwgy1gbbjgglvp4j31hc0swtcq.png)



### 1.2. Implementing the State Machine

![lj8lRd](https://cdn.jsdelivr.net/gh/Ouikujie/image@master/Mac/lj8lRd.png)

| S[2] S[1] S[0] | EXTRA | N[2] N[1] N[0] |
| :------------: | :---: | :------------: |
|     0 0 0      |   x   |     0 0 1      |
|     0 0 1      |   0   |     0 0 0      |
|     0 0 1      |   1   |     0 1 0      |
|     0 1 0      |   x   |     0 0 0      |



##### Task 3. Add your state machine to the schematic as a 3 bit register (for state) and a block of combinational logic implementing the NS(2:0) bus and the FETCH, EXEC1 and EXEC2 outputs.

To implement the stat machine, I created a `verilog` file to handle the boolean expression and connected it to  a 3-bit DFF to store the state temporarily. The logic box has a 3-bit input s[2:0] and a 3-bit output n[2:0]. Each bit of n[2:0] is calculated from corresponding boolean expressions. The outputs `FETCH`, `EXEC1`, `EXEC2` are calculated by the boolean expressions of s[2:0]. 

```verilog
assign N[2] = 0;
assign N[1] = !s[2] & !s[1] & s[0] & EXTRA;
assign N[0] = !s[2] & !s[1] & !s[0];
assign FETCH = !s[2] & !s[1] & !s[0];
assign EXEC1 = !s[2] & !s[1] & s[0];
assign EXEC2 = !s[2] & s[1] & !s[0];
```

![](https://cdn.jsdelivr.net/gh/Ouikujie/image@master/Mac/006tNbRwgy1gbbkr7wrlyj31hc0swq6e.png)



##### Task 4. Add another combinational block called DECODE, as in lecture 4 - slide 15. Implement boolean logic for the all necessary control signals in Verilog in this block.

![](https://cdn.jsdelivr.net/gh/Ouikujie/image@master/Mac/006tNbRwgy1gbbkrdrrvjj31hc0swgpy.png)

```verilog
module decode(input FETCH,
              input EXEC1,
              input EXEC2,
              input EQ,
              input MI,
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
              output MUX3_useAllBits);

  	assign LDA = !IR[3] & !IR[2] 	& !IR[1]	& !IR[0];
    assign STA = !IR[3] & !IR[2] 	& !IR[1]	& IR[0];
    assign ADD = !IR[3] & !IR[2] 	& IR[1]		& !IR[0];
    assign SUB = !IR[3] & !IR[2] 	& IR[1]		& IR[0];
    assign JMP = !IR[3] & IR[2] 	& !IR[1] 	& !IR[0];
    assign JMI = !IR[3] & IR[2]		& !IR[1] 	& IR[0];
    assign JEQ = !IR[3] & IR[2]		& IR[1] 	& !IR[0];
    assign STP = !IR[3] & IR[2] 	& IR[1] 	& IR[0];
    assign LDI = IR[3] 	& !IR[2]	& !IR[1]	& !IR[0];
    assign LSR = IR[3] 	& !IR[2] 	& IR[1] 	& !IR[0];
    assign ASR = IR[3] 	& !IR[2]	& IR[1] 	& IR[0];
		
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
    assign ACC_SHIFTIN     = ASR & EXEC1 & MI;
    // assign ACC_SHIFTIN     = 0;
    assign MUX3_useAllBits = LDA & EXEC2 | LDA & EXEC2 | LSR & EXEC1 | ASR & EXEC1;

endmodule
```



### 1.3. Adding a test program and simulating

##### Task 5. Add a simple test program containing the code in Figure *6* and check that the control path works with normal and JMP instructions.

![4_control_path](https://cdn.jsdelivr.net/gh/Ouikujie/image@master/Mac/006tNbRwgy1gbj0j7z9oyj31hc0swjvf.png)

```assembly
# MU0 code 
LDI 5 # ACC = 5
LDI 3 # ACC = 3
JMP 4 # PC = 4
LDI 0 # ACC = 0 (should not be executed)
LDI 1 # ACC = 1
STP		# STOP
```

```assembly
# mif content
0 : 8001;
1 : 8002;
2 : 4004;
3 : 8003;
4 : 8004;
5 : 7000;
```

![image-20200312021222625](https://cdn.jsdelivr.net/gh/Ouikujie/image@master/Mac/image-20200312021222625.png)



## 2. Data path Design

##### Block control signals with operation

| Device       | Input                           | Operation                                                    | 1                                 | 0                                    |
| ------------ | ------------------------------- | ------------------------------------------------------------ | --------------------------------- | ------------------------------------ |
| lpm_add_sub  | add_sub                         | dynamic switching between the adder and subtractor           | Adder                             | Subtractor                           |
| busmux       | sel                             | Select                                                       | datab                             | dataa                                |
| lpm_shiftreg | enable,<br />shiftin,<br />load | enable shiftin and load<br />serial operation<br />parallel operation | Enabled<br />Enabled<br />Enabled | Disabled<br />Disabled<br />Disabled |

### 2.1. Implementing the Data path schematic blocks

##### Task 6. Add the blocks needed for the Data path to your schematic

##### Task 7. Configure the properties of each of the blocks you are using, and connect up your mega-function block busses as per the schematic.

![MU0_data_path_bdf](https://cdn.jsdelivr.net/gh/Ouikujie/image@master/Mac/MU0_data_path_bdf-20200312022211296.PNG)

##### Task 8. Implement boolean logic for all of the necessary Data path control signals in Verilog, either in your existing DECODE block, or in some other new block. Include logic for the MUX3 data input signals, bits (15:12), that are missing from the schematic.

```verilog
module addzero(
  input [15:0] ramout,  // output from RAM
  input useAllBits,			// control signal for whether need to append zero
  output [15:0] z				// output
);
  
  assign z[15]	 = useAllBits & ramout[15]; // RAMout[15] = 0 if do not need all bits
  assign z[14]	 = useAllBits & ramout[14]; // RAMout[14] = 0 if do not need all bits
  assign z[13]	 = useAllBits & ramout[13]; // RAMout[13] = 0 if do not need all bits
  assign z[12]	 = useAllBits & ramout[12]; // RAMout[12] = 0 if do not need all bits
  assign z[11:0] = ramout[11:0];						// the rest of RAMout remains the same

endmodule
```

##### Task 9. Check that you have now connected everything. All signals previously connected to 0, because the Data path was not implemented, should now be connected. No input should be left unconnected (if it is, the circuit will not compile).

I create separate symbols for control path and data path for convenience of debug. 

![MU0_control+data_bdf](https://cdn.jsdelivr.net/gh/Ouikujie/image@master/Mac/MU0_control+data_bdf.PNG)



### 2.2. Adding a test program and simulating

##### Task 10. Add a simple test program and check that the Data path works.

```assembly
##MU0
LDI 0X999       // 0x000: LDI 0x999 # test functionality of LDI
LDA 0X100       // 0x001: LDA 0x100 # test functionality of LDA
LSR             // 0x002: LSR 0x000 # test functionality of LSR
STA 0X111       // 0x003: STA 0x111 # test functionality of STA
LDA 0X111       // 0x004: LDA 0x111 # ACC sould be the same if STA works
LDA 0X100       // 0x005: LDA 0x100 # for later test
ADD 0X101       // 0x006: ADD 0x101 # test functionality of ADD
SUB 0X102       // 0x007: SUB 0x102 # test functionality of SUB
JMP 0X00A       // 0x008: JMP 0x00a # test functionality of JMP
ADD 0X103       // 0x009: ADD 0x103 # should not be executed if JMP works
SUB 0X104       // 0x00a: SUB 0x104 # should be executed if JMP works
JEQ 0X00D       // 0x00b: JEQ 0x00d # test functionality of JEQ # ACC should be 0x0000
ADD 0X105       // 0x00c: ADD 0x105 # should not be executed if JEQ works
SUB 0X103       // 0x00d: SUB 0x103 # should be executed if JEQ works
JMI 0X00B       // 0x00e: JMI 0x00b # test functionality of JMI # ACC should be 0xFFFF
# JMI should mov PC to 0x007 and perform JEQ again with ACC=0x0001, this time
# JEQ should not jump to 0x009
# Furthermore, when executing to 0x00a again, JMI should also not perform jump
#	this time since ACC=0x0000, no infinit loop should be created
STP             // 0x00f: STP 0x000


ORG 0X100       // AREA 0x0100
DCW 0XDDDD      // 0x100: DATA|0xdddd|
DCW 0X1114      // 0x101: DATA|0x1114|
DCW 0X1F00      // 0x102: DATA|0x1f00|
DCW 0X0001      // 0x103: DATA|0x0001|
DCW 0XCFF1      // 0x104: DATA|0xcff1|
DCW 0X0002      // 0x105: DATA|0x0002|

# expected output 
PC=000 A=0000
PC=001 A=0999 IR=8999 // LDI 0x999
PC=002 A=dddd IR=0100 // LDA 0x100
PC=003 A=6eee IR=a000 // LSR 0x000
PC=004 A=6eee IR=1111 // STA 0x111
PC=005 A=6eee IR=0111 // LDA 0x111
PC=006 A=dddd IR=0100 // LDA 0x100
PC=007 A=eef1 IR=2101 // ADD 0x101
PC=008 A=cff1 IR=3102 // SUB 0x102
PC=00a A=cff1 IR=400a // JMP 0x00a
PC=00b A=0000 IR=3104 // SUB 0x104
PC=00d A=0000 IR=600d // JEQ 0x00d
PC=00e A=ffff IR=3103 // SUB 0x103
PC=00b A=ffff IR=500b // JMI 0x00b
PC=00c A=ffff IR=600d // JEQ 0x00d
PC=00d A=0001 IR=2105 // ADD 0x105
PC=00e A=0000 IR=3103 // SUB 0x103
PC=00f A=0000 IR=500b // JMI 0x00b
```

```assembly
# mif content
0 : 8999;
1 : 100;
2 : a000;
3 : 1111;
4 : 111;
5 : 100;
6 : 2101;
7 : 3102;
8 : 400a;
9 : 2103;
a : 3104;
b : 600d;
c : 2105;
d : 3103;
e : 500b;
f : 7000;
100 : dddd;
101 : 1114;
102 : 1f00;
103 : 1;
104 : cff1;
105 : 2;
```

###### Expected output from Visual2DECA

![QOSQWf](https://cdn.jsdelivr.net/gh/Ouikujie/image@master/Mac/QOSQWf.png)

###### The output I got

![image-20200312031403927](https://cdn.jsdelivr.net/gh/Ouikujie/image@master/Mac/image-20200312031403927.png)

![image-20200312031503110](https://cdn.jsdelivr.net/gh/Ouikujie/image@master/Mac/image-20200312031503110.png)



### Challenge

##### • Work out one or more new MU0 instructions - ones that you think will be easy to imple- ment and useful.

I add support to `ASR` in my MU0 CPU. 

```verilog
// Changes made in decoder
// add opcode (0b'1011, 0x'B) for ASR
assign ASR = IR[3] & !IR[2] & IR[1] & IR[0];

// ACC shift in 1 if MSB is 1
assign ACC_SHIFTIN = ASR & EXEC1 & MI;

// include ASR in PC_cnt_en
assign PC_cnt_en = LDA & EXEC2 | STA & EXEC1 | ADD & EXEC2 | SUB & EXEC2 | JMI & EXEC1 & !MI | JEQ & EXEC1 & !EQ | LDI & EXEC1 | LSR & EXEC1 | ASR & EXEC1;

// include ASR in ACC_en
assign ACC_EN = LDA & EXEC2 | ADD & EXEC2 | SUB & EXEC2 | LDI & EXEC1 | LSR & EXEC1 | ASR & EXEC1;
```

```assembly
# code added to mif
f : 106;
10 : b000;
106 : 0xD100;

# expected behaviour
0b'1101000100000000 (0x'D100) -> 0b'1110100010000000 (0x'E880)
```

![image-20200312032737451](https://cdn.jsdelivr.net/gh/Ouikujie/image@master/Mac/image-20200312032737451.png)



##### • Change your state machine and decode logic to speed up your CPU by pipelining instruction FETCH and EXEC1 phases.

My concept is that:

1. My decoder would send a `pipeline` signal when an instruction can be pipelined.
2. The PC helper helps to feed PC+1/N into the address input of RAM when PC+1/N is fed to PC at the same time. This eliminates one cycle delay at PC. 
3. State Machine can jump from `EXEC2` to `EXEC1` and `EXEC1` to `EXEC1` when pipelining happen since `FECTCH` has been performed in `EXEC1` or `EXEC2`. 

```verilog
// decode.v
assign P = LDA | LDI | ADD | SUB | LSR | ASR | JMP | JMI | JEQ;

// PCHelper.v
module PCHelper(
  input [11:0] norm,
  input P,
  input cnt_en,
  input JMP,
  input [11:0] J,
  output [11:0] op
);
  assign op = JMP ? J : (P & cnt_en) ? (norm + 11'b000000000001) : norm;
endmodule

// state_machine.v
module state_machine(
  input EXTRA,
  input P,
  output FETCH,
  output EXEC1,
  output EXEC2,
  output [2:0] N,
  input [2:0] s
)
  assign N[2]  = 0;
  assign N[1]  = !s[2] & !s[1] & s[0] & EXTRA;
  assign N[0]  = (!s[2] & !s[1] & !s[0]) | (!s[2] & !s[1] & s[0] & !EXTRA & P) | (!s[2] & s[1] & !s[0] & P);
  assign FETCH = !s[2] & !s[1] & !s[0];
  assign EXEC1 = !s[2] & !s[1] & s[0];
  assign EXEC2 = !s[2] &  s[1] & !s[0];
endmodule
```



###### Without Pipeline (Total time cost `485ns`)

![image-20200312033054906](https://cdn.jsdelivr.net/gh/Ouikujie/image@master/Mac/image-20200312033054906.png)

![image-20200312033112394](https://cdn.jsdelivr.net/gh/Ouikujie/image@master/Mac/image-20200312033112394.png)

![image-20200312033203850](https://cdn.jsdelivr.net/gh/Ouikujie/image@master/Mac/image-20200312033203850.png)

###### With Pipeline (Total time cost `305ns`)

![image-20200312032833553](https://cdn.jsdelivr.net/gh/Ouikujie/image@master/Mac/image-20200312032833553.png)

![image-20200312032737451](https://cdn.jsdelivr.net/gh/Ouikujie/image@master/Mac/image-20200312032737451.png)