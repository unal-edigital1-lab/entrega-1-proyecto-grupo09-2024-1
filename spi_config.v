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
	input play_press,
	input feed_press,
	input test_press,
	input test,
	input timer,
	input timer1s,
	input sound,
	input light,
	input [2:0]accel,

	//salidas reales
	output mosi,
	output sclk,
	output sce,
	output dc,
	output rst,
	output reg back
	);
	
	// Variables de pantalla 
	
	wire [7:0] message;
	wire spistart; 
	wire comm;
	wire [15:0]freq_div;
	wire avail;
	assign freq_div=100;//25000 freq deseada 1k (max 4M)div_factor 
	 
	//Variables de estado de la mascota
	reg [2:0] health=1;
	reg [2:0] hunger=1;
	reg [2:0] energy=1;
	reg [2:0] happiness=1;
	
	reg [2:0] test_health=1;
	reg [2:0] test_hunger=1;
	reg [2:0] test_energy=1;
	reg [2:0] test_happiness=1;
	
	reg hungry=0;
	reg sleepy=0;
	reg bored=0;
	reg play=0;
	reg feed=0;
	reg speaker=0;
	
	// Temporizadores de estado
	
	reg [5:0] hunger_sec=0;
	reg [5:0] energy_sec=0;
	reg [5:0] happiness_sec=0;
	
	reg [5:0] hunger_min=0;
	reg [5:0] energy_min=0;
	reg [5:0] happiness_min=0;
	
	reg [3:0] hunger_hour=0;
	reg [3:0] energy_hour=0;
	reg [3:0] happiness_hour=0;
	
	// Modo Test

	reg test_mode=0;
	reg [29:0] pusher=0;
	reg [29:0] speaker_count=0;
	reg allow_press=0;
	reg test_pressed=0;
	reg [3:0] test_case = 0;
	reg [2:0] pet_state = 0;
	
	// Estados de la mascota
	
	
	parameter STAY=0;
	parameter DEAD=1;
	parameter ASLEEP=2;
	
	
	spi_master Spi_Master (.clk(clock),.reset(Reset),.data_in(message),.start(spistart),.div_factor(freq_div),.command(comm),.mosi(mosi),.sclk(sclk),.sce (sce),.avail(avail),.dc(dc),.rst(rst));
	sprites sprites(.rst(Reset),.test(test_mode),.clock(clock),.avail(avail),.health(health),.hunger(hunger),.energy(energy),.happiness(happiness),.spistart(spistart),.comm(comm),.message(message),.play(play),.feed(feed),.pet_state(pet_state), .timer(timer1s), .hungry(hungry),.sleepy(sleepy), .sound(speaker),.bored(bored),.light(light), .accel(accel));
	//Reloj de tiempo de juego
	
	//Reloj de 50MHz
	
	always @(posedge clock) begin
		pusher<=pusher+1;
		if (pusher==150000000) begin
			allow_press<=1;
			pusher<=0;
		end

		if (sound) begin
			speaker<=1;
			speaker_count<=0;
		end
		if (speaker)begin
			speaker_count<=speaker_count+1;
			if (speaker_count==100000000) begin
				speaker<=0;
				speaker_count<=0;
			end
		end 
		if (Reset) begin
			test_mode<=0;
			test_case<=0;
		end
		else if (Reset==0) begin			
			if (test_press) begin
				test_mode<=1;
			end
			if (test_mode) begin
				if (test & allow_press) begin
					allow_press<=0;
					pusher<=0;
					test_case<=test_case+1;
					if (test_case==9) begin
						test_mode<=0;
						test_case<=0;
					end
				end
			end
		end
	end

always @(posedge timer or posedge Reset) 	
	if (Reset) begin
		hunger<=2;
		health <=3;
		happiness <= 2;
		energy <=3;
		
		hunger_sec=0;
		energy_sec=0;
		happiness_sec=0;
	
		hunger_min=0;
		energy_min=0;
		happiness_min=0;
	
		hunger_hour=0;
		energy_hour=0;
		happiness_hour=0;
	end
	else begin
		if (test_mode) begin
			health <= test_health;
			hunger<=test_hunger;
			energy <= test_energy;
			happiness <= test_happiness;
			
			hunger_sec=0;
			energy_sec=0;
			happiness_sec=0;
		
			hunger_min=0;
			energy_min=0;
			happiness_min=0;
		
			hunger_hour=0;
			energy_hour=0;
			happiness_hour=0;
			
		end
		else begin
			//Relojes de Tiempo de juego 
			hunger_sec <= hunger_sec+1;
			if (hunger_sec==59) begin
				hunger_sec<=0;
				hunger_min <= hunger_min+1;
				if (hunger_min==59)begin
					hunger_min<=0;
					hunger_hour <= hunger_hour+1;
				end
			end
			
			energy_sec <= energy_sec+1;
			if (energy_sec==59) begin
				energy_sec<=0;
				energy_min <= energy_min+1;
				if (energy_min==59)begin
					energy_min<=0;
					energy_hour <= energy_hour+1;
				end
			end
				
			happiness_sec <= happiness_sec+1;
			if (happiness_sec==59) begin
				happiness_sec <= 0;
				happiness_min <= happiness_min+1;
				if (happiness_min==59)begin
					happiness_min <= 0;
					happiness_hour<=happiness_hour+1;
				end
			end
			
			// CONDICIONALES DE JUEGO
			
			if (hunger_min == 2)begin
				hunger_min <= 0;
				hunger <= hunger-1;
			end
			
			
		end
	end
	
always @(posedge timer1s or posedge Reset) 	
	begin	
		if (Reset) begin
			
			pet_state <= STAY;
			sleepy<=0;
			bored <=0;
			hungry<=0;
		end 
		else begin
		
		if (test_mode) begin
			case (test_case) 
			1:begin
				pet_state <= DEAD;
				test_health <= 0;
				test_happiness <=0;
				test_hunger <= 0;
				test_energy <= 0;
			end
			
			2:begin
				pet_state <= STAY;
				hungry<=1;
				test_health <= 3;
				test_happiness <=3;
				test_hunger <= 1;
				test_energy <= 4;
			end
			
			3:begin
				sleepy <= 1;
				test_health <= 3;
				test_happiness <=3;
				test_hunger <= 3;
				hungry <=0;
				test_energy <= 1;
			end
			
			4:begin
				sleepy <= 0;
				test_energy <= 4;
				test_happiness <= 1;
				bored <= 1;
			end
			
			5:begin
				hungry<=1;
				test_hunger<=1;
				test_energy<=1;
				sleepy<=1;
			end 
			
			6:begin
				play<=1;
				bored<=0;
				test_happiness <= happiness+1;
			end 
			
			7:begin
				play <=0;
				test_happiness <=3;
				sleepy <= 0;
				pet_state<= ASLEEP;
				test_energy <= energy+1;
			end
			
			8:begin
				test_energy<=4;
				pet_state<=STAY;
				feed<=1;
				test_hunger<= test_hunger+1;
				hungry <= 0;
			end
			
			9:begin
				feed<=0;
				test_hunger<= 3;
				hungry <= 0;
				test_hunger <=2;
				test_energy <=3;
				test_health <=2;
				test_happiness <=2;
			end

			
			endcase
			
		end
		
		
		end
		
	end
			
endmodule
	 

