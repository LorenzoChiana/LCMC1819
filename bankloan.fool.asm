push 0
push 40000
push 50000
lhp 
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
9997
lhp 
sw 
lhp 
lhp 
push 1 
add 
shp 
lhp 
lhp 
sw 
lhp 
push 1 
add 
shp 
9995
lhp 
sw 
lhp 
lhp 
push 1 
add 
shp 
push 5000
push 20000
lhp 
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
9997
lhp 
sw 
lhp 
lhp 
push 1 
add 
shp 
lfp 
push -7
lfp
add
lw
push -6
lfp
add
lw
push -6
lfp
add
lw
lw 
push 1
add 
lw 
js 
push 40000
push 50000
lhp 
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
9997
lhp 
sw 
lhp 
lhp 
push 1 
add 
shp 
lhp 
lhp 
sw 
lhp 
push 1 
add 
shp 
9995
lhp 
sw 
lhp 
lhp 
push 1 
add 
shp 
push 5000
push 20000
lhp 
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
9997
lhp 
sw 
lhp 
lhp 
push 1 
add 
shp 
lfp 
push -7
lfp
add
lw
push -6
lfp
add
lw
push -6
lfp
add
lw
lw 
push 1
add 
lw 
js 
push -8
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
push -8
lfp
add
lw
push -8
lfp
add
lw
lw 
push 0
add 
lw 
js 
b label1
label0: 
push 0
label1: 
print
halt
