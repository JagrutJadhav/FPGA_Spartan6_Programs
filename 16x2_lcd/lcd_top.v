`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:12:29 09/26/2020 
// Design Name: 
// Module Name:    LCD_top 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module LCD_top(
		input clk,
		//input button,
		input rst,
		output [7:0] D,
		output RS,
		output RW,
		output E
    );
	 
parameter init = 4'b0000;
parameter char1 = 4'b0001;
parameter char2 = 4'b0010;
parameter char3 = 4'b0011;
parameter char4 = 4'b0100;
parameter char5 = 4'b0101;
parameter char6 = 4'b0110;
parameter idle = 4'b1111;

parameter init_1 = 3'b000;
parameter init_2= 3'b001;
parameter init_3= 3'b010;
parameter init_4= 3'b100;
parameter init_5= 3'b101;

wire done1;						//ref step down clock signal 
reg RS_out =1'b0;
reg RW_out =1'b0;
reg E_out =1'b0;
reg [7:0] data = 8'h00;
reg [3:0] state = idle;
reg [2:0] init_state = init_1 ;
reg init_E =1'b0;
reg [7:0] init_data = 8'h00; 
reg initiate = 1'b0, init_done = 1'b0;

wire but;

count c (.clk(clk) ,.done(done1));			//instantiation 

//debounce c (.clk(clk),.signal(button),.db(but));	//instantiation 

always @ (posedge done1, posedge rst)
begin
if (rst)
	begin
	RS_out <= 1'b0;
	RW_out <= 1'b0;
	initiate <= 1'b0;
	init_state <= init_1;
	state <= idle;
	end
else 
	begin
		if (E_out == 1'b1)  E_out <= 1'b0;
		else begin
		case (state)
			idle : state <= init;
			init : begin
						initiate <= 1'b1;
						RS_out <= 1'b0;
						//E_out <= 1'b0;
						RW_out <= 1'b0;
						case (init_state) 
						init_1 : begin
										data <= 8'h38;
										E_out <= 1'b1;
										init_state <= init_2;
										end
						init_2 : begin
										data <= 8'h0f;
										E_out <= 1'b1;
										init_state <= init_3;
										end
						init_3 : begin
										data <= 8'h01;
										E_out <= 1'b1;
										init_state <= init_4;
									end
						init_4 : begin
										data <= 8'h80;
										E_out <= 1'b1;
										init_state <= init_4;
										state <= char1;
										end
						init_5 : begin
										//init_data <= 8'h80;
										E_out <= 1'b0;
										state <= char1;
										init_done <= 1'b1;
										init_state <= init_1;
										end
						default :E_out <= 1'b0;
					endcase 
					end
			char1 : begin
							  RS_out <= 1'b1;
						     RW_out <= 1'b0;
							  E_out <= 1'b0;
							  data <= 8'h4a;   //print J
							end
			default : state <= init;
		
		endcase
		end
	end

end


assign RS = RS_out;
assign RW = RW_out;
assign E =  E_out ;
assign D = data;
endmodule



module count (input clk,		// module to step down the clock signal
			output reg done);
reg [31:0] counter = 32'd0; 		
initial begin
done <= 1'b0;
end

always @ (posedge clk) 
begin

	if (counter == 1000)			//300 milli seconds (3000000)
		begin
		done <= ~done;
		counter <= 32'b0;
		end
	else counter <= counter + 1'b1;
end	
endmodule


module debounce (input clk,		// module to debounce signal
				input signal,
				output reg db = 1'b0);  // output debounce signal
reg sig_0 =1'b0;
reg sig_1 = 1'b0;
reg [15:0] count = 16'b0;

always @ (posedge clk) sig_0 <= signal;
always @ (posedge clk) sig_1 <= sig_0;
always @ (posedge clk)
begin
	if(db == sig_1)
	begin
		count <= 16'b0;
	end
	else
		begin
		count<= count+1'b1;
		 if (count == 16'hffff) db <= ~db;
		end

end	

endmodule
