module traffic_light(
    input clk,
    input rst,
    output reg [2:0] light,
    output reg [4:0] down_cnt,
    input sw
    );
    
    reg [2:0] state;
    reg [2:0] next_state;
    reg [25:0] counter;
    reg div_clk;

    parameter GREEN = 3'd0, YELLOW = 3'd1, RED = 3'd2;

    always @(posedge clk or posedge rst) begin //frequency divider
        if(rst)begin
            counter <= 26'd0;
            div_clk <= 1;
        end else begin
            if(counter == 26'd50000000)begin
                counter <= 26'd0;
                div_clk <= ~div_clk;
            end else begin
                counter <= counter + 1;
            end
        end
    end

    always @(posedge div_clk or posedge rst)begin //state register
        if(rst)begin
            state <= GREEN;            
        end else begin
            state <= next_state;
        end
    end

    always @(*)begin //next_state logic
        case(state)
            GREEN:begin
                if(down_cnt == 1)begin
                    next_state <= YELLOW;
                end else begin
                    next_state <= GREEN;
                end
            end
            YELLOW:begin
                if(down_cnt == 1)begin
                    next_state <= RED;
                end else begin
                    next_state <= YELLOW;
                end
            end
            RED:begin
                if(down_cnt == 1)begin
                    next_state <= GREEN;
                end else begin
                    next_state <= RED;
                end
            end
            default:begin
                next_state <= GREEN;
            end
        endcase
    end

    always @(posedge div_clk or posedge rst) begin //down_counter
        if(rst)begin
            if(sw)begin
                down_cnt <= 5'd7;
            end else begin
                down_cnt <= 5'd15;
            end
        end else begin
            case(state)
                GREEN:
                    if(down_cnt == 1)begin
                        down_cnt <= 1;
                    end else begin
                        down_cnt <= down_cnt - 1;
                    end
                YELLOW:
                    if(down_cnt == 1)begin
                        if(sw)begin
                            down_cnt <= 5'd8;
                        end else begin
                            down_cnt <= 5'd16;
                        end
                    end else begin
                        down_cnt <= down_cnt - 1;
                    end
                RED:
                    if(down_cnt == 1)begin
                        if(sw)begin
                            down_cnt <= 5'd7;
                        end else begin
                            down_cnt <= 5'd15;
                        end
                    end else begin
                        down_cnt <= down_cnt - 1;
                    end
            endcase
        end
    end
    
    always @(*) begin //light
        case (state)
            GREEN: light = 3'b001;
            YELLOW: light = 3'b010;
            RED: light = 3'b100;
            default: light = 3'b001;
        endcase
    end

endmodule
