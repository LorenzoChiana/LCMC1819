push 0
lfp
 push function0
push -2
lfp
add
lw
push -3
lfp
add
lw
lfp
push 2
push 1
push -4
lfp
add
lw
push -5
lfp
add
lw
js
print
halt

function0:
cfp
lra
push 2
lfp
add
lw
push 2
lfp
add
lw
push 1
lfp
add
lw
bleq label0
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
