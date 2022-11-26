/* verilator lint_off WIDTH */
/* verilator lint_off COMBDLY */
/* verilator lint_off UNUSED */
/* verilator lint_off UNDRIVEN */

module Mod#(
    parameter IWIDTH = 1,
    parameter MODTYPE = "BPSK",
    parameter D    = 20,
    parameter IQWIDTH = 16,
    parameter OWIDTH = 32
) (
    input clk,
    input rst,

    input [IWIDTH-1:0]      dIn,
    input                   valIn,
    output logic            rdyIn,

    output logic [OWIDTH-1:0] dOut,
    output logic              valOut

);

// ================ Local parameters ==================== //
localparam PHINCWIDTH = 16;
localparam DDSOWIDTH  = 32;
// ==================== Signals ========================= //
logic [IWIDTH-1:0] dInInt;
logic              valInInt;
logic              rdyInInt;

logic [IWIDTH-1:0] bits;

logic [OWIDTH/2-1:0]        I, Q;
logic [OWIDTH/2-1:0]        IOut, QOut;

logic [PHINCWIDTH-1:0] phInc;
logic  valPhInc = 1;

logic [DDSOWIDTH-1:0] dOutDDS;  
logic valOutDDS;


// ==================== MAIN ============================ //

always_ff @( posedge clk ) begin : Input_trigger
    dInInt <= dIn;
    valInInt <= valIn;
end

generate
    case (MODTYPE)
        "BPSK": begin
            always_ff @( clk ) begin
                if (valInInt) begin
                    bits <= dInInt;
                end
                
                case (bits)
                    1'b0: begin 
                        I <= -D; 
                        Q <= 0; 
                    end
                    1'b1: begin 
                        I <=  D; 
                        Q <= 0; 
                    end
                    default: begin

                    end
                endcase
            end
        end
        "QPSK": begin
            always_ff @( clk ) begin
                if (valInInt) begin
                    bits <= dInInt;
                end
            end
            always_ff @( clk ) begin
                case (bits)
                    2'b00: begin 
                        I <= -D; 
                        Q <= -D; 
                    end
                    2'b01: begin 
                        I <= -D; 
                        Q <=  D; 
                    end
                    2'b10: begin 
                        I <=  D; 
                        Q <= -D; 
                    end
                    2'b11: begin 
                        I <=  D; 
                        Q <=  D; 
                    end
                    default: begin

                    end
                endcase
            end
        end
        "8PSK": begin
            always_ff @( clk ) begin
                if (valInInt) begin
                    bits <= dInInt;
                end
            end
            always_ff @( clk ) begin
                case (bits)
                    // 3'b000: begin 
                    //     I <= D; 
                    //     Q <= 0; 
                    // end
                    // 3'b001: begin 
                    //     I <=  D/2; 
                    //     Q <=  D; 
                    // end
                    // 3'b010: begin 
                    //     I <= -0,707*D; 
                    //     Q <=  0,707*D; 
                    // end
                    // 3'b011: begin 
                    //     I <= 0; 
                    //     Q <= D; 
                    // end
                    // 3'b100: begin 
                    //     I <=  0,707*D; 
                    //     Q <= -0,707*D; 
                    // end
                    // 3'b101: begin 
                    //     I <= 0; 
                    //     Q <= -D;       
                    // end
                    // 3'b110: begin 
                    //     I <= -D; 
                    //     Q <= 0;        
                    // end
                    // 3'b111: begin 
                    //     I <= -0,707*D; 
                    //     Q <= -0,707*D; 
                    // end
                    // default: 
                endcase
            end
        end
        "QAM16": begin
            always_ff @( clk ) begin
                if (valInInt) begin
                    bits <= dInInt;
                end
            end
            always_ff @( clk ) begin
                case (bits)
                    4'b0000: begin 
                        I <= D;    
                        Q <=   D; 
                    end
                    4'b0001: begin 
                        I <= 3*D;  
                        Q <=   D; 
                    end
                    4'b0010: begin
                        I <= D;   
                        Q <= 3*D; 
                    end
                    4'b0011: begin
                        I <= 3*D; 
                        Q <= 3*D; 
                    end
                    4'b0100: begin
                        I <= D;   
                        Q <=  -D; 
                    end
                    4'b0101: begin
                        I <= D;   
                        Q <=-3*D; 
                    end
                    4'b0110: begin
                        I <= 3*D; 
                        Q <=  -D; 
                    end
                    4'b0111: begin
                        I <= 3*D; 
                        Q <=-3*D; 
                    end
                    4'b1000: begin
                        I <= -D;  
                        Q <=   D; 
                    end
                    4'b1001: begin
                        I <= -D;  
                        Q <= 3*D; 
                    end
                    4'b1010: begin
                        I <= -3*D;
                        Q <=   D; 
                    end
                    4'b1011: begin
                        I <= -3*D;
                        Q <= 3*D; 
                    end
                    4'b1100: begin
                        I <= -D;  
                        Q <=   D; 
                    end
                    4'b1101: begin
                        I <= -3*D;
                        Q <=  -D; 
                    end
                    4'b1110: begin
                        I <= -D;  
                        Q <=-3*D; 
                    end
                    4'b1111: begin
                        I <= -3*D;
                        Q <=-3*D; 
                    end
                    default: begin

                    end
                endcase
            end
        end
        "QAM64": begin

        end 
        default: begin

        end
    endcase
endgenerate

DDS #(
    .PHINCWIDTH (PHINCWIDTH),
    .OWIDTH     (DDSOWIDTH)

) inst_dds(
    .clk      (clk),
    .reset    (rst),

    .phInc    (phInc),
    .valPhInc (valPhInc),

    .dOut     (dOutDDS),
    .valOut   (valOutDDS)
);



always_ff @( clk ) begin : Output
    IOut <= dOutDDS[DDSOWIDTH/2-1:0] * I;
    QOut <= dOutDDS[DDSOWIDTH-1:DDSOWIDTH/2] * Q;
    dOut <= {QOut, IOut};
    valOut <= valOutDDS;
end
endmodule
