`timescale 1ns / 1ps


module TB;

	// Inputs
	reg rst;
	reg clk;
	reg button;

	// Outputs
	wire [7:0] LED;

	// Instantiate the Unit Under Test (UUT)
	button uut (
		.rst(rst), 
		.clk(clk), 
		.button(button), 
		.LED(LED)
	);
	always
begin
	#1 clk <= ~clk;
end
	initial begin
		// Initialize Inputs
		rst = 0;
		clk = 0;
		button = 0;
	
		// Wait 1 ns for global reset to finish
		#1;
	

	button = 1'b1;
	#1
	button = 1'b0;
	#2;
	button = 1'b1;
	#1
	button = 1'b0;
	#1;
	button = 1'b1;
	#2;
	button = 1'b0;
	#1;
	button = 1'b1;
end
      
endmodule

