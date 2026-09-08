G90 G94
G17
G20

; Top side, second operation: T-shaped sight-line insets on all 9 pucks.
; Normally reuses the top-side height deltas (#400-408) from an earlier
; probe; if none (run standalone), probe now.  Either way the per-tool
; G55 Z datum is re-established below via ProbeOne.
o90 if [EXISTS[#<_probed>] EQ 0]
  #<_probed>=0
o90 endif
o92 if [#<_probed> EQ 0]
  $sd/run=/Loop/ProbeLoop.nc
o92 endif

G0 X#100 Y#200 Z#<_toolchange_z>

T5  ; select before length probing
M0 (MSG,install T5, position toolsetter, then cycle start)

; Re-zero Z for the new tool against the toolsetter
$sd/run=/Loop/ProbeOne.nc

M0 (MSG,remove toolsetter and ensure vacuum is on)

S9000 M3  ; spindle on for the whole pattern

#<_i> = 0

o100 while [#<_i> LT 9]
  ; Fetch coordinates for current point
  #<x_val> = #[100 + #<_i>]
  #<y_val> = #[200 + #<_i>]
  G0 X#<x_val> Y#<y_val>

  G10 L20 P2 X0 Y0  ; set G55 work zero at this puck
  G43.1 Z#[400 + #<_i>]  ; probed tool offset

  G55  ; use scratch WCS for the subprogram
  $sd/run=/Loop/3TLinesSingle.nc
  G54  ; back to primary WCS

  G49  ; cancel tool offset

  ; Increment counter
  #<_i> = [#<_i> + 1]
o100 endwhile

M5  ; spindle off

; Park at the toolchange reference over puck 0
G0 X#100 Y#200 Z#<_toolchange_z>
