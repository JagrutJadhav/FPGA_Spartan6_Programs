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
module baud_gen				// module to generate baudrate
	(input clk,
	input ena,
	input rst,
	output baud_clk);
					 
parameter baud_rate = 12'h4e2;		//initalize with 9600 baudrate at 12MHz clk
					 
reg [11:0] count = 12'h000;		//set counter to 0
reg signal = 1'b0;			//signal if counter reaches baudrate 
always @ (posedge clk, posedge rst)
begin
if(rst)
	count <= 12'h000;
else 
begin
	if (ena)
	begin
	count <= count + 1'b1;
	if(count >= baud_rate)
	begin
		count <= 12'h000;
		signal <= 1'b1;
	end	
	else
		signal <= 1'b0;
	end
  else count <= 12'h000;	
end	 
end

assign baud_clk = signal;
endmodule					
