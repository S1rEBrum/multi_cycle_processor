module regn(R, Rin, Clock, Resetn, Q);

parameter n = 9;
input wire [n-1:0] R;
input wire Rin, Clock, Resetn;
output reg [n-1:0] Q;

always @(posedge Clock or negedge Resetn)
	if (~Resetn)
		Q <= 0;
	else if (Rin)
		Q <= R;
endmodule
