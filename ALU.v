module ALU(
	input wire [8:0] ALUin1,	// a
	input wire [8:0] ALUin2,	// b
	input wire [1:0] sel,		// selector
	output reg [8:0] ALUout);	// output 
	
	parameter ADD = 2'b01;
	parameter SUB = 2'b00;
	parameter MULT = 2'b10;
	//blocking assignment because of combinotoricol logic
	always @(*)
		case (sel)
			ADD:
			begin 
				ALUout = ALUin1 + ALUin2;
			end 
			
			SUB:
			begin 
				ALUout = ALUin1 - ALUin2;
			end
			MULT:
			begin 
				ALUout = (ALUin2 << 1) + ALUin2 + (ALUin2 >> 1);
			end 
		endcase
		
endmodule