module M54HC194_SHIFTREG (
    
    input wire CLEAR; //active low

    input wire SR;  //shift right
    input wire [3:0] D;
    input wire SL;  //shift left
    input wire [1:0] S;

    input wire CLOCK;

    output wire [3:0] Q;
);

reg [3:0] Q_reg;
wire [3:0] Q_next_rising_edge;
wire [3:0] Q_next_falling_edge;

assign Q_next_falling_edge = Q;

always @(*) begin

    if(1'b0 == CLEAR) begin
        Q = 4'b0;
    end
    else begin
        Q = Q_reg;
    end
end

always @(*) begin

    case(S)

        2'b11: Q_next_rising_edge = D;
        2'b01: Q_next_rising_edge = {SR, Q[3:1]};
        2'b10: Q_next_rising_edge = {Q[2:0], SL};
        2'b00: Q_next_rising_edge = Q;
    endcase
end

always @(posedge CLOCK) begin

    Q_reg <= Q_next_rising_edge;
end

always @(negedge CLOCK) begin

    Q_reg <= Q_next_falling_edge;
end
    
endmodule