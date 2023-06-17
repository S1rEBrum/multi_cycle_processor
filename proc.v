module proc (DIN, Resetn, Clock, Run, Done, BusWires); 
input wire [8:0] DIN;
input wire Resetn, Clock, Run;
output reg Done;
output [8:0] BusWires;

// clk cycles
parameter T0 = 2'b00,
			 T1 = 2'b01,
			 T2 = 2'b10,
			 T3 = 2'b11;	

// opcode parameters
parameter MV = 3'b000,
			 MVI = 3'b001,
			 ADD = 3'b010,
			 SUB = 3'b011;
				
// parameter wires
wire [2:0] I;	// 3bit instruction
wire [8:0] IR;	// Instruction register input
wire [7:0] Xreg;	// 1st reg from the input
wire [7:0] Yreg;	// 2nd reg from the input 
wire [8:0] Aout_bus;	// output of reg A
wire [8:0] Gout_bus;	// output of reg G
wire [8:0] R0, R1, R2, R3, R4, R5, R6, R7;	// register R0-R7 inputs 
wire [8:0] AddSubOut;	// add/subtract output 

// parameter regs
reg [1:0] Tstep_Q;	// cs
reg [1:0] Tstep_D;	// ns 
reg IRin, Gin, Ain;
reg AddSub;	// enable regs
reg Gout, DINout;		// enable regs 
reg [7:0] Rin;		// R0-R7 input enable
reg [7:0] Rout;	// R0-R7 output enable 

// decode input to IR
assign I = IR[8:6];
dec3to8 decX (IR[5:3], 1'b1, Xreg); 
dec3to8 decY (IR[2:0], 1'b1, Yreg);

// Control FSM 
always @(*)
	begin 
		case (Tstep_Q)
			T0: begin 
				if (!Run)
					Tstep_D <= T0;		 // If not given Run prompt
				else
					Tstep_D <= T1;
			end 
			T1: begin 
				if (Done)
					Tstep_D <= T0; // return if command is 2 cycles long
				else
					Tstep_D <= T2;
			end
			T2: begin 
				Tstep_D <= T3;
			end 
			T3: begin 
				Tstep_D <= T0;
			end 
			default: Tstep_D <= T0;
		endcase
	end

// Control FSM 
always @(*)
	begin 
		
		// instance for all the regs 
		IRin <= 1'b0;	
		Gin <= 1'b0;
		Ain <= 1'b0;
		Done <= 1'b0;
		Rin <= 8'b0;
		Gout <= 1'b0;
		DINout <= 1'b0;
		Rout <= 8'b0;
		
		case (Tstep_Q) 	// caase cs
			T0: begin  
					IRin <= 1'b1;	// enable reg IR 
				end
			T1:	// first cycle
				case(I)
						MV:
						begin
							Rin <= Xreg;	// read reg X
							Rout <= Yreg;	// write reg Y
							Done <= 1'b1;	// enable Done
						end 
						MVI:
						begin
							Rin <= Xreg;	// write reg X
							DINout <= 1'b1;// enable DINout
							Done <= 1'b1;	// enable Done 
						end
						ADD:
						begin 
							Rout <= Xreg;	// read reg X
							Ain <= 1'b1;	// enable reg A
						end 
						SUB:
						begin 
							Rout <= Xreg;	// read reg X
							Ain <= 1'b1;	// enable reg A
						end 
						endcase		
			T2:	// second cycle
				case(I)
						ADD:
						begin 
							Rout <= Yreg;	// read from reg Y
							Gin <= 1'b1;	// enable reg G
							AddSub <= 1'b1;	// selector for add
						end 
						SUB:
						begin 
							Rout <= Yreg;	// read from reg Y
							Gin <= 1'b1;	// enable reg G in
							AddSub <= 1'b0;	// selector for subtract
						end 
				endcase				
			T3: 
				case(I)
						ADD:
						begin 
							Gout <= 1'b1;	// enable reg G out 
							Rin <= Xreg;	// write to reg X
							Done <= 1'b1;	// enable Done
						end 
						SUB:
						begin 
							Gout <= 1'b1;
							Rin <= Xreg;
							Done <= 1'b1;
						end
				endcase		
		endcase
	end

// Control FSM flip-flops 
always @(posedge Clock, negedge Resetn)
	begin 
		if (!Resetn)
			Tstep_Q <= 2'b0;
		else	
			Tstep_Q <= Tstep_D;
	end

//... instantiate other registers and the adder/subtractor unit
regn reg_0 (BusWires, Rin[0], Clock, Resetn,  R0);
regn reg_1 (BusWires, Rin[1], Clock, Resetn,  R1);
regn reg_2 (BusWires, Rin[2], Clock, Resetn,  R2);
regn reg_3 (BusWires, Rin[3], Clock, Resetn,  R3);
regn reg_4 (BusWires, Rin[4], Clock, Resetn,  R4);
regn reg_5 (BusWires, Rin[5], Clock, Resetn,  R5);
regn reg_6 (BusWires, Rin[6], Clock, Resetn,  R6);
regn reg_7 (BusWires, Rin[7], Clock, Resetn,  R7);

regn reg_A (BusWires, Ain, Clock, Resetn, Aout_bus);
regn reg_G (AddSubOut, Gin, Clock, Resetn, Gout_bus);
regn reg_IR (DIN, Run, Clock, Resetn, IR);

// mux instantiation 
mux10to1 mux10to1_inst(.R0(R0), .R1(R1), .R2(R2), .R3(R3),
 .R4(R4), .R5(R5), .R6(R6), .R7(R7), .DIN(DIN), .Gout_bus(Gout_bus),
 .Rout(Rout), .Gout(Gout), .DINout(DINout), .muxOut(BusWires));	

 //... define the bus 
assign AddSubOut = (AddSub) ? Aout_bus + BusWires : Aout_bus - BusWires;

endmodule
