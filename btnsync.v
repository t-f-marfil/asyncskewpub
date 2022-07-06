module btnsync #(
    parameter len = 3
)(
    input clk, resetn,
    input btn,
    output wire syncbtn
);

(* async_reg = "true" *)    reg [len-1:0] sync;

    assign syncbtn = sync[len-1];
    always @(posedge clk) begin
        if (~resetn) begin
            sync <= {len{1'b0}};
        end else begin
            sync <= {sync[1:0], btn};
        end
    end
    
endmodule