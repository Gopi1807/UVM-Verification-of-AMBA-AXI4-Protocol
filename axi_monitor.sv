class mon extends uvm_monitor;
    `uvm_component_utils(mon)

    transaction tr;
    virtual axi_if vif;

    logic [31:0] arr[120];
    logic [1:0] rdresp;
    logic [1:0] wrresp;
    logic resp;
    int err = 0;

    function new(string path = "mon", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        tr = transaction::type_id::create("tr");
        if(!uvm_config_db#(virtual axi_if)::get(this,"","vif",vif))
            `uvm_error("MON", "unable to access Interface");
    endfunction

    task compare();
        if(err == 0 && rdresp == 0 && wrresp == 0)
            begin
                `uvm_info("MON", $sformatf("Test Passed err :%0d wrresp :%0d rdresp :%0d ", err, rdresp, wrresp), UVM_MEDIUM); 
           err = 0;
            end
        else
        begin
            `uvm_info("MON", $sformatf("Test Failed err :%0d wrresp :%0d rdresp :%0d ", err, rdresp, wrresp), UVM_MEDIUM);
            err = 0; 
          end
    endtask

    virtual task run_phase(uvm_phase phase);
        forever begin
            @(posedge vif.clk);
            if(!vif.resetn)
        begin 
          `uvm_info("MON", "System Reset Detected", UVM_MEDIUM); 
        end
      
      else if(vif.resetn && vif.awaddr < 128)
        begin
       
          wait(vif.awvalid == 1'b1);
          
          for(int i =0; i < (vif.awlen + 1); i++) begin
          @(posedge vif.wready);
          arr[vif.next_addrwr] = vif.wdata;
          end
          
         // @(negedge vif.wlast);
          @(posedge vif.bvalid);
          wrresp = vif.bresp;///0
  //////////////////////////////////////////////////////        
          wait(vif.arvalid == 1'b1);
          
          for(int i =0; i < (vif.arlen + 1); i++) begin
            @(posedge vif.rvalid);
            if(vif.rdata != arr[vif.next_addrrd])
               begin
               err++;
               end
          end
          
          @(posedge vif.rlast);
          rdresp = vif.rresp;
          
          compare();
           $display("------------------------------");
          end
          
          else if (vif.resetn && vif.awaddr >= 128)
          begin
          wait(vif.awvalid == 1'b1);
          
          for(int i =0; i < (vif.awlen + 1); i++) begin
          @(negedge vif.wready);
          end
          
          @(posedge vif.bvalid);
          wrresp = vif.bresp;
          
          wait(vif.arvalid == 1'b1);
          
          for(int i =0; i < (vif.arlen + 1); i++) begin
            @(posedge vif.arready);
            if(vif.rresp != 2'b00)
               begin
               err++;
               end
          end
          
          @(posedge vif.rlast);
           rdresp = vif.rresp;  
              
              compare();   
           $display("------------------------------");   
         end
      
 end      
endtask 