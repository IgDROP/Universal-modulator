module QAM256modem #(
    parameter IWIDTH = 8
    parameter OWIDTH = 32
) (
    input [IWIDTH-1:0]      dIn,
    input                   valIn,
    output                  rdyIn,

    output reg [OWIDTH-1:0] dOut,
    output reg              valOut

);
    
always @(posedge clk ) begin
    if (reset) begin
        
    end else begin
        
    end
end

endmodule