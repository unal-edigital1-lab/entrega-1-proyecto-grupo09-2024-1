module button_press(
	input clock, //reloj de tiempo natural
	input button,
	input [5:0] sec,
	output reg press
	);
	
reg [5:0] timer=0;  

always @(posedge clock) 
	begin
		if (button & timer!=sec) begin
			timer<=timer+1;
			press<=0;
		end
		else if (timer==sec)begin
			press=1;
			timer<=0;
		end
		else if (button==0) begin
			press<=0;
			timer<=0;
		end
	end
endmodule