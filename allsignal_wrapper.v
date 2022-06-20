module allsignal_wrapper #(
    parameter wid = 4
)(
    input wire [0:0] clk1,
    input wire [0:0] clk2,
    input wire [0:0] resetn,
    input wire [0:0] fire,
    output wire [0:0] hazard
);

    allsignal #(
        .wid(wid)
    ) u0 (
        .clk1(clk1),
        .clk2(clk2),
        .resetn(resetn),
        .fire(fire),
        .hazard(hazard)
    );

endmodule