module alu (
    input  [15:0] A,B,
    input  [4:0] F,
    input  cin ,
    output reg  [15:0] Result,
    output reg [5:0] status  //{C, Z, N, V, P, A}
 );
 reg cf, zf, nf, vf, pf, af;
 reg flag_enable;
 reg [4:0] aux_check;
    always @(*) begin
        Result = 16'b0;
        
        aux_check = 5'b0;//internal reg to check for aux flag

        cf = 1'b0;
        zf = 1'b0;
        nf = 1'b0; 
        vf = 1'b0; 
        pf = 1'b0; 
        af = 1'b0;
        flag_enable=1'b1;
     case (F)
            //ARITHMETIC
            5'b00000: begin //   N/A
            Result=16'b0;
            flag_enable=1'b0;
            end

            5'b00001: begin // INC
                {cf,Result} = A + 1'b1 ;
                vf=(A[15]==1'b0 && Result[15]==1'b1);//over flow 
                af=(A[3:0]==4'b1111);//this will work with inc only(adding 1)
            end

            5'b00010: begin//   N/A
            Result=16'b0;
            flag_enable=1'b0;
            end

            5'b00011: begin//   DEC
                {cf,Result} = A - 1'b1 ;
                vf=(A[15]==1'b1 && Result[15]==1'b0);//over flow
                af=(A[3:0]==4'b0000);//as in inc this will only work in case of subt.1
            end

            5'b00100: begin //ADD
                {cf, Result} = A + B ;   
                vf=(A[15]==B[15] && A[15]!=Result[15]);//over flow ADD
                aux_check=A[3:0]+B[3:0];
                af=aux_check[4];// a more general approach (can be used in the first 2 cases )
            end

            5'b00101: begin//ADD_CARRY
                {cf, Result} = A + B + cin ;
                vf=(A[15]==B[15] && A[15]!=Result[15]);//over flow ADD
                aux_check=A[3:0]+B[3:0]+cin;
                af=aux_check[4];
            end

            5'b00110: begin//SUB
                {cf, Result} = A - B;
                vf=(A[15]!=B[15] && A[15]!=Result[15]);//over flow sub
                af=(A[3:0]<B[3:0]);//easier in sub
            end

            5'b00111: begin//SUB_BORROW
                {cf, Result} = A - B - cin;// If (A - B - cin) is negative, the MSB (cf) naturally becomes 1 then no need the complement it
                                            // this is also valid on any sub operation 
                vf=(A[15]!=B[15] && A[15]!=Result[15]);//over flow sub  
                af=({1'b0,A[3:0]}<({1'b0,B[3:0]}+cin));//easier in sub                         
            end
            //logic block
            5'b01000: begin//AND
                Result = A & B ;
            end

            5'b01001: begin// OR
                Result = A | B ;
            end


            5'b01010: begin// XOR
                Result = A ^ B ;
            end
    

            5'b01011: begin//NOT
                Result = ~A ;
            end
       
            //shift block
            5'b10000: begin//SHIFT LEFT
                cf=A[15];
                Result=A<<1;
                
            end


            5'b10001: begin//SHIFT RIGHT
                cf=A[0];
                Result=A>>1;

            end

         
            5'b10010: begin//SAL
                cf=A[15];
                Result= A<<1;
            end


            5'b10011: begin//SAR
                cf=A[0];
                Result=$signed(A)>>>1;
            end


            5'b10100: begin//ROL
                cf=A[15];
                Result={A[14:0],A[15]};
                
            end


            5'b10101: begin//ROR
                cf=A[0];
                Result={A[0],A[15:1]};
            end

//cin here is the carry from the prev operation (assumed it is connected to some top module like a controller or an MPU)
            5'b10110: begin//RCL
                
                Result={A[14:0],cin};
                cf=A[15];//this must be in this order 
                
            end


            5'b10111: begin//RCR
                
                Result={cin,A[15:1]};
                cf=A[0];//this must be in this order 
            end
        
            default: begin
                Result = 16'b0;
                
                flag_enable=1'b0;
            end

        endcase

        
        //we can calculate zf,pf,nf here (always will be the same way to calculate for every operation)
        if(flag_enable) 
        begin
        zf=~|Result;//ZERO FLAG
        pf=~^Result;//PARITY FLAG (even parity)
        nf=Result[15];//negative flag
        end
        // no need for else her because of the initialization at the top


        status = {cf, zf, nf, vf, pf, af};//mapping

    end
endmodule