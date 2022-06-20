module graysignal #(
    parameter wid = 4
)(
    input clk1, clk2, resetn,
    input fire,
    output hazard
);

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

    gray_send #(.wid(wid)) usend (.clk(clk1), .*);
    gray_recv #(.wid(wid)) urecv (.clk(clk2), .*);
    
endmodule

module gray_send #(
    parameter wid = 4
) (
    input clk, resetn,
    input fire,
    output reg [wid-1:0] dout 
);

    reg [wid-1:0] binptr;
    always_ff @( posedge clk ) begin 
        if (~resetn) begin
            dout <= '0;
            binptr <= '0;
        end else begin
            if (fire) begin
                binptr <= binptr + 1;
                dout <= (binptr >> 1) ^ binptr;
            end
        end
    end
    
endmodule

module gray_recv #(
    parameter wid = 4
)(
    input clk, resetn, 
    input [wid-1:0] din,
(* mark_debug = "true" *)    output logic hazard
);
    genvar i;

(* mark_debug = "true" *)    reg [wid-1:0] binbuf;

    logic [wid-1:0] dintobin;
    assign dintobin[wid-1] = din[wid-1];
    for (i = 0; i < wid-1; i++) begin
        assign dintobin[i] = ^din[wid-1:i];
    end

    // always_comb begin
    //     dintobin[wid-1] = din[wid-1];
    //     for (int j = 0; j < wid-1; j++) begin
    //         dintobin[j] = dintobin[j+1] ^ din[j];
    //     end
    // end

    always_ff @( posedge clk ) begin
        if (~resetn) begin
            binbuf <= '0;
        end else begin
            binbuf <= dintobin;
        end
    end

    always_comb begin
        hazard = '0;
        if (binbuf != dintobin) begin
            if (binbuf + {{(wid-1){1'b0}}, 1'b1} != dintobin) begin
                hazard = '1;
            end
        end
    end
    
endmodule