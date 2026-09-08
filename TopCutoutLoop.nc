G90 G94
G17
G20

; account for stock thickness to cut only partway through
#<bias>=0.1

; Top side, final operation: cut all 9 pucks free from the stock.
; MaybeProbe re-datums G55 Z for T3 (or runs a full survey if nothing has
; been probed this session); the height deltas #400-408 are reused.
; The cutout runs ~0.040 in radial oversize on purpose (sanding stock in post).
G0 X#100 Y#200

T3  ; select before length probing
M0 (MSG,install T3, then cycle start)
$sd/run=/Loop/MaybeProbe.nc

M0 (MSG,remove toolsetter and ensure vacuum is on)

S9000 M3  ; spindle on for the whole pattern

#<_i> = 0

o100 while [#<_i> LT 9]
  ; Fetch coordinates for current point
  #<x_val> = #[100 + #<_i>]
  #<y_val> = #[200 + #<_i>]
  G0 X#<x_val> Y#<y_val>

  G10 L20 P2 X0 Y0  ; set G55 work zero at this puck
  G43.1 Z[#[400 + #<_i>] + #<bias>]  ; probed tool offset

  G55  ; use scratch WCS for the subprogram
  $sd/run=/Loop/4CutSingle.nc
  G54  ; back to primary WCS

  G49  ; cancel tool offset

  ; Increment counter
  #<_i> = [#<_i> + 1]
o100 endwhile

M5  ; spindle off

; Park at the toolchange reference over puck 0
G0 X#100 Y#200 Z#<_toolchange_z>
