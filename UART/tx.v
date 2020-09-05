`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Jagrut Jadhav 
// Module Name:    tx 
//////////////////////////////////////////////////////////////////////////////////
module tx(input [7:0] din,
			 input tx_out_en,
			 input baud_clk,
			 input rst,
			 input clk,
			 output ready,
			 output data
    );
parameter st_bit = 4'b0000;
parameter bit_1  = 4'b0001;
parameter bit_2  = 4'b0010;
parameter bit_3  = 4'b0011;
parameter bit_4  = 4'b0100;
parameter bit_5  = 4'b0101;
parameter bit_6  = 4'b0110;
parameter bit_7  = 4'b0111;
parameter bit_8  = 4'b1000;
parameter stop   = 4'b1001;
parameter idle   = 4'b1111;

reg [3:0] state = idle;
reg [7:0] tx_buff = 8'h00;
reg tx_ready = 1'b1;
reg dout = 1'b1;
wire enable;
always @ (posedge rst,posedge baud_clk)
begin
	if (rst)
	begin
		tx_ready <= 1'b1;
		dout <= 1'b1;
		state <= idle;
	end
	else if(enable)
	begin
		
		case (state)
			idle   : begin
						tx_ready <= 1'b1;
						dout <= 1'b1;
						state <= st_bit;
						end
			st_bit : begin
						tx_ready <= 1'b0;
						dout <= 1'b0;
						state <= bit_1;
						end
			bit_1  : begin
						dout <= tx_buff[0];
						state <= bit_2;
						end
			bit_2  : begin
						dout <= tx_buff[1];
						state <= bit_3;
						end
			bit_3  : begin
						dout <= tx_buff[2];
						state <= bit_4;
						end
			bit_4  : begin
						dout <= tx_buff[3];
						state <= bit_5;
						end
			bit_5  : begin
						dout <= tx_buff[4];
						state <= bit_6;
						end
			bit_6  : begin
						dout <= tx_buff[5];
						state <= bit_7;
						end
			bit_7  : begin
						dout <= tx_buff[6];
						state <= bit_8;
						end
			bit_8  : begin
						dout <= tx_buff[7];
						state <= stop;
						end
			stop   : begin
						dout <= 1'b1;
						state <= idle;
						tx_ready <= 1'b1;
						end
			default : dout <= 1'b1;
		endcase	
	end
end	
always @ (posedge clk, posedge rst)	
begin
if (rst)
	tx_buff <= 8'h00;
else if(enable == 1'b0)
		tx_buff <= din;
end		

assign data = dout;
assign enable = tx_out_en;
assign ready = tx_ready;
endmodule
