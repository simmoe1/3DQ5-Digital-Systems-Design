/*
COMP ENG 3DQ5 
Ebrahim Simmons, Bilal Yusuf 
simmoe1, yusufb1
Monday, November 29, 2021
*/

`timescale 1ns/100ps
`ifndef DISABLE_DEFAULT_NET
`default_nettype none
`endif

`include "define_state.h"

module milestone2 (
    input   logic       Clock,
    input   logic       Resetn,

    input   logic[15:0] SRAM_read_data,
    input   logic       M2_start,

	output  logic[17:0] SRAM_address,
	output  logic[15:0] SRAM_write_data,
	output  logic	    SRAM_we_n,

    output logic m2_flag
);

milestone2_state_type milestone2_state;

logic [2:0] S_row, S_column, C_row, C_column, T_row, T_column;
logic compute_first_row, fetch_finish, fetch_toggle, write_finish;

//SRAM 
logic [6:0] address_a_S, address_b_S;
logic [31:0] data_a_S, data_b_S;
logic wren_a_S, wren_b_S;
logic [31:0] q_a_S, q_b_S;
logic [31:0] S_BUFFER_1, S_BUFFER_2, S_BUFFER_3;

//CRAM 
logic [6:0] address_a_C, address_b_C;
logic [31:0] data_a_C, data_b_C;
logic wren_a_C, wren_b_C;
logic [31:0] q_a_C, q_b_C;

//TRAM 
logic [6:0] address_a_T, address_b_T;
logic [31:0] data_a_T, data_b_T;
logic wren_a_T, wren_b_T;
logic [31:0] q_a_T, q_b_T;
logic [31:0] T_BUFFER_1, T_BUFFER_2, T_BUFFER_3;

assign data_a_C = 32'd0; assign data_b_C = 32'd0;
assign wren_a_C = 1'b0; assign wren_b_C = 1'b0;


dual_port_RAM S_RAM (
    .address_a(address_a_S),
	.address_b(address_b_S),
	.clock(Clock),
	.data_a(data_a_S),
	.data_b(data_b_S),
	.wren_a(wren_a_S),
	.wren_b(wren_b_S),
	.q_a(q_a_S),
	.q_b(q_b_S)
);

dual_port_RAM C_RAM (
    .address_a(address_a_C),
	.address_b(address_b_C),
	.clock(Clock),
	.data_a(data_a_C),
	.data_b(data_b_C),
	.wren_a(wren_a_C),
	.wren_b(wren_b_C),
	.q_a(q_a_C),
	.q_b(q_b_C)
);

dual_port_RAM T_RAM (
    .address_a(address_a_T),
	.address_b(address_b_T),
	.clock(Clock),
	.data_a(data_a_T),
	.data_b(data_b_T),
	.wren_a(wren_a_T),
	.wren_b(wren_b_T),
	.q_a(q_a_T),
	.q_b(q_b_T)
);

logic [31:0] oper1, oper2, oper3, oper4, oper5, oper6, multiplier1, multiplier2, multiplier3, accumulation1, accumulation2, accumulation3;
logic [63:0] multiplier1_long, multiplier2_long, multiplier3_long;

assign multiplier1_long = oper1*oper2;
assign multiplier2_long = oper3*oper4;
assign multiplier3_long = oper5*oper6;

assign multiplier1 = multiplier1_long[31:0];
assign multiplier2 = multiplier2_long[31:0];
assign multiplier3 = multiplier3_long[31:0];

logic [6:0] dpram_adder; //reading and writing 
logic read_adder_enable; //0=disable, 1=enable 
logic write_adder_enable; //0=disable, 1=enable 
logic [17:0] read_address;

//*************************************************************************************

always_ff @ (posedge Clock or negedge Resetn) begin
    if (Resetn == 1'b0) begin
        oper1 <= 32'd0; oper2 <= 32'd0; oper3 <= 32'd0; 
		  oper4 <= 32'd0;oper5 <= 32'd0; oper6 <= 32'd0;

        accumulation1 <= 32'd0; accumulation2 <= 32'd0; accumulation3 <= 32'd0;
		  
		  compute_first_row <= 1'b0;
		  fetch_finish <= 1'b0; fetch_toggle <= 1'b0;
		  write_finish <= 1'b0;
		  
		  S_row <= 3'd0; S_column <= 3'd0;
		  C_row <= 3'd0; C_column <= 3'd0;
		  T_row <= 3'd0; T_column <= 3'd0;

        address_a_S <= 7'd0; address_b_S <= 7'd0;
        data_a_S <= 32'd0; data_b_S <= 32'd0;
        wren_a_S <= 1'b0; wren_b_S <= 1'b0;
        S_BUFFER_1 <= 32'd0; S_BUFFER_2 <= 32'd0; S_BUFFER_3 <= 32'd0;
		  
		  address_a_C <= 7'd0; address_b_C <= 7'd0;
		  
        address_a_T <= 7'd0; address_b_T <= 7'd0;
        data_a_T <= 32'd0; data_b_T <= 32'd0;
        wren_a_T <= 1'b0; wren_b_T <= 1'b0;
        T_BUFFER_1 <= 32'd0; T_BUFFER_2 <= 32'd0; T_BUFFER_3 <= 32'd0;

        dpram_adder <= 7'd0;
        read_adder_enable <= 1'b0;
        write_adder_enable <= 1'b0;
        m2_flag <= 1'b0;
		
        SRAM_address <= 18'd0;
		  SRAM_write_data <= 16'd0;
        SRAM_we_n <= 1'b1;

        milestone2_state <= S_M2_IDLE;
    end else begin
        case (milestone2_state)
        S_M2_IDLE: begin
            if (M2_start) begin
                milestone2_state <= S_M2_LI_1;
                read_adder_enable <= 1'b1;  
            end
        end

//**********************************************************LEAD IN 
		  
        // FETCH S'
        S_M2_LI_1: begin
            SRAM_address <= read_address;
            milestone2_state <= S_M2_LI_2;
        end
		  S_M2_LI_2: begin
            SRAM_address <= read_address;
            milestone2_state <= S_M2_LI_2;
        end
        S_M2_LI_3: begin
            SRAM_address <= read_address;
            milestone2_state <= S_M2_LI_3;
        end
        S_M2_LI_4: begin
            SRAM_address <= read_address;            
            milestone2_state <= S_M2_LI_4;
        end
        S_M2_LI_5: begin
            SRAM_address <= read_address;            

            address_a_S <= dpram_adder;
            data_a_S[15:0] <= SRAM_read_data;

            milestone2_state <= S_M2_LI_5;

            if (dpram_adder == 7'd30) begin
                milestone2_state <= S_M2_LI_6;
                read_adder_enable <= 1'b0;
            end
        end
        S_M2_LI_6: begin
            SRAM_address <= read_address;            

            address_a_S <= dpram_adder;
            data_a_S[31:16] <= SRAM_read_data;
            wren_a_S <= 1'b1;

            dpram_adder <= dpram_adder + 7'd1; 
            milestone2_state <= S_M2_LI_4;
        end
        S_M2_LI_7: begin
            address_a_S <= dpram_adder;
            data_a_S[31:16] <= SRAM_read_data;

            dpram_adder <= dpram_adder + 7'd1;
            milestone2_state <= S_M2_LI_7;
        end
        S_M2_LI_8: begin
            address_a_S <= dpram_adder;
            data_a_S[15:0] <= SRAM_read_data;
            
            milestone2_state <= S_M2_LI_8;
        end
        S_M2_LI_9: begin
            address_a_S <= dpram_adder;
            data_a_S[31:16] <= SRAM_read_data;

            dpram_adder <= 7'd0;
            milestone2_state <= S_M2_LI_9;
        end

        //T COMPUTATION 
        S_M2_LI_10: begin
            wren_a_S <= 1'b0;

            address_a_S <= {S_row, 2'd0} + S_column[2:1];
            address_a_C <= {C_row, 2'd0} + C_column[2:1];
            address_b_C <= {C_row, 2'd0} + 7'd1 + C_column[2:1];

            S_column <= S_column + 3'd1;
            C_row <= C_row + 3'd1;

            milestone2_state <= S_M2_LI_10;
        end

        S_M2_LI_11: begin
            address_a_S <= {S_row, 2'd0} + S_column[2:1];
            address_a_C <= {C_row, 2'd0} + C_column[2:1];
            address_b_C <= {C_row, 2'd0} + 7'd1 + C_column[2:1];

            S_column <= S_column + 3'd1;
            C_row <= C_row + 3'd1;

            milestone2_state <= S_M2_LI_11;
        end
		  
        S_M2_LI_12: begin
            address_a_S <= {S_row, 2'd0} + S_column[2:1];
            address_a_C <= {C_row, 2'd0} + C_column[2:1];
            address_b_C <= {C_row, 2'd0} + 7'd1 + C_column[2:1];

            S_column <= S_column + 3'd1;
            C_row <= C_row + 3'd1;

            case (S_column[0])
                1'b0: begin
                    oper1 <= q_a_S[15:0]; 
                    oper3 <= q_a_S[15:0];
                    oper5 <= q_a_S[15:0];
                end
                1'b1: begin
                    oper1 <= q_a_S[31:16]; 
                    oper3 <= q_a_S[31:16]; 
                    oper5 <= q_a_S[31:16]; 
                end
            endcase

            oper2 <= q_a_C[31:16];
            oper4 <= q_a_C[15:0];
            oper6 <= q_b_C[31:16];         

            accumulation1 <= accumulation1 + multiplier1;
            accumulation2 <= accumulation2 + multiplier2;
            accumulation3 <= accumulation3 + multiplier3;

            if (S_column == 3'd3 && compute_first_row) begin
                accumulation1 <= multiplier1; accumulation2 <= multiplier2; accumulation3 <= multiplier3;
                T_BUFFER_1 <= accumulation1;
                T_BUFFER_2 <= accumulation2;
                T_BUFFER_3 <= accumulation3;
            end

            if (S_column == 3'd4 && compute_first_row) begin                        
                data_a_T <= T_BUFFER_1[31:8];
                data_b_T <= T_BUFFER_2[31:8];

                address_a_T <= {T_row, 3'd0} + T_column;
                address_b_T <= {T_row, 3'd0} + T_column + 7'd1;

                wren_a_T <= 1'b1; wren_b_T <= 1'b1;
            end

            if (S_column == 3'd5 && compute_first_row) begin
                data_a_T <= T_BUFFER_3[31:8];

                address_a_T <= {T_row, 3'd0} + T_column + 7'd2;
                address_b_T <= {T_row, 3'd0} + T_column + 7'd3;
            end

            if (S_column == 3'd6 && compute_first_row) begin
                wren_a_T <= 1'b0; wren_b_T <= 1'b0;

                if (T_row == 3'd7 && T_column == 3'd4) begin
                    read_adder_enable <= 1'b1;

                    compute_first_row <= 1'b0;

                    C_column <= 3'd0; C_row <= 3'd0;
                    S_column <= 3'd0; S_row <= 3'd0;
                    T_column <= 3'd0; T_row <= 3'd0;

                    oper1 <= 32'd0; oper2 <= 32'd0; oper3 <= 32'd0; oper4 <= 32'd0; oper5 <= 32'd0; oper6 <= 32'd0;

                    accumulation1 <= 32'd0; accumulation2 <= 32'd0; accumulation3 <= 32'd0;
                end
            end
            
				//INCREASE C ROWS 
            if (C_row == 3'd7) begin 
                C_column <= C_column + 3'd4;

                compute_first_row <= 1'b1;
                
                T_row <= S_row; T_column <= C_column; 

					 //INCREASE S COLUMNS   
                if (C_column == 3'd4) begin
                    S_row <= S_row + 3'd1;                        
                end
            end
        end
		  
		  endcase 
    end
end

endmodule



