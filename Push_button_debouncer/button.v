// Code written by Jagrut Jadhav

module button(	input rst,
					input clk,
					input button,
					output [7:0] LED);
					
reg [7:0] count = 8'd1;
wire but;
reg state = 1'b0;
reg CE= 1'b0,reset = 1'b0;									//ref step down clock signal 
//debounce c (.clk(clk),.signal(button),.db(but));	//instantiation 
always @ (posedge button)
begin
		count <= count+1'b1;	
end
assign LED = count;
endmodule

module debounce (input clk,		// module to debounce signal
			input signal,
			output reg db);
reg sig_0;
reg sig_1;
reg [15:0] count;

always @ (posedge clk) sig_0 <= signal;
always @ (posedge clk) sig_1 <= sig_0;
always @ (posedge clk)
begin
	if(db == sig_1)
		count <= 16'b0;
	else
		begin
		count<= count+1'b1;
		 if (count == 16'hffff) db <= ~db;
		 
		end

end	
endmodule




/*module blink (	input clk,				//clock input
					output [7:0] LED);	//8 leds outputs

reg [7:0] LED_status = 8'h00;			//set leds low initially 
reg [7:0] data = 8'h0; 					//case variable
wire done1;									//ref step down clock signal 
count c (.clk(clk),.done(done1));	//instantiation 

always @ (posedge done1)
begin
	case (data)           				// start LED patterns from here
		8'd0: begin 
				LED_status <= 8'b00000001;
				data <= 8'd1;
				end
		8'd1: begin 
				LED_status <= 8'b00000010;
				data <= 8'd2;
				end
		8'd2: begin 
				LED_status <= 8'b00000100;
				data <= 8'd3;
				end
		8'd3: begin 
				LED_status <= 8'b00001000;
				data <= 8'd4;
				end
		8'd4: begin 
				LED_status <= 8'b00010000;
			
			data <= 8'd5;
				end
		8'd5: begin 
				LED_status <= 8'b00100000;
				data <= 8'd6;
				end
		8'd6: begin 
				LED_status <= 8'b01000000;
				data <= 8'd7;
				end
		8'd7: begin 
				LED_status <= 8'b10000000;
				data <= 8'd8;
				end
		8'd8: begin 
				LED_status <= 8'b01000000;
				data <= 8'd9;
				end
		8'd9: begin 
				LED_status <= 8'b00100000;
				data <= 8'd10;
				end
		8'd10: begin 
				LED_status <= 8'b00010000;
				data <= 8'd11;
				end
		8'd11: begin 
				LED_status <= 8'b00001000;
				data <= 8'd12;
				end
		8'd12: begin 
				LED_status <= 8'b00000100;
				data <= 8'd13;
				end
		8'd13: begin 
				LED_status <= 8'b00000010;
				data <= 8'd14;
				end
		8'd14: begin 
				LED_status <= 8'b00000001;
				data <= 8'd15;
				end
		8'd15: begin 
				LED_status <= 8'b0001_1000;
				data <= 8'd16;
				end
		8'd16: begin 
				LED_status <= 8'b0010_0100;
				data <= 8'd17;
				end
		8'd17: begin 
				LED_status <= 8'b0100_0010;
				data <= 8'd18;
				end
		8'd18: begin 
				LED_status <= 8'b1000_0001;
				data <= 8'd19;
				end
		8'd19: begin 
				LED_status <= 8'b1100_0011;
				data <= 8'd20;
				end
		8'd20: begin 
				LED_status <= 8'b1110_0111;
				data <= 8'd21;
				end
		8'd21: begin 
				LED_status <= 8'b1111_1111;
				data <= 8'd22;
				end
		8'd22: begin 
				LED_status <= 8'b1110_0111;
				data <= 8'd23;
				end
		8'd23: begin 
				LED_status <= 8'b1100_0011;
				data <= 8'd24;
				end
		8'd24: begin 
				LED_status <= 8'b1000_0001;
				data <= 8'd25;
				end
		8'd25: begin 
				LED_status <= 8'b0000_0000;
				data <= 8'd26;
				end
		8'd26: begin 
				LED_status <= 8'b0101_0101;
				data <= 8'd27;
				end
		8'd27: begin 
				LED_status <= 8'b1010_1010;
				data <= 8'd28;
				end
		8'd28: begin 
				LED_status <= 8'b0101_0101;
				data <= 8'd29;
				end
		8'd29: begin 
				LED_status <= 8'b1010_1010;
				data <= 8'd30;
				end
		8'd30: begin 
				LED_status <= 8'b0101_0101;
				data <= 8'd31;
				end
		8'd31: begin 
				LED_status <= 8'b1000_0001;
				data <= 8'd32;
				end
		8'd32: begin 
				LED_status <= 8'b0001_1000;
				data <= 8'd0;
				end				
				
		default: data <= 4'h0; 		
	
	
	endcase

end

assign LED = LED_status;		// output to led pins

endmodule



module count (input clk,		// module to step down the clock signal
			output reg done);
reg [31:0] counter = 32'd0; 		
initial begin
done <= 1'b0;
end

always @ (posedge clk) 
begin

	if (counter == 3000000)			//300 milli seconds
		begin
		done <= ~done;
		counter <= 32'b0;
		end
	else counter <= counter + 1'b1;
end	
endmodule*/
