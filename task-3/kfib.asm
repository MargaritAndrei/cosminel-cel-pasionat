section .text
global kfib
kfib:
    ; create a new stack frame
    enter 0, 0
    push edi
    push esi
    push ebx
    push ecx

    ; n
    mov edi, [ebp + 8]
    ; k
    mov esi, [ebp + 12]

    cmp edi, esi
    jl zero_case
    je one_case

    xor ebx, ebx
    ; counter
    mov ecx, 1

loop_start:
    mov eax, edi
    sub eax, ecx
    ; verificam daca n - k <= 0
    cmp eax, 0
    jle loop_end

    push esi
    push eax
    call kfib
    ; apel recursiv de kfib
    add esp, 8

    add ebx, eax
    inc ecx
    cmp ecx, esi
    jle loop_start

loop_end:
    mov eax, ebx
    jmp finish

zero_case:
    ; returnam 0
    mov eax, 0
    jmp finish

one_case:
    ; returnam 1
    mov eax, 1

finish:
    pop ecx
    pop ebx
    pop esi
    pop edi
    leave
    ret