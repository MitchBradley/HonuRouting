; 9-point probe at putter puck centers
; inputs:
;   #100-108 - X coordinates (from PutterGrid.nc)
;   #200-208 - Y coordinates (from PutterGrid.nc)
; outputs:
;   #300-308 - Z coordinates (probed heights)
;   #400-408 - deltas (difference heightN - height0)
; The deltas can be used later to adjust based on a
; re-probe at position 0, with a different tool

G20
; Ensure the XY grid (#100-108 / #200-208) exists; build it if not
o90 if [EXISTS[#<_grid_available>] EQ 0]
  $sd/run=/Loop/PutterGrid.nc
o90 endif

; ==========================================================
; Execution Loop
; ==========================================================
#<_i> = 0

G0 X#100 Y#200
M0 (MSG,Move toolsetter into position and press cycle start)

o100 while [#<_i> LT 9]
  ; Fetch coordinates for current point
  #<x_val> = #[100 + #<_i>]
  #<y_val> = #[200 + #<_i>]
  G0 X#<x_val> Y#<y_val>

  #<_set_datum> = [#<_i> EQ 0]  ; take the G55 Z datum from the puck-0 probe only
  $sd/run=/Loop/ProbeOne.nc
  #[300 + #<_i>] = #5063         ; probe z
  #[400 + #<_i>] = [#5063 - #300]  ; delta z

  ; Increment counter
  #<_i> = [#<_i> + 1]
o100 endwhile

#<_probed>=1
