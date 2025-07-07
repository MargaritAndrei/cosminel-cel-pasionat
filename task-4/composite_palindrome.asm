section .text
global check_palindrome
global composite_palindrome
extern strlen
extern malloc
extern strcat
extern strcmp
extern free

check_palindrome:
    push ebp
    mov ebp, esp
    push esi
    push edi

    ; *str
    mov esi, [ebp + 8]
    ; len
    mov ecx, [ebp + 12]
    mov edx, ecx
    ; ecx = len/2
    shr ecx, 1
    test ecx, ecx
    jz ok

    ; edi = str + (len-1)
    mov edi, esi
    dec edx
    add edi, edx

parcurgere:
    mov al, [esi]
    cmp al, [edi]
    jne not_ok
    inc esi
    dec edi
    dec ecx
    jnz parcurgere

ok:
    ; return 1
    mov eax, 1
    pop edi
    pop esi
    pop ebp
    ret

not_ok:
    ; return 0
    xor eax, eax
    pop edi
    pop esi
    pop ebp
    ret

; char* subsequence_string(const char * const * const strs, int* indices, int count)
; functie auxiliara care obtine stringul subsirului de siruri concatenat
subsequence_string:
    ; create a new stack frame
    enter 0, 0
    ; aloc memorie pentru variabilele locale
    sub esp, 24
    ; int total_len = 0
    mov dword [ebp - 24], 0
    ; int i = 0
    mov dword [ebp - 20], 0

getstring_length_loop:
    ; Get indices[i]
    ; iau indexul i din ebp - 20
    mov eax, [ebp - 20]
    ; pun in edx indexul i
    lea edx, [eax * 4]
    ; in eax pun vectorul indices
    mov eax, [ebp + 12]
    ; indices[i]
    add eax, edx
    mov eax, [eax]          

    ; strs[indices[i]]
    lea edx, [eax * 4]
    ; strs
    mov eax, [ebp + 8]
    ; strs[indices[i]]
    add eax, edx
    mov eax, [eax]     

    ; strlen(strs[indices[i]])
    push eax
    call strlen
    ; apel de functie strlen
    add esp, 4
    ; apel de functie strlen returneaza lungimea in eax
    ; total_len += strlen result
    add [ebp - 24], eax
    ; i++
    inc dword [ebp - 20] 
    ; pun in eax pe i si verific daca este mai mic decat count
    mov eax, [ebp - 20]
    ; count este lungimea vectorului indices / numarul de stringuri date
    cmp eax, [ebp + 16]
    jl getstring_length_loop

    ; alocam memorie pentru stringul rezultat
    ; malloc(total_len + 1)
    mov eax, [ebp - 24]
    inc eax
    push eax
    call malloc
    ; apel de functie malloc returneaza adresa in eax
    add esp, 4
    ; punem eax-ul rezultat din malloc in result
    mov [ebp - 12], eax

    ; eax = result
    mov eax, [ebp - 12]
    ; punem '\0' la finalul lui result dupa alocarea memoriei
    mov byte [eax], 0

    ; i = 0
    mov dword [ebp - 16], 0

string_concat_loop:
    ; eax = i
    mov eax, [ebp - 16]
    ; edx = i * 4
    lea edx, [eax * 4]
    ; eax = indices
    mov eax, [ebp + 12]
    ; eax = indices[i]
    add eax, edx
    mov eax, [eax]

    ; edx = indices[i] * 4
    lea edx, [eax * 4]
    ; eax = strs
    mov eax, [ebp + 8]
    ; eax = strs[indices[i]]
    add eax, edx
    mov eax, [eax]

    ; strcat(result, strs[indices[i]])
    push eax
    ; parametrul 1 este sirul result
    push dword [ebp - 12]
    call strcat
    ; apel de functie strcat
    add esp, 8

    ; i++
    inc dword [ebp - 16]
    ; verific daca i < count
    ; count este lungimea vectorului indices / numarul de stringuri date
    mov eax, [ebp - 16]
    ; compar cu count
    cmp eax, [ebp + 16]
    jl string_concat_loop

    ; return result
    mov eax, [ebp - 12]
    leave
    ret

composite_palindrome:
    ; create a new stack frame
    enter 0, 0
    ; aloc memorie pentru variabilele locale
    sub esp, 120
    ; char *best_palindrome = NULL
    mov dword [ebp - 104], 0
    ; int best_length = 0
    mov dword [ebp - 100], 0
    ; int mask = 1
    mov dword [ebp - 96], 1

mask_loop:
    ; int count = 0
    mov dword [ebp - 92], 0
    ; int i = 0
    mov dword [ebp - 88], 0

bit_loop:
    ; verific daca bitul i din masca este 1
    ; eax = i
    mov eax, [ebp - 88]
    ; edx = mask       
    mov edx, [ebp - 96]
    mov ecx, eax
    ; shiftez masca la dreapta cu i biti
    shr edx, cl
    ; verific bitul i daca este 1 sau 0
    and edx, 1
    test edx, edx
    je bit_continue

    ; indices[count] = i
    ; eax = count
    mov eax, [ebp - 92]
    ; edx = i
    mov edx, [ebp - 88]
    ; indices[count] = i
    mov [ebp - 72 + eax * 4], edx
    ; count++
    inc dword [ebp - 92]

bit_continue:
    ; i++
    inc dword [ebp - 88]
    ; eax = i
    mov eax, [ebp - 88]
    ; verific daca i < len
    cmp eax, [ebp + 12]
    jl bit_loop

    ; apelez subsequence_string, punand parametrii sai pe stiva
    ; pun count pe stiva
    push dword [ebp - 92]
    ; eax = indices
    lea eax, [ebp - 72]
    push eax
    ; pun strs, stringurile date pe stiva
    push dword [ebp + 8]
    call subsequence_string
    ; apel de functie subsequence_string returneaza stringul concatenat in eax
    add esp, 12
    ; subsequence string returneaza un pointer la stringul dat de masca in eax
    ; char *concatenated = subsequence_string(strs, indices, count)
    mov [ebp - 80], eax

    ; pun pe stiva stringul concatenat
    push dword [ebp - 80]
    call strlen
    ; apel de functie strlen returneaza lungimea in eax
    add esp, 4
    ; int concat_len = strlen(concatenated)
    mov [ebp - 76], eax

    ; verific daca sirul rezultat este palindrom
    ; pun pe stiva concat_len
    push dword [ebp - 76]
    ; pun pe stiva concatenated     
    push dword [ebp - 80]
    call check_palindrome
    ; apel de functie check_palindrome returneaza 1 daca este palindrom, 0 in caz contrar
    add esp, 8
    test eax, eax
    je free_string

    ; int is_better = 0, is_better este 1 daca concatenated este mai lung decat best_palindrome
    mov dword [ebp - 84], 0
check_length:
    ; eax = concat_len
    mov eax, [ebp - 76]
    ; verific daca concat_len > best_length
    cmp eax, [ebp - 100]
    jle check_lexicographic
    ; is_better = 1
    mov dword [ebp - 84], 1
    jmp update_check

check_lexicographic:
    ; verific daca concat_len = best_length
    ; eax = concat_len
    mov eax, [ebp - 76]
    ; Check if same length and lexicographically smaller
    cmp eax, [ebp - 100]
    jne update_check

    ; strcmp(concatenated, best_palindrome), comparare lexicografica
    ; pun pe stiva best_palindrome
    push dword [ebp - 104]
    ; pun pe stiva concatenated
    push dword [ebp - 80]
    call strcmp
    ; apel de functie strcmp
    add esp, 8
    test eax, eax
    jns update_check
    ; is_better = 1
    mov dword [ebp - 84], 1

update_check:
    ; Verific daca is_better este 1, daca este 0 eliberez stringul concatenated
    cmp dword [ebp - 84], 0
    je free_string

    ; eliberez actualul best_palindrome daca este diferit de NULL
    cmp dword [ebp - 104], 0
    je update_best
    ; pun best_palindrome pe stiva
    push dword [ebp - 104]
    call free
    ; apel de functie free
    add esp, 4

update_best:
    ; best_palindrome devine sirul concatenated
    ; eax = concatenated
    mov eax, [ebp - 80]
    ; best_palindrome = concatenated
    mov [ebp - 104], eax
    ; eax = concat_len
    mov eax, [ebp - 76]
    ; best_length = concat_len
    mov [ebp - 100], eax
    jmp mask_continue

free_string:
    ; eliberez stringul concatenated, il pun pe stiva
    push dword [ebp - 80]
    call free
    ; apel de functie free
    add esp, 4

mask_continue:
    ; mask++
    inc dword [ebp - 96]

    ; verific daca masca este mai mica decat 2 ^ len
    ; eax = len
    mov eax, [ebp + 12]
    ; edx = 1
    mov edx, 1
    mov ecx, eax
    ; edx = 2 ^ len
    shl edx, cl
    ; compar masca cu 2 ^ len
    cmp dword [ebp - 96], edx
    jl mask_loop

    ; returnez best_palindrome
    mov eax, [ebp - 104]
    leave
    ret