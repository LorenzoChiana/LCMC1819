push 0
push function0
push function1
lfp
push 3
push 2
push -2
lfp
add
lw
push -3
lfp
add
lw
js
push -1
lfp
add
lw
push -2
lfp
add
lw
halt

function0:
cfp
lra
push 1
lfp
add
lw
push -2
lfp
add
lw
push 1
lfp
add
lw
beq label0
push 0
b label1
label0: 
push 1
label1: 
srv
pop
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
push 1
push -2
lfp
add
lw
srv
pop
sra
pop
pop
pop
sfp
lrv
lra
js
