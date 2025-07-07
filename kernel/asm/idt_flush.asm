global idt_flush

idt_flush:
    mov rax, rdi
    lidt [rax]
    ret