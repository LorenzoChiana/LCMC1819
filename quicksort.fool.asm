push 0
lfp
 push function1
lfp
 push function2
lfp
 push function4
lfp
 push function5
push -1
push 5
lhp 
lhp 
sw 
lhp 
push 1 
add 
shplhp 
sw 
lhp 
push 1 
add 
shp9998
lhp 
sw 
lhp 
lhp 
push 1 
add 
shppush 2
lhp 
lhp 
sw 
lhp 
push 1 
add 
shplhp 
sw 
lhp 
push 1 
add 
shp9998
lhp 
sw 
lhp 
lhp 
push 1 
add 
shppush 3
lhp 
lhp 
sw 
lhp 
push 1 
add 
shplhp 
sw 
lhp 
push 1 
add 
shp9998
lhp 
sw 
lhp 
lhp 
push 1 
add 
shppush 4
lhp 
lhp 
sw 
lhp 
push 1 
add 
shplhp 
sw 
lhp 
push 1 
add 
shp9998
lhp 
sw 
lhp 
lhp 
push 1 
add 
shppush 1
lhp 
lhp 
sw 
lhp 
push 1 
add 
shplhp 
sw 
lhp 
push 1 
add 
shp9998
lhp 
sw 
lhp 
lhp 
push 1 
add 
shppush 2
lhp 
lhp 
sw 
lhp 
push 1 
add 
shplhp 
sw 
lhp 
push 1 
add 
shp9998
lhp 
sw 
lhp 
lhp 
push 1 
add 
shplfp
 push function7
lfp
 push function8
lfp
 push function10
lfp
 push function11
push -1
push 5
lhp 
lhp 
sw 
lhp 
push 1 
add 
shplhp 
sw 
lhp 
push 1 
add 
shp9998
lhp 
sw 
lhp 
lhp 
push 1 
add 
shppush 2
lhp 
lhp 
sw 
lhp 
push 1 
add 
shplhp 
sw 
lhp 
push 1 
add 
shp9998
lhp 
sw 
lhp 
lhp 
push 1 
add 
shppush 3
lhp 
lhp 
sw 
lhp 
push 1 
add 
shplhp 
sw 
lhp 
push 1 
add 
shp9998
lhp 
sw 
lhp 
lhp 
push 1 
add 
shppush 4
lhp 
lhp 
sw 
lhp 
push 1 
add 
shplhp 
sw 
lhp 
push 1 
add 
shp9998
lhp 
sw 
lhp 
lhp 
push 1 
add 
shppush 1
lhp 
lhp 
sw 
lhp 
push 1 
add 
shplhp 
sw 
lhp 
push 1 
add 
shp9998
lhp 
sw 
lhp 
lhp 
push 1 
add 
shppush 2
lhp 
lhp 
sw 
lhp 
push 1 
add 
shplhp 
sw 
lhp 
push 1 
add 
shp9998
lhp 
sw 
lhp 
lhp 
push 1 
add 
shplfp
lfp
push -11
lfp
add
lw
lfp
push -9
add
lw
lfp
push -10
add
lw
js
lfp
push -3
add
lw
lfp
push -4
add
lw
js
halt

function0:
cfp
lra
push 1
lfp
add
lw
push 2
lfp
add
lw
lhp 
lhp 
sw 
lhp 
push 1 
add 
shplhp 
sw 
lhp 
push 1 
add 
shp9998
lhp 
sw 
lhp 
lhp 
push 1 
add 
shpsrv
sra
pop
pop
pop
sfp
lrv
lra
js

function1:
cfp
lra
lfp
 push function0
push 1
lfp
add
lw
push -1
beq label2
push 0
b label3
label2: 
push 1
label3: 
push 1
beq label0
lfp
lfp 
push 1
lfp
add
lw
push 1
lfp
add
lw
lw 
push 0
add 
lw 
js 
print
lfp
lfp 
push 1
lfp
add
lw
push 1
lfp
add
lw
lw 
push 1
add 
lw 
js 
lfp
lw
push -3
add
lw
lfp
lw
push -4
add
lw
js
lfp
push -2
add
lw
lfp
push -3
add
lw
js
b label1
label0: 
push -1
label1: 
srv
pop
pop
sra
pop
pop
sfp
lrv
lra
js

function2:
cfp
lra
push 1
lfp
add
lw
push -1
beq label6
push 0
b label7
label6: 
push 1
label7: 
push 1
beq label4
lfp
push 2
lfp
add
lw
lfp 
push 1
lfp
add
lw
push 1
lfp
add
lw
lw 
push 1
add 
lw 
js 
lfp
lw
push -5
add
lw
lfp
lw
push -6
add
lw
js
lfp 
push 1
lfp
add
lw
push 1
lfp
add
lw
lw 
push 0
add 
lw 
js 
lhp 
lhp 
sw 
lhp 
push 1 
add 
shplhp 
sw 
lhp 
push 1 
add 
shp9998
lhp 
sw 
lhp 
lhp 
push 1 
add 
shpb label5
label4: 
push 2
lfp
add
lw
label5: 
srv
sra
pop
pop
pop
sfp
lrv
lra
js

function3:
cfp
lra
push 3
lfp
lw
add
lw
push 1
beq label8
push 1
lfp
add
lw
push 1
beq label10
push 1
b label11
label10: 
push 0
label11: 
b label9
label8: 
push 1
lfp
add
lw
label9: 
srv
sra
pop
pop
sfp
lrv
lra
js

function4:
cfp
lra
lfp
 push function3
push 1
lfp
add
lw
push -1
beq label14
push 0
b label15
label14: 
push 1
label15: 
push 1
beq label12
lfp
lfp 
push 1
lfp
add
lw
push 1
lfp
add
lw
lw 
push 0
add 
lw 
js 
push 2
lfp
add
lw
bleq label18
push 0
b label19
label18: 
push 1
label19: 
lfp
push -2
add
lw
lfp
push -3
add
lw
js
push 1
beq label16
lfp
push 3
lfp
add
lw
push 2
lfp
add
lw
lfp 
push 1
lfp
add
lw
push 1
lfp
add
lw
lw 
push 1
add 
lw 
js 
lfp
lw
push -7
add
lw
lfp
lw
push -8
add
lw
js
b label17
label16: 
lfp
push 3
lfp
add
lw
push 2
lfp
add
lw
lfp 
push 1
lfp
add
lw
push 1
lfp
add
lw
lw 
push 1
add 
lw 
js 
lfp
lw
push -7
add
lw
lfp
lw
push -8
add
lw
js
lfp 
push 1
lfp
add
lw
push 1
lfp
add
lw
lw 
push 0
add 
lw 
js 
lhp 
lhp 
sw 
lhp 
push 1 
add 
shplhp 
sw 
lhp 
push 1 
add 
shp9998
lhp 
sw 
lhp 
lhp 
push 1 
add 
shplabel17: 
b label13
label12: 
push -1
label13: 
srv
pop
pop
sra
pop
pop
pop
pop
sfp
lrv
lra
js

function5:
cfp
lra
push 1
lfp
add
lw
push -1
beq label22
push 0
b label23
label22: 
push 1
label23: 
push 1
beq label20
lfp 
push 1
lfp
add
lw
push 1
lfp
add
lw
lw 
push 0
add 
lw 
js 
b label21
label20: 
push 0
label21: 
push 1
lfp
add
lw
push -1
beq label26
push 0
b label27
label26: 
push 1
label27: 
push 1
beq label24
lfp
lfp
lfp
push 0
push -2
lfp
add
lw
lfp 
push 1
lfp
add
lw
push 1
lfp
add
lw
lw 
push 1
add 
lw 
js 
lfp
lw
push -7
add
lw
lfp
lw
push -8
add
lw
js
lfp
lw
push -9
add
lw
lfp
lw
push -10
add
lw
js
push -2
lfp
add
lw
lhp 
lhp 
sw 
lhp 
push 1 
add 
shplhp 
sw 
lhp 
push 1 
add 
shp9998
lhp 
sw 
lhp 
lhp 
push 1 
add 
shplfp
lfp
push 1
push -2
lfp
add
lw
lfp 
push 1
lfp
add
lw
push 1
lfp
add
lw
lw 
push 1
add 
lw 
js 
lfp
lw
push -7
add
lw
lfp
lw
push -8
add
lw
js
lfp
lw
push -9
add
lw
lfp
lw
push -10
add
lw
js
lfp
lw
push -5
add
lw
lfp
lw
push -6
add
lw
js
b label25
label24: 
push -1
label25: 
srv
pop
sra
pop
pop
sfp
lrv
lra
js

function6:
cfp
lra
push 1
lfp
add
lw
push 2
lfp
add
lw
lhp 
lhp 
sw 
lhp 
push 1 
add 
shplhp 
sw 
lhp 
push 1 
add 
shp9998
lhp 
sw 
lhp 
lhp 
push 1 
add 
shpsrv
sra
pop
pop
pop
sfp
lrv
lra
js

function7:
cfp
lra
lfp
 push function6
push 1
lfp
add
lw
push -1
beq label30
push 0
b label31
label30: 
push 1
label31: 
push 1
beq label28
lfp
lfp 
push 1
lfp
add
lw
push 1
lfp
add
lw
lw 
push 0
add 
lw 
js 
print
lfp
lfp 
push 1
lfp
add
lw
push 1
lfp
add
lw
lw 
push 1
add 
lw 
js 
lfp
lw
push -3
add
lw
lfp
lw
push -4
add
lw
js
lfp
push -2
add
lw
lfp
push -3
add
lw
js
b label29
label28: 
push -1
label29: 
srv
pop
pop
sra
pop
pop
sfp
lrv
lra
js

function8:
cfp
lra
push 1
lfp
add
lw
push -1
beq label34
push 0
b label35
label34: 
push 1
label35: 
push 1
beq label32
lfp
push 2
lfp
add
lw
lfp 
push 1
lfp
add
lw
push 1
lfp
add
lw
lw 
push 1
add 
lw 
js 
lfp
lw
push -5
add
lw
lfp
lw
push -6
add
lw
js
lfp 
push 1
lfp
add
lw
push 1
lfp
add
lw
lw 
push 0
add 
lw 
js 
lhp 
lhp 
sw 
lhp 
push 1 
add 
shplhp 
sw 
lhp 
push 1 
add 
shp9998
lhp 
sw 
lhp 
lhp 
push 1 
add 
shpb label33
label32: 
push 2
lfp
add
lw
label33: 
srv
sra
pop
pop
pop
sfp
lrv
lra
js

function9:
cfp
lra
push 3
lfp
lw
add
lw
push 1
beq label36
push 1
lfp
add
lw
push 1
beq label38
push 1
b label39
label38: 
push 0
label39: 
b label37
label36: 
push 1
lfp
add
lw
label37: 
srv
sra
pop
pop
sfp
lrv
lra
js

function10:
cfp
lra
lfp
 push function9
push 1
lfp
add
lw
push -1
beq label42
push 0
b label43
label42: 
push 1
label43: 
push 1
beq label40
lfp
lfp 
push 1
lfp
add
lw
push 1
lfp
add
lw
lw 
push 0
add 
lw 
js 
push 2
lfp
add
lw
bleq label46
push 0
b label47
label46: 
push 1
label47: 
lfp
push -2
add
lw
lfp
push -3
add
lw
js
push 1
beq label44
lfp
push 3
lfp
add
lw
push 2
lfp
add
lw
lfp 
push 1
lfp
add
lw
push 1
lfp
add
lw
lw 
push 1
add 
lw 
js 
lfp
lw
push -7
add
lw
lfp
lw
push -8
add
lw
js
b label45
label44: 
lfp
push 3
lfp
add
lw
push 2
lfp
add
lw
lfp 
push 1
lfp
add
lw
push 1
lfp
add
lw
lw 
push 1
add 
lw 
js 
lfp
lw
push -7
add
lw
lfp
lw
push -8
add
lw
js
lfp 
push 1
lfp
add
lw
push 1
lfp
add
lw
lw 
push 0
add 
lw 
js 
lhp 
lhp 
sw 
lhp 
push 1 
add 
shplhp 
sw 
lhp 
push 1 
add 
shp9998
lhp 
sw 
lhp 
lhp 
push 1 
add 
shplabel45: 
b label41
label40: 
push -1
label41: 
srv
pop
pop
sra
pop
pop
pop
pop
sfp
lrv
lra
js

function11:
cfp
lra
push 1
lfp
add
lw
push -1
beq label50
push 0
b label51
label50: 
push 1
label51: 
push 1
beq label48
lfp 
push 1
lfp
add
lw
push 1
lfp
add
lw
lw 
push 0
add 
lw 
js 
b label49
label48: 
push 0
label49: 
push 1
lfp
add
lw
push -1
beq label54
push 0
b label55
label54: 
push 1
label55: 
push 1
beq label52
lfp
lfp
lfp
push 0
push -2
lfp
add
lw
lfp 
push 1
lfp
add
lw
push 1
lfp
add
lw
lw 
push 1
add 
lw 
js 
lfp
lw
push -7
add
lw
lfp
lw
push -8
add
lw
js
lfp
lw
push -9
add
lw
lfp
lw
push -10
add
lw
js
push -2
lfp
add
lw
lhp 
lhp 
sw 
lhp 
push 1 
add 
shplhp 
sw 
lhp 
push 1 
add 
shp9998
lhp 
sw 
lhp 
lhp 
push 1 
add 
shplfp
lfp
push 1
push -2
lfp
add
lw
lfp 
push 1
lfp
add
lw
push 1
lfp
add
lw
lw 
push 1
add 
lw 
js 
lfp
lw
push -7
add
lw
lfp
lw
push -8
add
lw
js
lfp
lw
push -9
add
lw
lfp
lw
push -10
add
lw
js
lfp
lw
push -5
add
lw
lfp
lw
push -6
add
lw
js
b label53
label52: 
push -1
label53: 
srv
pop
sra
pop
pop
sfp
lrv
lra
js
