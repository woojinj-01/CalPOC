module TB_CalPOC;

  reg CLK;
  reg ButtonFor1;
  reg ButtonFor0;
  reg ButtonForOR;
  reg ButtonForXOR;
  reg ButtonForEquals;
  reg ButtonForClear;

  wire [2:0] LEDForA;
  wire [2:0] LEDForB;
  wire [2:0] SevenSeg;

  // Instantiate the module under test
  CalPOC_FSM Calculator (
    .CLK(CLK),
    .ButtonFor1(ButtonFor1),
    .ButtonFor0(ButtonFor0),
    .ButtonForOR(ButtonForOR),
    .ButtonForXOR(ButtonForXOR),
    .ButtonForEquals(ButtonForEquals),
    .ButtonForClear(ButtonForClear),
    .LEDForA(LEDForA),
    .LEDForB(LEDForB),
    .SevenSeg(SevenSeg)
  );

  // Task to toggle a signal with a specified delay
  task toggle_signal(ref reg signal, int delay);
    begin
      signal = 1;
      #delay 
      signal = 0;
      #10
    end
  endtask

  // Clock generation (50 MHz)
  always begin
    #5 CLK = ~CLK;
  end

  // Test stimulus
  initial begin
    CLK = 0;
    ButtonFor1 = 0;
    ButtonFor0 = 0;
    ButtonForOR = 0;
    ButtonForXOR = 0;
    ButtonForEquals = 0;
    ButtonForClear = 0;

    // Apply some inputs
    // For example, to test state `STATE_ARG1`, you can toggle it using toggle_signal():
    toggle_signal(ButtonFor1, 10)

    toggle_signal(ButtonFor0, 10)

    toggle_signal(ButtonFor1, 10)

    toggle_signal(ButtonForOR, 10)

    toggle_signal(ButtonFor0, 10)

    toggle_signal(ButtonFor0, 10)

    toggle_signal(ButtonFor1, 10)

    toggle_signal(ButtonForEquals, 10)

    toggle_signal(ButtonForClear, 10)

    // Add more test cases by changing inputs

    // Monitor outputs
    $display("Time=%t LEDForA=%h LEDForB=%h SevenSeg=%h", $time, LEDForA, LEDForB, SevenSeg);

    // End simulation after some time
    #1000 $finish;
  end

endmodule
