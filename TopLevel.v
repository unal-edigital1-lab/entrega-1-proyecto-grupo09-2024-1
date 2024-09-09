module TopLevel(
  input test,
  input feed,
  input play,
  input light,
  input sound,
  input clk,
  input rst,
  input health,
  
  output [0:6] sseg,
  output [5:0] an,
  output reg led,
  output sclk,
  output res, 
  output dc,
  output sce,
  output sdin);

initial begin
led<=1;
end
  
wire [5:0] sec;
wire [5:0] min;
wire [5:0] hour;

reg [2:0] accel=4;
reg [29:0] pusher=0;
reg allow_press=0;

wire timer;
wire timer1s;
wire rst_press;
wire [17:0] time_teller;

assign time_teller = {hour,min,sec};
//Mdivisor guide:
// 0 = x16
// 1 = x8
// 2 = x4
// 3 = x2
// 4 = x1

clkgen clkgen(.clkin(clk), .clkoutV(timer), .clkout1s(timer1s), .Mdivisor(accel));

display display(.num(time_teller), .clk(clk), .rst(!rst_press), .sseg(sseg),.an(an));

spi_config spi_config(.clock(clk), .Reset(rst_press), .mosi(sdin), .sclk(sclk), .sce(sce), .dc(dc), .rst(res), .play_press(!play), .feed_press(!feed), .test_press(test_press), .test(!test), .timer(timer), .timer1s(timer1s), .sound(!sound), .light(!light), .accel(accel));

watch watch(.clock(timer), .sec(sec), .min(min), .hour(hour));

button_press button_press(.clock(timer1s), .button(!test), .sec(4),.press(test_press));

button_press(.clock(timer1s), .button(!rst), .sec(4),.press(rst_press));

always @(posedge clk) 
	begin
		if (accel > 4) accel<=4;
		pusher<=pusher+1;
		if (pusher==50000000) begin
			allow_press<=1;
			pusher<=0;
		end
		if (!rst & allow_press) begin
			allow_press<=0;
			pusher<=0;
			accel<=accel-1;
			
		end
	end
endmodule