`include "alu.v"
`include "mux.v"
`include "demux.v"
`include "dff.v"
`include "shiftreg.v"

module CalPOC (
    
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
    
endmodule