module VGA_CTRL(
	input clk, 
	input rst, 
	output reg hsync, 
	output reg vsync, 
	output [3:0] vga_r, 
	output [3:0] vga_g, 
	output [3:0] vga_b
	);

	reg hs_data_en, vs_data_en;
	reg [11:0] data_in;
	reg [9:0] hcount; //0-799
	reg [9:0] vcount; //0-524

	parameter H_Total = 800 - 1;
	parameter H_Sync = 96 - 1;
	parameter H_Back = 48 - 1;
	parameter H_Active = 640 - 1;
	parameter H_Front = 16 - 1;
	parameter H_Start = 144 - 1;
	parameter H_End = 784 - 1;

	parameter V_Total = 525 - 1;
	parameter V_Sync = 2 - 1;
	parameter V_Back = 33 - 1;
	parameter V_Active = 480 - 1;
	parameter V_Front = 10 - 1;
	parameter V_Start = 35 - 1;
	parameter V_End = 515 - 1;
	//不管水平or垂直，依序都是sync => back porch => active => front porch 

	//hcount
	always @(posedge clk or posedge rst) begin
		if (rst) begin
			hcount <= 0;
		end
		else if (hcount == H_Total) begin //換行
			hcount <= 0;
		end
		else begin
			hcount <= hcount + 1;
		end
	end

	//vcount
	always @(posedge clk or posedge rst) begin
		if (rst) begin
			vcount <= 0;
		end
		else if (vcount == V_Total) begin
			vcount <= 0;
		end
		else if (hcount == H_Total) begin //換行
			vcount <= vcount + 1;
		end
	end

	//hsync
	always @(*) begin //Sync pulse
		if (hcount >= 0 && hcount <= H_Sync) begin
			hsync = 0;
		end
		else begin
			hsync = 1;
		end
	end

	always @(*) begin //Sync pulse
		if (vcount >= 0 && vcount <= V_Sync) begin
			vsync = 0;
		end
		else begin
			vsync = 1;
		end
	end

	//輸出enable訊號 (Active video區)
	always @(*) begin //Active video
	    if(hcount > H_Start && hcount <= H_End)
	        hs_data_en = 1'b1;
	    else
	        hs_data_en = 1'b0;
	end

	always @(*) begin //Active video
		if(vcount > V_Start && vcount <= V_End)
	        vs_data_en = 1'b1;
	    else
	        vs_data_en = 1'b0;
	end

	
	always @(*) begin //設定顏色
          if(hcount > H_Start && hcount <= H_Start + 80)
              data_in = 12'hf00;
          else if(hcount > H_Start + 80 && hcount <= H_Start + 160)
              data_in = 12'h0f0;
          else if(hcount > H_Start + 160 && hcount <= H_Start + 240)
              data_in = 12'h00f;
          else if(hcount > H_Start + 240 && hcount <= H_Start + 320)
              data_in = 12'hf0f;
          else if(hcount > H_Start + 320 && hcount <= H_Start + 400)
              data_in = 12'hff0;
          else if(hcount > H_Start + 400 && hcount <= H_Start + 480)
              data_in = 12'h0ff;
          else if(hcount > H_Start + 480 && hcount <= H_Start + 560)
              data_in = 12'hfff;
          else if(hcount > H_Start + 560 && hcount <= H_Start + 640)
              data_in = 12'h000;
          else
              data_in = 12'hfff ;
        end
	

	assign vga_r = (hs_data_en && vs_data_en) ?  data_in[11:8] : 0;
	assign vga_g = (hs_data_en && vs_data_en) ?  data_in[7:4]  : 0;
	assign vga_b = (hs_data_en && vs_data_en) ?  data_in[3:0]  : 0;
endmodule