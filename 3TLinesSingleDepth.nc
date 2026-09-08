(3TLinesSingle)
(URH Hole)
(Machine)
(  vendor: Geometric Robotics)
(  model: 2x2)
(  description: GR3 2x2 Router)
(T5  D=0.1875 CR=0 - ZMIN=-0.1 - flat end mill)

; Require that _depth is set
o90 if [EXISTS[#<_depth>] EQ 0]
  (MSG, 3TLinesSingleDepth - _depth is not set)
  o91 error [3]
o90 endif

G90 G94
G17
G20

(TLineShort5 3)
G0 X-0.9638 Y0
Z0.5
Z0.1
G1 Z-#<_depth> F10
X0.5462 F80
Z0.1
G0 Z0.5

(TLineLong5 3)
X0.5462 Y-1.5125
Z0.5
Z0.1
G1 Z-#<_depth> F10
Y1.5125 F80
Z0.1
G0 Z0.5
