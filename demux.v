module 74HC4053_DEMUX (
    
    input E;    //active low

    input wire [2:0] S;

    input wire [2:0] Y0;
    input wire [2:0] Y1;

    output wire [2:0] Z;
);

integer i;

always @(*) begin

    if(1'b0 == E) begin

        for (i =0; i<3; i++) begin

            if(1'b0 == S[i]) begin

                Z[i] = Y0[i] 
            end
            else if(1'b1 == S[i]) begin

                Z[i] = Y1[i] 
            end
        end
    end
end

endmodule