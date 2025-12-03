// Testbench for counter module
module counter_tb;
    reg clk;
    reg reset;
    reg enable;
    wire [7:0] count;

    // Instantiate the counter
    counter #(.WIDTH(8)) dut (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .count(count)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test sequence
    initial begin
        // Generate VCD file for waveform viewing
        $dumpfile("counter.vcd");
        $dumpvars(0, counter_tb);

        // Initialize signals
        reset = 1;
        enable = 0;
        
        // Release reset
        #20 reset = 0;
        
        // Enable counter
        #10 enable = 1;
        
        // Run for some time
        #200;
        
        // Disable counter
        enable = 0;
        #50;
        
        // Enable again
        enable = 1;
        #100;
        
        // Finish simulation
        $display("Simulation completed");
        $finish;
    end

    // Monitor
    initial begin
        $monitor("Time=%0t reset=%b enable=%b count=%d", 
                 $time, reset, enable, count);
    end

endmodule
