#include <stdlib.h>
#include <iostream>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include "VMod.h"

#define MAX_SIM_TIME 20
vluint64_t mainTime = 0;

uint16_t i;
// void testDataGen(int stTime, int endTime) {
//     while(dut->gotFinish()) {
//         dut->dIn = i+1;
//         i++;

//     }
// }

int main(int argc, char** argv, char** env) {

    if(0 && argc && argv && env) {}

    Verilated::debug(0);
    Verilated::traceEverOn(true);
    Verilated::randReset(2);
    Verilated::commandArgs(argc, argv);
    Verilated::mkdir("logs");
    
    VMod *dut = new VMod;
    
    VerilatedContext* contextp = new VerilatedContext;
    //For GTKWAVE
    VerilatedVcdC *m_trace = new VerilatedVcdC;
    dut->trace(m_trace, 5);
    m_trace->open("waveform.vcd");

    dut->clk = 0;
    while (mainTime < 10000) {
        ++mainTime;
        dut->clk = !dut->clk;
        dut->dIn = 0;
        dut->valIn = 0;
        dut->rst = (mainTime < 10) ? 1:0;
        // testDataGen(0,100);
        dut->eval();
        m_trace->dump(mainTime);
    }

    m_trace->close();
    delete dut;
    exit(EXIT_SUCCESS);
}

