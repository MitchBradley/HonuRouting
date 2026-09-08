; ProbeOne - probe the toolsetter once at the current XY, optionally set
; the G55 Z datum so the toolsetter surface reads #<_toolsetter_height>,
; then back off.
;
; #<_set_datum> (global): non-zero -> set the datum; 0 -> skip it.
;   Defaults to 1 when unset, and is restored to 1 before returning, so a
;   caller that wants to skip must set 0 immediately before each call.
;   ProbeLoop.nc sets it 0 for pucks 1-8 and 1 for puck 0.

o10 if [EXISTS[#<_set_datum>] EQ 0]
  #<_set_datum>=1
o10 endif

$sd/run=/Loop/ProbeCore.nc

o20 if [#<_set_datum> NE 0]
  G10 L20 P2 Z#<_toolsetter_height>  ; toolsetter surface -> toolsetter_height in G55
o20 endif
#<_set_datum>=1  ; restore default for the next caller

G0 G91 Z#<_backoff_distance>
G90
