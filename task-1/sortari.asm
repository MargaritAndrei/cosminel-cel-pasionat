section .text
global sort

sort:
    ; n = numarul de noduri
    mov eax, [esp + 4]    
    ; node (pointer la vectorul de noduri)
    mov ebx, [esp + 8]    
    ; valoarea pe care o cautam
    mov ecx, 1            

iterare:
    ; indexul cautarii
    mov edx, 0

cautare_min_curent:
    mov esi, edx
    ; dimensiunea structurii node
    imul esi, 8
    ; node[i]->val
    add esi, ebx
    cmp [esi], ecx
    je gasit
    ; incrementam indexul
    add edx, 1
    jmp cautare_min_curent

gasit:
    ; am gasit nodul si l am salvat in esi
    ; cautam urmatorul nod
    mov edx, 0
    ; incrementam valoarea cautata
    add ecx, 1

cautare_min_urmator:
    ; node[i]
    mov edi, edx 
    ; dimensiunea structurii node
    imul edi, 8
    add edi, ebx
    cmp [edi], ecx
    je gasit_urmator
    ; incrementare index
    add edx, 1
    jmp cautare_min_urmator

gasit_urmator:
    ; node[j]->next
    add esi, 4             
    ; node[j]->next = node[i]
    mov [esi], edi
    ; verificam daca am ajuns la ultimul nod ce trebuie prelucrat
    cmp ecx, eax - 1 
    jne iterare
done:
    ; i = 1
    mov ecx, 1

cautare_nod_start:
    mov edx, [ebx]
    ; daca este primul element din lista
    cmp edx, 1 
    je gata
    ; dimensiunea structurii node
    add ebx, 8
    jmp cautare_nod_start
gata:
    ; adresa primului nod
    mov eax, ebx
    ret