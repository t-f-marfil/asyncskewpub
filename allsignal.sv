module allsignal #(
    parameter wid = 4
)(
    input clk1, clk2, resetn,
    input fire,
    output hazard
);
// clk1 < clk2
    wire grayhazard, naivehazard;
    graysignal ugray (.hazard(grayhazard), .*);
    naivesignal unaive (.hazard(naivehazard), .*);

    assign hazard = grayhazard | naivehazard;

    wire pulseghazard, pulsenhazard;
    topulse gpulse(.clk(clk2), .din(grayhazard), .dout(pulseghazard), .*);
    topulse npulse(.clk(clk2), .din(naivehazard), .dout(pulsenhazard), .*);

(* mark_debug = "true" *)    reg [31:0] gcount, ncount;

    always_ff @( posedge clk2 ) begin
        if (~resetn) begin
            gcount <= '0;
            ncount <= '0;
        end else begin
            if (pulseghazard) gcount <= gcount + 1;
            if (pulsenhazard) ncount <= ncount + 1;
        end
    end
    
endmodule

module topulse (
    input clk, resetn,
    input din,
    output dout
);
    reg dbuf;

    always_ff @( posedge clk ) begin 
        if (~resetn) begin
            dbuf <= '0;
        end else begin
            dbuf <= din;
        end
    end

    assign dout = din & ~dbuf;
endmodule