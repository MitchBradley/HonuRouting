G90 G94
G17
G20

; account for stock thickness to cut only partway through
#<bias>=0.1



T3  ; select before length probing
M0 (MSG,install T3, position toolsetter, then cycle start)




S9000 M3  ; spindle on for the whole pattern

#<_i> = 0

o100 while [#<_i> LT 9]
  ; Fetch coordinates for current point
  #<x_val> = #[100 + #<_i>]
  #<y_val> = #[200 + #<_i>]
  G0 X#<x_val> Y#<y_val>

  G10 L20 P2 X0 Y0  ; set G55 work zero at this puck
  G43.1 Z[#[400 + #<_i>] - #<bias>]  ; probed tool offset

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
