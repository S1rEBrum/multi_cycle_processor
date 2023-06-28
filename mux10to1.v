module mux10to1 (
	input wire [8:0] R0,
	input wire [8:0] R1,
	input wire [8:0] R2,
	input wire [8:0] R3,
	input wire [8:0] R4,
	input wire [8:0] R5,
	input wire [8:0] R6,
	input wire [8:0] R7,
	input wire [8:0] DIN,
	input wire [8:0] Gout_bus,
	input wire [7:0] Rout,
	input wire Gout, 
	input wire DINout,
	output reg [8:0] mux_reg //what goes out. the bus
	);
	
	reg [9:0] mux_sel;
	// assign mux_sel={Rout,Gout,DINout};
	
	always @(*)
	begin 
		if (Gout) begin 
			mux_reg <= Gout_bus;
		end else if (DINout) begin 
			mux_reg <= DIN;
		end else if (Rout == 8'b00000001) begin
			mux_reg <= R0;
		end else if (Rout == 8'b00000010) begin
			mux_reg <= R1;
		end else if (Rout == 8'b00000100) begin
			mux_reg <= R2;
		end else if (Rout == 8'b00001000) begin
			mux_reg <= R3;
		end else if (Rout == 8'b00010000) begin
			mux_reg <= R4;
		end else if (Rout == 8'b00100000) begin
			mux_reg <= R5;
		end else if (Rout == 8'b01000000) begin
			mux_reg <= R6;
		end else if (Rout == 8'b10000000) begin
			mux_reg <= R7;
		end 
	end


endmodule