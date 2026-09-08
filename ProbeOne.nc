; ProbeOne - probe the toolsetter once at the current XY (fast approach,
; pull off, slow re-probe), optionally set the G55 Z datum so the
; toolsetter surface reads #<_toolsetter_height>, then back off.
;
; #<_set_datum> (global): non-zero -> set the datum; 0 -> skip it.
;   Defaults to 1 when unset, and is restored to 1 before returning, so a
;   caller that wants to skip must set 0 immediately before each call.
;   ProbeLoop.nc sets it 0 for pucks 1-8 and 1 for puck 0.
;
; Also (re)defines the shared toolsetter/backoff globals used by
; ProbeLoop.nc and the Top*Loop park moves.
; On return: #5063 = probed Z, absolute mode (G90) restored.

o10 if [EXISTS[#<_set_datum>] EQ 0]
  #<_set_datum>=1
o10 endif

; Shared globals
#<_toolsetter_height>=2.5 ; in
#<_backoff_distance>=0.5 ; in
#<_toolchange_z>=[#<_toolsetter_height>+#<_backoff_distance>]

; Probe-motion params - local to this file
#<fast_rate>=10 ; in/min
#<slow_rate>=1 ; in/min
#<probe_drop>=0.6 ; in - max probe descent below current Z (safety margin above hard limit)
#<pulloff_distance>=0.1 ; in

G20
G38.2 G91 F#<fast_rate> Z-#<probe_drop>
G0 G91 Z#<pulloff_distance>
G38.2 G91 F#<slow_rate> Z-#<probe_drop>

o20 if [#<_set_datum> NE 0]
  G10 L20 P2 Z#<_toolsetter_height>  ; toolsetter surface -> toolsetter_height in G55
o20 endif
#<_set_datum>=1  ; restore default for the next caller

G0 G91 Z#<_backoff_distance>
G90
