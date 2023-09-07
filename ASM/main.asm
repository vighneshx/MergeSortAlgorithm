; author: Vighnesh
; date: [8-09-2023]
; role: AI Engineering Script 

________________________________________________________________

section .data
    array db 9, 7, 5, 11, 12, 2, 14, 3, 10, 6, 1, 8, 4, 13   ; Sample array to be sorted
    array_len equ $ - array

section .bss
    temp_array resb 14    ; Temporary array for merging

section .text
    global _start

_start:
    ; Initialize parameters
    lea esi, [array]        ; Load the address of the input array
    mov edi, 0              ; Initialize the index for the temporary array
    mov edx, array_len      ; Load the length of the array

    ; Call the Merge Sort algorithm
    call MergeSort

    ; Exit the program
    mov eax, 1              ; Exit syscall number
    xor ebx, ebx            ; Exit status (0)
    int 80h                 ; Invoke syscall

MergeSort:
    ; Merge Sort algorithm implementation
    ; Input: ESI (address of the input array), EDI (index for temporary array), EDX (length)
    ; Output: The sorted array

    ; Base case: if the array has 1 or 0 elements, it's already sorted
    cmp edx, 1
    jbe .done

    ; Divide the array into two halves
    shr edx, 1              ; Divide the length by 2
    push edx                ; Save the length of the first half
    lea edx, [edx + 1]      ; Load the length of the second half

    ; Recursively sort the first half
    call MergeSort

    ; Restore the length of the first half
    pop edx

    ; Calculate the start address of the second half
    lea esi, [esi + edx]

    ; Merge the two sorted halves into the temporary array
    lea edi, [temp_array]
    mov ecx, array_len
    call Merge

    ; Copy the sorted temporary array back to the original array
    mov esi, temp_array
    mov edi, array
    rep movsb

.done:
    ret

Merge:
    ; Merge two sorted arrays
    ; Input: ESI (address of the first array), EDI (address of the second array), ECX (total length)
    ; Output: The merged array in the temporary array

    xor eax, eax            ; Clear the counter
    xor ebx, ebx            ; Clear the counter
    xor edx, edx            ; Clear the counter

.merge_loop:
    cmp eax, ecx            ; Check if we've reached the end of the first array
    jz .copy_second_array   ; If yes, copy the remaining elements from the second array

    cmp ebx, ecx            ; Check if we've reached the end of the second array
    jz .copy_first_array    ; If yes, copy the remaining elements from the first array

    ; Compare the elements in both arrays
    mov al, [esi + eax]
    mov bl, [edi + ebx]
    cmp al, bl

    ; Copy the smaller element to the temporary array
    jl .copy_first_element
    .copy_second_element:
        mov [temp_array + edx], bl
        inc ebx
        jmp .increment_counters

    .copy_first_element:
        mov [temp_array + edx], al
        inc eax

    .increment_counters:
        inc edx
        jmp .merge_loop

.copy_second_array:
    ; Copy the remaining elements from the second array
    mov ecx, [temp_array + edx]  ; Get the current length of the temporary array
    rep movsb
    ret

.copy_first_array:
    ; Copy the remaining elements from the first array
    mov ecx, [temp_array + edx]  ; Get the current length of the temporary array
    rep movsb
    ret
