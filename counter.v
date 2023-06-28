module counter (
	input wire clk,
	input wire rstn,
	output wire [4:0] out
	);

	parameter COUNT_TO = 5'b11111;
	reg [4:0] count;
	
	always @(posedge clk or negedge rstn)
	begin 
		if (~rstn)
			begin 
				//out <= 5'b0;
				count <= 0;
			end 
		else if (count > COUNT_TO)
			begin 
				count <= 5'b0;
				//out <= 0;
			end 
		else
			begin 
				//out <= count;
				count <= count + 5'b1;
			end			
	end 
	
assign out = count;
	
endmodule