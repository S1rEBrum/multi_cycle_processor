module part2_top(Resetn, MClock, PClock, Run, Done, BusWires);

//input wire [8:0] DIN;
input wire Resetn, Run;
input wire MClock, PClock;
output wire Done;
output wire [8:0] BusWires;

wire [8:0] q;
wire [4:0] count_out;

// counter instance 
counter counter_inst(.clk(MClock), .rstn(Resetn), .out(count_out));

// memory instance
inst_mem inst_mem(.address(count_out), .clock(MClock), .q(q));

// processor instance 
proc proc_inst(.DIN(q), .Resetn(Resetn), .Clock(PClock),
					.Run(Run), .Done(Done), .BusWires(BusWires));
					
endmodule