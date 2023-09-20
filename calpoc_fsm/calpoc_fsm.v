`define STATE_ARG1 2'b00
`define STATE_ARG2_OR 2'b01
`define STATE_ARG2_XOR 2'b10
`define STATE_OUTPUT 2'b11

`define ALU_OR 1'b1
`define ALU_XOR 1'b0

`define SHIFT_REG_RESET 2'b00
`define SHIFT_REG_STAY 2'b01
`define SHIFT_REG_SHIFT 2'b10

module CalPOC_FSM (

    input wire CLK;

    input wire ButtonFor1;
    input wire ButtonFor0;

    input wire ButtonForOR;
    input wire ButtonForXOR;

    input wire ButtonForEquals;
    input wire ButtonForClear;

    output wire [2:0] LEDForA;
    output wire [2:0] LEDForB;
    output wire [2:0] SevenSeg;
);

    reg [1:0] state;
    wire [1:0] state_next;

    reg [3:0] shift_reg_arg1;
    reg [3:0] shift_reg_arg2;
    
    wire [3:0] shift_reg_arg1_next;
    wire [3:0] shift_reg_arg2_next;

    wire [2:0] alu_output;

    //output representation (simply connecting wires)
    assign LEDForA = shift_reg_arg1[2:0];
    assign LEDForB = shift_reg_arg2[2:0];
    assign SevenSeg = alu_output;

    //mini alu for prototyping
    function [2:0] mini_alu(
        input [2:0] arg1;
        input [2:0] arg2;

        input opcode;
    );
        mini_alu = (`ALU_OR == sel) ? arg1|arg1 : 
                    (`ALU_XOR == sel) ? arg1^arg2 : 3'b0;
        
    endfunction

    //shift register control: simply models behavior of shift registers
    function [3:0] control_shift_reg(

        input [3:0] shift_reg;
        input data;

        input [1:0] mode;
    );
        control_shift_reg = (`SHIFT_REG_RESET == mode) ? 4'b0000 : 
                            (`SHIFT_REG_STAY == mode) ? shift_reg :
                            (`SHIFT_REG_SHIFT == mode) ? {shift_reg[2:0], data} : 4'bz; 
        
    endfunction

    //comb logic: alu control
    always @(*) begin

        alu_output = (`STATE_ARG2_OR == state) ? mini_alu(shift_reg_arg1[2:0], shift_reg_arg2[2:0], `ALU_OR) :
                    (`STATE_ARG2_XOR == state) ? mini_alu(shift_reg_arg1[2:0], shift_reg_arg2[2:0], `ALU_XOR) : 3'b000
    end

    //comb logic: shift register control (determining next state)
    always @(*) begin
        case(state)

            `STATE_ARG1: begin
                
                if(ButtonForClear) begin
                    //reset shift registers

                    shift_reg_arg1_next = control_shift_reg(shift_reg_arg1, 0, `SHIFT_REG_RESET);
                    shift_reg_arg2_next = control_shift_reg(shift_reg_arg2, 0, `SHIFT_REG_RESET);
                end
                else if(ButtonFor0) begin

                    shift_reg_arg1_next = control_shift_reg(shift_reg_arg1, 0, `SHIFT_REG_SHIFT);
                    shift_reg_arg2_next = control_shift_reg(shift_reg_arg2, 0, `SHIFT_REG_STAY);
                end
                else if(ButtonFor1) begin

                    shift_reg_arg1_next = control_shift_reg(shift_reg_arg1, 1, `SHIFT_REG_SHIFT);
                    shift_reg_arg2_next = control_shift_reg(shift_reg_arg2, 0, `SHIFT_REG_STAY);
                end
                else begin

                    shift_reg_arg1_next = control_shift_reg(shift_reg_arg1, 0, `SHIFT_REG_STAY);
                    shift_reg_arg2_next = control_shift_reg(shift_reg_arg2, 0, `SHIFT_REG_STAY);
                end
            end

            `STATE_ARG2_OR: begin

                if(ButtonForClear) begin

                    shift_reg_arg1_next = control_shift_reg(shift_reg_arg1, 0, `SHIFT_REG_RESET);
                    shift_reg_arg2_next = control_shift_reg(shift_reg_arg2, 0, `SHIFT_REG_RESET);
                end
                else if(ButtonFor0) begin

                    shift_reg_arg1_next = control_shift_reg(shift_reg_arg1, 0, `SHIFT_REG_STAY);
                    shift_reg_arg2_next = control_shift_reg(shift_reg_arg2, 0, `SHIFT_REG_SHIFT);
                end
                else if(ButtonFor1) begin

                    shift_reg_arg1_next = control_shift_reg(shift_reg_arg1, 0, `SHIFT_REG_STAY);
                    shift_reg_arg2_next = control_shift_reg(shift_reg_arg2, 1, `SHIFT_REG_SHIFT);
                end
                else begin

                    shift_reg_arg1_next = control_shift_reg(shift_reg_arg1, 0, `SHIFT_REG_STAY);
                    shift_reg_arg2_next = control_shift_reg(shift_reg_arg2, 0, `SHIFT_REG_STAY);
                end
            end

            `STATE_ARG2_XOR: begin

                if(ButtonForClear) begin

                    shift_reg_arg1_next = control_shift_reg(shift_reg_arg1, 0, `SHIFT_REG_RESET);
                    shift_reg_arg2_next = control_shift_reg(shift_reg_arg2, 0, `SHIFT_REG_RESET);
                end
                else if(ButtonFor0) begin

                    shift_reg_arg1_next = control_shift_reg(shift_reg_arg1, 0, `SHIFT_REG_STAY);
                    shift_reg_arg2_next = control_shift_reg(shift_reg_arg2, 0, `SHIFT_REG_SHIFT);
                end
                else if(ButtonFor1) begin

                    shift_reg_arg1_next = control_shift_reg(shift_reg_arg1, 0, `SHIFT_REG_STAY);
                    shift_reg_arg2_next = control_shift_reg(shift_reg_arg2, 1, `SHIFT_REG_SHIFT);
                end
                else begin

                    shift_reg_arg1_next = control_shift_reg(shift_reg_arg1, 0, `SHIFT_REG_STAY);
                    shift_reg_arg2_next = control_shift_reg(shift_reg_arg2, 0, `SHIFT_REG_STAY);
                end
            end

            `STATE_OUTPUT: begin
                if(ButtonForClear) begin

                    shift_reg_arg1_next = control_shift_reg(shift_reg_arg1, 0, `SHIFT_REG_RESET);
                    shift_reg_arg2_next = control_shift_reg(shift_reg_arg2, 0, `SHIFT_REG_RESET);
                end
                else begin

                    shift_reg_arg1_next = control_shift_reg(shift_reg_arg1, 0, `SHIFT_REG_STAY);
                    shift_reg_arg2_next = control_shift_reg(shift_reg_arg2, 0, `SHIFT_REG_STAY);
                end
            end
        endcase
    end

    //comb logic: DFF control (determining next state)
    always @(*) begin

        case(state)

            `STATE_ARG1: begin
                
                if(ButtonForClear) begin
                    state_next = `STATE_ARG1;
                end
                else if(ButtonForOR) begin
                    state_next = `STATE_ARG2_OR;
                end
                else if(ButtonForXOR) begin
                    state_next = `STATE_ARG2_XOR;
                end
                else begin
                    state_next = `STATE_ARG1;
                end
            end

            `STATE_ARG2_OR: begin

                if(ButtonForClear) begin
                    state_next = `STATE_ARG1;
                end
                else if(ButtonForEquals) begin
                    state_next = `STATE_ARG3;
                end
                else begin
                    state_next = `STATE_ARG2_OR;
                end
            end

            `STATE_ARG2_XOR: begin

                if(ButtonForClear) begin
                    state_next = `STATE_ARG1;
                end
                else if(ButtonForEquals) begin
                    state_next = `STATE_ARG3;
                end
                else begin
                    state_next = `STATE_ARG2_XOR;
                end
            end

            `STATE_OUTPUT: begin
                if(ButtonForClear) begin
                    state_next = `STATE_ARG1;
                end
                else begin
                    state_next = `STATE_ARG3;
                end
            end
        endcase
    end

    //procedural logic with rising edge clk
    always @(posedge CLK) begin

        state <= state_next;

        shift_reg_arg1 <= shift_reg_arg1_next;
        shift_reg_arg2 <= shift_reg_arg2_next; 
    end
    
endmodule