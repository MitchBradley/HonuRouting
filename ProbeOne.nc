; Two-stage probe of the toolsetter at the current XY:
; fast approach, pull off, slow re-probe.
; Requires the probe params from ProbeLoop.nc (global for the session):
;   #<_fast_rate> #<_slow_rate> #<_probe_drop> #<_pulloff_distance>
; On return: #5063 holds the probed Z, the tool sits at the slow-probe
; contact point, and absolute mode (G90) is restored.  The caller
; records the result, sets any datum, and backs off.

G20
G38.2 G91 F#<_fast_rate> Z-#<_probe_drop>
G0 G91 Z#<_pulloff_distance>
G38.2 G91 F#<_slow_rate> Z-#<_probe_drop>
G90
