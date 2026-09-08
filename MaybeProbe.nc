; MaybeProbe - ensure valid probe data and a correct G55 Z datum for the
; tool now in the spindle.  Call AFTER that tool is installed.
;
;   #<_probed> == 0 -> full 9-point ProbeLoop: builds the grid if needed,
;                      surveys #300-308 / #400-408, sets the puck-0 G55 Z
;                      datum, sets #<_probed>=1.  (ProbeLoop has its own
;                      toolsetter-position M0.)
;   #<_probed> != 0 -> already surveyed this session; just re-datum G55 Z
;                      for the current tool via a single ProbeOne.
o90 if [EXISTS[#<_probed>] EQ 0]
  #<_probed>=0
o90 endif
o92 if [#<_probed> EQ 0]
  $sd/run=/Loop/ProbeLoop.nc
o92 else
  M0 (MSG,position toolsetter, then cycle start)
  $sd/run=/Loop/ProbeOne.nc
o92 endif
