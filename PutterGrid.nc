; Establish grid points of putter puck centers
; outputs:
;   #100-108 - X coordinates
;   #200-208 - Y coordinates

; ==========================================================
; Grid & Array Configuration
; ==========================================================
#<x_start> = 0.00
#<y_start> = 0.00
#<x_delta> = -4.15
#<y_delta> = -5.00
#<x_offset> = 2.30
#<y_offset> = -2.00

; ==========================================================
; Array Initialization (Boustrophedon / Serpentine Pattern)
; ==========================================================
#<row> = 0

o10 while [#<row> LT 3]
  #<col> = 0
  o20 while [#<col> LT 3]

    ; Determine X column index based on row direction
    ; Even rows (0, 2): Left-to-Right (0, 1, 2)
    ; Odd row (1): Right-to-Left (2, 1, 0)
    o30 if [[#<row> MOD 2] EQ 0]
      #<eff_col> = #<col>
    o30 else
      #<eff_col> = [2 - #<col>]
    o30 endif

    ; Calculate linear index (0 through 8)
    #<idx> = [[#<row> * 3] + #<col>]

    ; Store calculated X and Y coordinates into #100-#108 and #200-#208
    #[100 + #<idx>] = [#<x_start> + #<x_offset> + [#<eff_col> * #<x_delta>]]
    #[200 + #<idx>] = [#<y_start> + #<y_offset> + [#<row> * #<y_delta>]]

    #<col> = [#<col> + 1]
  o20 endwhile

  #<row> = [#<row> + 1]
o10 endwhile

; Signal that the grid has been computed (global, read by later programs)
#<_grid_available> = 1
