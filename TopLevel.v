module TopLevel(
  input test,
  input feed,
  input play,
  input light,
  input sound,
  input clk,
  input rst,
  input accel,
  input [1:0]health,
  output [0:6] sseg,
  output [5:0] an,
  output reg led,
  output sclk,
  output res, 
  output dc,
  output sce,
  output sdin);


clkgen clkgen(.clkin(clk), .clkout(timer), .divisor(50000000));

display display(.num(press), .clk(clk), .rst(rst), .sseg(sseg),.an(an));

spi_config spi_config(.clock(clk), .Reset(rst), . mosi(sdin), .sclk(sclk), .sce(sce), .dc(dc), .rst(res), .health(health), .timer(timer), .play(1));

button_press button_press(.clk(timer), .button(!rst), .press(press));

always @(posedge clk) 
	begin
	end
endmodule