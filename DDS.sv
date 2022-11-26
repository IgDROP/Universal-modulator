/* verilator lint_off WIDTH */
/* verilator lint_off UNUSED */
module DDS #(
    parameter PHINCWIDTH = 16,
    parameter OWIDTH     = 32

) (
    input                   clk,
    input                   reset,

    input [PHINCWIDTH-1:0]  phInc,
    input                   valPhInc,


    output reg [OWIDTH-1:0] dOut,
    output reg              valOut
);

enum {idle, firstq, secondq, thirdq, fourthq} state;

logic [PHINCWIDTH-1:0] phAcc;
logic [OWIDTH/2-1:0] sin;
logic [OWIDTH/2-1:0] cos;

localparam LUTSIZE = 64;
logic [15:0] sin_lut [0:LUTSIZE-1];
logic [15:0] cos_lut [0:LUTSIZE-1];
initial begin
    $readmemh("sine_lut.txt", sin_lut, 0, LUTSIZE-1);
    $readmemh("cosine_lut.txt", cos_lut, 0, LUTSIZE-1);
end

always @(posedge clk) begin
    if (reset) begin
        state <= idle;
        phAcc <= 0;
    end else begin
        case (state)
            idle: begin
                state <= firstq;
            end 
            firstq: begin
                sin <= sin_lut[]
            end
            secondq: begin

            end
            thirdq: begin
                
            end
            fourthq: begin

            end
            default: 
        endcase
    end
end
endmodule
