# This is the set of instructions listed in the instruction memory portion of the CMPEN 331 final project.
# With the MARS MIPS simulator, one can step through the individual instructions and see how they function.

main:	
		lui		$at, 0
		ori		$a0, $at, 80
		jal		sum
	
dslot1:
		addi	$a1, $zero, 4
return:
		sw		$v0, 0($a0)
		lw		$t1, 0($a0)
		sub		$t0, $t1, $a0
		addi	$a1, $zero, 3
loop2:
		addi	$a1, $a1, -1
		ori		$t0, $a1, 0xffff	# Immediate value: 65535
		xori	$t0, $t0, 0x5555	# Immediate value: 21845
		addi	$t1, $zero, -1
		andi	$t2, $t1, 0xffff	# Immediate value: 65535
		or		$a2, $t2, $t1
		xor		$t0, $t2, $t1
		and		$a3, $t2, $a2
		beq		$a1, $zero, shift
	
dslot2:
		nop
		j		loop2

dslot3:
		nop
shift:
		addi	$a1, $zero, -1
		sll		$t0, $a1, 15
		sll		$t0, $t0, 16
		sra		$t0, $t0, 16
		srl		$t0, $t0, 15
	
finish:
		j		finish
	
dslot4:
		nop
sum:
		add		$t0, $zero, $zero
loop:
		lw		$t1, 0($a0)
stall:
		add		$t0, $t0, $t1
		addi	$a1, $a1, -1
		bne		$a1, $0, loop
dslot5:
		addi	$a0, $a0, 4
		jr		$ra
	
dslot6:
		sll		$v0, $t0, 0