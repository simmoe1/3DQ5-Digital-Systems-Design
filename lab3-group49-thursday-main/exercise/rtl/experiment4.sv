/*
Copyright by Henry Ko and Nicola Nicolici
Department of Electrical and Computer Engineering
McMaster University
Ontario, Canada
*/

`timescale 1ns/100ps
`ifndef DISABLE_DEFAULT_NET
`default_nettype none
`endif

module experiment4 (
		/////// board clocks                      ////////////
		input logic CLOCK_50_I,                   // 50 MHz clock

		/////// switches                          ////////////
		input logic[17:0] SWITCH_I,               // toggle switches

		/////// VGA interface                     ////////////
		output logic VGA_CLOCK_O,                 // VGA clock
		output logic VGA_HSYNC_O,                 // VGA H_SYNC
		output logic VGA_VSYNC_O,                 // VGA V_SYNC
		output logic VGA_BLANK_O,                 // VGA BLANK
		output logic VGA_SYNC_O,                  // VGA SYNC
		output logic[7:0] VGA_RED_O,              // VGA red
		output logic[7:0] VGA_GREEN_O,            // VGA green
		output logic[7:0] VGA_BLUE_O,              // VGA blue

		/////// PS2                               ////////////
		input logic PS2_DATA_I,                   // PS2 data
		input logic PS2_CLOCK_I                   // PS2 clock
);

`include "VGA_param.h"
parameter SCREEN_BORDER_OFFSET = 32;
parameter DEFAULT_MESSAGE_LINE = 280;
parameter DEFAULT_MESSAGE_START_COL = 360;
parameter KEYBOARD_MESSAGE_LINE = 320;
parameter KEYBOARD_MESSAGE_START_COL = 360;
parameter KEYPRESS_COUNT_LINE = 360;
parameter KEYPRESS_COUNT_START_COL = 360;


logic resetn, enable;

logic [7:0] VGA_red, VGA_green, VGA_blue;
logic [9:0] pixel_X_pos;
logic [9:0] pixel_Y_pos;

logic [5:0] character_address;
logic rom_mux_output;

logic screen_border_on;

assign resetn = ~SWITCH_I[17];

logic [7:0] PS2_code;
logic [7:0] PS2_reg [30:0];
logic PS2_code_ready;

logic [3:0] letter_counter [5:0];
logic [3:0] data_count;
logic [3:0] letter_count_max;
logic [3:0] max_value;
logic [3:0] display_letter_count;

logic PS2_code_ready_buf;
logic PS2_make_code;

// PS/2 controller
PS2_controller ps2_unit (
	.Clock_50(CLOCK_50_I),
	.Resetn(resetn),
	.PS2_clock(PS2_CLOCK_I),
	.PS2_data(PS2_DATA_I),
	.PS2_code(PS2_code),
	.PS2_code_ready(PS2_code_ready),
	.PS2_make_code(PS2_make_code)
);

// Putting the PS2 code into a register
always_ff @ (posedge CLOCK_50_I or negedge resetn) begin
	if (resetn == 1'b0) begin
		PS2_code_ready_buf <= 1'b0;
		
		PS2_reg[30] <= 8'd0;
		PS2_reg[29] <= 8'd0;
		PS2_reg[28] <= 8'd0;
		PS2_reg[27] <= 8'd0;
		PS2_reg[26] <= 8'd0;
		PS2_reg[25] <= 8'd0;
		PS2_reg[24] <= 8'd0;
		PS2_reg[23] <= 8'd0;
		PS2_reg[22] <= 8'd0;
		PS2_reg[21] <= 8'd0;
		PS2_reg[20] <= 8'd0;
		PS2_reg[19] <= 8'd0;
		PS2_reg[18] <= 8'd0;
		PS2_reg[17] <= 8'd0;
		PS2_reg[16] <= 8'd0;
		PS2_reg[15] <= 8'd0;
		PS2_reg[14] <= 8'd0;
		PS2_reg[13] <= 8'd0;
		PS2_reg[12] <= 8'd0;
		PS2_reg[11] <= 8'd0;
		PS2_reg[10] <= 8'd0;
		PS2_reg[9] <= 8'd0;
		PS2_reg[8] <= 8'd0;
		PS2_reg[7] <= 8'd0;
		PS2_reg[6] <= 8'd0;
		PS2_reg[5] <= 8'd0;
		PS2_reg[4] <= 8'd0;
		PS2_reg[3] <= 8'd0;
		PS2_reg[2] <= 8'd0;
		PS2_reg[1] <= 8'd0;
		PS2_reg[0] <= 8'd0;
		
		letter_counter[5] <= 4'd0;
		letter_counter[4] <= 4'd0;
		letter_counter[3] <= 4'd0;
		letter_counter[2] <= 4'd0;
		letter_counter[1] <= 4'd0;
		letter_counter[0] <= 4'd0;
		
		data_count <= 4'd0;
		max_value <= 4'd0;
		letter_count_max <= 4'd5;
		
	end else begin
		PS2_code_ready_buf <= PS2_code_ready;
		if (PS2_code_ready && ~PS2_code_ready_buf && PS2_make_code) begin
			// scan code detected
			if (data_count < 4'd30) begin  
				data_count <= data_count + 4'd1;
				PS2_reg[data_count] <= PS2_code;
				case (PS2_code) 
					8'h1C: letter_counter[0] <= letter_counter[0] + 4'd1; //A
					8'h32: letter_counter[1] <= letter_counter[1] + 4'd1; //B
					8'h21: letter_counter[2] <= letter_counter[2] + 4'd1; //C
					8'h23: letter_counter[3] <= letter_counter[3] + 4'd1; //D
					8'h24: letter_counter[4] <= letter_counter[4] + 4'd1; //E
					8'h2B: letter_counter[5] <= letter_counter[5] + 4'd1; //F
				endcase 
			end 
		end 	
			
		if(data_count == 4'd30) begin 
			if(letter_counter[0] > max_value) begin
				max_value <= letter_counter[0];
				letter_count_max <= 4'd0;
			end 
			if(letter_counter[1] > max_value) begin
				max_value <= letter_counter[1];
				letter_count_max <= 4'd1;
			end 
			if(letter_counter[2] > max_value) begin
				max_value <= letter_counter[2];
				letter_count_max <= 4'd2;
			end 
			if(letter_counter[3] > max_value) begin
				max_value <= letter_counter[3];
				letter_count_max <= 4'd3;
			end 
			if(letter_counter[4] > max_value) begin
				max_value <= letter_counter[4];
				letter_count_max <= 4'd4;
			end 
			if(letter_counter[5] > max_value) begin
				max_value <= letter_counter[5];
				letter_count_max <= 4'd5;
			end 
		end
	end
end

VGA_controller VGA_unit(
	.clock(CLOCK_50_I),
	.resetn(resetn),
	.enable(enable),

	.iRed(VGA_red),
	.iGreen(VGA_green),
	.iBlue(VGA_blue),
	.oCoord_X(pixel_X_pos),
	.oCoord_Y(pixel_Y_pos),
	
	// VGA Side
	.oVGA_R(VGA_RED_O),
	.oVGA_G(VGA_GREEN_O),
	.oVGA_B(VGA_BLUE_O),
	.oVGA_H_SYNC(VGA_HSYNC_O),
	.oVGA_V_SYNC(VGA_VSYNC_O),
	.oVGA_SYNC(VGA_SYNC_O),
	.oVGA_BLANK(VGA_BLANK_O)
);

logic [2:0] delay_X_pos;

always_ff @(posedge CLOCK_50_I or negedge resetn) begin
	if(!resetn) begin
		delay_X_pos[2:0] <= 3'd0;
	end else begin
		delay_X_pos[2:0] <= pixel_X_pos[2:0];
	end
end

// Character ROM
char_rom char_rom_unit (
	.Clock(CLOCK_50_I),
	.Character_address(character_address),
	.Font_row(pixel_Y_pos[2:0]),
	.Font_col(delay_X_pos[2:0]),
	.Rom_mux_output(rom_mux_output)
);

// this experiment is in the 800x600 @ 72 fps mode
assign enable = 1'b1;
assign VGA_CLOCK_O = ~CLOCK_50_I;

always_comb begin
	screen_border_on = 0;
	if (pixel_X_pos == SCREEN_BORDER_OFFSET || pixel_X_pos == H_SYNC_ACT-SCREEN_BORDER_OFFSET)
		if (pixel_Y_pos >= SCREEN_BORDER_OFFSET && pixel_Y_pos < V_SYNC_ACT-SCREEN_BORDER_OFFSET)
			screen_border_on = 1'b1;
	if (pixel_Y_pos == SCREEN_BORDER_OFFSET || pixel_Y_pos == V_SYNC_ACT-SCREEN_BORDER_OFFSET)
		if (pixel_X_pos >= SCREEN_BORDER_OFFSET && pixel_X_pos < H_SYNC_ACT-SCREEN_BORDER_OFFSET)
			screen_border_on = 1'b1;
end

// Display text
always_comb begin

	character_address = 6'o40; // Show space by default
	
	// 8 x 8 characters
	if (pixel_Y_pos[9:3] == ((DEFAULT_MESSAGE_LINE) >> 3)) begin
		// Reach the section where the text is displayed
		case (pixel_X_pos[9:3])
			(DEFAULT_MESSAGE_START_COL >> 3) +  0: character_address = 6'o14; // L
			(DEFAULT_MESSAGE_START_COL >> 3) +  1: character_address = 6'o01; // A
			(DEFAULT_MESSAGE_START_COL >> 3) +  2: character_address = 6'o02; // B
			(DEFAULT_MESSAGE_START_COL >> 3) +  3: character_address = 6'o40; // space
			(DEFAULT_MESSAGE_START_COL >> 3) +  4: character_address = 6'o63; // 3			
			(DEFAULT_MESSAGE_START_COL >> 3) +  5: character_address = 6'o40; // space
			(DEFAULT_MESSAGE_START_COL >> 3) +  6: character_address = 6'o05; // E
			(DEFAULT_MESSAGE_START_COL >> 3) +  7: character_address = 6'o30; // X
			(DEFAULT_MESSAGE_START_COL >> 3) +  8: character_address = 6'o20; // P
			(DEFAULT_MESSAGE_START_COL >> 3) +  9: character_address = 6'o40; // space
			(DEFAULT_MESSAGE_START_COL >> 3) + 10: character_address = 6'o64; // 4			
			(DEFAULT_MESSAGE_START_COL >> 3) + 11: character_address = 6'o40; // space
			(DEFAULT_MESSAGE_START_COL >> 3) + 12: character_address = 6'o03; // C
			(DEFAULT_MESSAGE_START_COL >> 3) + 13: character_address = 6'o10; // H
			(DEFAULT_MESSAGE_START_COL >> 3) + 14: character_address = 6'o05; // E
			(DEFAULT_MESSAGE_START_COL >> 3) + 15: character_address = 6'o03; // C
			(DEFAULT_MESSAGE_START_COL >> 3) + 16: character_address = 6'o13; // K
			(DEFAULT_MESSAGE_START_COL >> 3) + 17: character_address = 6'o40; // space
			(DEFAULT_MESSAGE_START_COL >> 3) + 18: character_address = 6'o60; // 0	
			default: character_address = 6'o40; // space
		endcase
	end

	// 8 x 8 characters
	if (pixel_Y_pos[9:3] == ((KEYBOARD_MESSAGE_LINE) >> 3)) begin
		// Reach the section where the text is displayed
		if (pixel_X_pos[9:3] == ((KEYBOARD_MESSAGE_START_COL >> 3) + display_letter_count)) begin
			case (PS2_reg[display_letter_count])
					8'h45:   character_address = 6'o60; // 0
					8'h16:   character_address = 6'o61; // 1
					8'h1E:   character_address = 6'o62; // 2
					8'h26:   character_address = 6'o63; // 3
					8'h25:   character_address = 6'o64; // 4
					8'h2E:   character_address = 6'o65; // 5
					8'h36:   character_address = 6'o66; // 6
					8'h3D:   character_address = 6'o67; // 7
					8'h3E:   character_address = 6'o70; // 8
					8'h46:   character_address = 6'o71; // 9
					default: character_address = 6'o40; // space
			endcase
		end 	
	end
	
	//displaying message
	if (pixel_Y_pos[9:3] == ((KEYBOARD_MESSAGE_LINE) >> 3)) begin
		if (letter_count_max == 4'd5 && max_value == 4'd0) begin
			case(pixel_X_pos[9:3])
				(KEYPRESS_COUNT_START_COL >> 3) +  0: character_address = 6'o16; // N
				(KEYPRESS_COUNT_START_COL >> 3) +  1: character_address = 6'o17; // O
				(KEYPRESS_COUNT_START_COL >> 3) +  2: character_address = 6'o40; // space
				(KEYPRESS_COUNT_START_COL >> 3) +  3: character_address = 6'o15; // M
				(KEYPRESS_COUNT_START_COL >> 3) +  4: character_address = 6'o17; // O
				(KEYPRESS_COUNT_START_COL >> 3) +  5: character_address = 6'o16; // N
				(KEYPRESS_COUNT_START_COL >> 3) +  6: character_address = 6'o11; // I
				(KEYPRESS_COUNT_START_COL >> 3) +  7: character_address = 6'o24; // T
				(KEYPRESS_COUNT_START_COL >> 3) +  8: character_address = 6'o17; // O
				(KEYPRESS_COUNT_START_COL >> 3) +  9: character_address = 6'o22; // R
				(KEYPRESS_COUNT_START_COL >> 3) + 10: character_address = 6'o05; // E
				(KEYPRESS_COUNT_START_COL >> 3) + 11: character_address = 6'o04; // D	
				(KEYPRESS_COUNT_START_COL >> 3) + 12: character_address = 6'o40; // space
				(KEYPRESS_COUNT_START_COL >> 3) + 13: character_address = 6'o13; // K
				(KEYPRESS_COUNT_START_COL >> 3) + 14: character_address = 6'o05; // E
				(KEYPRESS_COUNT_START_COL >> 3) + 15: character_address = 6'o31; // Y
				(KEYPRESS_COUNT_START_COL >> 3) + 16: character_address = 6'o23; // S			
				(KEYPRESS_COUNT_START_COL >> 3) + 17: character_address = 6'o40; // space
				(KEYPRESS_COUNT_START_COL >> 3) + 18: character_address = 6'o20; // P
				(KEYPRESS_COUNT_START_COL >> 3) + 19: character_address = 6'o22; // R
				(KEYPRESS_COUNT_START_COL >> 3) + 20: character_address = 6'o05; // E
				(KEYPRESS_COUNT_START_COL >> 3) + 21: character_address = 6'o23; // S
				(KEYPRESS_COUNT_START_COL >> 3) + 22: character_address = 6'o23; // S
				(KEYPRESS_COUNT_START_COL >> 3) + 23: character_address = 6'o05; // E
				(KEYPRESS_COUNT_START_COL >> 3) + 24: character_address = 6'o04; // D	
				default: character_address = 6'o40; // space
			endcase
		end else begin 
			case(pixel_X_pos[9:3])
				(KEYPRESS_COUNT_START_COL >> 3) +  0: character_address = 6'o13; // K
				(KEYPRESS_COUNT_START_COL >> 3) +  1: character_address = 6'o05; // E
				(KEYPRESS_COUNT_START_COL >> 3) +  2: character_address = 6'o31; // Y
				(KEYPRESS_COUNT_START_COL >> 3) +  3: character_address = 6'o40; // space
				(KEYPRESS_COUNT_START_COL >> 3) +  4: //LETTER BEING PRESSED 
					case(letter_count_max)
						4'd0: character_address = 6'o01; //A
						4'd1: character_address = 6'o02; //B
						4'd2: character_address = 6'o03; //C
						4'd3: character_address = 6'o04; //D
						4'd4: character_address = 6'o05; //E
						4'd5: character_address = 6'o06; //F
					endcase
				(KEYPRESS_COUNT_START_COL >> 3) +  5: character_address = 6'o40; // space
				(KEYPRESS_COUNT_START_COL >> 3) +  6: character_address = 6'o20; // P
				(KEYPRESS_COUNT_START_COL >> 3) +  7: character_address = 6'o22; // R
				(KEYPRESS_COUNT_START_COL >> 3) +  8: character_address = 6'o05; // E
				(KEYPRESS_COUNT_START_COL >> 3) +  9: character_address = 6'o23; // S
				(KEYPRESS_COUNT_START_COL >> 3) + 10: character_address = 6'o23; // S			
				(KEYPRESS_COUNT_START_COL >> 3) + 11: character_address = 6'o05; // E
				(KEYPRESS_COUNT_START_COL >> 3) + 12: character_address = 6'o04; // D
				(KEYPRESS_COUNT_START_COL >> 3) + 13: character_address = 6'o40; // space
				(KEYPRESS_COUNT_START_COL >> 3) + 14: //NUMBER OF TIMES PRESSED
					case(max_value)
						4'd0: character_address = 6'o60; // 0	 
						4'd1: character_address = 6'o61; // 1
						4'd2: character_address = 6'o62; // 2
						4'd3: character_address = 6'o63; // 3
						4'd4: character_address = 6'o64; // 4
						4'd5: character_address = 6'o65; // 5
						4'd6: character_address = 6'o66; // 6
						4'd7: character_address = 6'o67; // 7
						4'd8: character_address = 6'o70; // 8
						4'd9: character_address = 6'o71; // 9
					endcase 
				(KEYPRESS_COUNT_START_COL >> 3) + 15: character_address = 6'o40; // space
				(KEYPRESS_COUNT_START_COL >> 3) + 16: character_address = 6'o24; // T
				(KEYPRESS_COUNT_START_COL >> 3) + 17: character_address = 6'o11; // I
				(KEYPRESS_COUNT_START_COL >> 3) + 18: character_address = 6'o15; // M
				(KEYPRESS_COUNT_START_COL >> 3) + 19: character_address = 6'o05; // E
				(KEYPRESS_COUNT_START_COL >> 3) + 20: character_address = 6'o23; // S	
				default: character_address = 6'o40; // space		
			endcase
		end 
	end 
	
end


always_ff @(posedge CLOCK_50_I or negedge resetn) begin
	if (resetn == 1'b0) begin
		display_letter_count <= 4'd0;
	end else if (pixel_Y_pos[9:3] == ((KEYBOARD_MESSAGE_LINE) >> 3)) begin
		if (pixel_X_pos == KEYBOARD_MESSAGE_START_COL + display_letter_count*4'd8 + 7) begin
			display_letter_count <= display_letter_count + 4'd1;
		end
	end
end


// RGB signals
always_comb begin
		VGA_red = 8'h00;
		VGA_green = 8'h00;
		VGA_blue = 8'h00;

		if (screen_border_on) begin
			// blue border
			VGA_blue = 8'hFF;
		end
		
		if (rom_mux_output) begin
			// yellow text
			VGA_red = 8'hFF;
			VGA_green = 8'hFF;
		end
end

endmodule
