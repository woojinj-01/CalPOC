module DM74LS181_ALU (
    input wire [3:0] A; //active low
    input wire [3:0] B; //active low

    input wire [3:0] S;

    input wire M;   //mode control

    input wire C_in; //carry input

    output wire [3:0] F; //active low

    output wire AEqualsB;

    output wire G; //active low

    output wire P; //active low

    output wire C_out; //carry output

);

always @(*) begin

    if(2'b1 == M) begin
        case(S)

            2'b1001: F = A^B;
            2'b1011: F = A|B;
        endcase
    end
    
end
    
endmodule