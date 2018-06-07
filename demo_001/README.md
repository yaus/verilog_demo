# Demo 001
## Objective
* Study IcarusVerilog 
* Study testbench construction

## Icarus Verilog
1. Install icarus verilog
``` bash
sudo apt install iverilog
```
2. Install gtkwave
``` bash
sudo apt install gtkwave
```

## Testbench
Verilog uses module hierarchical. Code structure is:
``` verilog 
module MODULE_NAME;
/* module body here */
endmodule
``` 

To execute instruction from the beginning, *initial* is used.
``` verilog
module MODULE_NAME;
initial         // execute next statement at the start of simulation
    $finish;    // end the simulation
endmodule
```

To execute a sequence of code, *begin*-*end* pair is used. The code will execute sequently.
``` verilog
module MODULE_NAME;
initial
    begin: BLOCK_NAME // Optional
        $display("Hello world!");
        $finish;
    end: BLOCK_NAME // Optional
endmodule
```