module alu (
    input  [15:0] op1,op2,
    input  [3:0] opcode,
    output reg [15:0] out,
    output reg logic_flag,cmp_flag,arith_flag,shift_flag
);
    always @(*) begin
        out         = 16'b0;
        logic_flag  = 1'b0;
        cmp_flag    = 1'b0;
        arith_flag  = 1'b0;
        shift_flag  = 1'b0;

        case(opcode)
        4'b0000:begin
            out=op1+op2;
            arith_flag=1'b1;
        end
        4'b0001:begin
            out=op1-op2;
            arith_flag=1'b1;
        end
        4'b0010:begin
            out=op1*op2;
            arith_flag=1'b1;
        end
        4'b0011:begin
            out=op1/op2;
            arith_flag=1'b1;
        end
        4'b0100:begin
            out=op1&op2;
            logic_flag=1'b1;
        end
        4'b0101:begin
            out=op1|op2;
            logic_flag=1'b1;
        end
        4'b0110:begin
            out=~(op1&op2);
            logic_flag=1'b1;
        end
        4'b0111:begin
            out=~(op1|op2);
            logic_flag=1'b1;
        end
        4'b1000:begin
            out=op1^op2;
            logic_flag=1'b1;
        end
        4'b1001:begin
            out=~(op1^op2);
            logic_flag=1'b1;
        end
        4'b1010:begin//(comparison) will ask about complexity.better with cond. op.  ???
            if (op1==op2) begin
                out=16'b1;
            end
            else begin
                out=16'b0;
            end
            cmp_flag=1'b1;

        end
        4'b1011:begin
            if (op1>op2) begin
                out=16'b10;
            end
            else begin
                out=16'b0;
            end
            cmp_flag=1'b1;
            
        end
        4'b1100:begin
            if (op1<op2) begin
                out=16'b11;
            end
            else begin
                out=16'b0;
            end
            cmp_flag=1'b1;
            
        end
        4'b1101:begin//shifting
            out=op1>>1;
            shift_flag=1'b1;
        end
        4'b1110:begin
            out=op1<<1;
            shift_flag=1'b1;
        end
        default:begin
            out=16'b0;
        end

    endcase
    end
endmodule