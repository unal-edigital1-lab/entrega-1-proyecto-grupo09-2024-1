/*
Este modulo configura y controla las variables que seran enviadas al spi_ master

ENTRADAS DESDE FPGA
										_______________
									  |               |
(de la fpga, pin)	clock	-----|               |----> clk
(boton)				Reset	-----|               |---->rst
									  |       message |----> data_in[7:0] 
									  |       spistart|----> start 
									  |       freq    |----> freq_div[15:0]  
									  |     		      |---- > data_out [7:0](se pone por coherencia pero no sirve xd)
							        |               |---- > busy
									  |               |---- >avail
									  |_______comm____|----> command


*/


module spi_config(
   input clock,
	input Reset,
	input [1:0] health,
	input timer,
	input play,
	//salidas reales
	output mosi,
	output sclk,
	output sce,
	output dc,
	output rst,
	output reg back
	//output reg [2:0]test,
	//output reg [7:0] message
	);
	
	//registros a utilizar/modificar en este modulo
	wire [7:0] message;
	wire spistart; 
	wire comm;
	
	wire [15:0]freq_div;
	wire avail;
	
	assign freq_div=1000;//25000 freq deseada 1k (max 4M)div_factor 
	 
	
	spi_master Spi_Master (
		.clk(clock),
		.reset(~Reset),
		.data_in(message),
		.start(spistart),
		.div_factor(freq_div),
		.command(comm),
		.mosi(mosi),
		.sclk(sclk),
		.sce (sce),
		.avail(avail),
		.dc(dc),
		.rst(rst)
	);

	sprites sprites(
   .clock(clock),
	.avail(avail),
	.health(health),
	.spistart(spistart),
	.comm(comm),
	.message(message),
	.timer(timer),
	.play(play)
	);
 
	always @(posedge clock) begin
	
	end
	 
endmodule
	 

