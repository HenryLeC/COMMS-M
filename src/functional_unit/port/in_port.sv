`default_nettype none
`timescale 1ps/1ps

module in_port #(
    parameter N = 2,
    parameter WIDTH = 32,
    parameter ADDR_WIDTH = 6,
    parameter bit [ADDR_WIDTH-1:0] ADDRESS  = 6'b000000
)(
    input  wire  clk,
    input  wire  rst_n,

    input  wire  [WIDTH-1:0]      busses      [0:N-1],
    input  wire  [ADDR_WIDTH-1:0] addr_busses [0:N-1],

    output logic [WIDTH-1:0]      data,
    output logic                  data_valid
);

    logic [N-1:0] bus_valid;


    int i;
    always_ff @(posedge clk or negedge rst_n)
    if (!rst_n)
        bus_valid <= 0;
    else begin
        for (i = 0 ; i < N; i++)
            bus_valid[i] <= addr_busses[i] == ADDRESS;
    end

    int j;
    always_comb begin : bus_mux
        data_valid = 0;
        data = 0;
        for (j = 0; j < N; j++)
        if (bus_valid[j]) begin
            data = busses[j];
            data_valid = 1;
        end
    end

endmodule