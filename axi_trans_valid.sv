class valid_wrrd_fixed extends uvm_sequence#(transaction);
    `uvm_object_utils(valid_wrrd_fixed)

    transaction tr;

    function new(string path = "valid_wrrd_fixed");
        super.new(path);
    endfunction

    virtual task body();
        tr = transaction::type_id::create("tr");
        start_item(tr);
        assert(tr.randomize());
        tr.op = wrrdfixed;
        tr.awlen = 7;
        tr.awburst = 0;
        tr.awsize = 2;
        finish_item(tr);
    endtask
endclass