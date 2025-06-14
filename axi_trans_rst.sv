class rst_dut extends uvm_sequence#(transaction);
    `uvm_object_utils(reset_dut)

    transaction tr;

    function new(string path = "rst_dut");
        super.new(path);
    endfunction

    virtual task body();
        repeat(5) begin
            tr = transaction::type_id::create("tr");
            `uvm_info("SEQ", "Sending RST Transaction to DRV", UVM_NONE);
            start_item(tr);
            assert(tr.randomize());
            tr.op = rstdut;
            finish_item();
        end
    endtask
endclass