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
module uart_top( input clk,
					input rst,
					 output tx 
					);
 
 wire baud_rate;
 wire baud_clk;
 wire enable;
 reg [7:0] din;
 wire tx_out_en;
 wire ready;
 wire data ;
 reg tx_enable = 1'b0;
 reg rx_enable =1'b0;
 reg [2:0] state =3'b000;
 baud_gen baud						// module to generate baudrate
		   (.clk(clk),
			.ena(enable),
			.rst(rst),
			.baud_clk);
 

 tx trans (.din(din),			// module tx instantiated
			 .tx_out_en(tx_enable),
			 .baud_clk,
			 .rst(rst),
			 .clk(clk),
			 .ready(ready),
			 .data(data)
    );	 
always @ (posedge clk, posedge rst)
begin
	if(rst)
	begin
		tx_enable <= 1'b0;
	end
	else 
	begin
		if (ready == 1'b1)
		begin
			case (state)
			3'b000:begin
						din <= 8'b01000001;
						state <= 3'b001;
					 end
			3'b001: begin
						tx_enable <= 1'b1;
						end
			default : state <= 3'b000;
			endcase
		end
	end

end
assign enable = tx_enable | rx_enable;
assign tx = tx_enable ? data:1'b1;
endmodule

