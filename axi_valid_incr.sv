class valid_wrrd_incr extends uvm_sequence#(transaction);
    `uvm_object_utils(valid_wrrd_incr)

    transaction tr;

    function new(string path = "valid_wrrd_incr");
        super.new(path);
    endfunction

    virtual task body();
        tr = transaction::type_id::create("tr");
        start_item(tr);
        assert(tr.randomize());
        tr.op = wrrdincr;
        tr.awlen = 7;
        tr.awburst = 1;
        tr.awsize = 2;
        finish_item(tr);
    endtask
endclass