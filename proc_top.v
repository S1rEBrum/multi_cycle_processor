module proc_top(DIN, Resetn, Clock, Run, Done, BusWires);

input wire [8:0] DIN;
input wire Resetn, Clock, Run;
output wire Done;
output wire [8:0] BusWires;


proc proc_inst(.DIN(DIN), .Resetn(Resetn), .Clock(Clock),
					.Run(Run), .Done(Done), .BusWires(BusWires));
					
endmodule