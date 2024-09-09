module clkgen(clkin,clkoutV, clkout1s, Mdivisor);

input [2:0] Mdivisor;
input clkin;
output reg clkoutV; // output clock after dividing the input clock by divisor
output reg clkout1s; 

reg[27:0] counter=28'd0;
reg [4:0] vtime=7;
reg [4:0] vtime1s=31;

parameter divisor = 781250;

//Mdivisor guide:
// 0 = x16
// 1 = x8
// 2 = x4
// 3 = x2
// 4 = x1

always @(posedge clkin)
	begin
		counter <= counter + 1;
		if(counter==divisor-1)begin
			counter <= 28'd0;
			vtime <=vtime-1;
			vtime1s <=vtime1s-1;
			if (vtime ==0) begin 
				clkoutV = ~clkoutV;
				vtime <= (2 << Mdivisor)-1;
			end 
			if (vtime1s ==0) begin 
				clkout1s = ~clkout1s;
				vtime1s <= 31;
			end 	
		end
	end
endmodule