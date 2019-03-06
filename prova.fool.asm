push 0
push 6
push 2
sub
push function0
lfp
push 0
push -2
lfp
add
lw
lfp
push -3
lfp
add
lw
js
push 1
beq label2
push 0
b label3
label2: 
push 1
label3: 
print
halt

function0:
cfp
lra
push 2
lfp
add
lw
push -2
lfp
add
lw
push 1
beq label0
push 1
b label1
label0: 
push 0
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
