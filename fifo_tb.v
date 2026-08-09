`timescale 1ns/1ps

module fifo_tb;

    reg clk;
    reg reset;

    reg wr_en;
    reg rd_en;

    reg [7:0] data_in;

    wire [7:0] data_out;
    wire full;
    wire empty;

    // Instantiate FIFO
    fifo uut (
        .clk(clk),
        .reset(reset),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .data_in(data_in),
        .data_out(data_out),
        .full(full),
        .empty(empty)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Write task
    task write_data;
        input [7:0] data;
        begin
            @(negedge clk);
            wr_en = 1'b1;
            data_in = data;

            @(negedge clk);
            wr_en = 1'b0;

            $display("WRITE: Data = %0d", data);
        end
    endtask

    // Read task
    task read_data;
        begin
            @(negedge clk);
            rd_en = 1'b1;

            @(negedge clk);
            rd_en = 1'b0;

            $display("READ : Data = %0d", data_out);
        end
    endtask

    initial begin

        // Initialize
        clk = 1'b0;
        reset = 1'b1;
        wr_en = 1'b0;
        rd_en = 1'b0;
        data_in = 8'd0;

        // Reset
        #10;
        reset = 1'b0;

        // --------------------------------
        // TEST 1: Write data
        // --------------------------------

        write_data(8'd10);
        write_data(8'd20);
        write_data(8'd30);
        write_data(8'd40);

        // --------------------------------
        // TEST 2: Read data
        // Expected:
        // 10, 20, 30, 40
        // --------------------------------

        read_data();
        read_data();
        read_data();
        read_data();

        // --------------------------------
        // TEST 3: Write more data
        // --------------------------------

        write_data(8'd50);
        write_data(8'd60);
        write_data(8'd70);

        // --------------------------------
        // TEST 4: Read data
        // --------------------------------

        read_data();
        read_data();
        read_data();

        // --------------------------------
        // TEST 5: Reset
        // --------------------------------

        @(negedge clk);
        reset = 1'b1;

        @(negedge clk);
        reset = 1'b0;

        #20;

        $finish;

    end

    // Monitor signals
    initial begin

        $monitor(
            "TIME=%0t | RESET=%b | WR=%b | RD=%b | IN=%0d | OUT=%0d | COUNT=%0d | FULL=%b | EMPTY=%b",
            $time,
            reset,
            wr_en,
            rd_en,
            data_in,
            data_out,
            uut.count,
            full,
            empty
        );

    end

    // Waveform generation
    initial begin
        $dumpfile("fifo.vcd");
        $dumpvars(0, fifo_tb);
    end

endmodule