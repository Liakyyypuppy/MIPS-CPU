module _2050_ALU #(parameter W=4)
(input [W-1:0] A, input [W-1:0] B,//两个数据输入
 input [2:0] F,//功能码
 output reg [W-1:0] Y,//运算结果输出
 output reg Overflow,//溢出判断
output reg Zero);//0输出

always @(*)
begin
    case(F)
        3'b000: Y = A & B; //与运算A AND B 
        3'b001: Y = A | B; //或运算A OR B
        3'b010: begin		//加法运算
						Y= A + B;
						//如果两个加数的符号位相同，和的符号位之相反，则溢出
						//Overflow = (A[W-1] == B[W-1] && Y[W-1] != A[W-1])? 1: 0; 
					 end
        3'b011: Y = 0; //无用功能not used
        3'b100: Y = A & ~B; //A AND ~B
        3'b101: Y = A | ~B; //A OR ~B
        3'b110: begin
						Y= A - B;
						//溢出情况一：被减数为正数，减数为负数，得到的差为负数，则溢出
						//溢出情况二：被减数为负数，减数为正数，得到的差为正数，则溢出
						//Overflow = ( (A[W-1] == 0 && B[W-1] == 1 && Y[W-1] ==1) || (A[W-1] == 1 && B[W-1] == 0 && Y[W-1] ==0) )? 1: 0; 
					 end
        3'b111: begin 			// SLT运算（Set on Less Than）
							if (A < B) 
             		   Y = 1;
           		      else 
            		   Y = 0;
      	       end
		  default: Y = 0;
    endcase
end

always @(*)
begin
Zero = (Y == 0)? 1 : 0 ;//当 Y==0 时，输出 Zero 是 1 ，否则为 0；
if(F==3'b010)
Overflow = (A[W-1] == B[W-1] && Y[W-1] != A[W-1])? 1: 0; 
else if(F==3'b110)
Overflow = ( (A[W-1] == 0 && B[W-1] == 1 && Y[W-1] ==1) || (A[W-1] == 1 && B[W-1] == 0 && Y[W-1] ==0) )? 1: 0; 
else Overflow=0;
end
endmodule 