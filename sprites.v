/*
Este modulo es un "banco" de los pasos seguidos para dibujar cada uno de los sprites.
Tambien contiene el ciclo que mantiene a la pantalla dibujando constantemente
*/


module sprites(
   input clock,
	input avail,	
	input [2:0] health,
	input [2:0] happiness,
	input [2:0] energy,
	input [2:0] hunger,
	input play,
	
	output reg spistart,
	output reg comm,
	output reg [7:0] message
	);
	
	reg play_animation = 0;
	
// variables de dibujo	
	reg [4:0] row=0;
	reg [1:0] drawn_hearts=0;
	reg [1:0] drawn_smiles=0;
	reg [1:0] drawn_bones=0;
	reg [2:0] drawn_bat=0;
	
	reg [5:0] heart_pos=2;
	reg [6:0] smile_pos=50;
	reg [6:0] bone_pos=48;
	reg [6:0] bat_pos=8;
	
	reg [8:0] step=4'h0;
	reg [4:0] state=4'h0;
	reg [5:0] count=4'h0;
	reg [6:0] trainer_pos=70;
	
	//Permite ejecutar eventos de animacion con la comparacion entre relojes de distinta frecuencia
	reg comp=0; 
	
	//Contador de segundos
	reg [5:0] animation_timer=0;  
	
	//Reloj de timpo natural
	clkgen clkgen(.clkin(clock), .clkout(timer), .divisor(50000000));
	
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
	parameter ERASER=20;
	
	reg [10:0] i=0;
	
	reg [7: 0] sprites [255:0];
	
	initial begin
	sprites [0]=8'b00011110;
	sprites [1]=8'b00111011;
	sprites [2]=8'b01110111;
	sprites [3]=8'b11111110;
	sprites [4]=8'b11111110;
	sprites [5]=8'b01111111;
	sprites [6]=8'b00111111;
	sprites [7]=8'b00011110;
	// SMILE
	sprites [8]=8'b00111100;
	sprites [9]=8'b01000010; 			
	sprites [10]=8'b10010101;
	sprites [11]=8'b10100001;
	sprites [12]=8'b10100001;
	sprites [13]=8'b10010101;
	sprites [14]=8'b01000010;
	sprites [15]=8'b00111100;
	// BONE
	sprites [16]=8'b01111100;//dibujo 
	sprites [17]=8'b10010010; 
	sprites [18]=8'b10000010;
	sprites [19]=8'b01101100;
	sprites [20]=8'b00101000;
	sprites [21]=8'b00101000;
	sprites [22]=8'b00101000;
	sprites [23]=8'b01101100;
	sprites [24]=8'b10000010;
	sprites[25] =8'b10010010;
	sprites[26] =8'b01111100;

	// Battery sprite
	sprites[27] = 8'b11111111;
	sprites[28] = 8'b10000001;
	sprites[29] = 8'b10000001;
	sprites[30] = 8'b10000001;
	sprites[31] = 8'b10000001;
	sprites[32] = 8'b11111111;
	sprites[33] = 8'b10000001;
	sprites[34] = 8'b10000001;
	sprites[35] = 8'b10000001;
	sprites[36] = 8'b10000001;
	sprites[37] = 8'b11111111;
	sprites[38] = 8'b10000001;
	sprites[39] = 8'b10000001;
	sprites[40] = 8'b10000001;
	sprites[41] = 8'b10000001;
	sprites[42] = 8'b11111111;
	sprites[43] = 8'b10000001;
	sprites[44] = 8'b10000001;
	sprites[45] = 8'b10000001;
	sprites[46] = 8'b10000001;
	sprites[47] = 8'b11111111;
	sprites[48] = 8'b01111110;
	sprites[49] = 8'b01111110;

// Battery level indicator
	sprites[50] = 8'b10111101;
	sprites[51] = 8'b10111101;

	// Body A1 sprite
	sprites[52] = 8'b01001110; 
	sprites[53] = 8'b11110010;
	sprites[54] = 8'b00100010;
	sprites[55] = 8'b01000100;
	sprites[56] = 8'b00010100;
	sprites[57] = 8'b01000100;
	sprites[58] = 8'b00100010;
	sprites[59] = 8'b11110010;
	sprites[60] = 8'b01001110;
	sprites[61] = 8'b00000000; 
	sprites[62] = 8'b00000000; 
	sprites[63] = 8'b11000000;
	sprites[64] = 8'b00100000;
	sprites[65] = 8'b11010000;
	sprites[66] = 8'b10010000;
	sprites[67] = 8'b01100000;
	// Body A2 sprite
	sprites[68] = 8'b11000001; 
	sprites[69] = 8'b10111110;
	sprites[70] = 8'b11000011;
	sprites[71] = 8'b10110010;
	sprites[72] = 8'b10000001;
	sprites[73] = 8'b11111000;
	sprites[74] = 8'b10100001;
	sprites[75] = 8'b10100001;
	sprites[76] = 8'b10000010;
	sprites[77] = 8'b10000111;
	sprites[78] = 8'b01111000;
	sprites[79] = 8'b00100111;
	sprites[80] = 8'b00011000;
	sprites[81] = 8'b00000000; 
	sprites[82] = 8'b00000000; 
	// Body B1 sprite
	sprites[83] = 8'b00100111; 
	sprites[84] = 8'b01111001;
	sprites[85] = 8'b10010001;
	sprites[86] = 8'b00100010;
	sprites[87] = 8'b10001010;
	sprites[88] = 8'b00100010;
	sprites[89] = 8'b10010001;
	sprites[90] = 8'b01111001;
	sprites[91] = 8'b10100111;
	sprites[92] = 8'b00000000; 
	sprites[93] = 8'b00000000; 
	sprites[94] = 8'b01100000;
	sprites[95] = 8'b10010000;
	sprites[96] = 8'b11010000;
	sprites[97] = 8'b00100000;
	sprites[98] = 8'b11000000;
	// Body B2 sprite
	sprites[99] = 8'b11000000; 
	sprites[100] = 8'b10111111;
	sprites[101] = 8'b11000001;
	sprites[102] = 8'b10111001;
	sprites[103] = 8'b10000000;
	sprites[104] = 8'b11111100;
	sprites[105] = 8'b10100001;
	sprites[106] = 8'b10100001;
	sprites[107] = 8'b10000010;
	sprites[108] = 8'b10000100;
	sprites[109] = 8'b01111000;
	sprites[110] = 8'b00101111;
	sprites[111] = 8'b00010000;
	sprites[112] = 8'b00001111;
	sprites[113] = 8'b00000000;
	//Trainer A1
	sprites[114] = 8'b00010000;
	sprites[115] = 8'b00101000;
	sprites[116] = 8'b11101100;
	sprites[117] = 8'b00000010;
	sprites[118] = 8'b11000001;
	sprites[119] = 8'b00000001;
	sprites[120] = 8'b00100001;
	sprites[121] = 8'b11100001;
	sprites[122] = 8'b01100001;
	sprites[123] = 8'b01100001;
	sprites[124] = 8'b11110010;
	sprites[125] = 8'b11111100;
	sprites[126] = 8'b01110000;
	sprites[127] = 8'b00000000;
	//TRAINER A2
	sprites[128] = 8'b00000000;
	sprites[129] = 8'b00000001;
	sprites[130] = 8'b00000010;
	sprites[131] = 8'b01100100;
	sprites[132] = 8'b10011100;
	sprites[133] = 8'b10011100;
	sprites[134] = 8'b10100100;
	sprites[135] = 8'b10100110;
	sprites[136] = 8'b01111010;
	sprites[137] = 8'b00100001;
	sprites[138] = 8'b00011110;
	sprites[139] = 8'b00000000;
	sprites[140] = 8'b00000000;
	// TRAINER B1
	sprites[141] = 8'b00100000;
	sprites[142] = 8'b01010000;
	sprites[143] = 8'b11011000;
	sprites[144] = 8'b00000100;
	sprites[145] = 8'b10000010;
	sprites[146] = 8'b00000010;
	sprites[147] = 8'b01000010;
	sprites[148] = 8'b11000010;
	sprites[149] = 8'b11000010;
	sprites[150] = 8'b11000010;
	sprites[151] = 8'b11100100;
	sprites[152] = 8'b11111000;
	sprites[153] = 8'b11100000;
	sprites[154] = 8'b00000000;
	// TRAINER B2
	sprites[155] = 8'b00100000;
	sprites[156] = 8'b01010011;
	sprites[157] = 8'b10010100;
	sprites[158] = 8'b10111001;
	sprites[159] = 8'b11011000;
	sprites[160] = 8'b01011000;
	sprites[161] = 8'b01111001;
	sprites[162] = 8'b01001100;
	sprites[163] = 8'b01001100;
	sprites[164] = 8'b10110011;
	sprites[165] = 8'b10011101;
	sprites[166] = 8'b01100000;
	sprites[167] = 8'b00000000;
	sprites[168] = 8'b00000000;


end
	
always @(posedge clock) begin
	if (play) begin
		play_animation<=1;
	end
	
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
			4'h0: begin spistart<=1; comm<=0; message<=heart_pos+128;// Coordinates X
			if(avail) count<=4'h1;
			end
			
			4'h1: begin message<=8'b01000001; // en y 
			if(avail) count<=4'h2;
			end
			
			4'h2: begin message<=8'b01000001;step<=0; // en y 
			if(avail) count<=4'h3;
			end
			
			4'h3: begin comm<=1; 
			message<=sprites[step];//dibujo 
			if(avail)begin
				step<=step+1;
				if (step==7) begin
					spistart=0;
					state<=IDLE;
					count<=0;
					heart_pos <= heart_pos + 12;				
				end 
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
			
			4'h2: begin message<=8'b01000001;step<=8; // en y 3
			if(avail) count<=4'h3;
			end
			
			4'h3: begin comm<=1; 
			message<=sprites[step];//dibujo 
			if(avail)begin
				step<=step+1;
				if (step==15) begin
					spistart=0;
					state<=IDLE;
					count<=0;
					smile_pos <= smile_pos + 12;				
				end 
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
			
			4'h2: begin message<=8'b01000100;step<=16; //
			if(avail) count<=4'h3;
			end
			
			4'h3: begin comm<=1; 
			message<=sprites[step];//dibujo 
			if(avail)begin
				step<=step+1;
				if (step==26) begin
					spistart=0;
					state<=IDLE;
					count<=0;
					bone_pos <= bone_pos + 12;				
				end 
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
			
			4'h2: begin message<=8'b01000100; step<=27; //
			if(avail) count<=4'h3;
			end
			
			4'h3: begin comm<=1; 
			message<=sprites[step];//dibujo 
			if(avail)begin
				step<=step+1;
				if (step==49) begin
					spistart=0;
					state<=IDLE;
					count<=0;				
				end 
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
			
			4'h2: begin message<=8'b01000100; step<=50;//
			if(avail) count<=4'h3;
			end
			
			4'h3: begin comm<=1; 
			message<=sprites[step];//dibujo 
			if(avail)begin
				step<=step+1;
				if (step==51) begin
					spistart=0;
					state<=IDLE;
					count<=0;
					bat_pos <= bat_pos + 5;				
				end 
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
			if(avail) begin 
				if (i<=7) begin 
					i<=i+1;
					count<=4'h3;
					end 
				else 
				begin 
				heart_pos<=heart_pos+12;
				state<=IDLE;
				count<=4'h0;
				i<=0;
				end
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
			
			2: begin message<=8'b01000010;step<=52;
			if(avail) count<=3;
			end
			// SPRITE
			4'h3: begin comm<=1; 
			message<=sprites[step];//dibujo 
			if(avail)begin
				step<=step+1;
				if (step==67) begin
					spistart=0;
					state<=IDLE;
					count<=0;				
				end 
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
			
			2: begin message<=8'b01000011;step<=68;
			if(avail) count<=3;
			end
			// SPRITE
			3: begin comm<=1; 
			message<=sprites[step];//dibujo 
			if(avail)begin
				step<=step+1;
				if (step==82) begin
					spistart=0;
					state<=IDLE;
					count<=0;				
				end 
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
			
			2: begin message<=8'b01000010;step<=83;
			if(avail) count<=3;
			end
			// SPRITE
			3: begin comm<=1; 
			message<=sprites[step];//dibujo 
			if(avail)begin
				step<=step+1;
				if (step==98) begin
					spistart=0;
					state<=IDLE;
					count<=0;				
				end 
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
			
			2: begin message<=8'b01000011;step<=99;
			if(avail) count<=3;
			end
			// SPRITE
			3: begin comm<=1; 
			message<=sprites[step];//dibujo 
			if(avail)begin
				step<=step+1;
				if (step==113) begin
					spistart=0;
					state<=IDLE;
					count<=0;				
				end 
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
			
			2: begin message<=8'b01000010; step<=114;
			if(avail) count<=3;
			end
			// SPRITE
			3: begin comm<=1; 
			message<=sprites[step];//dibujo 
			if(avail)begin
				step<=step+1;
				if (step==127) begin
					spistart=0;
					state<=IDLE;
					count<=0;				
				end 
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
			
			2: begin message<=8'b01000011; step<=128;
			if(avail) count<=3;
			end
			// SPRITE
			3: begin comm<=1; 
			message<=sprites[step];//dibujo 
			if(avail)begin
				step<=step+1;
				if (step==140) begin
					spistart=0;
					state<=IDLE;
					count<=0;				
				end 
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
			
			2: begin message<=8'b01000010; step<=141;
			if(avail) count<=3;
			end
			// SPRITE
			3: begin comm<=1; 
			message<=sprites[step];//dibujo 
			if(avail)begin
				step<=step+1;
				if (step==154) begin
					spistart=0;
					state<=IDLE;
					count<=0;				
				end 
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
			
			2: begin message<=8'b01000011;step<=155;
			if(avail) count<=3;
			end
			// SPRITE
			3: begin comm<=1; 
			message<=sprites[step];//dibujo 
			if(avail)begin
				step<=step+1;
				if (step==168) begin
					spistart=0;
					state<=IDLE;
					count<=0;				
				end 
			end		
			end
			endcase
		end
		
		ERASER: begin
			case(count)
			0: begin spistart<=1; comm<=0; message<=180;// 
			if(avail) count<=1;
			end
			
			1: begin message<=8'b01000011; // en y 3
			if(avail) count<=2;
			end
			
			2: begin message<=8'b01000011;
			if(avail) count<=3;
			end
			// SPRITE
			3: begin message<=8'b11111111; 
			if(avail & i==31) begin
				count<=4'h4;
				i<=0; 
			end
			else if (avail)begin
				i<=i+1;
			end
			end
			
			4: begin message<=8'b0;
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
					if (drawn_hearts < health  & timer) state <= HEART;
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
					if (drawn_smiles < happiness & timer) state <= SMILE;
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
					if (drawn_bones < hunger & timer) state <= BONE;
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
				if (play_animation) begin
					if (timer!=comp) begin
						comp <= timer;
						if (animation_timer!=18) begin
							animation_timer <= animation_timer+1;
							trainer_pos <= trainer_pos-1;
						end					
						else begin
							animation_timer <= 0;
							trainer_pos <= 70;
							play_animation<=0;
						end		
					end
					
					if (timer) state <= TRAINER_A_1;
					else state <= TRAINER_B_1;
					row <= 4;
					end
				else	row <= 5;
				end	
				
			4: begin
				if (play_animation) begin
					if (timer) state <= TRAINER_A_2;
					else state <= TRAINER_B_2;
					end
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
				if (drawn_bat < 4) begin
					if (drawn_bat < energy & timer) state <= BATTERY_LEVEL;
					else state <= NO_BATTERY_LEVEL;
					drawn_bat <= drawn_bat+1;
				end
				else begin
					drawn_bat <= 0;
					row <= 9;
					bat_pos <= 8;
				end
			end
			end
			
			9: begin
			state <= ERASER;
			row <= 0;
			end

		endcase
		end
	endcase
	end
endmodule
