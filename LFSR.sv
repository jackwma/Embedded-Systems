module LFSR(Clock, Reset, out);
	output logic[9:0] out;
	input logic Clock, Reset;
	logic linear_feedback;
	
	
	//assign out = 9'b000000000;
	
	assign linear_feedback = ~(out[8]^out[4]);
	
	always @(posedge Clock) begin
		if(Reset) begin
			out <= 9'b000000000;
			end
		else begin
			out <= {out[8],out[7],out[6],out[5],out[4],
			out[3],out[2],out[1],out[0], linear_feedback};
		
		end
	end
	
	
endmodule

module LFSR_testbench();
	logic clk, Reset;
	logic[9:0] out;
	
	LFSR dut(.Clock(clk), .Reset, .out);
	
	parameter CLOCK_PERIOD = 100;
	initial clk = 1;
	always begin
		#(CLOCK_PERIOD / 2);
		clk = ~clk;
	end 
	
	initial begin
					@(posedge clk);
		Reset <= 0; @(posedge clk);
		Reset <= 1; @(posedge clk);
						@(posedge clk);
		Reset <= 0; @(posedge clk);
		Reset <= 1; @(posedge clk);
		$stop; // End the simulation.
	end 
endmodule 