module fifo (
    input  wire       clk,
    input  wire       reset,

    input  wire       wr_en,
    input  wire       rd_en,

    input  wire [7:0] data_in,
    output reg  [7:0] data_out,

    output wire       full,
    output wire       empty
);

    // FIFO memory
    reg [7:0] mem [0:7];

    // Read and write pointers
    reg [2:0] wr_ptr;
    reg [2:0] rd_ptr;

    // Number of stored elements
    reg [3:0] count;

    // FIFO status
    assign empty = (count == 4'd0);
    assign full  = (count == 4'd8);

    always @(posedge clk) begin

        if (reset) begin
            wr_ptr    <= 3'd0;
            rd_ptr    <= 3'd0;
            count     <= 4'd0;
            data_out  <= 8'd0;
        end

        else begin

            // Write operation
            if (wr_en && !full) begin
                mem[wr_ptr] <= data_in;
                wr_ptr <= wr_ptr + 1'b1;
            end

            // Read operation
            if (rd_en && !empty) begin
                data_out <= mem[rd_ptr];
                rd_ptr <= rd_ptr + 1'b1;
            end

            // Update FIFO count
            case ({wr_en && !full, rd_en && !empty})

                2'b10:
                    count <= count + 1'b1;

                2'b01:
                    count <= count - 1'b1;

                default:
                    count <= count;

            endcase

        end
    end

endmodule