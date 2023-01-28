`define TimeExpire1 32'd25000000
`define GameDuration 5'd31;
module clk1Hz(clk,rst,div_clk);
input clk,rst;
output div_clk;

reg div_clk;
reg[31:0]count;

always@(posedge clk)
begin 
    if(!rst)
    begin
        count<=32'd0;
        div_clk<=1'b0;
    end
    else 
    begin 
        if(count==`TimeExpire1)
        begin
            count<=32'd0;
            div_clk<=~div_clk;
        end
        else
        begin
            count<=count+32'd1;
        end
    end
end
endmodule

module level(state1,state2,state3,pointOut);
input state1,state2,state3;
output reg [4:0]pointOut;

always@(state1 or state2 or state3)
begin
    if(state1 && state2 && state3)
    begin
        pointOut <= 5'd20;
    end
    else if(!state1 && state2 && state3)
    begin
        pointOut <= 5'd15;
    end
    else
    begin
        pointOut <= 5'd10;
    end
end
endmodule

module countDown(divClk,rst,timeNow,overFlow,led0, led1, led2, led3, led4, led5, led6, led7, led8, led9, rand);
input divClk,rst;
output reg [4:0]timeNow;
output reg overFlow,led0, led1, led2, led3, led4, led5, led6, led7, led8, led9;

output reg [3:0] rand;
reg [3:0] next_data;

always @*
begin
   next_data[3] = rand[3]^timeNow[1];
	next_data[2] = rand[2]^timeNow[0];
	next_data[1] = rand[1]^next_data[3];
	next_data[0] = rand[0]^next_data[2];
	
end


reg flag;
always@(posedge divClk or negedge rst)
begin
	 
    if(!rst)
    begin  
			flag <= 0;
			timeNow <= `GameDuration;
			overFlow <= 0;
			led0 <= 0;
			led1 <= 0;
			led2 <= 0;
			led3 <= 0;
			led4 <= 0;
			led5 <= 0;
			led6 <= 0;
			led7 <= 0;
			led8 <= 0;
			led9 <= 0;
	 end
    else
    begin
		 if(!overFlow)
		 begin
			if(timeNow == 1)
			begin
            overFlow <= 1;
				timeNow <= timeNow - 1;
				rand <= 4'hf;
			end
			else
            timeNow <= timeNow - 1;
				rand <= next_data;
		end
		else
		begin
			if(flag == 0) begin
				flag <= 1;
				led0 <= 1;
				led1 <= 1;
				led2 <= 1;
				led3 <= 1;
				led4 <= 1;
				led5 <= 1;
				led6 <= 1;
				led7 <= 1;	
				led8 <= 1;
				led9 <= 1;
			end else begin
				flag <= 0;
				led0 <= 0;
				led1 <= 0;
				led2 <= 0;
				led3 <= 0;
				led4 <= 0;
				led5 <= 0;
				led6 <= 0;
				led7 <= 0;
				led8 <= 0;
				led9 <= 0;
			end
		 end
    end
end
endmodule

module display(count,out1,out2);
input [4:0]count;
output reg [6:0]out1;
output reg [6:0]out2;

wire [4:0]first;
wire [4:0]second;

assign first = count % 10 ;
assign second = count / 10;

always@(count)
begin
    case(first)
        4'b0000:out1=7'b1000000;//0
        4'b0001:out1=7'b1111001;//1
        4'b0010:out1=7'b0100100;//2
        4'b0011:out1=7'b0110000;//3
        4'b0100:out1=7'b0011001;//4
        4'b0101:out1=7'b0010010;//5
        4'b0110:out1=7'b0000010;//6
        4'b0111:out1=7'b1111000;//7
        4'b1000:out1=7'b0000000;//8
        4'b1001:out1=7'b0010000;//9
    endcase
    case(second)
        4'b0000:out2=7'b1000000;//0
        4'b0001:out2=7'b1111001;//1
        4'b0010:out2=7'b0100100;//2
        4'b0011:out2=7'b0110000;//3
        4'b0100:out2=7'b0011001;//4
        4'b0101:out2=7'b0010010;//5
        4'b0110:out2=7'b0000010;//6
        4'b0111:out2=7'b1111000;//7
        4'b1000:out2=7'b0000000;//8
        4'b1001:out2=7'b0010000;//9
    endcase
end
endmodule

module addScore(clk,rst,hit,score);
input clk,rst,hit;
output reg [4:0]score; 
reg flagNow;
always @(posedge clk or negedge rst)
begin
	if(!rst)
	begin
		score <= 0;
		flagNow <= 0;
	end
	else
	begin
		if(hit != flagNow)
		begin
			score <= score + 1;
			flagNow <= hit;
		end
	end
end
endmodule



//show image
module image(clk, rst, score, goal, timenow, dot_col, row_count);
input clk, rst;
input [4:0] score;
input [4:0] goal;
input [4:0] timenow;
// output reg [7:0] dot_row;
output reg [7:0] dot_col;

input [2:0] row_count;
 
always@(posedge clk or negedge rst)
begin
   if(~rst)
	begin
	    // dot_row <= 8'b0;
		 dot_col <= 8'b0;
		 // row_count <= 0;
	end
	else
	begin
//	    row_count <= row_count + 1;
//		 case(row_count)
//		     3'd0: dot_row <= 8'b01111111; 
//			  3'd1: dot_row <= 8'b10111111; 
//			  3'd2: dot_row <= 8'b11011111; 
//			  3'd3: dot_row <= 8'b11101111; 
//			  3'd4: dot_row <= 8'b11110111; 
//			  3'd5: dot_row <= 8'b11111011; 
//           3'd6: dot_row <= 8'b11111101; 
//           3'd7: dot_row <= 8'b11111110; 
//		 endcase
		 if(score >= goal && timenow == 5'd0)
		 begin
			 case(row_count)
					3'd0:dot_col <= 8'b01000010;
					3'd1:dot_col <= 8'b11100111;
					3'd2:dot_col <= 8'b11100111;
					3'd3:dot_col <= 8'b11111111;
					3'd4:dot_col <= 8'b01111110;
					3'd5:dot_col <= 8'b01111110;
					3'd6:dot_col <= 8'b01111110;
					3'd7:dot_col <= 8'b00111100;
			endcase
		 end
		 else if(score < goal && timenow == 5'd0)
		 begin
			 case(row_count)
					3'd0:dot_col <= 8'b00000000;
					3'd1:dot_col <= 8'b01000000;
					3'd2:dot_col <= 8'b01000000;
					3'd3:dot_col <= 8'b01000000;
					3'd4:dot_col <= 8'b01000000;
					3'd5:dot_col <= 8'b01000000;
					3'd6:dot_col <= 8'b01111100;
					3'd7:dot_col <= 8'b00000000;
			endcase
		 end
		 else
		 begin
			 case(row_count)
						3'd0:dot_col <= 8'b00000000;
						3'd1:dot_col <= 8'b00000000;
						3'd2:dot_col <= 8'b00000000;
						3'd3:dot_col <= 8'b00000000;
						3'd4:dot_col <= 8'b00000000;
						3'd5:dot_col <= 8'b00000000;
						3'd6:dot_col <= 8'b00000000;
						3'd7:dot_col <= 8'b00000000;
				endcase
		 end
	end

end
endmodule 

//show the position of mouse
module matrix(clk, rst, random, dot_row, dot_col, row_count);
input clk, rst;
input [3:0] random;
output reg [7:0] dot_row;
output reg [7:0] dot_col;

output reg [2:0] row_count;

 
always@(posedge clk or negedge rst)
begin
   if(~rst)
	begin
	    dot_row <= 8'b0;
		 dot_col <= 8'b0;
		 row_count <= 0;
	end
	else
	begin
	    row_count <= row_count + 1;
		 case(row_count)
		     3'd0: dot_row <= 8'b01111111; 
			  3'd1: dot_row <= 8'b10111111; 
			  3'd2: dot_row <= 8'b11011111; 
			  3'd3: dot_row <= 8'b11101111; 
			  3'd4: dot_row <= 8'b11110111; 
			  3'd5: dot_row <= 8'b11111011; 
           3'd6: dot_row <= 8'b11111101; 
           3'd7: dot_row <= 8'b11111110; 
		 endcase
		 case(random)
		     4'd1:
				begin
				case(row_count)
					3'd0:dot_col <= 8'b00110000;
					3'd1:dot_col <= 8'b00110000;
					3'd2:dot_col <= 8'd0;
					3'd3:dot_col <= 8'd0;
					3'd4:dot_col <= 8'd0;
					3'd5:dot_col <= 8'd0;
					3'd6:dot_col <= 8'd0;
					3'd7:dot_col <= 8'd0;
				endcase
				end
				4'd2:
				begin
				case(row_count)
					3'd0:dot_col <= 8'b00001100;
					3'd1:dot_col <= 8'b00001100;
					3'd2:dot_col <= 8'd0;
					3'd3:dot_col <= 8'd0;
					3'd4:dot_col <= 8'd0;
					3'd5:dot_col <= 8'd0;
					3'd6:dot_col <= 8'd0;
					3'd7:dot_col <= 8'd0;
				endcase
				end
				4'd3:
				begin
				case(row_count)
					3'd0:dot_col <= 8'b00000011;
					3'd1:dot_col <= 8'b00000011;
					3'd2:dot_col <= 8'd0;
					3'd3:dot_col <= 8'd0;
					3'd4:dot_col <= 8'd0;
					3'd5:dot_col <= 8'd0;
					3'd6:dot_col <= 8'd0;
					3'd7:dot_col <= 8'd0;
				endcase
				end
				4'd0:
				begin
				case(row_count)
					3'd0:dot_col <= 8'b11000000;
					3'd1:dot_col <= 8'b11000000;
					3'd2:dot_col <= 8'd0;
					3'd3:dot_col <= 8'd0;
					3'd4:dot_col <= 8'd0;
					3'd5:dot_col <= 8'd0;
					3'd6:dot_col <= 8'd0;
					3'd7:dot_col <= 8'd0;
				endcase
				end
				4'd4:
				begin
				case(row_count)
					3'd0:dot_col <= 8'd0;
					3'd1:dot_col <= 8'd0;
					3'd2:dot_col <= 8'b11000000;
					3'd3:dot_col <= 8'b11000000;
					3'd4:dot_col <= 8'd0;
					3'd5:dot_col <= 8'd0;
					3'd6:dot_col <= 8'd0;
					3'd7:dot_col <= 8'd0;
				endcase
				end
				4'd5:
				begin
				case(row_count)
					3'd0:dot_col <= 8'd0;
					3'd1:dot_col <= 8'd0;
					3'd2:dot_col <= 8'b00110000;
					3'd3:dot_col <= 8'b00110000;
					3'd4:dot_col <= 8'd0;
					3'd5:dot_col <= 8'd0;
					3'd6:dot_col <= 8'd0;
					3'd7:dot_col <= 8'd0;
				endcase
				end
				4'd6:
				begin
				case(row_count)
					3'd0:dot_col <= 8'd0;
					3'd1:dot_col <= 8'd0;
					3'd2:dot_col <= 8'b00001100;
					3'd3:dot_col <= 8'b00001100;
					3'd4:dot_col <= 8'd0;
					3'd5:dot_col <= 8'd0;
					3'd6:dot_col <= 8'd0;
					3'd7:dot_col <= 8'd0;
				endcase
				end
				4'd7:
				begin
				case(row_count)
					3'd0:dot_col <= 8'd0;
					3'd1:dot_col <= 8'd0;
					3'd2:dot_col <= 8'b00000011;
					3'd3:dot_col <= 8'b00000011;
					3'd4:dot_col <= 8'd0;
					3'd5:dot_col <= 8'd0;
					3'd6:dot_col <= 8'd0;
					3'd7:dot_col <= 8'd0;
				endcase
				end
				4'd8:
				begin
				case(row_count)
					3'd0:dot_col <= 8'd0;
					3'd1:dot_col <= 8'd0;
					3'd2:dot_col <= 8'd0;
					3'd3:dot_col <= 8'd0;
					3'd4:dot_col <= 8'b11000000;
					3'd5:dot_col <= 8'b11000000;
					3'd6:dot_col <= 8'd0;
					3'd7:dot_col <= 8'd0;
				endcase
				end
				4'd9:
				begin
				case(row_count)
					3'd0:dot_col <= 8'd0;
					3'd1:dot_col <= 8'd0;
					3'd2:dot_col <= 8'd0;
					3'd3:dot_col <= 8'd0;
					3'd4:dot_col <= 8'b00110000;
					3'd5:dot_col <= 8'b00110000;
					3'd6:dot_col <= 8'd0;
					3'd7:dot_col <= 8'd0;
				endcase
				end
				4'd10:
				begin
				case(row_count)
					3'd0:dot_col <= 8'd0;
					3'd1:dot_col <= 8'd0;
					3'd2:dot_col <= 8'd0;
					3'd3:dot_col <= 8'd0;
					3'd4:dot_col <= 8'b00001100;
					3'd5:dot_col <= 8'b00001100;
					3'd6:dot_col <= 8'd0;
					3'd7:dot_col <= 8'd0;
				endcase
				end
				4'd11:
				begin
				case(row_count)
					3'd0:dot_col <= 8'd0;
					3'd1:dot_col <= 8'd0;
					3'd2:dot_col <= 8'd0;
					3'd3:dot_col <= 8'd0;
					3'd4:dot_col <= 8'b00000011;
					3'd5:dot_col <= 8'b00000011;
					3'd6:dot_col <= 8'd0;
					3'd7:dot_col <= 8'd0;
				endcase
				end
				4'd12:
				begin
				case(row_count)
					3'd0:dot_col <= 8'd0;
					3'd1:dot_col <= 8'd0;
					3'd2:dot_col <= 8'd0;
					3'd3:dot_col <= 8'd0;
					3'd4:dot_col <= 8'd0;
					3'd5:dot_col <= 8'd0;
					3'd6:dot_col <= 8'b11000000;
					3'd7:dot_col <= 8'b11000000;
				endcase
				end
				4'd13:
				begin
				case(row_count)
					3'd0:dot_col <= 8'd0;
					3'd1:dot_col <= 8'd0;
					3'd2:dot_col <= 8'd0;
					3'd3:dot_col <= 8'd0;
					3'd4:dot_col <= 8'd0;
					3'd5:dot_col <= 8'd0;
					3'd6:dot_col <= 8'b00110000;
					3'd7:dot_col <= 8'b00110000;
				endcase
				end
				4'd14:
				begin
				case(row_count)
					3'd0:dot_col <= 8'd0;
					3'd1:dot_col <= 8'd0;
					3'd2:dot_col <= 8'd0;
					3'd3:dot_col <= 8'd0;
					3'd4:dot_col <= 8'd0;
					3'd5:dot_col <= 8'd0;
					3'd6:dot_col <= 8'b00001100;
					3'd7:dot_col <= 8'b00001100;
				endcase
				end
				4'd15:
				begin
				case(row_count)
					3'd0:dot_col <= 8'd0;
					3'd1:dot_col <= 8'd0;
					3'd2:dot_col <= 8'd0;
					3'd3:dot_col <= 8'd0;
					3'd4:dot_col <= 8'd0;
					3'd5:dot_col <= 8'd0;
					3'd6:dot_col <= 8'b00000011;
					3'd7:dot_col <= 8'b00000011;
				endcase
				end
		endcase

	end

end
endmodule 


`define pTimeExpire 32'd250000
// 100Hz不須再除頻 // keypad
module checkkeypad(clk, rst, overFlow,keypadRow, keypadCol,rand,flag,flagrst);
	input clk, rst,overFlow,flagrst;
	input[3:0]keypadCol,rand;
	output [3:0]keypadRow;

	reg[3:0]keypadRow;
	reg[3:0]keypadBuf;
	reg[31:0]keypadDelay;
    output reg flag;
    reg nowRstFlag;
	always@(posedge clk)
	begin
		if(!rst)
		begin
			keypadRow <= 4'b1110;
			keypadBuf <= 4'b0000;
			keypadDelay <= 31'd0;
			flag <= 0;
			nowRstFlag<=0;
		end 
		else
		begin
		    if(flagrst != nowRstFlag)
		    begin
		        flag <= 0;
				nowRstFlag <= flagrst;
		    end
		    else
		    begin
    			if(keypadDelay == `pTimeExpire)
    			begin
    				keypadDelay = 31'd0;
    				case({keypadRow, keypadCol})
    					8'b1110_1110 : 
    					    if(rand == 4'd15)
    					        flag <= 1;
    					8'b1110_1101 :
    					    if(rand == 4'd14)
    					        flag <= 1;
    					8'b1110_1011 : 
    					    if(rand == 4'd13)
    					        flag <= 1;
    					8'b1110_0111 :
    					    if(rand == 4'd12)
    					        flag <= 1;
    					8'b1101_1110 : 
    					    if(rand == 4'd11)
    					        flag <= 1;
    					8'b1101_1101 : 
    					    if(rand == 4'd10)
    					        flag <= 1;
    					8'b1101_1011 : 
    					    if(rand == 4'd9)
    					        flag <= 1;
    					8'b1101_0111 : 
    					    if(rand == 4'd8)
    					        flag <= 1;
    					8'b1011_1110 : 
    					    if(rand == 4'd7)
    					        flag <= 1;
    					8'b1011_1101 : 
    					    if(rand == 4'd6)
    					        flag <= 1;
    					8'b1011_1011 : 
    					    if(rand == 4'd5)
    					        flag <= 1;
    					8'b1011_0111 : 
    					    if(rand == 4'd4)
    					        flag <= 1;
    					8'b0111_1110 : 
    					    if(rand == 4'd3)
    					        flag <= 1;
    					8'b0111_1101 : 
    					    if(rand == 4'd2)
    					        flag <= 1;
    					8'b0111_1011 : 
    					    if(rand == 4'd1)
    					        flag <= 1;
    					8'b0111_0111 : 
    					    if(rand == 4'd0)
    					        flag <= 1;
    				endcase
    				case(keypadRow)
    					4'b1110 : keypadRow <= 4'b1101;
    					4'b1101 : keypadRow <= 4'b1011;
    					4'b1011 : keypadRow <= 4'b0111;
    					4'b0111 : keypadRow <= 4'b1110;
    					default : keypadRow <= 4'b1110;
    				endcase
    			end
    			else
    				keypadDelay <= keypadDelay + 1'b1;
    		end
		end
	end 
endmodule 



// 圖形divider
`define mTimeExpire 32'd2500
// 10000Hz
module clk_div_matrix(clk, rst, div_clk);
input clk, rst;
output div_clk;

reg div_clk;
reg [31:0] count;

always@(posedge clk)
begin

  if(!rst)
  begin
      count <= 32'd0;
		div_clk <= 1'b0;
  end
  else
  begin
      if(count == `mTimeExpire)
		begin
		    count <= 32'd0;
			 div_clk <= ~div_clk;
		end
		else
		begin
		    count <= count + 32'd1;
		end
  end

end


endmodule


module hit(clk,rst,flag,hit,flagrst);
input clk,flag,rst;
output reg hit,flagrst;
always@(posedge clk)
begin
    if(!rst)
    begin
        hit <= 0;
        flagrst <= 0;
    end
    else
    begin
        if(flag == 1)
        begin
            hit <= ~hit;
            flagrst <= ~flagrst;
        end
    end
end
endmodule

module main(clk,rst,s1,s2,s3,out1,out2,out3,out4,out5,out6, led0, led1, led2, led3, led4, led5, led6, led7, led8, led9, dot_row, dot_col, dot_col2, keypadRow, keypadCol);
	input clk,rst,s1,s2,s3;
	output led0, led1, led2, led3, led4, led5, led6, led7, led8, led9;
	output [6:0]out1,out2,out3,out4,out5,out6;
	
	output [7:0] dot_row;
	output [7:0] dot_col;
	output [7:0] dot_col2;
	input[3:0]keypadCol;
	output [3:0]keypadRow;
	
	wire divm;
	wire [3:0] rand;
	wire [3:0]keypadBuf;
	wire hit ,flag;
	wire [2:0] row_count;
 
	wire toggle1Hz;
	clk1Hz Clk1Hz(clk,rst,toggle1Hz);
	wire [4:0]targetLevel;
	level Level(s1,s2,s3,targetLevel);
	wire [4:0]timeNow;
	wire overFlow,flagrst;
	countDown CountDown(toggle1Hz,rst,timeNow,overFlow,led0, led1, led2, led3, led4, led5, led6, led7, led8, led9, rand);
	display LevelDisplay(targetLevel,out1,out2);
	display CountDownDisplay(timeNow,out3,out4);
	
	clk_div_matrix u_mHz(.clk(clk), .rst(rst), .div_clk(divm));
	matrix u_matrix(.clk(divm), .rst(rst), .random(rand), .dot_row(dot_row), .dot_col(dot_col), .row_count(row_count));
	checkkeypad u_pad(.clk(clk), .rst(rst), .overFlow(overFlow),.keypadRow(keypadRow), .keypadCol(keypadCol),.rand(rand),.flag(flag),.flagrst(flagrst));
	
	hit Hit(.clk(toggle1Hz),.rst(rst),.flag(flag),.hit(hit),.flagrst(flagrst));
	wire [4:0]score;
	addScore Score(clk,rst,hit,score);
	display ScoreDisplay(score,out5,out6);
	image u_image(.clk(divm), .rst(rst), .score(score), .goal(targetLevel), .timenow(timeNow), .row_count(row_count), .dot_col(dot_col2));
endmodule 