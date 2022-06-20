module naivesignal #(
    parameter wid = 4
)(
    input clk1, clk2, resetn,
    input fire, 
    output hazard
);
    // wire [wid-1:0] dtrans;
    wire [wid-1:0] din, dout;
    genvar i;
    for (i = 0; i < wid; i++) begin
    (* async_reg = "true" *)    reg [2:0] sync;

        assign din[i] = sync[2];
        always_ff @( posedge clk2 ) begin
            if (~resetn) begin
                sync <= '0;
            end else begin
                sync <= {sync[1:0], dout[i]};
            end
        end
    end

    naive_send #(.wid(wid)) usend (.clk(clk1), .*);
    naive_recv #(.wid(wid)) urecv (.clk(clk2), .*);


endmodule

module naive_send #(
    parameter wid = 4
)(
    input clk, resetn,
    input fire,
    output reg [wid-1:0] dout
);

    always_ff @( posedge clk ) begin
        if (~resetn) begin
            dout <= '0;
        end else begin
            if (fire) dout <= dout + 1;
        end
    end
    
endmodule

module naive_recv #(
    parameter wid = 4
)(
    input clk, resetn,
    input [wid-1:0] din,
(* mark_debug = "true" *)    output reg hazard
);

(* mark_debug = "true" *)    reg [wid-1:0] dbuf;

    always_comb begin
        hazard = '0;

        if (dbuf != din) begin
            if (dbuf + {{(wid-1){1'b0}}, 1'b1} != din) begin
                hazard = '1;
            end
        end
    end

    always_ff @( posedge clk ) begin
        if (~resetn) begin
            dbuf <= '0;
        end else begin
            dbuf <= din;
        end
    end
    
endmodule