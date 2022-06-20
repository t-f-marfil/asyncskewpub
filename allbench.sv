module allbench ();

    logic clk1, clk2, resetn, fire;

    design_1_wrapper dut (.*);

    initial begin
        fire = 0;
        #35;
        fire = 1;
    end

    initial begin
        resetn = 0;
        #25;
        resetn = 1;
    end

    initial begin
        clk1 = 0;
        forever begin
            #5;
            clk1 = ~clk1;
        end
    end

    initial begin
        clk2 = 0;
        forever begin
            #3;
            clk2 = ~clk2;
        end
    end
    
endmodule