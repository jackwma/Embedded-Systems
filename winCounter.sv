module winCounter(Clock, Reset, L, R, leftLight, rightLight, hexDisplay, out);
	input logic Clock, Reset;
	input logic L, R;
	input logic leftLight, rightLight;
	output logic[6:0] hexDisplay;
	output logic out;
	
	logic[6:0] ZERO, ONE, TWO, THREE, FOUR, FIVE, SIX, SEVEN;
	enum{A, B, C, D, E, F, G, H} ps, ns;

	assign ZERO = ~7'b0111111;
	assign ONE = ~7'b0000110;
	assign TWO = ~7'b1011011;
	assign THREE = ~7'b1001111;
	assign FOUR = ~7'b1100110;
	assign FIVE = ~7'b1101101;
	assign SIX = ~7'b1111101;
	assign SEVEN = ~7'b0000111;
	
	always_comb begin
		case(ps)
			A: begin
					if(leftLight & L & ~R) begin
						ns = B;
						hexDisplay = ONE;
						end 
					else if(rightLight & ~L & R) begin
						ns = B;
						hexDisplay = ONE;
						end
					else begin
						ns = A;
						hexDisplay = ZERO;
						end
				end
			B: begin
					if(leftLight & L & ~R) begin
						ns = C;
						hexDisplay = TWO;
						end 
					else if(rightLight & ~L & R) begin
						ns = C;
						hexDisplay = TWO;
						end
					else begin
						ns = B;
						hexDisplay = ONE;
						end
				end
		
			C: begin
					if(leftLight & L & ~R) begin
						ns = D;
						hexDisplay = THREE;
						end 
					else if(rightLight & ~L & R) begin
						ns = D;
						hexDisplay = THREE;
						end
					else begin
						ns = C;
						hexDisplay = TWO;
						end
				end
			
			D: begin
					if(leftLight & L & ~R) begin
						ns = E;
						hexDisplay = FOUR;
						end 
					else if(rightLight & ~L & R) begin
						ns = E;
						hexDisplay = FOUR;
						end
					else begin
						ns = D;
						hexDisplay = THREE;
						end
				end
			
			E: begin
					if(leftLight & L & ~R) begin
						ns = F;
						hexDisplay = FIVE;
						end 
					else if(rightLight & ~L & R) begin
						ns = F;
						hexDisplay = FIVE;
						end
					else begin
						ns = E;
						hexDisplay = FOUR;
						end
				end
			
			F: begin
					if(leftLight & L & ~R) begin
						ns = G;
						hexDisplay = SIX;
						end 
					else if(rightLight & ~L & R) begin
						ns = G;
						hexDisplay = SIX;
						end
					else begin
						ns = F;
						hexDisplay = FIVE;
						end
				end
			
			G: begin
					if(leftLight & L & ~R) begin
						ns = H;
						hexDisplay = SEVEN;
						end 
					else if(rightLight & ~L & R) begin
						ns = H;
						hexDisplay = SEVEN;
						end
					else begin
						ns = G;
						hexDisplay = SIX;
						end
				end
			
			H:  begin
						begin
							ns = H;
							hexDisplay = SEVEN;
						end
				end
		endcase 
	end
	assign out = (leftLight & L) | (rightLight & R);
	
	always_ff @(posedge Clock) begin
		if(Reset) 
			ps <= A;
		else 
			ps <= ns;
	end
	
endmodule 

module winCounter_testbench();
	logic clk, reset, L, R;
	logic lightOn;
	logic NL, NR;
	logic[6:0] hexDisplay;
	winCounter dut (.Clock(clk), .Reset(reset), .L(L), .R(R), .leftLight(NL), .rightLight(NR), .hexDisplay(hexDisplay)); // Instantiate the D FF
	
	parameter CLOCK_PERIOD = 100;
	
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	initial begin // Set up the reset signal
		reset <= 1; 					@(posedge clk);
		reset <= 0; hexDisplay[6:0] <= 0;					@(posedge clk);
		NL <= 1;		L <= 1;			@(posedge clk);
											@(posedge clk);
											@(posedge clk);
											@(posedge clk);
											@(posedge clk);
						reset <= 1; 	@(posedge clk);
						reset <= 0; 	@(posedge clk);
						L <= 1;			@(posedge clk);
											@(posedge clk);
											@(posedge clk);
											@(posedge clk);
						NL <= 0;			@(posedge clk);
						R <= 1;			@(posedge clk);
											@(posedge clk);
											@(posedge clk);
											@(posedge clk);
											@(posedge clk);
		reset <= 1; 					@(posedge clk);
		reset <= 0; 					@(posedge clk);
		NR <= 1;		R <= 1;			@(posedge clk);
											@(posedge clk);
											@(posedge clk);
											@(posedge clk);
											@(posedge clk);
						NR <= 0;			@(posedge clk);
		$stop(); // end the simulation
	end
endmodule 