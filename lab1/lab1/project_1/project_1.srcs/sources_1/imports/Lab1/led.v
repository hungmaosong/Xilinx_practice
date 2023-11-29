`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/01/31 14:45:04
// Design Name: 
// Module Name: led
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module led(
    input clk,
    input reset,
    input [7:0] switch,
    output reg [7:0] led
    );

     always@(posedge clk or posedge reset)begin
           if(reset)begin
               led <= 0;
           end
           else begin
               led <= switch;
           end
      end
      
    
endmodule
