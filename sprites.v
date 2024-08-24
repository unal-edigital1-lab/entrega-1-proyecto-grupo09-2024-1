/*
Este modulo es un "banco" de los pasos seguidos para dibujar cada uno de los sprites.
Tambien contiene el ciclo que mantiene a la pantalla dibujando constantemente
*/


module sprites(
   input clock,
	input avail,	
	input [1:0] health,
	input timer,
	input play,
	
	output reg spistart,
	output reg comm,
	output reg [7:0] message
	);
	
// variables de dibujo	
	reg [4:0] row=0;
	reg [1:0] drawn_hearts=0;
	reg [1:0] drawn_smiles=0;
	reg [1:0] drawn_bones=0;
	reg [1:0] drawn_bat=0;
	
	reg [5:0] heart_pos=2;
	reg [6:0] smile_pos=50;
	reg [6:0] bone_pos=48;
	reg [6:0] bat_pos=8;
	
	reg [4:0] state=4'h0;
	reg [5:0] count=4'h0;
	reg [6:0] trainer_pos=70;
	
	reg comp=0; //Permite ejecutar eventos solo con el reloj timer (de segundos)
	
	reg [5:0] animation_timer=0; // contador de segundos 
	
	parameter INIT=4'h0;
	parameter HEART=4'h1;
	parameter IDLE=4'h2;
	parameter BODY_A_1=4'h3;
	parameter BODY_A_2=4'h4;
	parameter BODY_B_1=4'h5;
	parameter BODY_B_2=4'h6;
	parameter NO_HEART=4'h7;
	parameter SMILE=4'h8;
	parameter NO_SMILE=4'h9;
	parameter TRAINER_A_1=4'hA;
	parameter TRAINER_A_2=4'hB;
	parameter TRAINER_B_1=4'hC;
	parameter TRAINER_B_2=4'hD;
	parameter DARK_MODE=4'hE;
	parameter BONE=4'hF;
	parameter NO_BONE=16;
	parameter BATTERY=17;
	parameter BATTERY_LEVEL=18;
	parameter NO_BATTERY_LEVEL=19;
	
	reg [10:0] i=0;
	
always @(posedge clock) begin
case(state) 
		INIT:begin //configuracion 
			case(count)
			4'h0:begin  spistart<=1;	comm<=0; 
			if (avail) count<=4'h1;
			end
			
			4'h1: begin message<=8'b00100001;
			if (avail) count<=4'h2;
			end
			
			4'h2:begin  message<=8'b10010000;	 
			if (avail) count<=4'h3;
			end
			
			4'h3: begin message<=8'b00100000; 
			if(avail) count<=4'h4;
			end
			
			4'h4: begin	message<=8'b00001100; 
			if(avail) count<=4'h5;
			end
			
			4'h5: begin	 comm<=1; message<=8'h0; //limpia la pantalla
			if(avail) begin 
				if (i<=503) begin 
					i<=i+1;
					count<=4'h5;
					end 
				else 
				begin 
				state<=IDLE;
				count<=4'h0;
				i<=0;
				end
				end
			end
			
			4'h6: begin  message<=8'b000101;
			if (avail) spistart<=0;
			end
			
			endcase
		end
		
		DARK_MODE:begin //configuracion 
			case(count)
			4'h0:begin  spistart<=1;	comm<=0; 
			if (avail) count<=4'h1;
			end
			
			4'h1: begin  message<=8'b00001101;
			if (avail) spistart<=0;
			state<=IDLE;
			count<=0;
			end
			
			endcase
		end
		
		HEART: begin //dibujar
			case(count)
			4'h0: begin spistart<=1; comm<=0; message<=heart_pos+128;// Coordinates X=2
			if(avail) count<=4'h1;
			end
			
			4'h1: begin message<=8'b01000001; // en y 3
			if(avail) count<=4'h2;
			end
			
			4'h2: begin message<=8'b01000001; // en y 3
			if(avail) count<=4'h3;
			end
			
			4'h3: begin comm<=1; message<=8'b00011110;//dibujo 
			if(avail) count<=4'h4;
			end
			
			4'h4: begin message<=8'b00111011; 
			if(avail) count<=4'h5;
			end
			
			4'h5: begin	message<=8'b01110111;
			if(avail) count<=4'h6;
			end
			
			4'h6: begin message<=8'b11111110;
			if(avail) count<=4'h7;
			end
			
			4'h7: begin message<=8'b11111110;
			if(avail) count<=4'h8;
			end
			
			4'h8: begin	message<=8'b01111111;
			if(avail) count<=4'h9;
			end
			
			4'h9: begin message<=8'b00111111;
			if(avail) count<=4'hA;
			end
			
			4'hA: begin message<=8'b00011110;
			if(avail) begin
			spistart=0;
			state<=IDLE;
			count<=0;
			heart_pos <= heart_pos + 12;
			end
			end
			endcase
		end
		
		SMILE: begin //dibujar
			case(count)
			4'h0: begin spistart<=1; comm<=0; message<=smile_pos+128;// Coordinates X=2
			if(avail) count<=4'h1;
			end
			
			4'h1: begin message<=8'b01000001; // en y 3
			if(avail) count<=4'h2;
			end
			
			4'h2: begin message<=8'b01000001; // en y 3
			if(avail) count<=4'h3;
			end
			
			4'h3: begin comm<=1; message<=8'b00111100;//dibujo 
			if(avail) count<=4'h4;
			end
			
			4'h4: begin message<=8'b01000010; 
			if(avail) count<=4'h5;
			end
			
			4'h5: begin	message<=8'b10010101;
			if(avail) count<=4'h6;
			end
			
			4'h6: begin message<=8'b10100001;
			if(avail) count<=4'h7;
			end
			
			4'h7: begin message<=8'b10100001;
			if(avail) count<=4'h8;
			end
			
			4'h8: begin	message<=8'b10010101;
			if(avail) count<=4'h9;
			end
			
			4'h9: begin message<=8'b01000010;
			if(avail) count<=4'hA;
			end
			
			4'hA: begin message<=8'b00111100;
			if(avail) begin
			spistart=0;
			state<=IDLE;
			count<=0;
			smile_pos <= smile_pos + 12;
			end
			end
			endcase
		end
		
		BONE: begin //dibujar
			case(count)
			4'h0: begin spistart<=1; comm<=0; message<=bone_pos+128;// Coordinates X=2
			if(avail) count<=4'h1;
			end
			
			4'h1: begin message<=8'b01000100; // y=4
			if(avail) count<=4'h2;
			end
			
			4'h2: begin message<=8'b01000100; //
			if(avail) count<=4'h3;
			end
			
			4'h3: begin comm<=1; message<=8'b01111100;//dibujo 
			if(avail) count<=4'h4;
			end
			
			4'h4: begin message<=8'b10010010; 
			if(avail) count<=4'h5;
			end
			
			4'h5: begin	message<=8'b10000010;
			if(avail) count<=4'h6;
			end
			
			4'h6: begin message<=8'b01101100;
			if(avail) count<=4'h7;
			end
			
			4'h7: begin message<=8'b00101000;
			if(avail) count<=4'h8;
			end
			
			4'h8: begin	message<=8'b00101000;
			if(avail) count<=4'h9;
			end
			
			4'h9: begin message<=8'b00101000;
			if(avail) count<=4'hA;
			end
			
			4'hA: begin message<=8'b01101100;
			if(avail) count<=4'hB;
			end
			
			4'hB: begin message<=8'b10000010;
			if(avail) count<=4'hC;
			end
			
			4'hC: begin message<=8'b10010010;
			if(avail) count<=4'hD;
			end
			
			4'hD: begin message<=8'b01111100;
			if(avail) begin
			spistart=0;
			state<=IDLE;
			count<=0;
			bone_pos <= bone_pos + 12;
			end
			end
			endcase
		end
		
		BATTERY: begin //dibujar
			case(count)
			4'h0: begin spistart<=1; comm<=0; message<=134; i<=0;// Coordinates X=2
			if(avail) count<=4'h1;
			end
			
			4'h1: begin message<=8'b01000100; // y=4
			if(avail) count<=4'h2;
			end
			
			4'h2: begin message<=8'b01000100; //
			if(avail) count<=4'h3;
			end
			
			4'h3: begin comm<=1; message<=8'b11111111;//dibujo 
			if(avail) count<=4'h4;
			end
			
			4'h4: begin message<=8'b10000001; 
			if(avail & i==3) begin
				count<=4'h5;
				i<=0; 
			end
			else if (avail)begin
				i<=i+1;
			end
			end
			
			4'h5: begin comm<=1; message<=8'b11111111; i<=0;//dibujo 
			if(avail) count<=4'h6;
			end
			
			4'h6: begin message<=8'b10000001; 
			if(avail & i==3) begin
				count<=4'h7;
				i<=0; 
			end
			else if (avail)begin
				i<=i+1;
			end
			end
			
			4'h7: begin comm<=1; message<=8'b11111111; i<=0;//dibujo 
			if(avail) count<=4'h8;
			end
			
			4'h8: begin message<=8'b10000001; 
			if(avail & i==3) begin
				count<=4'h9;
				i<=0; 
			end
			else if (avail)begin
				i<=i+1;
			end
			end
			
			4'h9: begin comm<=1; message<=8'b11111111; i<=0;//dibujo 
			if(avail) count<=4'hA;
			end
			
			4'hA: begin message<=8'b10000001; 
			if(avail & i==3) begin
				count<=4'hB;
				i<=0; 
			end
			else if (avail)begin
				i<=i+1;
			end
			end
			
			4'hB: begin comm<=1; message<=8'b11111111; i<=0;//dibujo 
			if(avail) count<=4'hC;
			end
			
			4'hC: begin comm<=1; message<=8'b01111110; i<=0;//dibujo 
			if(avail) count<=4'hD;
			end
			
			4'hD: begin message<=8'b01111110;
			if(avail) begin
			spistart=0;
			state<=IDLE;
			count<=0;
			end
			end
			endcase
		end
		
		BATTERY_LEVEL: begin //dibujar
			case(count)
			4'h0: begin spistart<=1; comm<=0; message<=bat_pos+128;// Coordinates X=2
			if(avail) count<=4'h1;
			end
			
			4'h1: begin message<=8'b01000100; // y=4
			if(avail) count<=4'h2;
			end
			
			4'h2: begin message<=8'b01000100; //
			if(avail) count<=4'h3;
			end
			
			4'h3: begin comm<=1; message<=8'b10111101;//dibujo 
			if(avail) count<=4'h4;
			end
			
			4'h4: begin message<=8'b10111101;
			if(avail) begin
			spistart=0;
			state<=IDLE;
			count<=0;
			bat_pos <= bat_pos + 5;
			end
			end
			endcase
		end
		
		NO_BATTERY_LEVEL: begin //dibujar
			case(count)
			4'h0: begin spistart<=1; comm<=0; message<=bat_pos+128;// Coordinates X=2
			if(avail) count<=4'h1;
			end
			
			4'h1: begin message<=8'b01000100; // y=4
			if(avail) count<=4'h2;
			end
			
			4'h2: begin message<=8'b01000100; //
			if(avail) count<=4'h3;
			end
			
			4'h3: begin comm<=1; message<=8'b10000001;//dibujo 
			if(avail) count<=4'h4;
			end
			
			4'h4: begin message<=8'b10000001;
			if(avail) begin
			spistart=0;
			state<=IDLE;
			count<=0;
			bat_pos <= bat_pos + 5;
			end
			end
			endcase
		end
		
		
		
		NO_HEART: begin //dibujar
			case(count)
			4'h0: begin spistart<=1; comm<=0; message<=heart_pos+128;// Coordinates X=2
			if(avail) count<=4'h1;
			end
			
			4'h1: begin message<=8'b01000001; // en y 3
			if(avail) count<=4'h2;
			end
			
			4'h2: begin message<=8'b01000001; // en y 3
			if(avail) count<=4'h3;
			end
			
			4'h3: begin comm<=1; message<=8'b0000;//dibujo 
			if(avail) count<=4'h4;
			end
			
			4'h4: begin message<=8'b00; 
			if(avail) count<=4'h5;
			end
			
			4'h5: begin	message<=8'b0;
			if(avail) count<=4'h6;
			end
			
			4'h6: begin message<=8'b0;
			if(avail) count<=4'h7;
			end
			
			4'h7: begin message<=8'b0;
			if(avail) count<=4'h8;
			end
			
			4'h8: begin	message<=8'b0;
			if(avail) count<=4'h9;
			end
			
			4'h9: begin message<=8'b0;
			if(avail) count<=4'hA;
			end
			
			4'hA: begin message<=8'b0;
			if(avail) begin
			spistart=0;
			state<=IDLE;
			count<=0;
			heart_pos <= heart_pos + 12;
			end
			end
			endcase
		end
		
		NO_SMILE: begin //dibujar
			case(count)
			4'h0: begin spistart<=1; comm<=0; message<=smile_pos+128;// Coordinates X=2
			if(avail) count<=4'h1;
			end
			
			4'h1: begin message<=8'b01000001; // en y 3
			if(avail) count<=4'h2;
			end
			
			4'h2: begin message<=8'b01000001; // en y 3
			if(avail) count<=4'h3;
			end
			
			4'h3: begin comm<=1; message<=8'b0000;//dibujo 
			if(avail) count<=4'h4;
			end
			
			4'h4: begin message<=8'b00; 
			if(avail) count<=4'h5;
			end
			
			4'h5: begin	message<=8'b0;
			if(avail) count<=4'h6;
			end
			
			4'h6: begin message<=8'b0;
			if(avail) count<=4'h7;
			end
			
			4'h7: begin message<=8'b0;
			if(avail) count<=4'h8;
			end
			
			4'h8: begin	message<=8'b0;
			if(avail) count<=4'h9;
			end
			
			4'h9: begin message<=8'b0;
			if(avail) count<=4'hA;
			end
			
			4'hA: begin message<=8'b0;
			if(avail) begin
			spistart=0;
			state<=IDLE;
			count<=0;
			smile_pos <= smile_pos + 12;
			end
			end
			endcase
		end
		
		NO_BONE: begin //dibujar
			case(count)
			4'h0: begin spistart<=1; comm<=0; message<=bone_pos+128;// Coordinates X=2
			if(avail) count<=4'h1;
			end
			
			4'h1: begin message<=8'b01000100; // y=4
			if(avail) count<=4'h2;
			end
			
			4'h2: begin message<=8'b01000100; //
			if(avail) count<=4'h3;
			end
			
			4'h3: begin comm<=1; message<=8'b000;//dibujo 
			if(avail) count<=4'h4;
			end
			
			4'h4: begin message<=8'b0; 
			if(avail) count<=4'h5;
			end
			
			4'h5: begin	message<=8'b00000;
			if(avail) count<=4'h6;
			end
			
			4'h6: begin message<=8'b000;
			if(avail) count<=4'h7;
			end
			
			4'h7: begin message<=8'b00000;
			if(avail) count<=4'h8;
			end
			
			4'h8: begin	message<=8'b00000;
			if(avail) count<=4'h9;
			end
			
			4'h9: begin message<=8'b00000;
			if(avail) count<=4'hA;
			end
			
			4'hA: begin message<=8'b000;
			if(avail) count<=4'hB;
			end
			
			4'hB: begin message<=8'b0;
			if(avail) count<=4'hC;
			end
			
			4'hC: begin message<=8'b000;
			if(avail) count<=4'hD;
			end
			
			4'hD: begin message<=8'b0;
			if(avail) begin
			spistart=0;
			state<=IDLE;
			count<=0;
			bone_pos <= bone_pos + 12;
			end
			end
			endcase
		end
		
		BODY_A_1: begin
			case(count)
			0: begin spistart<=1; comm<=0; message<=36+128;// Coordinates X=2
			if(avail) count<=1;
			end
			
			1: begin message<=8'b01000010; // en y 3
			if(avail) count<=2;
			end
			
			2: begin message<=8'b01000010;
			if(avail) count<=3;
			end
			// SPRITE
			3: begin comm<=1; message<=8'b01001110; 
			if(avail) count<=4;
			end
			
			4: begin	message<=8'b11110010;
			if(avail) count<=5;
			end
			
			5: begin message<=8'b00100010;
			if(avail) count<=6;
			end
			
			6: begin message<=8'b01000100;
			if(avail) count<=7;
			end
			
			7: begin	message<=8'b00010100;
			if(avail) count<=8;
			end
			
			8: begin message<=8'b01000100;
			if(avail) count<=9;
			end
			
			9: begin message<=8'b00100010;
			if(avail) count<=10;
			end
			
			10: begin message<=8'b11110010;
			if(avail) count<=11;
			end
			
			11: begin message<=8'b01001110;
			if(avail) count<=12;
			end
			
			12: begin message<=8'b000000;
			if(avail) count<=13;
			end
			
			13: begin message<=8'b00000;
			if(avail) count<=14;
			end
			
			14: begin message<=8'b11000000;
			if(avail) count<=15;
			end
			
			15: begin message<=8'b00100000;
			if(avail) count<=16;
			end
			
			16: begin message<=8'b11010000;
			if(avail) count<=17;
			end
			
			17: begin message<=8'b10010000;
			if(avail) count<=18;
			end
			
			18: begin message<=8'b01100000;
			if(avail) begin
			spistart=0;
			state<=IDLE;
			count<=0;
			end
			end
			endcase		
		end
		
		BODY_A_2: begin
			case(count)
			0: begin spistart<=1; comm<=0; message<=38+128;// Coordinates X=2
			if(avail) count<=1;
			end
			
			1: begin message<=8'b01000011; // en y 3
			if(avail) count<=2;
			end
			
			2: begin message<=8'b01000011;
			if(avail) count<=3;
			end
			// SPRITE
			3: begin comm<=1; message<=8'b11000001; 
			if(avail) count<=4;
			end
			
			4: begin	message<=8'b10111110;
			if(avail) count<=5;
			end
			
			5: begin message<=8'b11000011;
			if(avail) count<=6;
			end
			
			6: begin message<=8'b10110010;
			if(avail) count<=7;
			end
			
			7: begin	message<=8'b10000001;
			if(avail) count<=8;
			end
			
			8: begin message<=8'b11111000;
			if(avail) count<=9;
			end
			
			9: begin message<=8'b10100001;
			if(avail) count<=10;
			end
			
			10: begin message<=8'b10100001;
			if(avail) count<=11;
			end
			
			11: begin message<=8'b10000010;
			if(avail) count<=12;
			end
			
			12: begin message<=8'b10000111;
			if(avail) count<=13;
			end
			
			13: begin message<=8'b01111000;
			if(avail) count<=14;
			end
			
			14: begin message<=8'b00100111;
			if(avail) count<=15;
			end
			
			15: begin message<=8'b00011000;
			if(avail) count<=16;
			end
			
			16: begin message<=8'b00000000;
			if(avail) count<=17;
			end
			
			17: begin message<=8'b00000000;
			if(avail) begin
			spistart=0;
			state<=IDLE;
			count<=0;
			end
			end
			endcase		
		end
		
		BODY_B_1: begin
			case(count)
			0: begin spistart<=1; comm<=0; message<=36+128;// Coordinates X=2
			if(avail) count<=1;
			end
			
			1: begin message<=8'b01000010; // en y 3
			if(avail) count<=2;
			end
			
			2: begin message<=8'b01000010;
			if(avail) count<=3;
			end
			// SPRITE
			3: begin comm<=1; message<=8'b00100111; 
			if(avail) count<=4;
			end
			
			4: begin	message<=8'b01111001;
			if(avail) count<=5;
			end
			
			5: begin message<=8'b10010001;
			if(avail) count<=6;
			end
			
			6: begin message<=8'b00100010;
			if(avail) count<=7;
			end
			
			7: begin	message<=8'b10001010;
			if(avail) count<=8;
			end
			
			8: begin message<=8'b00100010;
			if(avail) count<=9;
			end
			
			9: begin message<=8'b10010001;
			if(avail) count<=10;
			end
			
			10: begin message<=8'b01111001;
			if(avail) count<=11;
			end
			
			11: begin message<=8'b10100111;
			if(avail) count<=12;
			end
			
			12: begin message<=8'b000000;
			if(avail) count<=13;
			end
			
			13: begin message<=8'b00000;
			if(avail) count<=14;
			end
			
			14: begin message<=8'b01100000;
			if(avail) count<=15;
			end
			
			15: begin message<=8'b10010000;
			if(avail) count<=16;
			end
			
			16: begin message<=8'b11010000;
			if(avail) count<=17;
			end
			
			17: begin message<=8'b00100000;
			if(avail) count<=18;
			end
			
			18: begin message<=8'b11000000;
			if(avail) begin
			spistart=0;
			state<=IDLE;
			count<=0;
			end
			end
			endcase		
		end
		
		BODY_B_2: begin
			case(count)
			0: begin spistart<=1; comm<=0; message<=38+128;// Coordinates X=2
			if(avail) count<=1;
			end
			
			1: begin message<=8'b01000011; // en y 3
			if(avail) count<=2;
			end
			
			2: begin message<=8'b01000011;
			if(avail) count<=3;
			end
			// SPRITE
			3: begin comm<=1; message<=8'b11000000; 
			if(avail) count<=4;
			end
			
			4: begin	message<=8'b10111111;
			if(avail) count<=5;
			end
			
			5: begin message<=8'b11000001;
			if(avail) count<=6;
			end
			
			6: begin message<=8'b10111001;
			if(avail) count<=7;
			end
			
			7: begin	message<=8'b10000000;
			if(avail) count<=8;
			end
			
			8: begin message<=8'b11111100;
			if(avail) count<=9;
			end
			
			9: begin message<=8'b10100001;
			if(avail) count<=10;
			end
			
			10: begin message<=8'b10100001;
			if(avail) count<=11;
			end
			
			11: begin message<=8'b10000010;
			if(avail) count<=12;
			end
			
			12: begin message<=8'b10000100;
			if(avail) count<=13;
			end
			
			13: begin message<=8'b01111000;
			if(avail) count<=14;
			end
			
			14: begin message<=8'b00101111;
			if(avail) count<=15;
			end
			
			15: begin message<=8'b00010000;
			if(avail) count<=16;
			end
			
			16: begin message<=8'b00001111;
			if(avail) count<=17;
			end
			
			17: begin message<=8'b00000000;
			if(avail) begin
			spistart=0;
			state<=IDLE;
			count<=0;
			end
			end
			endcase		
		end
		
		TRAINER_A_1: begin
			case(count)
			0: begin spistart<=1; comm<=0; message<=trainer_pos+128;// Coordinates X=2
			if(avail) count<=1;
			end
			
			1: begin message<=8'b01000010; // en y 3
			if(avail) count<=2;
			end
			
			2: begin message<=8'b01000010;
			if(avail) count<=3;
			end
			// SPRITE
			3: begin comm<=1; message<=8'b00010000; 
			if(avail) count<=4;
			end
			
			4: begin	message<=8'b00101000;
			if(avail) count<=5;
			end
			
			5: begin message<=8'b11101100;
			if(avail) count<=6;
			end
			
			6: begin message<=8'b00000010;
			if(avail) count<=7;
			end
			
			7: begin	message<=8'b11000001;
			if(avail) count<=8;
			end
			
			8: begin message<=8'b00000001;
			if(avail) count<=9;
			end
			
			9: begin message<=8'b00100001;
			if(avail) count<=10;
			end
			
			10: begin message<=8'b11100001;
			if(avail) count<=11;
			end
			
			11: begin message<=8'b01100001;
			if(avail) count<=12;
			end
			
			12: begin message<=8'b01100001;
			if(avail) count<=13;
			end
			
			13: begin message<=8'b11110010;
			if(avail) count<=14;
			end
			
			14: begin message<=8'b11111100;
			if(avail) count<=15;
			end
			
			15: begin message<=8'b01110000;
			if(avail) count<=16;
			end
			
			16: begin message<=8'b00000000;
			if(avail) begin
			spistart=0;
			state<=IDLE;
			count<=0;
			end
			end
			endcase		
		end
		
		TRAINER_A_2: begin
			case(count)
			0: begin spistart<=1; comm<=0; message<=trainer_pos+129;// Coordinates X=2
			if(avail) count<=1;
			end
			
			1: begin message<=8'b01000011; // en y 3
			if(avail) count<=2;
			end
			
			2: begin message<=8'b01000011;
			if(avail) count<=3;
			end
			// SPRITE
			3: begin comm<=1; message<=8'b00000000; 
			if(avail) count<=4;
			end
			
			4: begin comm<=1; message<=8'b00000001; 
			if(avail) count<=5;
			end
			
			5: begin	message<=8'b00000010;
			if(avail) count<=6;
			end
			
			6: begin message<=8'b01100100;
			if(avail) count<=7;
			end
			
			7: begin message<=8'b10011100;
			if(avail) count<=8;
			end
			
			8: begin	message<=8'b10011100;
			if(avail) count<=9;
			end
			
			9: begin message<=8'b10100100;
			if(avail) count<=10;
			end
			
			10: begin message<=8'b10100110;
			if(avail) count<=11;
			end
			
			11: begin message<=8'b01111010;
			if(avail) count<=12;
			end
			
			12: begin message<=8'b00100001;
			if(avail) count<=13;
			end
			
			13: begin message<=8'b00011110;
			if(avail) count<=14;
			end
			
			14: begin message<=8'b0000;
			if(avail) count<=15;
			end
			
			15: begin message<=8'b00000000;
			if(avail) begin
			spistart=0;
			state<=IDLE;
			count<=0;
			end
			end
			endcase		
		end
		
		TRAINER_B_1: begin
			case(count)
			0: begin spistart<=1; comm<=0; message<=trainer_pos+128;// Coordinates X=2
			if(avail) count<=1;
			end
			
			1: begin message<=8'b01000010; // en y 3
			if(avail) count<=2;
			end
			
			2: begin message<=8'b01000010;
			if(avail) count<=3;
			end
			// SPRITE
			3: begin comm<=1; message<=8'b00100000; 
			if(avail) count<=4;
			end
			
			4: begin	message<=8'b01010000;
			if(avail) count<=5;
			end
			
			5: begin message<=8'b11011000;
			if(avail) count<=6;
			end
			
			6: begin message<=8'b00000100;
			if(avail) count<=7;
			end
			
			7: begin	message<=8'b10000010;
			if(avail) count<=8;
			end
			
			8: begin message<=8'b00000010;
			if(avail) count<=9;
			end
			
			9: begin message<=8'b01000010;
			if(avail) count<=10;
			end
			
			10: begin message<=8'b11000010;
			if(avail) count<=11;
			end
			
			11: begin message<=8'b11000010;
			if(avail) count<=12;
			end
			
			12: begin message<=8'b11000010;
			if(avail) count<=13;
			end
			
			13: begin message<=8'b11100100;
			if(avail) count<=14;
			end
			
			14: begin message<=8'b11111000;
			if(avail) count<=15;
			end
			
			15: begin message<=8'b11100000;
			if(avail) count<=16;
			end
			
			16: begin message<=8'b000000;
			if(avail) begin
			spistart=0;
			state<=IDLE;
			count<=0;
			end
			end
			endcase		
		end
		
		TRAINER_B_2: begin
			case(count)
			0: begin spistart<=1; comm<=0; message<=trainer_pos+129;// 
			if(avail) count<=1;
			end
			
			1: begin message<=8'b01000011; // en y 3
			if(avail) count<=2;
			end
			
			2: begin message<=8'b01000011;
			if(avail) count<=3;
			end
			// SPRITE
			3: begin comm<=1; message<=8'b00100000; 
			if(avail) count<=4;
			end
			
			4: begin	message<=8'b01010011;
			if(avail) count<=5;
			end
			
			5: begin message<=8'b10010100;
			if(avail) count<=6;
			end
			
			6: begin message<=8'b10111001;
			if(avail) count<=7;
			end
			
			7: begin	message<=8'b11011000;
			if(avail) count<=8;
			end
			
			8: begin message<=8'b01011000;
			if(avail) count<=9;
			end
			
			9: begin message<=8'b01111001;
			if(avail) count<=10;
			end
			
			10: begin message<=8'b01001100;
			if(avail) count<=11;
			end
			
			11: begin message<=8'b01001100;
			if(avail) count<=12;
			end
			
			12: begin message<=8'b10110011;
			if(avail) count<=13;
			end
			
			13: begin message<=8'b10011101;
			if(avail) count<=14;
			end
			
			14: begin message<=8'b01100000;
			if(avail) count<=15;
			end
			
			15: begin message<=8'b00000000;
			if(avail) begin
			spistart=0;
			state<=IDLE;
			count<=0;
			end
			end
			endcase		
		end
		
		IDLE: begin
		case(row)
		
		0: begin
		if(avail) begin
			if (drawn_hearts < 3) begin
				if (drawn_hearts < health & timer) state <= HEART;
				else state <= NO_HEART;
				drawn_hearts <= drawn_hearts+1;
			end
			else begin
				drawn_hearts <= 0;
				row <= 1;
				heart_pos <= 2;
			end
		end
		end
		
		1: begin
		if(avail) begin
			if (drawn_smiles < 3) begin
				if (drawn_smiles < health & timer) state <= SMILE;
				else state <= NO_SMILE;
				drawn_smiles <= drawn_smiles+1;
			end
			else begin
				drawn_smiles <= 0;
				row <= 2;
				smile_pos <= 50;
			end
		end
		end
		
		2: begin
		if(avail) begin
			if (drawn_bones < 3) begin
				if (drawn_bones < health & timer) state <= BONE;
				else state <= NO_BONE;
				drawn_bones <= drawn_bones+1;
			end
			else begin
				drawn_bones <= 0;
				row <= 3;
				bone_pos <= 48;
			end
		end
		end
		
		3: begin
		if (timer!=comp)begin
			comp <= timer;
			if (animation_timer!=18) begin
			animation_timer <= animation_timer+1;
			trainer_pos <= trainer_pos-1;
			end
		end
		
		if (timer) state <= TRAINER_A_1;
		else state <= TRAINER_B_1;
		row <= 4;
		end
		
		4: begin
		if (timer) state <= TRAINER_A_2;
		else state <= TRAINER_B_2;
		row <= 5;
		end
		
		5: begin
		if (timer) state <= BODY_A_1;
		else state <= BODY_B_1;
		row <= 6;
		end
		
		6: begin
		if (timer) state <= BODY_A_2;
		else state <= BODY_B_2;
		row <= 7;
		end
		
		7: begin
		state <= BATTERY;
		row <= 8;
		end
		
		8: begin
		if(avail) begin
			if (drawn_bat < 3) begin
				if (drawn_bat < health & timer) state <= BATTERY_LEVEL;
				else state <= NO_BATTERY_LEVEL;
				drawn_bat <= drawn_bat+1;
			end
			else begin
				drawn_bat <= 0;
				row <= 0;
				bat_pos <= 8;
			end
		end
		end

	endcase
	end
endcase
end
endmodule