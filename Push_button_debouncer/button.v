// Code written by Jagrut Jadhav

module button(	input rst,
					input clk,
					input button,
					output [7:0] LED);
					
reg [7:0] count = 8'd0;
wire but;
reg state = 1'b0;
reg CE= 1'b0,reset = 1'b0;									//ref step down clock signal 
debounce c (.clk(clk),.signal(button),.db(but));	//instantiation 
always @ (posedge but, posedge rst)
begin
if (rst)															// reset leds to 0
begin
	count <= 7'b0;	
end
else
begin
   count <= count + 1'b1;
	if(count == 8'hff)
		count <= 7'b0;
		
end			
end
assign LED = count;
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
