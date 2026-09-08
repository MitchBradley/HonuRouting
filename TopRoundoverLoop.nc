G90 G94
G17
G20

; Top side, first operation. Stock has been flipped from the bottom side.
; The XY grid (#100-108 / #200-208) carries over from the bottom run.  If
; it is missing (e.g. a reset since the bottom run), ProbeLoop.nc rebuilds
; it; if the fixturing changed, re-run PutterGrid.nc by hand first.
; Re-probe here to capture top-side stock heights: this overwrites
; #300-308 (probed Z) and #400-408 (deltas) with top-side values.
T24  ; top roundover form mill - select before length probing
$sd/run=/Loop/ProbeLoop.nc   ; re-probes; sets #<_probed>=1

G0 X#100 Y#200

M0 (MSG,pause to remove toolsetter)
M0 (MSG,safety)

S18000 M3  ; spindle on for the whole pattern

#<_i> = 0

o100 while [#<_i> LT 9]
  ; Fetch coordinates for current point
  #<x_val> = #[100 + #<_i>]
  #<y_val> = #[200 + #<_i>]
  G0 X#<x_val> Y#<y_val>

  G10 L20 P2 X0 Y0  ; set G55 work zero at this puck
  G43.1 Z#[400 + #<_i>]  ; probed tool offset

  G55  ; use scratch WCS for the subprogram
  $sd/run=/Loop/2TopRoundSingle.nc
  G54  ; back to primary WCS

  G49  ; cancel tool offset

  ; Increment counter
  #<_i> = [#<_i> + 1]
o100 endwhile

M5  ; spindle off

; Park at the toolchange reference over puck 0
G0 X#100 Y#200 Z#<_toolchange_z>
