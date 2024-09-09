/*
Este modulo es un "banco" de los pasos seguidos para dibujar cada uno de los sprites.
Tambien contiene el ciclo que mantiene a la pantalla dibujando constantemente
*/


module sprites(
   input clock,
	input avail,	
	input [1:0] health,
	input [1:0] happiness,
	input [2:0] energy,
	input [1:0] hunger,
	input play,
	input test,
	input rst,
	input [1:0] pet_state,
	input hungry,
	input sleepy,
	input bored,
	input timer,
	input sound,
	input light,
	input feed,
	input [2:0] accel,
	
	output reg spistart,
	output reg comm,
	output reg [7:0] message
	
	);
	
	
	
// Variables de dibujo	
	reg [4:0] row=0;
	reg [1:0] drawn_hearts=0;
	reg [1:0] drawn_smiles=0;
	reg [1:0] drawn_bones=0;
	reg [2:0] drawn_bat=0;
	
	reg [5:0] heart_pos=2;
	reg [6:0] smile_pos=50;
	reg [6:0] bone_pos=48;
	reg [6:0] bat_pos=8;
	reg [6:0] pencil_pos=8;
	
	reg [10:0] first_step=4'h0;
	reg [10:0] last_step=4'h0;
	reg [10:0] step=4'h0;
	reg [4:0] state=4'h0;
	reg [4:0] y_pos=4'h0;
	reg [5:0] count=4'h0;
	reg [6:0] trainer_pos=70;
	reg [6:0] feed_pos=70;
	
	//Permite ejecutar eventos de animacion con la comparacion entre relojes de distinta frecuencia
	reg comp=0; 
	reg trainer_comp=0;
	reg feed_comp=0;
	reg alternator;
	
	//Contador de segundos
	reg [1:0] animation_timer=0;  
	reg [2:0] trainer_timer=0;
	reg [2:0] feed_timer=0;	
	reg play_animation = 0;
	reg feed_animation = 0;
		
	parameter INIT=4'h0;
	parameter IDLE=4'h2;
   parameter PENCIL=26;

	
	// Estados de la mascota
	
	parameter STAY=0;
	parameter DEAD=1;
	parameter ASLEEP=2;
	
	parameter SLEEPY=3;
	parameter HUNGRY=4;
	
	
	reg [10:0] i=0;
	
	reg [7:0] sprites [1023:0];
	
initial begin
	sprites[0]=8'b00011110;
	sprites[1]=8'b00111011;
	sprites[2]=8'b01110111;
	sprites[3]=8'b11111110;
	sprites[4]=8'b11111110;
	sprites[5]=8'b01111111;
	sprites[6]=8'b00111111;
	sprites[7]=8'b00011110;
	// SMILE
	sprites[8]=8'b00111100;
	sprites[9]=8'b01000010; 			
	sprites[10]=8'b10010101;
	sprites[11]=8'b10100001;
	sprites[12]=8'b10100001;
	sprites[13]=8'b10010101;
	sprites[14]=8'b01000010;
	sprites[15]=8'b00111100;
	// BONE	
	sprites[16]=8'b01111100;//dibujo 
	sprites[17]=8'b10010010; 
	sprites[18]=8'b10000010;
	sprites[19]=8'b01101100;
	sprites[20]=8'b00101000;
	sprites[21]=8'b00101000;
	sprites[22]=8'b00101000;
	sprites[23]=8'b01101100;
	sprites[24]=8'b10000010;
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
	
	// TEST
	sprites[169] = 8'b00000010;
	sprites[170] = 8'b00111110;
	sprites[171] = 8'b00000010;
	sprites[172] = 8'b00000000;
	sprites[173] = 8'b00111110;
	sprites[174] = 8'b00101010;
	sprites[175] = 8'b00000000;
	sprites[176] = 8'b00101110;
	sprites[177] = 8'b00111010;
	sprites[178] = 8'b00000000;
	sprites[179] = 8'b00000010;
	sprites[180] = 8'b00111110;
	sprites[181] = 8'b00000010;
	sprites[182] = 8'b00000000;
	sprites[183] = 8'b00000000;
	// DEAD 1 
	sprites[184] = 8'b00000000;
	sprites[185] = 8'b10000000;
	sprites[186] = 8'b10000000;
	sprites[187] = 8'b10000000;
	sprites[188] = 8'b10011100;
	sprites[189] = 8'b10010100;
	sprites[190] = 8'b11110111;
	sprites[191] = 8'b00000001;
	sprites[192] = 8'b11110111;
	sprites[193] = 8'b10010100;
	sprites[194] = 8'b10011100;
	sprites[195] = 8'b10000000;
	sprites[196] = 8'b10000000;
	sprites[197] = 8'b10000000;
	sprites[198] = 8'b00000000;
	sprites[199] = 8'b00000000;
	//DEAD 2
	sprites[200] = 8'b11111111;
	sprites[201] = 8'b10000000;
	sprites[202] = 8'b10111110;
	sprites[203] = 8'b10001010;
	sprites[204] = 8'b10110110;
	sprites[205] = 8'b10000000;
	sprites[206] = 8'b10100010;
	sprites[207] = 8'b10111110;
	sprites[208] = 8'b10100010;
	sprites[209] = 8'b10000000;
	sprites[210] = 8'b10111110;
	sprites[211] = 8'b10001010;
	sprites[212] = 8'b10001110;
	sprites[213] = 8'b10000000;
	sprites[214] = 8'b11111111;
	sprites[215] = 8'b00000000;
	//POKEBALL_1
	sprites[216] = 8'b00000000;
	sprites[217] = 8'b00000000;
	sprites[218] = 8'b11000000;
	sprites[219] = 8'b00110000;
	sprites[220] = 8'b00001000;
	sprites[221] = 8'b00001000;
	sprites[222] = 8'b10000100;
	sprites[223] = 8'b01000100;
	sprites[224] = 8'b01000100;
	sprites[225] = 8'b10000100;
	sprites[226] = 8'b00001000;
	sprites[227] = 8'b00001000;
	sprites[228] = 8'b00110000;
	sprites[229] = 8'b11000000;
	sprites[230] = 8'b00000000;
	sprites[231] = 8'b00000000;
	sprites[232] = 8'b11001000;
	sprites[233] = 8'b10101000;
	sprites[234] = 8'b10011000;
	sprites[235] = 8'b00000000;
	sprites[236] = 8'b01100100;
	sprites[237] = 8'b01010100;
	sprites[238] = 8'b01001100;
	sprites[239] = 8'b00000000;
	sprites[240] = 8'b00110010;
	sprites[241] = 8'b00101010;
	sprites[242] = 8'b00100110;
	
	//POKEBALL_2
	
	
	sprites[243] = 8'b00000011;
	sprites[244] = 8'b00001101;
	sprites[245] = 8'b00010001;
	sprites[246] = 8'b00010001;
	sprites[247] = 8'b00100001;
	sprites[248] = 8'b00100010;
	sprites[249] = 8'b00100010;
	sprites[250] = 8'b00100001;
	sprites[251] = 8'b00010001;
	sprites[252] = 8'b00010001;
	sprites[253] = 8'b00001101;
	sprites[254] = 8'b00000011;
	sprites[255] = 8'b00000000;
	sprites[256] = 8'b00000000;
	sprites[257] = 8'b00000000;
	sprites[258] = 8'b00000000;
	sprites[259] = 8'b00000000;
	sprites[260] = 8'b00000000;
	// FOOD_1
	sprites[261] = 8'b11100000;
	sprites[262] = 8'b00010000;
	sprites[263] = 8'b00001000;
	sprites[264] = 8'b00001000;
	sprites[265] = 8'b11101000;
	sprites[266] = 8'b10101000;
	sprites[267] = 8'b00001000;
	sprites[268] = 8'b11001000;
	sprites[269] = 8'b00101000;
	sprites[270] = 8'b11001000;
	sprites[271] = 8'b00001000;
	sprites[272] = 8'b11001000;
	sprites[273] = 8'b00101000;
	sprites[274] = 8'b11001000;
	sprites[275] = 8'b00001000;
	sprites[276] = 8'b11101000;
	sprites[277] = 8'b00101000;
	sprites[278] = 8'b11001000;
	sprites[279] = 8'b00001000;
	sprites[280] = 8'b11101000;
	sprites[281] = 8'b00001000;
	sprites[282] = 8'b00001000;
	sprites[283] = 8'b00010000;
	sprites[284] = 8'b11100000;
	sprites[285] = 8'b10000000;
	sprites[286] = 8'b00000000;
	sprites[287] = 8'b00000000;
	sprites[288] = 8'b00000000;
	//FOOD_2
	sprites[289] = 8'b00000011;
	sprites[290] = 8'b00000100;
	sprites[291] = 8'b00001000;
	sprites[292] = 8'b00011000;
	sprites[293] = 8'b00011011;
	sprites[294] = 8'b00011000;
	sprites[295] = 8'b00011000;
	sprites[296] = 8'b00011001;
	sprites[297] = 8'b00011010;
	sprites[298] = 8'b00011001;
	sprites[299] = 8'b00011000;
	sprites[300] = 8'b00011001;
	sprites[301] = 8'b00011010;
	sprites[302] = 8'b00011001;
	sprites[303] = 8'b00011000;
	sprites[304] = 8'b00011011;
	sprites[305] = 8'b00011010;
	sprites[306] = 8'b00011001;
	sprites[307] = 8'b00011000;
	sprites[308] = 8'b00011010;
	sprites[309] = 8'b00011000;
	sprites[310] = 8'b00011000;
	sprites[311] = 8'b00011100;
	sprites[312] = 8'b00001111;
	sprites[313] = 8'b00000111;
	sprites[314] = 8'b00000010;
	// SLEEP! 1
	sprites[315] = 8'b11100000;
	sprites[316] = 8'b00010000;
	sprites[317] = 8'b00001000;
	sprites[318] = 8'b11101000;
	sprites[319] = 8'b10101000;
	sprites[320] = 8'b00001000;
	sprites[321] = 8'b11101000;
	sprites[322] = 8'b00001000;
	sprites[323] = 8'b00001000;
	sprites[324] = 8'b11101000;
	sprites[325] = 8'b10101000;
	sprites[326] = 8'b00001000;
	sprites[327] = 8'b11101000;
	sprites[328] = 8'b10101000;
	sprites[329] = 8'b00001000;
	sprites[330] = 8'b11101000;
	sprites[331] = 8'b10101000;
	sprites[332] = 8'b11101000;
	sprites[333] = 8'b00001000;
	sprites[334] = 8'b11101000;
	sprites[335] = 8'b00001000;
	sprites[336] = 8'b00001000;
	sprites[337] = 8'b00010000;
	sprites[338] = 8'b11100000;
	sprites[339] = 8'b10000000;
	sprites[340] = 8'b00000000;
	sprites[341] = 8'b00000000;
	//SLEEP 2
	sprites[342] = 8'b00000011;
	sprites[343] = 8'b00000100;
	sprites[344] = 8'b00001000;
	sprites[345] = 8'b00011010;
	sprites[346] = 8'b00011011;
	sprites[347] = 8'b00011000;
	sprites[348] = 8'b00011011;
	sprites[349] = 8'b00011010;
	sprites[350] = 8'b00011000;
	sprites[351] = 8'b00011011;
	sprites[352] = 8'b00011010;
	sprites[353] = 8'b00011000;
	sprites[354] = 8'b00011011;
	sprites[355] = 8'b00011010;
	sprites[356] = 8'b00011000;
	sprites[357] = 8'b00011011;
	sprites[358] = 8'b00011000;
	sprites[359] = 8'b00011000;
	sprites[360] = 8'b00011000;
	sprites[361] = 8'b00011010;
	sprites[362] = 8'b00011000;
	sprites[363] = 8'b00011000;
	sprites[364] = 8'b00011100;
	sprites[365] = 8'b00001111;
	sprites[366] = 8'b00000111;
	sprites[367] = 8'b00000010;
	// SPEAKER
	sprites[368] = 8'b00011000;
	sprites[369] = 8'b00111100;
	sprites[370] = 8'b01111110;
	sprites[371] = 8'b11111111;
	sprites[372] = 8'b11111111;
	sprites[373] = 8'b00000000;
	sprites[374] = 8'b00100100;
	sprites[375] = 8'b00011000;
	sprites[376] = 8'b01000010;
	sprites[377] = 8'b00111100;
	sprites[378] = 8'b10000001;
	sprites[379] = 8'b01111110;
	// PLAY! 1
	sprites[380] = 8'b11100000;
	sprites[381] = 8'b00010000;
	sprites[382] = 8'b00001000;
	sprites[383] = 8'b00001000;
	sprites[384] = 8'b11101000;
	sprites[385] = 8'b10101000;
	sprites[386] = 8'b11101000;
	sprites[387] = 8'b00001000;
	sprites[388] = 8'b11101000;
	sprites[389] = 8'b00001000;
	sprites[390] = 8'b00001000;
	sprites[391] = 8'b11101000;
	sprites[392] = 8'b10101000;
	sprites[393] = 8'b11101000;
	sprites[394] = 8'b00001000;
	sprites[395] = 8'b11101000;
	sprites[396] = 8'b10001000;
	sprites[397] = 8'b11101000;
	sprites[398] = 8'b00001000;
	sprites[399] = 8'b11101000;
	sprites[400] = 8'b00001000;
	sprites[401] = 8'b00001000;
	sprites[402] = 8'b00010000;
	sprites[403] = 8'b11100000;
	sprites[404] = 8'b10000000;
	sprites[405] = 8'b00000000;
	sprites[406] = 8'b00000000;
	sprites[407] = 8'b00000000;

	// PLAY_2
	sprites[408] = 8'b00000011;
	sprites[409] = 8'b00000100;
	sprites[410] = 8'b00001000;
	sprites[411] = 8'b00011000;
	sprites[412] = 8'b00011011;
	sprites[413] = 8'b00011000;
	sprites[414] = 8'b00011000;
	sprites[415] = 8'b00011000;
	sprites[416] = 8'b00011011;
	sprites[417] = 8'b00011010;
	sprites[418] = 8'b00011000;
	sprites[419] = 8'b00011011;
	sprites[420] = 8'b00011000;
	sprites[421] = 8'b00011011;
	sprites[422] = 8'b00011000;
	sprites[423] = 8'b00011000;
	sprites[424] = 8'b00011011;
	sprites[425] = 8'b00011000;
	sprites[426] = 8'b00011000;
	sprites[427] = 8'b00011010;
	sprites[428] = 8'b00011000;
	sprites[429] = 8'b00011000;
	sprites[430] = 8'b00011100;
	sprites[431] = 8'b00001111;
	sprites[432] = 8'b00000111;
	sprites[433] = 8'b00000010;
	//APPLE
	sprites[434] = 8'b00000000;
	sprites[435] = 8'b00111000;
	sprites[436] = 8'b01101100;
	sprites[437] = 8'b11110100;
	sprites[438] = 8'b11111111;
	sprites[439] = 8'b11111101;
	sprites[440] = 8'b11111100;
	sprites[441] = 8'b01111100;
	sprites[442] = 8'b00111000;
	sprites[443] = 8'b00000000;
	sprites[444] = 8'b00000000;
	//BULB
	sprites[445] = 8'b01001001;
	sprites[446] = 8'b01001001;
	sprites[447] = 8'b00101010;
	sprites[448] = 8'b00000000;
	sprites[449] = 8'b00011100;
	sprites[450] = 8'b01100010;
	sprites[451] = 8'b10100010;
	sprites[452] = 8'b10100010;
	sprites[453] = 8'b01100010;
	sprites[454] = 8'b00011100;
	sprites[455] = 8'b00000000;
	sprites[456] = 8'b00101010;
	sprites[457] = 8'b01001001;
	sprites[458] = 8'b01001001;
	// X 
	sprites[459] = 8'b00000000;
	sprites[460] = 8'b00100010;
	sprites[461] = 8'b00010100;
	sprites[462] = 8'b00001000;
	sprites[463] = 8'b00010100;
	sprites[464] = 8'b00100010;
	sprites[465] = 8'b00000000;
	//1
	sprites[466] = 8'b00100100;
	sprites[467] = 8'b00111110;
	sprites[468] = 8'b00100000;
	sprites[469] = 8'b00000000;
	sprites[470] = 8'b00000000;
	sprites[471] = 8'b00000000;
	sprites[472] = 8'b00000000;
	sprites[473] = 8'b00000000;
	//2
	sprites[474] = 8'b00100100;
	sprites[475] = 8'b00110010;
	sprites[476] = 8'b00101010;
	sprites[477] = 8'b00100100;
	sprites[478] = 8'b00000000;
	sprites[479] = 8'b00000000;
	sprites[480] = 8'b00000000;
	sprites[481] = 8'b00000000;
	sprites[482] = 8'b00000000;
	//4
	sprites[483] = 8'b00011000;
	sprites[484] = 8'b00010100;
	sprites[485] = 8'b00111110;
	sprites[486] = 8'b00010000;
	sprites[487] = 8'b00000000;
	sprites[488] = 8'b00000000;
	sprites[489] = 8'b00000000;
	sprites[490] = 8'b00000000;
	sprites[491] = 8'b00000000;
	//8
	sprites[492] = 8'b00111110;
	sprites[493] = 8'b00101010;
	sprites[494] = 8'b00111110;
	sprites[495] = 8'b00000000;
	sprites[496] = 8'b00000000;
	sprites[497] = 8'b00000000;
	sprites[498] = 8'b00000000;
	//16
	sprites[499] = 8'b00100100;
	sprites[500] = 8'b00111110;
	sprites[501] = 8'b00100000;
	sprites[502] = 8'b00000000;
	sprites[503] = 8'b00111110;
	sprites[504] = 8'b00101010;
	sprites[505] = 8'b00111010;
	sprites[506] = 8'b00000000;

	
end

	
always @(posedge clock) begin
	if (play) begin
		play_animation<=1;
	end
	if (feed) begin
		feed_animation<=1;
	end
	if (rst) begin
		state<=0;
		i<=0;
		row=0;
		drawn_hearts=0;
		drawn_smiles=0;
		drawn_bones=0;
		drawn_bat=0;
		heart_pos=2;
		smile_pos=50;
		bone_pos=48;
		bat_pos=8;
		count=4'h0;
		trainer_pos=70;
		comp=0; 
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

		PENCIL: begin //dibujar
			case(count)
			4'h0: begin spistart<=1; comm<=0; message<=pencil_pos+128;// Coordinates X
			if(avail) count<=4'h1;
			end
			
			4'h1: begin message <=y_pos +64; // en y 
			if(avail) count<=4'h2;
			end
			
			4'h2: begin message<=y_pos +64;step<=first_step; // en y 
			if(avail) count<=4'h3;
			end
			
			4'h3: begin comm<=1; 
			message<=sprites[step];//dibujo 
			if(avail)begin
				step<=step+1;
				if (step==last_step) begin
					spistart=0;
					state<=IDLE;
					count<=0;
				end 
			end		
			end
			endcase
		end
		
		
		IDLE: begin
			case(row)
			0: begin
				y_pos<=1;
				pencil_pos<=heart_pos;
				if (drawn_hearts < 3) begin
					if (drawn_hearts < health & timer) begin
						first_step<=0;
						last_step<=7;											
					end
					else begin
						first_step<=700;
						last_step<=707;	
					end
					drawn_hearts <= drawn_hearts +1;
					heart_pos <= heart_pos + 12;
				end			
				else begin
					drawn_hearts <= 0;
					heart_pos <= 2;
					first_step<=700;
					last_step<=700;
					row<=1;
				end
			end
			
			1: begin
				pencil_pos<=smile_pos;
				if (drawn_smiles < 3) begin
					if (drawn_smiles < happiness & timer) begin
						first_step<=8;
						last_step<=15;
					end
					else begin
						first_step<=700;
						last_step<=707;			
					end
					drawn_smiles <= drawn_smiles+1;
					smile_pos<=smile_pos+12;
				end
				else begin
				drawn_smiles <= 0;
				smile_pos<=50;
				first_step<=700;
				last_step<=700;
				row<=2;
				end
			end
			
			2: begin
				pencil_pos<=6;
				y_pos <= 4;
				first_step<=27;
				last_step<=49;
				row<=3;
			end
			
			3: begin
				pencil_pos<=bat_pos;
				y_pos <= 4; 
				if (drawn_bat < 4) begin
					if (drawn_bat < energy & timer) begin
						first_step<=50;
						last_step<=51;
					end
					else begin
						first_step<=28;
						last_step<=29;			
					end
					drawn_bat <= drawn_bat+1;
					bat_pos<=bat_pos+5;
				end
				else begin
				drawn_bat <= 0;
				bat_pos<= 8;
				first_step<=48;
				last_step<=48;
				row<=4;
				end
			end
			
			
			4: begin
				pencil_pos<= bone_pos; 
				if (drawn_bones < 3) begin
					if (drawn_bones < hunger & timer) begin
						first_step<=16;
						last_step<=26;
					end
					else begin
						first_step<=700;
						last_step<=710;			
					end
					drawn_bones <= drawn_bones + 1;
					bone_pos <= bone_pos + 12;
				end
				else begin
				drawn_bones <= 0;
				bone_pos<= 48;
				first_step<=700;
				last_step<=700;
				row<=5;
				end
			end
			
			5: begin
				pencil_pos <= 33;
				y_pos <= 2;
				case(pet_state)
				STAY: begin
						if (timer) begin
							first_step<= 52;
							last_step<= 67;
						end
						else begin
							first_step<= 83;
							last_step<= 98;
						end
					end
					
				DEAD: begin
					first_step<= 182;
					last_step<= 199;
				end
				
				ASLEEP: begin
					first_step<= 216;
					case (animation_timer)
						0:last_step<= 230;
						1:last_step<= 235;
						2:last_step<= 239;
						3:last_step<= 242;
					endcase
				end
				endcase
				row<=6;
				end
				
			6: begin
				pencil_pos <= 35;
				y_pos <= 3;
				case(pet_state)
				STAY: begin
						if (timer) begin
							first_step<= 68;
							last_step<= 82;
						end
						else begin
							first_step<= 99;
							last_step<= 113;
						end
					end
					
				DEAD: begin
					first_step<= 200;
					last_step<= 215;
				end
				
				ASLEEP: begin
					first_step<= 243;
					last_step<= 260;
				end	
				endcase
				row<=7;
				end
				
			7: begin
				pencil_pos <= 5;
				y_pos <= 0;
				if (test) begin
					first_step <= 169;
					last_step <= 181;
				end
				else begin
					first_step <= 700;
					last_step <= 712;
				end
				if (timer!=comp) begin
					comp <= timer;
					row <=8;
				end
				else row<=10;
				end
			//ERASER	
			8: begin
				pencil_pos <= 0;
				y_pos <= 2;
				first_step <= 700;
				last_step <= 800;
				row <=9;
				end
				
			9: begin
				pencil_pos <= 0;
				y_pos <= 3;
				first_step <= 700;
				last_step <= 800;
				row <=10;
				end
				
			10:begin
				if (alternator) begin
					if (hungry & timer) begin
						pencil_pos <= 4;
						y_pos <= 2;					
						first_step <= 261;
						last_step <= 288;		
					end
					if (sleepy & !timer) begin
						pencil_pos <= 4;
						y_pos <= 3;
						first_step <= 342;
						last_step <= 367;		
					end
				end
				else begin
					if (bored & timer) begin
						pencil_pos <= 4;
						y_pos <= 2;					
						first_step <= 380;
						last_step <= 407;		
					end	
				end
				row <=11;
				end
			
			11:begin
				if (alternator) begin
					if (hungry & timer) begin
						pencil_pos <= 4;
						y_pos <= 3;
						first_step <= 289;
						last_step <= 314;		
					end
					if (sleepy & !timer) begin
						pencil_pos <= 4;
						y_pos <= 2;		
						first_step <= 315;
						last_step <= 341;
					end
				end
				else begin
					if (bored & timer) begin
						pencil_pos <= 4;
						y_pos <= 3;
						first_step <= 408;
						last_step <= 433;		
					end
				end			
				row <=12;
				end
				
			12:begin
				y_pos <= 0;
				pencil_pos <= 33;
				if (sound) begin					
					first_step <= 368;
					last_step <= 379;
				end
				else begin
					first_step <= 1012;
					last_step <= 1023;
				end
				row <=13;
				end
			
			13:begin
				if (play_animation) begin
					y_pos <= 2;
					pencil_pos<= trainer_pos;
					if (timer) begin
						first_step <= 114;
						last_step <= 127;
					end
					else begin
						first_step <= 141;
						last_step <= 154;
					end
				end
				if (timer!=trainer_comp & play_animation) begin
					trainer_comp <= timer;
					if (trainer_pos>50) begin
						trainer_pos <= trainer_pos-1;
					end
					else if (trainer_pos==50) begin
						trainer_timer<=trainer_timer+1;
						if (trainer_timer==6) begin
							play_animation<=0;
							trainer_pos<=70;
							trainer_timer<=0;
							first_step <= 1012;
							last_step <= 1023;
						end
					end
				end
				row <= 14;
				end
				
			14:begin
				if (play_animation) begin
					y_pos <= 3;
					pencil_pos<= trainer_pos+1;
					if (timer) begin
						first_step <= 128;
						last_step <= 140;
					end
					else begin
						first_step <= 155;
						last_step <= 168;
					end
				end
				row <= 15;
				end
				
			15:begin
				if (feed_animation) begin
					y_pos <= 2;
					pencil_pos<= feed_pos;
					first_step <= 434;
					last_step <= 444;
				end
				if (timer!=feed_comp & feed_animation) begin
					feed_comp <= timer;
					if (feed_pos>50) begin
						feed_pos <= feed_pos-2;
					end
					else if (feed_pos==50) begin
						feed_timer <= feed_timer+1;
						if (feed_timer==2) begin
							feed_animation<=0;
							feed_pos<=70;
							feed_timer<=0;
						end
					end
				end
				row <= 16;
				end
			
			16:begin
				y_pos <= 5;
				pencil_pos <= 33;
				if (light) begin					
					first_step <= 445;
					last_step <= 458;
				end
				else begin
					first_step <= 1009;
					last_step <= 1023;
				end
				row <=17;
				end
				
//Mdivisor guide:
// 0 = x16
// 1 = x8
// 2 = x4
// 3 = x2
// 4 = x1

			17:begin
				y_pos <= 5;
				pencil_pos <= 2;
				first_step <= 459;
				last_step <= 465;
				row <=18;
				end
				
			18:begin
				y_pos <= 5;
				pencil_pos <= 10;
				case(accel)
					4:begin
						first_step <= 466;
						last_step <= 473;
					end
					
					3:begin
						first_step <= 474;
						last_step <= 482;
					end
					
					2:begin
						first_step <= 483;
						last_step <= 491;
					end
					
					1:begin
						first_step <= 492;
						last_step <= 498;
					end
					
					0:begin
						first_step <= 499;
						last_step <= 506;
					end	
				endcase
				row <=0;
				end
			
		endcase
		state<=PENCIL;
		end
	endcase
	end
	
	always @(posedge timer) begin
		animation_timer<=animation_timer+3;
		alternator<=alternator+1;
	end

endmodule
