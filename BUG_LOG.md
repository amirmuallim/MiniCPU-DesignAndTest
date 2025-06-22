# 🐞 Bug Log

This log contains a record of bugs encountered and fixed in this project.

---

## 🐞 Bug - [2025-06-22] [closed]

**File:** `regiter_bank, output_selection.v`

**Description:**
> The output was not propagated from the r_b to OUTPUT PORTS for output_value operation

**Expected behavior:**
> The stored valued propagate in the output ports

**Actual behavior:**
> Garbage value are propagate in output ports

**Root Cause:**
> Register banks output ports were depended on posedge of clk, output selection code is not correct. 

**Old Code:**
```verilog
// register bank
always @(posedge clk)
begin
	if(write_reg)
		mem[k] <= reg_in;

	left_out <= mem[i];		
    right_out <= mem[j];

// output_selection
    always @(posedge clk) begin
        if (out_en) begin
            case(i)
                3'd0: reg0 <= (out_sel) ? A : regi;
                3'd1: reg1 <= (out_sel) ? A : regi;
                3'd2: reg2 <= (out_sel) ? A : regi;
                3'd3: reg3 <= (out_sel) ? A : regi;
                3'd4: reg4 <= (out_sel) ? A : regi;
                3'd5: reg5 <= (out_sel) ? A : regi;
                3'd6: reg6 <= (out_sel) ? A : regi;
                3'd7: reg7 <= (out_sel) ? A : regi;
            endcase
        end
    end
	
end     

```

**New Code (Fix):**
```verilog
// register_bank
always @(posedge clk)
begin
	if(write_reg)
		mem[k] <= reg_in;

	// left_out <= mem[i];		
	// right_out <= mem[j];
	
end

// output_selection
    always @(posedge clk) begin
        if (out_en) begin
            case(i)
                3'd0: reg0 <= (out_sel) ? regi : A;
                3'd1: reg1 <= (out_sel) ? regi : A;
                3'd2: reg2 <= (out_sel) ? regi : A;
                3'd3: reg3 <= (out_sel) ? regi : A;
                3'd4: reg4 <= (out_sel) ? regi : A;
                3'd5: reg5 <= (out_sel) ? regi : A;
                3'd6: reg6 <= (out_sel) ? regi : A;
                3'd7: reg7 <= (out_sel) ? regi : A;
            endcase
        end
    end
```

--- 

## 🐞 Bug - [2025-06-22] [closed]

**File:** `register_bank`

**Description:**
> The stored data in register bank is unsigned, making the jump instruction retrieving unsigned resulting in wrong operation.

**Expected behavior:**
> Proper storage of data as signed in the register bank

**Actual behavior:**
> Data is stored as unsigned in register bank

**Root Cause:**
> Declared the registered bank mem array without signed

**Old Code:**
```verilog
reg [7:0] mem [15:0];

```

**New Code (Fix):**
```verilog
reg signed [7:0] mem [15:0];

```

---