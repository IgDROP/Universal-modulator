module DDS #(
    parameter MODE = "PHASE_INC", //"PHASE" OR "PHASE_INC"
    parameter PHACCWIDTH = 16,
    parameter PHINCWIDTH = 16

) (
    input [PHINCWIDTH-1:0]  phInc,
    input                   valPhInc,

    input [PHACCWIDTH-1:0]  phIn,
    input                   valPh,

    output reg [OWIDTH-1:0] dOut,
    output reg              valOut
);


    
endmodule