`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Jagrut Jadhav
// Module Name:    uart_top 
// Project Name: 
// Target Devices: 
// Tool versions: 1.0
// Description: UART TX/RX
// clk freq used <= 12MHz
// Dependencies: 
// 4800 <= 2500clk <= 0x9C4
// 9600 <= 1250clk <= 0x4E2
// 12500<= 104clk  <= 0x068
//////////////////////////////////////////////////////////////////////////////////
module uart_top( 	input 				clk,					//system-clk signal
									input 				rst,					//reset signal active-high
									input 				rx_data,			//rx signal input from UART
									input 				tx_enable,		//enable pin to transmit data to activate UART tx. ENABLE SHOULD BE KEPT HIGH UNTIL data is transmitted
									input 	[7:0] tx_parallel,	//8_bit parallel data to bve transmitted to tx
									output 	[7:0] rx_parallel,	//8 bit parallel data fetched from rx 
									output 				rx_ready,			//indication that we can get the data from rx.(ready = 0 means that it is receieving data from UART and is between process)
									output 				tx_ready,			//indication that tx is ready to input value.(ready = 0 means it is transmitting previous data and is between process)
									output 				tx_data				//tx signal out to UART
								);
 //Baud generator sognals
 wire baud_rate;
 wire baud_clk;
 wire enable;
 //tx signals
 reg [7:0] din;
 wire ready;
 //rx signals
 wire rx_ready;
 wire rx_in_en;
 wire [7:0] dout;
 
 baud_gen baud						// module to generate baudrate
				(.clk(clk),
				.ena(enable),
				.rst(rst),
				.baud_clk
				);
 

 tx trans (.din(tx_parallel),			// module tx instantiated
			 .tx_out_en(tx_enable),
			 .baud_clk(baud_clk),
			 .rst(rst),
			 .clk(clk),
			 .ready(tx_ready),
			 .data(data)
			);

 rx reci (                 //module rx 
		.data(rx_data), 
		.baud_clk(baud_clk), 
		.rst(rst), 
		.clk(clk), 
		.rx_ready(rx_ready), 
		.rx_in_en(rx_in_en), 
		.dout(dout)
		);	 

assign rx_parallel = dout;
assign enable = tx_enable | rx_in_en;
assign tx_data = tx_enable ? data:1'b1;
endmodule
