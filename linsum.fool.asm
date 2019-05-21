push 0
lfp
 push function0
lfp
 push function2
lfp
push 2
lfp
push -4
add
lw
lfp
push -5
add
lw
js
print
halt

function0:
cfp
lra
lfp
push 7
push 5
lfp
push 2
add
lw
lfp
push 1
add
lw
js
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
push 1
add
lw
lfp
push 2
add
lw
add
lfp
lw
push 1
add
lw
mult
srv
sra
pop
pop
pop
sfp
lrv
lra
js

function2:
cfp
lra
lfp
 push function1
lfp
lfp
push -2
add
lw
lfp
push -3
add
lw
lfp
lw
push -2
add
lw
lfp
lw
push -3
add
lw
js
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
