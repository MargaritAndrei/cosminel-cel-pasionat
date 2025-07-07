global sort
global get_words

extern qsort
extern strlen
extern strcmp
extern strtok

section .data

; delimitatori
delims db ' ', ',', '.', 10, 0

section .text

;; int compare(const void *p1, const void *p2)
compar:
    ; create a new stack frame
    enter 0, 0
    push ebx
    push esi
    push edi

    ; char *a, char *b
    ; &element1
    mov eax, [ebp + 8]    
    mov esi, [eax]

    ; &element2
    mov eax, [ebp + 12]   
    mov edi, [eax]

    push esi
    call strlen
    ; apel de strlen
    add esp, 4
    mov ebx, eax

    push edi
    call strlen
    ; apel de strlen
    add esp, 4
    mov ecx, eax
    cmp ebx, ecx
    jl len_less
    jg len_greater

    ; strcmp pentru siruri de lungime egala
    push edi
    push esi
    call strcmp
    ; apel de strcmp
    add esp, 8
    jmp done
len_less:
    ; lungimea lui a < lungimea lui b
    mov eax, -1
    jmp done
len_greater:
    ; lungimea lui a > lungimea lui b
    mov eax, 1

done:
    pop edi
    pop esi
    pop ebx
    leave
    ret

;; sort(char **words, int number_of_words, int size)
sort:
    ; create a new stack frame
    enter 0, 0
    xor eax, eax
    push dword compar
    ; size
    push dword[ebp + 16]
    ; number_of_words
    push dword[ebp + 12]
    ; words
    push dword[ebp + 8]
    call qsort
    ; apel de functie
    add esp, 16
    xor eax, eax
    leave
    ret

;; get_words(char *s, char **words, int number_of_words)
get_words:
    ; create a new stack frame
    enter 0, 0
    xor eax, eax
    ; eax = strtok(s, delims)
    mov eax, [ebp + 8]
    push dword delims
    push eax
    call strtok
    ; apel de strtok
    add esp, 8
    ; esi = words[0]
    mov esi, [ebp + 12]
    ; index = 0
    mov ebx, 0
    ; verific daca strtok a returnat 0
    cmp eax, 0
    je final
    ; salvam primul cuvant
    mov [esi + ebx * 4], eax
    inc ebx

cauta_cuvinte:
    mov eax, ebx
    ; index < number_of_words
    cmp eax, [ebp + 16]
    jge final
    push dword delims
    ; adaug null pentru strtok
    push dword 0
    call strtok
    ; apel de strtok
    add esp, 8
    ; verific daca strtok a returnat 0
    cmp eax, 0
    je final
    ; salvam cuvantul
    mov [esi + ebx * 4], eax
    inc ebx
    jmp cauta_cuvinte

final:
    leave
    ret
