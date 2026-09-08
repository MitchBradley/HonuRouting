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
; Require that PutterGrid.nc has run and populated #100-108 / #200-208
o90 if [EXISTS[#<_grid_available>] EQ 0]
  (MSG, ProbeLoop: PutterGrid.nc has not been run - aborting)
  o91 error [3]
o90 endif

; Toolsetter / backoff params - global so the tool-change re-probe in the
; top loops can reuse them.  The probe rates and travel live in ProbeOne.nc.
#<_toolsetter_height>=2.5 ; in
#<_backoff_distance>=0.5 ; in
#<_toolchange_z>=[#<_toolsetter_height>+#<_backoff_distance>]

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

  $sd/run=/Loop/ProbeOne.nc
  #[300 + #<_i>] = #5063         ; probe z
  #[400 + #<_i>] = [#5063 - #300]  ; delta z

  o101 if [#<_i> EQ 0]
    G10 L20 P2 Z#<_toolsetter_height>  ; set G55 Z datum from the puck-0 toolsetter probe
  o101 endif

  G0 G91 Z#<_backoff_distance>
  G90

  ; Increment counter
  #<_i> = [#<_i> + 1]
o100 endwhile

#<_probed>=1
