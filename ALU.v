module alu (
    input  [15:0] op1,op2,
    input  [4:0] opcode,
    input  cin ;
    output reg [15:0] out,
    output reg cf,nf,af,of,pf,zf
 );
    always @(*) begin
        out = 16'b0;
        cf  = 1'b0;
        zf  = 1'b0;
        af  = 1'b0;
        of  = 1'b0;
        pf  = 1'b0;
        nf  = 1'b0;
     case (opcode)
            
            5'b00000: begin
            end
            5'b00001: begin
                out = op1 + 1'b1 ;
            end
            5'b00010: begin
            end
            5'b00011: begin
                out = op1 - 1'b1 ;
            end
            5'b00100: begin
                {cf, out} = op1 + op2 ;   
            end
            5'b00101: begin
                {cf, out} = op1 + op2 + cin ;
            end
            5'b00110: begin
                {cf, out} = op1 - op2;
            end
            5'b00111: begin
                {cf, out} = op1 - op2 - cin;
            end

            5'b01000: begin
                out = op1 & op2 ;
            end
            5'b01001: begin
                out = op1 | op2 ;
            end
            5'b01010: begin
                out = op1 ^ op2 ;
            end
            5'b01011: begin
                out = ~op1 ;
            end
            5'b01100: begin
            end
            5'b01101: begin
            end
            5'b01110: begin
            end
            5'b01111: begin
            end

            5'b10000: begin
            end
            5'b10001: begin
            end
            5'b10010: begin
            end
            5'b10011: begin
            end
            5'b10100: begin
            end
            5'b10101: begin
            end
            5'b10110: begin
            end
            5'b10111: begin
            end

            5'b11000: begin
            end
            5'b11001: begin
            end
            5'b11010: begin
            end
            5'b11011: begin
            end
            5'b11100: begin
            end
            5'b11101: begin
            end
            5'b11110: begin
            end
            5'b11111: begin
            end
            default: begin
                out = 16'b0;
                cf  = 1'b0;
                zf  = 1'b0;
                af  = 1'b0;
                of  = 1'b0;
                pf  = 1'b0;
                nf  = 1'b0;
            end

        endcase
    end
endmodule