`timescale 1ns/1ns

//32-bit ALU that was discussed in 341.
//Can perform 5 operations (AND, OR, ADD, SUB, SLT).
//It'll take in two values to perform the operation on (A, B).
//It'll take the 2-bit OPCODE.
//It'll take the SUB bit in (used for the full adder).
//It'll output the output into out and the cout into count (if nec.)
module alu(input [31:0] A, input [31:0] B, input [1:0] op, input sub, output reg [31:0] out, output reg cout);
   always @(op, A, B, sub) begin
      case(op)
	2'b00: out <= A & B;
	2'b01: out <= A | B;
	2'b10: begin
	   if(sub == 0) out <= A + B;
	   else out <= A - B;
	end
	//SLT operation
	2'b11: begin
	   //We've subtracted A - B with the adder. Let's take that result, check if it's less than 0. If it is, we'll set out to a 1, else a 0.
	   if(A < B) out <= 32'b1;
	   else out <= 32'b0;
	end
      endcase // case (op)
   end
endmodule // alu

module main();
   reg [31:0] a,b;
   wire [31:0] out;
   reg 	       sub;
   reg [1:0]   op;
   
   alu my_alu(a, b, op, sub, out, cout);

   initial begin
      $monitor($time,, "A = 0x%h, B = 0x%h, OP = %b, SUB = %b, OUT = 0x%h", a, b, op, sub, out);
      //OR Operation: Or(0x0, 0x1)
      $display("\t\t0x00000000 | 0x00000001");
      a = 32'h00000000;
      b = 32'h00000001;
      op = 2'b01;
      
      //Add operation: Add(0x0, 0x1)
      #10;
      $display("\t\t0x00000000 + 0x00000001");
      a = 32'h00000000;
      b = 32'h00000001;
      sub = 0;
      op = 2'b10;
      
      //SLT operation: SLT(0x1, 0x3)
      #10;
      $display("\t\tSLT 0x00000001, 0x00000003");
      a = 32'h00000001;
      b = 32'h00000011;
      sub = 1;
      op = 2'b11;

      //AND operation: And(0x928C, 0x0149)
      #10;
      $display("\t\t0x341B928C & 0x12340149");
      a = 32'h341B928C;
      b = 32'h12340149;
      op = 2'b00;

      #10;
      $display("\t\t0x80000000 + 0x80000000");
      a = 32'h80000000;
      b = 32'h80000000;
      op = 2'b10;
      sub = 0;
      
   end
endmodule // main
