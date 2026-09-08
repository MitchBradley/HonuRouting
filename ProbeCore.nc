; ProbeCore - two-stage probe of the toolsetter at the current XY
; (fast approach, pull off, slow re-probe), and the home for the shared
; toolsetter / backoff globals.
; On return: #5063 holds the probed Z, the tool sits at the slow-probe
; contact point, and absolute mode (G90) is restored.  The caller
; records the result, sets any datum, and backs off.

; Shared globals - used by ProbeLoop.nc, ProbeOne.nc and the Top*Loop park moves
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
G90
