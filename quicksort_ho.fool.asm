push 0
lhp
push method0
lhp
sw
lhp
push 1 
add
shp
push method1
lhp
sw
lhp
push 1 
add
shp
lfp
push function1
lfp
push function2
lfp
push function3
lfp
push function6
lfp
push function7
lfp
push function8
push -1
lhp
sw
lhp
push 1 
add
shp
push 5
lhp
sw
lhp
push 1 
add
shp
push 9998
lw
lhp
sw
lhp 
lhp
push 1 
add
shp
lhp
sw
lhp
push 1 
add
shp
push 2
lhp
sw
lhp
push 1 
add
shp
push 9998
lw
lhp
sw
lhp 
lhp
push 1 
add
shp
lhp
sw
lhp
push 1 
add
shp
push 3
lhp
sw
lhp
push 1 
add
shp
push 9998
lw
lhp
sw
lhp 
lhp
push 1 
add
shp
lhp
sw
lhp
push 1 
add
shp
push 4
lhp
sw
lhp
push 1 
add
shp
push 9998
lw
lhp
sw
lhp 
lhp
push 1 
add
shp
lhp
sw
lhp
push 1 
add
shp
push 1
lhp
sw
lhp
push 1 
add
shp
push 9998
lw
lhp
sw
lhp 
lhp
push 1 
add
shp
lhp
sw
lhp
push 1 
add
shp
push 2
lhp
sw
lhp
push 1 
add
shp
push 9998
lw
lhp
sw
lhp 
lhp
push 1 
add
shp
lfp
lfp
push -13
lfp
add
lw
push -14
lfp
add
lw
push -15
lfp
add
lw
push -9
lfp
add
lw 
push -10
lfp
add
lw
js
push -3
lfp
add
lw 
push -4
lfp
add
lw
js
halt


method0:
cfp
lra
push -1
lfp
lw
add
lw
srv
sra
pop
sfp
lrv
lra
js

method1:
cfp
lra
push -2
lfp
lw
add
lw
srv
sra
pop
sfp
lrv
lra
js

function0:
cfp
lra
push 1
lfp
add
lw
lhp
sw
lhp
push 1 
add
shp
push 2
lfp
add
lw
lhp
sw
lhp
push 1 
add
shp
push 9998
lw
lhp
sw
lhp 
lhp
push 1 
add
shp
srv
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
push -3
lfp
lw
add
lw 
push -4
lfp
lw
add
lw
js
push -2
lfp
add
lw 
push -3
lfp
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
push -5
lfp
lw
add
lw 
push -6
lfp
lw
add
lw
js
lhp
sw
lhp
push 1 
add
shp
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
sw
lhp
push 1 
add
shp
push 9998
lw
lhp
sw
lhp 
lhp
push 1 
add
shp
b label5
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
push 1
lfp
add
lw
push -1
beq label10
push 0
b label11
label10: 
push 1
label11: 
push 1
beq label8
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
push 1
lfp
add
lw
js
push 1
beq label12
lfp
push 2
lfp
add
lw
push 1
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
push -7
lfp
lw
add
lw 
push -8
lfp
lw
add
lw
js
b label13
label12: 
lfp
push 2
lfp
add
lw
push 1
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
push -7
lfp
lw
add
lw 
push -8
lfp
lw
add
lw
js
lhp
sw
lhp
push 1 
add
shp
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
sw
lhp
push 1 
add
shp
push 9998
lw
lhp
sw
lhp 
lhp
push 1 
add
shp
label13: 
b label9
label8: 
push -1
label9: 
srv
sra
pop
pop
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
push -2
lfp
lw
add
lw
push 1
lfp
add
lw
push 2
lfp
lw
add
lw 
push 1
lfp
lw
add
lw
js
srv
sra
pop
pop
sfp
lrv
lra
js

function5:
cfp
lra
lfp
push -2
lfp
lw
add
lw
push 1
lfp
add
lw
push 2
lfp
lw
add
lw 
push 1
lfp
lw
add
lw
js
push 1
beq label18
push 1
b label19
label18: 
push 0
label19: 
srv
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
push -1
beq label16
push 0
b label17
label16: 
push 1
label17: 
push 1
beq label14
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
b label15
label14: 
push 0
label15: 
lfp
push function4
lfp
push function5
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
lfp
push 2
lfp
add
lw
push 1
lfp
add
lw
lfp
push -5
lfp
add
lw
push -6
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
push -7
lfp
lw
add
lw 
push -8
lfp
lw
add
lw
js
push -9
lfp
lw
add
lw 
push -10
lfp
lw
add
lw
js
lhp
sw
lhp
push 1 
add
shp
push -2
lfp
add
lw
lhp
sw
lhp
push 1 
add
shp
push 9998
lw
lhp
sw
lhp 
lhp
push 1 
add
shp
lfp
push 2
lfp
add
lw
push 1
lfp
add
lw
lfp
push -3
lfp
add
lw
push -4
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
push -7
lfp
lw
add
lw 
push -8
lfp
lw
add
lw
js
push -9
lfp
lw
add
lw 
push -10
lfp
lw
add
lw
js
push -5
lfp
lw
add
lw 
push -6
lfp
lw
add
lw
js
b label21
label20: 
push -1
label21: 
srv
pop
pop
pop
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

function7:
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
bleq label24
push 0
b label25
label24: 
push 1
label25: 
srv
sra
pop
pop
pop
sfp
lrv
lra
js

function8:
cfp
lra
push 2
lfp
add
lw
push 1
lfp
add
lw
bleq label26
push 0
b label27
label26: 
push 1
label27: 
srv
sra
pop
pop
pop
sfp
lrv
lra
js
