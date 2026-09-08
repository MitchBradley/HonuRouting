; ProbeOne - probe the toolsetter once at the current XY, set the G55 Z
; datum so the toolsetter surface reads #<_toolsetter_height>, then back off.
; Used for the tool-change re-probe in the Top*Loop files.

$sd/run=/Loop/ProbeCore.nc
G10 L20 P2 Z#<_toolsetter_height>  ; toolsetter surface -> toolsetter_height in G55
G0 G91 Z#<_backoff_distance>
G90
