module 74HCT173_DFF (

    input [1:0] OE; //active low
    input CP;   //clock
    input [1:0] E;  //active low
    input [3:0] D; 
    input MR;   //asynchronous master reset

    output wire [3:0] Q;
);

//only register operating modes are implemented

reg [3:0] Q_reg;
wire [3:0] Q_next;

always @(*) begin

    if(1'b1 == MR) begin
        Q = 4'b0;
    end
    else begin
        Q = Q_reg;
    end
end

always @(*) begin

    if(~(|E)) begin
        Q_next = D;
    end
    else begin
        Q_next = Q;
    end
end

always @(posedge CP) begin

    Q_reg <= Q_next;
end
    
endmodule