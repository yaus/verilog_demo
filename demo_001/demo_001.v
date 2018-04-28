// module -- Keyword for module declaration
// main   -- name of the module
module main;

// initial -- execute next block/statement once only on start of the simulation
initial
    // begin -- start a statement block
    // BLOCK_NAME -- label of statement block
    begin : BLOCK_NAME
        // $display -- internal function for print string
        $display("Hello world!");
        // $finish -- internal function for stop simulation
        $finish;
    end : BLOCK_NAME
    // end -- end of a statement block
    // BLOCK_NAME -- for paired up BEGIN-END(non-necessary)

endmodule
// endmodule -- Keyword for the end of the module declaration

