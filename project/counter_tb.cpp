#include "Vcounter_tb.h"
#include "verilated.h"
#include "verilated_vcd_c.h"

int main(int argc, char** argv) {
    Verilated::commandArgs(argc, argv);
    
    // Instantiate the module
    Vcounter_tb* tb = new Vcounter_tb;
    
    // Enable waveform tracing
    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    tb->trace(tfp, 99);
    tfp->open("counter.vcd");
    
    // Simulation time
    vluint64_t sim_time = 0;
    const vluint64_t max_sim_time = 500;
    
    // Run simulation
    while (sim_time < max_sim_time && !Verilated::gotFinish()) {
        tb->eval();
        tfp->dump(sim_time);
        sim_time++;
    }
    
    // Cleanup
    tfp->close();
    delete tb;
    delete tfp;
    
    return 0;
}
