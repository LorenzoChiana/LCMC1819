push 0
lhp 
push function0
lhp 
sw 
lhp 
push 1 
add 
shp 
push function1
lhp 
sw 
lhp 
push 1 
add 
shp 
lfp
 push function3
lfp
 push function4
lfp
 push function6
lfp
 push function7
push 2
push 1
push 4
push 3
push 2
push 5
push -1
lhp 
sw 
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

function1:
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

function2:
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
lhp 
sw 
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

function3:
cfp
lra
lfp
 push function2
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

function4:
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
lhp 
sw 
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

function5:
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

function6:
cfp
lra
lfp
 push function5
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
lhp 
sw 
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
push 9998
lw 
lhp 
sw 
lhp 
lhp 
push 1 
add 
shp 
label17: 
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

function7:
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
push -2
lfp
add
lw
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
lhp 
sw 
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
