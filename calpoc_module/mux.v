module 74157 (

    input [3:0] A;
    input [3:0] B;

    input G;

    input S;    //select

    output [3:0] Y;
);

always @(*) begin

    if(1'b0 == G) begin
        case(S) 

            1'b0: Y = A;
            1'b1: Y = B;

        endcase
    end
    
end
    
endmodule