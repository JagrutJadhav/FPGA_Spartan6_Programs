`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Jagrut Jadhav
// Module Name:    LCD_top 
//Descriptions : This display uses 4 buttons to send command or data ,
// It has 3 modules instantiated in (UART , Debouncer and clk_divider)
//////////////////////////////////////////////////////////////////////////////////
module lcd_interface(
	input clk,
	input cmd_button,     //this button sends data to the LCD
	input data_button,    // this button sends command to the lcd
	input rst,
	input normal,         // input button to wipe out command and data button ragisters
	input rx_data,	
	output [7:0] D,
	output RS,
	output RW,
	output E,
	output cmd_led,
	output data_led
    );
	 
parameter init = 4'b0000;
parameter cmd_st = 4'b0001;
parameter data_st = 4'b0010;
parameter stop = 4'b0011;

wire done1;			//ref step down clock signal 
reg RS_out =1'b0;
reg RW_out =1'b0;
reg E_out =1'b0;
reg [7:0] data = 8'h00;
reg [3:0] state = init;

wire [7:0] rx_parallel;		//8 bit parallel data fetched from rx 
wire rx_ready;			//indication that we can get the data from rx.(ready = 0 means that it is receieving data from UART and is between process)

reg [7:0] rx_buffer;
wire cmd_but;
wire data_but;
wire norm_but;
reg d_led = 1'b0;
reg c_led =1'b0;

reg c_but = 1'b0;
reg d_but = 1'b0;

count c (.clk(clk) ,.done(done1));		//instantiation 

 uart_top  rx_UART ( .clk(clk),			//system-clk signal
		.rst(rst),			//reset signal active-high
		.rx_data(rx_data),		//rx signal input from UART
		.tx_enable(),			//enable pin to transmit data to activate UART tx. ENABLE SHOULD BE KEPT HIGH UNTIL data is transmitted
		.tx_parallel(),			//8_bit parallel data to bve transmitted to tx
		.rx_parallel(rx_parallel),	//8 bit parallel data fetched from rx 
		.rx_ready(rx_ready),		//indication that we can get the data from rx.(ready = 0 means that it is receieving data from UART and is between process)
		.tx_ready(),			//indication that tx is ready to input value.(ready = 0 means it is transmitting previous data and is between process)
		.tx_data()			//tx signal out to UART
		);

debounce norm_de (.clk(clk),.signal(normal),.db(norm_but));		//instantiation 
debounce cmd_de (.clk(clk),.signal(cmd_button),.db(cmd_but));		//instantiation 
debounce data_de (.clk(clk),.signal(data_button),.db(data_but));	//instantiation 

always @ (posedge clk, posedge rst)
begin
if (rst)
	begin
	rx_buffer <= 8'h00;
	c_led <= 1'b0;
	d_led <= 1'b0;
	c_but <= 1'b0;
   d_but <= 1'b0;
	end
else 
	begin
	rx_buffer <= rx_parallel;
	if(cmd_but == 1'b1)
		begin
			c_led <= 1'b1;
			c_but <= 1'b1;
			d_but <= 1'b0;
			d_led <= 1'b0;
		end
	else if (data_but == 1'b1)
		begin
			c_led <= 1'b0;
			d_led <= 1'b1;
			c_but <= 1'b0;
			d_but <= 1'b1;
		end
	else if (norm_but == 1'b1)
		begin
			c_led <= 1'b0;
			d_led <= 1'b0;
			c_but <= 1'b0;
			d_but <= 1'b0;
		end
	end
end

always  @ (posedge done1, posedge rst)
begin
	if (rst)
	begin
	RS_out <= 1'b0;
	RW_out <= 1'b0;
	state <= init;
	E_out <= 1'b0;
	end
	else
	begin
	case (state)
	init : begin
		E_out <= 1'b0;
		if (c_but == 1'b1)
			state <= cmd_st;
		else if (d_but == 1'b1 )
			state <= data_st;
		end
	cmd_st : begin
		if (rx_ready == 1'b1)
		begin
			E_out <= 1'b1;
			RS_out <= 1'b0;
			data <= rx_buffer;
			state <= stop;
		end
		end
	data_st : begin
		if (rx_ready == 1'b1)
		 begin
			E_out <= 1'b1;
			RS_out <= 1'b1;
			data <= rx_buffer;
			state <= stop;
		 end
		 end
	stop :   begin
		if (norm_but)
			state <= init;
		else state <= stop;
		end
		
	default : E_out <= 1'b0;
	endcase
	end

end

assign RS = RS_out;
assign RW = RW_out;
assign E =  E_out ;
assign D = data;
assign cmd_led = c_led;
assign data_led = d_led;
endmodule

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module count (input clk,		// module to step down the clock signal
			output reg done);
reg [31:0] counter = 32'd0; 		
initial begin
done <= 1'b0;
end

always @ (posedge clk) 
begin

	if (counter == 1000)			
		begin
		done <= ~done;
		counter <= 32'b0;
		end
	else counter <= counter + 1'b1;
end	
endmodule

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
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
