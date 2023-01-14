/*
COMPENG 3DQ5
Ebrahim Simmons, Bilal Yusuf 
simmoe1, yusufb1 
Monday, November 29th, 2021 
*/

`timescale 1ns/100ps
`ifndef DISABLE_DEFAULT_NET
`default_nettype none
`endif

`include "define_state.h"

module milestone1 (
	input	logic		Clock,
	input	logic		Resetn,

	input	logic[15:0]	SRAM_read_data,
	input	logic		M1_start,

	output	logic[17:0]	SRAM_address,
	output	logic[15:0]	SRAM_write_data,
	output	logic		SRAM_we_n,

	output	logic 		m1_flag
);

milestone1_state_type milestone1_state;

logic [31:0] oper1, oper2, oper3, oper4, multiplier1, multiplier2;
logic [63:0] multiplier1_long, multiplier2_long;

assign multiplier1_long = $signed(oper1)*$signed(oper2);
assign multiplier2_long = $signed(oper3)*$signed(oper4);

assign multiplier1 = multiplier1_long[31:0];
assign multiplier2 = multiplier2_long[31:0];

logic [7:0] Ujn5, Ujn3, Ujn1, Uj1, Uj3, Uj5;
logic [7:0] Vjn5, Vjn3, Vjn1, Vj1, Vj3, Vj5;

logic [31:0] U_prime, V_prime;

logic [7:0] y_odd[2:0], y_even[2:0];
logic [15:0] u_buffer, v_buffer;

logic [31:0] u_even_calc, u_odd_calc;
logic [31:0] v_even_calc, v_odd_calc; 
logic [31:0] y_even_calc, y_odd_calc;

logic [31:0] r_odd, g_odd, b_odd;
logic [31:0] r_even, g_even, b_even;
logic [31:0] RED_ODD_FINAL, RED_EVEN_FINAL; 
logic [31:0] GREEN_ODD_FINAL, GREEN_EVEN_FINAL;
logic [31:0] BLUE_ODD_FINAL, BLUE_EVEN_FINAL;

logic [15:0] n_count;
logic [15:0] addr_count;
logic [15:0] count_uv; 
logic [17:0] counter_rgb;

logic sync;//sync shift registers in common case
logic uvREAD;//determines when to read new U/V values (0 don't read; 1 read)

logic [15:0] RED, GREEN, BLUE;

assign RED[15:8] = RED_ODD_FINAL[31] ? 8'd0: |RED_ODD_FINAL[30:24] ? 8'd255: RED_ODD_FINAL[23:16];
assign RED[7:0] = RED_EVEN_FINAL[31] ? 8'd0: |RED_EVEN_FINAL[30:24] ? 8'd255: RED_EVEN_FINAL[23:16];

assign GREEN[15:8] = GREEN_ODD_FINAL[31] ? 8'd0: |GREEN_ODD_FINAL[30:24] ? 8'd255: GREEN_ODD_FINAL[23:16];
assign GREEN[7:0] = GREEN_EVEN_FINAL[31] ? 8'd0: |GREEN_EVEN_FINAL[30:24] ? 8'd255: GREEN_EVEN_FINAL[23:16];

assign BLUE[15:8] = BLUE_ODD_FINAL[31] ? 8'd0: |BLUE_ODD_FINAL[30:24] ? 8'd255: BLUE_ODD_FINAL[23:16];
assign BLUE[7:0] = BLUE_EVEN_FINAL[31] ? 8'd0: |BLUE_EVEN_FINAL[30:24] ? 8'd255: BLUE_EVEN_FINAL[23:16];

always_ff @ (posedge Clock or negedge Resetn) begin
	if (Resetn == 1'b0) begin
		Ujn5 <= 8'h0;
		Ujn3 <= 8'h0;
		Ujn1 <= 8'h0;
		Uj1 <= 8'h0;
		Uj3 <= 8'h0;
		Uj5 <= 8'h0;
		Vjn5 <= 8'h0;
		Vjn3 <= 8'h0;
		Vjn1 <= 8'h0;
		Vj1 <= 8'h0;
		Vj3 <= 8'h0;
		Vj5 <= 8'h0;

		U_prime <= 32'h0; V_prime <= 32'h0;

		y_odd[0] <= 8'h0; y_even[0] <= 8'h0;
		y_odd[1] <= 8'h0; y_even[1] <= 8'h0;
		y_odd[2] <= 8'h0; y_even[2] <= 8'h0;
		u_buffer <= 8'h0; v_buffer <= 8'h0;

		r_odd <= 32'h0; g_odd <= 32'h0; b_odd <= 32'h0;
		r_even <= 32'h0; g_even <= 32'h0; b_even <= 32'h0;

		u_even_calc <= 32'h0; u_odd_calc <= 32'h0;
		v_even_calc <= 32'h0; v_odd_calc <= 32'h0;
		y_even_calc <= 32'h0; y_odd_calc <= 32'h0;

		oper1 <= 32'h0;
		oper2 <= 32'h0;
		oper3 <= 32'h0;
		oper4 <= 32'h0;

		SRAM_address <= 18'd0;
		SRAM_write_data <= 16'd0;
		SRAM_we_n <= 1'b1;

		m1_flag <= 1'b0;
		uvREAD <= 1'b1;

		n_count <= 16'd0;
		addr_count <= 16'd0;
		count_uv <= 16'd0;
		counter_rgb <= 18'd0;
		sync <= 1'b0;

		milestone1_state <= S_M1_IDLE;
	end else begin
	case (milestone1_state)
		S_M1_IDLE: begin
			if (M1_start) begin
				milestone1_state <= S_M1_LI_1;
			end
		end

//**********************************LEAD IN BEGIN 

		//READ 0,1
		S_M1_LI_1: begin
			SRAM_address <= U_BASE_ADDRESS;
			milestone1_state <= S_M1_LI_2;
		end
		S_M1_LI_2: begin
			SRAM_address <= V_BASE_ADDRESS;
			count_uv <= count_uv + 16'd1;
			milestone1_state <= S_M1_LI_3;
		end
		S_M1_LI_3: begin
			SRAM_address <= Y_BASE_ADDRESS;
			addr_count <= addr_count + 16'd1;
			milestone1_state <= S_M1_LI_4;
		end
		S_M1_LI_4: begin
			SRAM_address <= U_BASE_ADDRESS + count_uv;

			Ujn5 <= SRAM_read_data[15:8];
			Ujn3 <= SRAM_read_data[15:8];
			Ujn1 <= SRAM_read_data[15:8];
			Uj1 <= SRAM_read_data[7:0];

			milestone1_state <= S_M1_LI_5;
		end
		S_M1_LI_5: begin
			SRAM_address <= V_BASE_ADDRESS + count_uv;
			count_uv <= count_uv + 16'd1;

			Vjn5 <= SRAM_read_data[15:8];
			Vjn3 <= SRAM_read_data[15:8];
			Vjn1 <= SRAM_read_data[15:8];
			Vj1 <= SRAM_read_data[7:0];

			milestone1_state <= S_M1_LI_6;
		end
		S_M1_LI_6: begin
			SRAM_address <= Y_BASE_ADDRESS + addr_count;
			addr_count <= addr_count + 16'd1;

			y_even[0] <= SRAM_read_data[15:8];
			y_odd[0] <= SRAM_read_data[7:0];

			milestone1_state <= S_M1_LI_7;
		end
		S_M1_LI_7: begin
			SRAM_address <= U_BASE_ADDRESS + count_uv;

			Uj3 <= SRAM_read_data[15:8];
			Uj5 <= SRAM_read_data[7:0];
			
			milestone1_state <= S_M1_LI_8;
		end
		S_M1_LI_8: begin
			SRAM_address <= V_BASE_ADDRESS + count_uv;
			count_uv <= count_uv + 16'd1;

			Vj3 <= SRAM_read_data[15:8];
			Vj5 <= SRAM_read_data[7:0];

			//U UPSAMPLING 
			oper1 <= 32'd21;
			oper2 <= Ujn5;

			//V UPSAMPLING
			oper3 <= 32'd21;
			oper4 <= Vjn5;
			
			milestone1_state <= S_M1_LI_9;
		end
		S_M1_LI_9: begin
			SRAM_address <= Y_BASE_ADDRESS + addr_count;
			addr_count <= addr_count + 16'd1;

			y_even[1] <= SRAM_read_data[15:8];
			y_odd[1] <= SRAM_read_data[7:0];

			//U UPSAMPLING
			oper1 <= -32'sd52;
			oper2 <= Ujn3;

			//V UPSAMPLING
			oper3 <= -32'sd52;
			oper4 <= Vjn3;

			//UV ACCUMULATION 
			U_prime <= 32'd128 + multiplier1;
			V_prime <= 32'd128 + multiplier2;
			
			milestone1_state <= S_M1_LI_10;
		end
		S_M1_LI_10: begin

			u_buffer <= SRAM_read_data;

			//U UPSAMPLING
			oper1 <= 32'd159;
			oper2 <= Ujn1;

			//V UPSAMPLING
			oper3 <= 32'd159;
			oper4 <= Vjn1;

			//UV ACCUMULATION
			U_prime <= U_prime + multiplier1;
			V_prime <= V_prime + multiplier2;
			
			milestone1_state <= S_M1_LI_11;
		end
		S_M1_LI_11: begin
			v_buffer <= SRAM_read_data;

			//U UPSAMPLING
			oper1 <= 32'd159;
			oper2 <= Uj1;

			//V UPSAMPLING
			oper3 <= 32'd159;
			oper4 <= Vj1;

			//UV ACCUMULATION
			U_prime <= U_prime + multiplier1;
			V_prime <= V_prime + multiplier2;
			
			milestone1_state <= S_M1_LI_12;
		end
		S_M1_LI_12: begin
			y_even[2] <= SRAM_read_data[15:8];
			y_odd[2] <= SRAM_read_data[7:0];

			//U UPSAMPLING
			oper1 <= -32'sd52;
			oper2 <= Uj3;

			//V UPSAMPLING
			oper3 <= -32'sd52;
			oper4 <= Vj3;
				
			//UV ACCUMULATION
			U_prime <= U_prime + multiplier1;
			V_prime <= V_prime + multiplier2;

			milestone1_state <= S_M1_LI_13;
		end

		S_M1_LI_13: begin
			//U UPSAMPLING
			oper1 <= 32'd21;
			oper2 <= Uj5;

			//V UPSAMPLING
			oper3 <= 32'd21;
			oper4 <= Vj5;

			//SHIFT REGISTERS
			Uj5 <= u_buffer[15:8];
			Uj3 <= Uj5;
			Uj1 <= Uj3;
			Ujn1 <= Uj1;
			Ujn3 <= Ujn1;
			Ujn5 <= Ujn3;

			Vj5 <= v_buffer[15:8];
			Vj3 <= Vj5;
			Vj1 <= Vj3;
			Vjn1 <= Vj1;
			Vjn3 <= Vjn1;
			Vjn5 <= Vjn3;

			//UV ACCUMULATION
			U_prime <= U_prime + multiplier1;
			V_prime <= V_prime + multiplier2;

			milestone1_state <= S_M1_LI_14;
		end
		S_M1_LI_14: begin
            //U UPSAMPLING
            oper1 <= 32'd21;
            oper2 <= Ujn5;

            //V UPSAMPLING
            oper3 <= 32'd21;
            oper4 <= Vjn5;
			
			//UV ACCUMULATION
			U_prime <= U_prime + multiplier1;
			V_prime <= V_prime + multiplier2;

			milestone1_state <= S_M1_LI_15;
		end
		S_M1_LI_15: begin
			SRAM_address <= Y_BASE_ADDRESS + addr_count;
			addr_count <= addr_count + 16'd1;

			//U UPSAMPLING
            oper1 <= -32'sd52;
            oper2 <= Ujn3;

            //V UPSAMPLING
            oper3 <= -32'sd52;
            oper4 <= Vjn3;

			//UV ACCUMULATION 
			U_prime <= 32'd128 + multiplier1;
			V_prime <= 32'd128 + multiplier2;

			//CALCULATIONS 
			u_odd_calc <= {{8{U_prime[31]}},U_prime[31:8]} - 32'd128;
			u_even_calc <= {24'd0, Ujn1} - 32'd128;

			v_odd_calc <= {{8{V_prime[31]}},V_prime[31:8]} - 32'd128;
			v_even_calc <= {24'd0, Vjn1} - 32'd128;

			y_odd_calc <= y_odd[0] - 32'd16;
			y_even_calc <= y_even[0] - 32'd16;

			y_even[1] <= y_even[2]; y_odd[1] <= y_odd[2];
			y_even[0] <= y_even[1]; y_odd[0] <= y_odd[1];

			milestone1_state <= S_M1_LI_16;
		end
		
		//START CSC
		S_M1_LI_16: begin
			//U UPSAMPLING
            oper1 <= 32'd159;
            oper2 <= Ujn1;

            //V UPSAMPLING
            oper3 <= 32'd159;
            oper4 <= Vjn1;
			
			//UV ACCUMULATION
			U_prime <= U_prime + multiplier1;
			V_prime <= V_prime + multiplier2;
			
			milestone1_state <= S_M1_LI_17;
		end
		S_M1_LI_17: begin
			//U UPSAMPLING
            oper1 <= 32'd159;
            oper2 <= Uj1;

            //V UPSAMPLING
            oper3 <= 32'd159;
            oper4 <= Vj1;

			//UV ACCUMULATION
			U_prime <= U_prime + multiplier1;
			V_prime <= V_prime + multiplier2;
			
			milestone1_state <= S_M1_LI_18;
		end
		S_M1_LI_18: begin
			y_odd[2] <= SRAM_read_data[7:0];
			y_even[2] <= SRAM_read_data[15:8];

			//U UPSAMPLING
            oper1 <= -32'sd52;
            oper2 <= Uj3;

            //V UPSAMPLING
            oper3 <= -32'sd52;
            oper4 <= Vj3;

			//UV ACCUMULATION
			U_prime <= U_prime + multiplier1;
			V_prime <= V_prime + multiplier2;
			
			milestone1_state <= S_M1_LI_19;
		end

		S_M1_LI_19: begin
			SRAM_address <= U_BASE_ADDRESS + count_uv;

			//U UPSAMPLING
			oper1 <= 32'd21;
			oper2 <= Uj5;

			//V UPSAMPLING
			oper3 <= 32'd21;
			oper4 <= Vj5;

			//SHIFT REGISTERS
			Uj5 <= u_buffer[7:0];
			Uj3 <= Uj5;
			Uj1 <= Uj3;
			Ujn1 <= Uj1;
			Ujn3 <= Ujn1;
			Ujn5 <= Ujn3;

			Vj5 <= v_buffer[7:0];
			Vj3 <= Vj5;
			Vj1 <= Vj3;
			Vjn1 <= Vj1;
			Vjn3 <= Vjn1;
			Vjn5 <= Vjn3;

			//UV ACCUMULATION
			U_prime <= U_prime + multiplier1;
			V_prime <= V_prime + multiplier2;
			
			milestone1_state <= S_M1_LI_20;
		end
		S_M1_LI_20: begin
			SRAM_address <= V_BASE_ADDRESS + count_uv;
			
			//UV ACCUMULATION
			U_prime <= U_prime + multiplier1;
			V_prime <= V_prime + multiplier2;	
			
			milestone1_state <= S_M1_LI_21;
		end
		
		S_M1_LI_21: begin
			SRAM_address <= Y_BASE_ADDRESS + addr_count;
			addr_count <= addr_count + 16'd1;
			
			// STORE FOR CALCULATIONS
			u_odd_calc <= {{8{U_prime[31]}},U_prime[31:8]} - 32'd128;
			u_even_calc <= {24'd0, Ujn1} - 32'd128;

			v_odd_calc <= {{8{V_prime[31]}},V_prime[31:8]} - 32'd128;
			v_even_calc <= {24'd0, Vjn1} - 32'd128;

			y_odd_calc <= y_odd[0] - 32'd16;
			y_even_calc <= y_even[0] - 32'd16;

			y_even[1] <= y_even[2]; y_odd[1] <= y_odd[2];
			y_even[0] <= y_even[1]; y_odd[0] <= y_odd[1];

			milestone1_state <= S_M1_LI_22;
		end
		
		//RGB 
		S_M1_LI_22: begin
			//RGB ODD
			oper1 <= 32'd76284;
			oper2 <= y_odd_calc;
			
			//RGB EVEN
			oper3 <= 32'd76284;
			oper4 <= y_even_calc;
			
			milestone1_state <= S_M1_LI_23;
		end
		
		S_M1_LI_23: begin
			//RGB ODD
			oper1 <= 32'd104595;
			oper2 <= v_odd_calc;
			
			//RGB EVEN
			oper3 <= 32'd104595;
			oper4 <= v_even_calc;

			//RGB ACCUMULATION
			r_even <= multiplier2; r_odd <= multiplier1;
			g_even <= multiplier2; g_odd <= multiplier1;
			b_even <= multiplier2; b_odd <= multiplier1;

			milestone1_state <= S_M1_LI_24;
		end
		
		S_M1_LI_24: begin
			//RGB ODD
			oper1 <= -32'sd25624;
			oper2 <= u_odd_calc;
			
			//RGB EVEN
			oper3 <= -32'sd25624;
			oper4 <= u_even_calc;

			//RGB ACCUMULATION
			r_even <= r_even + multiplier2; 
			r_odd <= r_odd + multiplier1;

			milestone1_state <= S_M1_LI_25;
		end
		
		S_M1_LI_25: begin
			//RGB ODD
			oper1 <= -32'sd53281;
			oper2 <= v_odd_calc;
			
			//RGB EVEN
			oper3 <= -32'sd53281;
			oper4 <= v_even_calc;

			//RGB ACCUMULATION
			g_even <= g_even + multiplier2; 
			g_odd <= g_odd + multiplier1;
			
			milestone1_state <= S_M1_LI_26;
		end
		
		S_M1_LI_26: begin
			//RGB ODD
			oper1 <= 32'd132251;
			oper2 <= u_odd_calc;
			
			//RGB EVEN
			oper3 <= 32'd132251;
			oper4 <= u_even_calc;

			//RGB ACCUMULATION
			g_even <= g_even + multiplier2; 
			g_odd <= g_odd + multiplier1;
			
			milestone1_state <= S_M1_LI_27;
		end
		
		S_M1_LI_27: begin
			//RGB ACCUMULATION
			RED_ODD_FINAL <= r_odd; RED_EVEN_FINAL <= r_even;
			GREEN_ODD_FINAL <= g_odd; GREEN_EVEN_FINAL <= g_even;
			BLUE_ODD_FINAL <= b_odd + multiplier1; BLUE_EVEN_FINAL <= b_even + multiplier2;

			n_count <= 16'd2;
			
			milestone1_state <= S_M1_CC_1;
		end
		
//**********************************LEAD IN END
//**********************************COMMON CASE BEGIN 

		// READ; COMPUTE; WRITE
		S_M1_CC_1: begin 
			SRAM_address <= RGB_BASE_ADDRESS + counter_rgb; 

			if (uvREAD) begin
				u_buffer <= SRAM_read_data;
			end
			
			// U UPSAMPLINGstarting the upsampling here, we exploit the symmetry so we can do more calulation in less states 
			oper1 <= 32'd21; 
			oper2 <= Ujn5 + Uj5; //21*(Ujn5 + Uj5)
			
			//lead out statments check to see if the count is above 156 if so replace values of uj5 with value depending on n_count (otherwise it will exceed value)
			if (n_count > 16'd156) begin
				case (n_count)
					16'd159: oper2 <= Ujn5 +Ujn1;//21*(Ujn5 +Ujn1)
					16'd158: oper2 <= Ujn5 +Uj1;//21*(Ujn5 +Uj1)
					16'd157: oper2 <= Ujn5 +Uj3;//21*(Ujn5 +Uj3)
				endcase
			end
			
			//U UPSAMPLING we exploit the symmetry so we can do more calulation in less states 
			oper3 <= -32'sd52;
			oper4 <= Ujn3 + Uj3; //-52*(ujn3 + uj3)
			
			
			//lead out statments check to see if the count is above 157 if so replace values of uj3 with value depending on n_count (otherwise it will exceed value)
			if (n_count > 16'd157) begin
				case (n_count)
					16'd159: oper4 <= Ujn3 +Ujn1; //-52*(ujn3 + Ujn1)
					16'd158: oper4 <= Ujn3 +Uj1;//-52*(ujn3 + Uj1)
				endcase
			end
			
			//writing back the data here from last cycle/lead in
			//ebabling the write enable
			SRAM_we_n <= 1'b0;
			SRAM_write_data <= {RED[7:0], GREEN[7:0]};//r_even, g_even
	
			//go to next state 
			milestone1_state <= S_M1_CC_2;
		end
		S_M1_CC_2: begin
            SRAM_address <= RGB_BASE_ADDRESS + counter_rgb + 18'd1; 

            if (uvREAD) begin
                v_buffer <= SRAM_read_data;
                count_uv <= count_uv + 16'd1;
            end

			   // U UPSAMPLING we exploit the symmetry so we can do more calulation in less states 
            oper1 <= 32'd159;
            oper2 <= Ujn1 + Uj1;//159(ujn1 +uj1)
				
				//checking too see if Uj+1 exceeds max value if so replace with Uj-1
				if (n_count == 16'd159) oper2 <= Ujn1 + Ujn1; //159 * (ujn1 + ujn1)
				
			   // V UPSAMPLING starting the V upsampling here, we exploit the symmetry so we can do more calulation in less states 
            oper3 <= 32'd159;
            oper4 <= Vjn1 + Vj1;//159 * (vjn1 + vj1)
				
				//checking too see if Vj+1 exceeds max value if so replace with Vj-1
				if (n_count == 16'd159) oper4 <= Vjn1+ Vjn1; //159 * (vjn1 + vjn1)
				
            // U' ACCUMULATION
				//adding up the U prime values from last state 		
            U_prime <= 32'd128 + multiplier1 + multiplier2;//21*(Ujn5 +Uj5) - 52(Ujn3 + Uj3) +128
				
				//writing back the data here from last cycle/lead in
				//ebabling the write enable
				SRAM_write_data <= {BLUE[7:0], RED[15:8]};// b_even, r_odd
				
				//go to next state 
            milestone1_state <= S_M1_CC_3;
        end 

        S_M1_CC_3: begin
            SRAM_address <= RGB_BASE_ADDRESS + counter_rgb + 18'd2; 
            counter_rgb <= counter_rgb + 16'd3;
				
				uvREAD <= ~uvREAD;

            y_even[2] <= SRAM_read_data[15:8];
            y_odd[2] <= SRAM_read_data[7:0];
            

            // V UPSAMPLING we exploit the symmetry so we can do more calulation in less states 
            oper1 <= 32'd21;
            oper2 <= Vjn5 + Vj5; //21*(Vjn5 + Vj5)
								
								
				//checking too see if Vj+5 exceeds max value if so replace with appropiate val
				if (n_count > 16'd156) begin
					case (n_count)
						16'd159: oper2 <= Vjn5 +Vjn1; //21*(Vjn5 + Vjn1)
						16'd158: oper2 <= Vjn5 +Vj1;//21*(Vjn5 + Vj1)
						16'd157: oper2 <= Vjn5 +Vj3;//21*(Vjn5 + Vj3)
					endcase
				end
				
				// V UPSAMPLING we exploit the symmetry so we can do more calulation in less states 
            oper3 <= -32'sd52;
            oper4 <= Vjn3 + Vj3; //-52*vjn3 +vj3
					
				//checking too see if Vj+3 exceeds max value if so replace with appropiate val
				if (n_count > 16'd157) begin
					case (n_count)
						16'd159: oper4 <= Vjn3 +Vjn1;//-52*Vjn3 +Vjn1
						16'd158: oper4 <=Vjn3 + Vj1;//-52*vVjn3 +Vj1
					endcase
				end	
				
				//SHIFT REGISTERS
				if (~uvREAD) begin
					Uj5 <= u_buffer[7:0];
				end else begin
					Uj5 <= u_buffer[15:8];
				end
				Uj3 <= Uj5;
				Uj1 <= Uj3;
				Ujn1 <= Uj1;
				Ujn3 <= Ujn1;
				Ujn5 <= Ujn3;
				
				if (~uvREAD) begin
					Vj5 <= v_buffer[7:0];
				end else begin
					Vj5 <= v_buffer[15:8];
				end
				Vj3 <= Vj5;
				Vj1 <= Vj3;
				Vjn1 <= Vj1;
				Vjn3 <= Vjn1;
				Vjn5 <= Vjn3;
				
				//add 1 to n_count 
				n_count <= n_count + 16'd1;
				//if it hits 159 reset to zero
				if (n_count == 16'd159) n_count <= 16'd0;
				
            // U' and V' ACCUMULATION
				//adding U' values from last state
				U_prime <= U_prime + multiplier1;//21*(Ujn5 +Uj5) - 52(Ujn3 + Uj3) + 159*(Ujn1+ Uj1) +128
            //begining to add V' values up
				V_prime <= 32'd128 + multiplier2; //159*(Vjn1 + Vj1) +128

				//writing the SRAM data for green odd and blue odd
				SRAM_write_data <= {GREEN[15:8], BLUE[15:8]}; //g_odd, b_odd 
				
            milestone1_state <= S_M1_CC_4;
        end
		  
		S_M1_CC_4: begin
			//SRAM_address <= U_BASE_ADDRESS + count_uv;
			
			// starting the RGB acculmulation
			oper1 <= 32'd76284;
			oper2 <= y_even_calc; //y even * 76284

			oper3 <= 32'd104595;
			oper4 <= v_even_calc; //v even * 104595
			
         //final V' ACCUMULATION from last state
			//adding V' values from last state
			V_prime <= V_prime + multiplier1 + multiplier2; //159 * (Vjn1 + Vj1) 21*(Ujn5 +Uj5) - 52(Ujn3 + Uj3) +128
			
			//disable sram write enable
			SRAM_we_n <= 1'b1;

			//go to next state
			milestone1_state <= S_M1_CC_5; 
		end
		
		S_M1_CC_5: begin
			//SRAM_address <= V_BASE_ADDRESS + count_uv;
			
			// starting the RGB acculmulation
			oper1 <= -32'sd25624;;
			oper2 <= u_even_calc; //u' even * -25624

			oper3 <= -32'sd53281;;
			oper4 <= v_even_calc; //v' *-53281

			// RGB ACCUMULATION
			//assigning the first multiplier value to all even rgb since that is same
			r_even <= multiplier1 + multiplier2;  
			g_even <= multiplier1;
			b_even <= multiplier1;
		
			//go to next state 
			milestone1_state <= S_M1_CC_6;
		end
		
		S_M1_CC_6: begin
			//SRAM_address <= Y_BASE_ADDRESS + addr_count;

			// RGB acculmulation 
			//final even calculation for even 
			oper1 <= 32'd132251;
			oper2 <= u_even_calc; //u' even * 132251

			// starting the rgb accumlation for odd values
			oper3 <= 32'd76284;
			oper4 <= y_odd_calc; //y odd * 76284

			// RGB ACCUMULATION
			//adding multiplier values of 1 and 2 to green even from last state
			g_even <= g_even + multiplier1 + multiplier2; 
			
			//go to next state
			milestone1_state <= S_M1_CC_7;

		end

		S_M1_CC_7: begin
			SRAM_address <= U_BASE_ADDRESS + count_uv;

				// RGB acculmulation 
            oper1 <= 32'd104595;
            oper2 <= v_odd_calc; // v odd * 104595

				// RGB acculmulation 
            oper3 <= -32'sd25624;
            oper4 <= u_odd_calc;//u odd* -256424


			// RGB ACCUMULATION
			//finsihing b even val from last state 
			b_even <= b_even + multiplier1; 
			
			//assgining first odd vals to rgb
			r_odd <= multiplier2;
			g_odd <= multiplier2;
			b_odd <= multiplier2;	
			
			//go to next state
			milestone1_state <= S_M1_CC_8;

		end		
		
		S_M1_CC_8: begin
			SRAM_address <= V_BASE_ADDRESS + count_uv;

				// RGB acculmulation 
            oper1 <= -32'sd53281;
            oper2 <= v_odd_calc;//53281*v' odd

				// RGB acculmulation 
            oper3 <= 32'd132251;
            oper4 <= u_odd_calc;//u' odd *132251


			// RGB ACCUMULATION
			r_odd <= r_odd + multiplier1; //final accumulation for red odd
			g_odd <= g_odd + multiplier2; //accumlation for green odd


			if (addr_count == 16'd10) sync = 1'b1;
			
			milestone1_state <= S_M1_CC_9;

		end	
		S_M1_CC_9: begin
			SRAM_address <= Y_BASE_ADDRESS + addr_count;
			addr_count <= addr_count + 16'd1;
			
			// STORE FOR CALCULATIONS
			
			//calculating u odd
			u_odd_calc <= {{8{U_prime[31]}},U_prime[31:8]} - 32'd128;
			//calculating u even
			//if addr count greater than 10 use ujn3 instead
			if (sync) begin
				u_even_calc <= {24'd0, Ujn3} - 32'd128;
			end else begin
				u_even_calc <= {24'd0, Ujn1} - 32'd128;
			end
			
			//calculating v odd
			v_odd_calc <= {{8{V_prime[31]}},V_prime[31:8]} - 32'd128;
			//calculating v even
			//if addr count greater than 10 use vjn3 instead
			if (sync) begin
				v_even_calc <= {24'd0, Vjn3} - 32'd128; 
			end else begin
				v_even_calc <= {24'd0, Vjn1} - 32'd128;
			end

			
			y_odd_calc <= y_odd[0] - 32'd16;
			y_even_calc <= y_even[0] - 32'd16;

			y_even[1] <= y_even[2]; y_odd[1] <= y_odd[2];
			y_even[0] <= y_even[1]; y_odd[0] <= y_odd[1];

						
			// RGB ACCUMULATION (FINAL)
			//add values to green odd and blue odd from last state
			RED_ODD_FINAL <= r_odd; RED_EVEN_FINAL <= r_even;
			GREEN_ODD_FINAL <= g_odd + multiplier1; GREEN_EVEN_FINAL <= g_even;
			BLUE_ODD_FINAL <= b_odd + multiplier2; BLUE_EVEN_FINAL <= b_even;
			
			if (addr_count < 16'd38404) begin
				milestone1_state <= S_M1_CC_1;
			end else begin
				milestone1_state <= S_M1_FINISH;
			end

		end	
		S_M1_FINISH: begin
			m1_flag <= 1'b1;
		end
		endcase
	end
end

endmodule 