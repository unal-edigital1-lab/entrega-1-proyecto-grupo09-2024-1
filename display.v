`timescale 1ns / 1ps
module display(
    input [18:0] num,
    input clk,
    output [0:6] sseg,
    output reg [5:0] an,
	 input rst,
	 output led
    );
	 
	 
reg [3:0]bcd=0;
//wire [15:0] num=16'h4321;
 
BCDtoSSeg bcdtosseg(.BCD(bcd), .SSeg(sseg));

reg [26:0] cfreq=0;
wire enable;

// Divisor de frecuecia

assign enable = cfreq[16];
assign led =enable;
always @(posedge clk) begin
  if(rst==0) begin
		cfreq <= 0;
	end else begin
		cfreq <=cfreq+1;
	end
end

reg [2:0] count =0;
always @(posedge enable) begin
		if(rst==0) begin
			count<= 0;
			an<=6'b11111; 
		end else begin
			count<= count+1;
			an<=6'b111111; 
			case (count) 	
				3'h0: begin bcd <= num[5:0] % 10;   an<=6'b111110; end 
				3'h1: begin bcd <= (((num[5:0] - (num[5:0] % 10)) / 10) % 10);   an<=6'b111101; end 
				3'h2: begin bcd <= num[11:6] % 10;  an<=6'b111011; end 
				3'h3: begin bcd <= (((num[11:6] - (num[11:6] % 10)) / 10) % 10); an<=6'b110111; end 
				3'h4: begin bcd <= num[17:12] % 10; an<=6'b101111; end
				3'h5: begin bcd <= (((num[17:12] - (num[17:12] % 10)) / 10) % 10); an<=6'b011111; end
			endcase
		end
end

endmodule