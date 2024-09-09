module watch(
	input clock, //reloj de tiempo natural
	output reg [5:0] sec,
	output reg [5:0] min,
	output reg [3:0] hour);
	
always @(posedge clock) 
	begin
		sec<=sec+1;
		if (sec==59) begin
			sec<=0;
			min<=min+1;
			if (min==59)begin
				min<=0;
				hour<=hour+1;
			end
		end
	
	end
endmodule