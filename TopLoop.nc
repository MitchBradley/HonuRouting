G90 G94
G17
G20

; Top side, full sequence. Run after BottomLoop.nc and after flipping the stock.
; The XY grid (#100-108 / #200-208) carries over from the bottom run in the
; usual case; if the fixturing changed, re-run PutterGrid.nc by hand first.
;
; TopRoundoverLoop re-probes for top-side stock heights (sets #<_probed>);
; the other two loops abort if #<_probed> is 0.
; Each sub-loop has its own M0 tool-change / safety pauses.

$sd/run=/Loop/TopRoundoverLoop.nc
$sd/run=/Loop/TopTLinesLoop.nc
$sd/run=/Loop/TopCutoutLoop.nc
