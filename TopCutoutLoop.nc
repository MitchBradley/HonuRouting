G90 G94
G17
G20

; account for stock thickness to cut only partway through
#<bias>=0.1

; Top side, final operation: cut all 9 pucks free from the stock.
; No 9-point re-probe - reuses the top-side height deltas (#400-408) from
; TopRoundoverLoop.nc; only re-zeros Z for the new tool against the toolsetter.
; The cutout runs ~0.040 in radial oversize on purpose (sanding stock in post).
o90 if [EXISTS[#<_top_heights_available>] EQ 0]
  (MSG, TopCutoutLoop: TopRoundoverLoop.nc has not been run - aborting)
  o91 error [3]
o90 endif

G0 X#100 Y#200 Z#<_toolchange_z>

T3  ; select before length probing
M0 (MSG,install T3, position toolsetter, then cycle start)

; Re-zero Z for the new tool against the toolsetter (same probe pattern as ProbeLoop)
G38.2 G91 F#<_fast_rate> Z-#<_probe_drop>
G0 G91 Z#<_pulloff_distance>
G38.2 G91 F#<_slow_rate> Z-#<_probe_drop>
G10 L20 P2 Z#<_toolsetter_height>  ; toolsetter surface -> toolsetter_height in G55
G0 G91 Z#<_backoff_distance>
G90

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
