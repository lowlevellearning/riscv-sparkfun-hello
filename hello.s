.align 2
.equ UART_REG_TXFIFO, 0
.equ UART_BASE, 0x10013000

.section .text
.globl _start

_start:
    csrr  t0, mhartid
    bnez  t0, halt

    la    sp, stack_top
    la    a0, msg
    jal   puts


puts:
    li  t0, UART_BASE

.puts_loop: lbu t1, (a0)
    beqz t1, .puts_leave


.puts_waits: lw t2, UART_REG_TXFIFO(t0)
    bltz t2, .puts_waits

    sw  t1, UART_REG_TXFIFO(t0)

    add a0, a0, 1
    j .puts_loop


.puts_leave:
    ret



halt: j halt



.section .rodata
msg:
  .string "LowLevelGang.\n"
  