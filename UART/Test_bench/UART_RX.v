`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:26:29 09/21/2020
// Design Name:   uart_top
// Module Name:   C:/Users/Admin/Desktop/FPGA_PRactice/Spartan 6 board/UART/UART_tb.v
// Project Name:  UART
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: uart_top
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module UART_tb;

	// Inputs
	reg clk;
	reg rst;
	reg rx_data;
	// Outputs
	wire [7:0] rx;

	// Instantiate the Unit Under Test (UUT)
	uart_top uut (
		.clk(clk), 
		.rst(rst), 
		.rx_data(rx_data), 
		.rx(rx)
	);
	always #1 clk <= ~clk;
	initial begin
		// Initialize Inputs
		clk = 1'b0;
		rst = 1'b0;
		rx_data = 1'b1;
		
		// Wait 100 ns for global reset to finish
		#5000;
		
		rx_data = 1'b0;
		
		#2500;
		rx_data = 1'b1;
		
		#2500;
		rx_data = 1'b0;
		
		#2500;
		rx_data = 1'b0;
		
		#2500;
		rx_data = 1'b0;
		
		#2500;
		rx_data = 1'b0;
		
		#2500;
		rx_data = 1'b0;
		
		#2500;
		rx_data = 1'b1;
		
		#2500;
		rx_data = 1'b0;
		
		#2500;
		rx_data = 1'b1;
		
		
		
		#1000
		rx_data = 1'b0;
		
		#2500;
		rx_data = 1'b0;
		
		#2500;
		rx_data = 1'b1;
		
		#2500;
		rx_data = 1'b0;
		
		#2500;
		rx_data = 1'b0;
		
		#2500;
		rx_data = 1'b0;
		
		#2500;
		rx_data = 1'b0;
		
		#2500;
		rx_data = 1'b1;
		
		#2500;
		rx_data = 1'b0;
		
		#2500;
		rx_data = 1'b1;
		
		
        
		// Add stimulus here

	end
      
endmodule

