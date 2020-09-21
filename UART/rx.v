
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Jagrut Jadhav 
// Module Name:    rx 
//////////////////////////////////////////////////////////////////////////////////
module rx(input data,
			 input baud_clk,
			 input rst,
			 input clk,
			 //input rx_enable,
			 output rx_ready,
			 output rx_in_en,
			 output [7:0] dout
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

reg [3:0] state = bit_1;
reg [7:0] rx_buff = 8'h00;
reg [7:0] rx_buff_out = 8'h00;
reg rx_ready_bit = 1'b1;
reg rx_rst = 1'b0;
reg rx_end = 1'b0;
//reg din = 1'b0;
reg enable = 1'b0;
always @ (posedge rx_rst,posedge baud_clk)
begin
	if (rx_rst)
	begin
		rx_ready_bit <= 1'b1;
		rx_buff <= 8'h00;
		rx_end = 1'b0;
		state <= bit_1;
	end
	else if(enable == 1'b1)
	begin
		rx_end = 1'b0;
		case (state)
		
			
			st_bit : begin
						state <= bit_1;
						rx_ready_bit <= 1'b0;
						end
			bit_1  : begin
						rx_buff[0] <= data;
						rx_ready_bit <= 1'b0;
						state <= bit_2;
						end
			bit_2  : begin
						rx_buff[1] <= data;
						state <= bit_3;
						end
			bit_3  : begin
						rx_buff[2] <= data;
						state <= bit_4;
						end
			bit_4  : begin
						rx_buff[3] <= data;
						state <= bit_5;
						end
			bit_5  : begin
						rx_buff[4] <= data;
						state <= bit_6;
						end
			bit_6  : begin
						rx_buff[5] <= data;
						state <= bit_7;
						end
			bit_7  : begin
						rx_buff[6] <= data;
						state <= bit_8;
						end
			bit_8  : begin
						rx_buff[7] <= data;
						state <= stop;
						end
			stop   : begin
						state <= bit_1;
						rx_ready_bit <= 1'b1;
						rx_end = 1'b1;
						end
			default : state <= bit_1;
		endcase	
	end
end	
always @ (posedge clk, posedge rst)	
begin
if (rst) 
begin
	enable <= 1'b0;
	rx_rst <= 1'b0;
end

else if (rx_end == 1'b1 && enable == 1'b1)
begin
	  enable <= 1'b0;
	  rx_buff_out <= rx_buff;
	  rx_rst <= 1'b1;
end
else if (data == 1'b0)
begin
		enable <= 1'b1;
end
else rx_rst <= 1'b0;


end		
assign dout = rx_buff_out ;
assign rx_in_en = enable;
assign rx_ready = rx_ready_bit;
endmodule
