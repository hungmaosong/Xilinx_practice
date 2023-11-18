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

    /*狀態*/
    parameter Green = 2'd0, Yellow = 2'd1, Red = 2'd2;
    reg [1:0] current_state, next_state;
    /*狀態*/
    /*自訂變數*/
    reg [4:0] timer;
    reg [26:0] counter; //除頻用(數到100000000)
    /*自訂變數*/
    
    //nextstate logic
    always @(*) begin
        case (current_state)
            Green:
            begin
                if(timer == 0)
                begin
                    next_state = Yellow;
                end
                else
                begin
                    next_state = Green;
                end
            end 
            Yellow:
            begin
                if(timer == 0)
                begin
                    next_state = Red;
                end
                else
                begin
                    next_state = Yellow;
                end
            end 
            Red:
            begin
                if(timer == 0)
                begin
                    next_state = Green;
                end
                else
                begin
                    next_state = Red;
                end
            end 
            default: next_state = Green;
        endcase
    end

    //state register
    always @(posedge clk or posedge reset) begin
        if(reset)
        begin
            current_state <= Green;
        end
        else
        begin
            current_state <= next_state;
        end
    end

    //LED
     always@(posedge clk or posedge reset)begin
           if(reset)begin
               led <= 0;
           end
           else begin
               led <= switch;
           end
      end

    //timer
    always @(posedge clk or posedge reset) begin
       if(reset)
       begin
            if(switch[0]) timer <= 7;
            else timer <= 15;
       end
       else
       begin
            if(switch[0])
            begin
                case (current_state)
                    Green: 
                    begin
                        if(counter == 100000000)
                        begin
                            if(timer == 0)
                            begin
                                timer <= 1;
                            end
                            else
                            begin
                                timer <= timer - 1;
                            end
                        end
                    end
                    Yellow:
                    begin
                        if(counter == 100000000)
                        begin
                            if(timer == 0)
                            begin
                                timer <= 8;
                            end
                            else
                            begin
                                timer <= timer - 1;
                            end
                        end
                    end
                    Red: 
                    begin
                        if(counter == 100000000)
                        begin
                            if(timer == 0)
                            begin
                                timer <= 7;
                            end
                            else
                            begin
                                timer <= timer - 1;
                            end
                        end
                    end
                endcase
            end
            else
            begin
                case (current_state)
                    Green: 
                    begin
                        if(counter == 100000000)
                        begin
                            if(timer == 0)
                            begin
                                timer <= 1;
                            end
                            else
                            begin
                                timer <= timer - 1;
                            end
                        end
                    end
                    Yellow:
                    begin
                        if(counter == 100000000)
                        begin
                            if(timer == 0)
                            begin
                                timer <= 16;
                            end
                            else
                            begin
                                timer <= timer - 1;
                            end
                        end
                    end
                    Red: 
                    begin
                        if(counter == 100000000)
                        begin
                            if(timer == 0)
                            begin
                                timer <= 15;
                            end
                            else
                            begin
                                timer <= timer - 1;
                            end
                        end
                    end
                endcase
            end
       end
    end
    
    //counter
    always @(posedge clk or posedge reset) begin
        if(reset)
        begin
            counter <= 0;
        end
        else
        begin
            if(counter == 100000000)
            begin
                counter <= 0;
            end
            else
            begin
                counter <= counter + 1;
            end
        end
    end
    
endmodule
