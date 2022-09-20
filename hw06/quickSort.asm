;;=============================================================
;; CS 2110 - Fall 2021
;; Homework 6 - Quick Sort
;;=============================================================
;; Name: Donaven Lobo
;;============================================================

;; In this file, you must implement the 'quicksort' and 'partition' subroutines.

;; Little reminder from your friendly neighborhood 2110 TA staff: don't run
;; this directly by pressing 'RUN' in complx, since there is nothing put at
;; address x3000. Instead, load it and use 'Debug' -> 'Simulate
;; Subroutine Call' and choose the 'quicksort' or 'partition' label.


;; Pseudocode:



;; Partition

;;    partition(int[] arr, int low, int high) {
;;        int pivot = arr[high];
;;        int i = low - 1;
;;        for (j = low; j < high; j++) {
;;            if (arr[j] < pivot) {
;;                i++;
;;                int temp = arr[j];
;;                arr[j] = arr[i];
;;                arr[i] = temp;
;;            }
;;        }
;;        int temp = arr[high];
;;        arr[high] = arr[i + 1];
;;        arr[i + 1] = temp;
;;        return i + 1;
;;    }

;; Quicksort

;;    quicksort(int[] arr, int left, int right) {
;;        if (left < right) {
;;            int pi = partition(arr, left, right);
;;            quicksort(arr, left, pi - 1);
;;            quicksort(arr, pi + 1, right);
;;        }
;;    }


.orig x3000
    ;; you do not need to write anything here
HALT

partition
    ;; Stack Build up
    ADD R6,R6,-4 ; push 4 words for ret value, old ret add, old frame ptr, local variable (answer)
    STR R7,R6,2 ; Save old RA
    STR R5,R6,1 ; Save old FP
    ADD R5,R6,0 ; Set FP = SP
    ADD R6,R6,-5 ; Push 5 words onto stack
    STR R0,R5,-1 ; Save old R0
    STR R1,R5,-2 ; Save old R1
    STR R2,R5,-3 ; Save old R2
    STR R3,R5,-4 ; Save old R3
    STR R4,R5,-5 ; Save old R4
    ;; End of Stack build up
    LDR R0,R5,5 ;; Load R0 = low = j
    ADD R1,R0,-1 ;; R1 = i = low -1
    STR R1,R5,0 ;; Store i as local variable
    LDR R1,R5,6 ;; Load R1 = high
    NOT R1,R1
    ADD R1,R1,1 ;; R1 = -high
    ADD R1,R0,R1 ;; R1 = low - high
FOR1 ADD R1,R1,0 ;; Set CC
    BRzp ENDF1 ;; Branch if >=0
    LDR R1,R5,4 ;; LD Array address into R1
    LDR R2,R5,6 ;; Load R2 = high
    ADD R2,R1,R2 ;; R2 = address of arr[high] = pivot
    LDR R2,R2,0 ;; R2 = arr[high] = pivot
    ADD R1,R1,R0 ;; R1 = address of arr[j]
    LDR R1,R1,0 ;; R1 = arr[j]
    NOT R2,R2
    ADD R2,R2,1 ;; R2 = -pivot
    ADD R1,R1,R2 ;; R1 = arr[j] - pivot
    BRzp ENDIF1 ;; Branch if >=0
    LDR R1,R5,0 ;; get i into R1
    ADD R1,R1,1 ;; i++
    STR R1,R5,0 ;; Store incremented i value
    LDR R1,R5,4 ;; Load array address into R1
    ADD R1,R1,R0 ; R1 = temp add = address of arr[j]
    LDR R4,R1,0 ;; Get temp value = arr[j] (store in R4)
    LDR R2,R5,0 ;; get i into R2
    LDR R3,R5,4 ;; get address of array into R3
    ADD R2,R2,R3 ;; R2 = address of arr[i]
    LDR R3,R2,0 ;; R3 = arr[i]
    STR R3,R1,0 ;; arr[j] = arr[i]
    STR R4,R2,0 ;; arr[i] = temp = arr[j]
ENDIF1 NOP
    ;; Increment for loop
    ADD R0,R0,1 ;; j++
    LDR R1,R5,6 ;; Load R1 = high
    NOT R1,R1
    ADD R1,R1,1 ;; R1 = -high
    ADD R1,R0,R1 ;; R1 = j - high
    BR FOR1
ENDF1 NOP
    LDR R0,R5,4 ;; load array address into R0
    LDR R1,R5,6 ;; Load R1 = high
    ADD R0,R0,R1 ;; R0 = temp add = address of arr[high]
    LDR R4,R0,0 ;; R4 = temp value
    LDR R1,R5,0 ;; R1 = i
    ADD R1,R1,1 ;; R1 = i+1
    LDR R2,R5,4 ;; load array address into R0
    ADD R1,R1,R2 ;; R1 = address of arr[i+1]
    LDR R2,R1,0 ;; R2 = arr[i+1]
    STR R2,R0,0 ;; arr[high] = arr[i + 1]
    STR R4,R1,0 ;; arr[i + 1] = temp
    LDR R0,R5,0 ;; R0 = i
    ADD R0,R0,1 ;; R0 = i + 1
    STR R0,R5,3 ;; Store return value in the stack Frame
    ;; Tear down the stack frame
    LDR R4,R5,-5 ;; Restore R4
    LDR R3,R5,-4 ;; Restore R3
    LDR R2,R5,-3 ;; Restore R2
    LDR R1,R5,-2 ;; Restore R1
    LDR R0,R5,-1 ;; Restore R0
    ADD R6,R5,0 ;; pop all saved registers and local variables
    LDR R7,R5,2 ;; R7 = OLD return address
    LDR R5,R5,1 ;; FP = OLD FP
    ADD R6,R6,3 ;; Pop last 4 words
    ;; STACK Tear down complete

    RET

quicksort   ;; please do not change the name of your subroutine
;;    quicksort(int[] arr, int left, int right) {
;;        if (left < right) {
;;            int pi = partition(arr, left, right);
;;            quicksort(arr, left, pi - 1);
;;            quicksort(arr, pi + 1, right);
;;        }
;;    }
    ;; Stack Build up
    ADD R6,R6,-4 ; push 4 words for ret value, old ret add, old frame ptr, local variable (answer)
    STR R7,R6,2 ; Save old RA
    STR R5,R6,1 ; Save old FP
    ADD R5,R6,0 ; Set FP = SP
    ADD R6,R6,-5 ; Push 5 words onto stack
    STR R0,R5,-1 ; Save old R0
    STR R1,R5,-2 ; Save old R1
    STR R2,R5,-3 ; Save old R2
    STR R3,R5,-4 ; Save old R3
    STR R4,R5,-5 ; Save old R4
    ;; End of Stack build up
    LDR R0,R5,5 ;; R0 = left
    LDR R1,R5,6 ;; R1 = right
    NOT R1,R1
    ADD R1,R1,1 ;; R1 = -right
    ADD R0,R0,R1 ;; R0 = left - right
    BRzp ENDIF2 ;; Branch if >= 0
    ;; Push arguments for Partition in reverse order
    LDR R0,R5,6 ;; R0 = right
    ADD R6,R6,-1
    STR R0,R6,0 ;; push(right)
    LDR R0,R5,5 ;; R0 = left
    ADD R6,R6,-1
    STR R0,R6,0 ;; push(left)
    LDR R0,R5,4 ;; R0 = arr
    ADD R6,R6,-1
    STR R0,R6,0 ;; push(arr)
    JSR partition
    LDR R1,R6,0 ;; Store return value in R1 = pi
    ADD R6,R6,4 ;; pop remainder of stack
    STR R1,R5,0 ;; Store pi in local variable
    ;; Push arguments for first recursive quicksort call
    LDR R0,R5,0 ;; R0 = pi
    ADD R0,R0,-1 ;; R0 = pi - 1
    ADD R6,R6,-1
    STR R0,R6,0 ;; push(pi - 1)
    LDR R0,R5,5 ;; R0 = left
    ADD R6,R6,-1
    STR R0,R6,0 ;; push(left)
    LDR R0,R5,4 ;; R0 = arr
    ADD R6,R6,-1
    STR R0,R6,0 ;; push(arr)
    JSR quicksort
    ADD R6,R6,4 ;; pop remainder of stack
    ;; Push arguments for second recursive quicksort call
    LDR R0,R5,6 ;; R0 = right
    ADD R6,R6,-1
    STR R0,R6,0 ;; push(right)
    LDR R0,R5,0 ;; R0 = pi
    ADD R0,R0,1 ;; R0 = pi + 1
    ADD R6,R6,-1
    STR R0,R6,0 ;; push(pi + 1)
    LDR R0,R5,4 ;; R0 = arr
    ADD R6,R6,-1
    STR R0,R6,0 ;; push(arr)
    JSR quicksort
    ADD R6,R6,4 ;; pop remainder of stack
ENDIF2 NOP
    ;LDR R0,R5,0
    ;STR R0,R5,3
    ;; Tear down the stack frame
    LDR R4,R5,-5 ;; Restore R4
    LDR R3,R5,-4 ;; Restore R3
    LDR R2,R5,-3 ;; Restore R2
    LDR R1,R5,-2 ;; Restore R1
    LDR R0,R5,-1 ;; Restore R0
    ADD R6,R5,0 ;; pop all saved registers and local variables
    LDR R7,R5,2 ;; R7 = OLD return address
    LDR R5,R5,1 ;; FP = OLD FP
    ADD R6,R6,3 ;; Pop last 3 words
    ;; STACK Tear down complete

    RET

STACK .fill xF000
;ARRAY .fill x4000
.end

;; USE FOR DEBUGGING IN COMPLEX
;; load array at x4000 and put the length as 7

;; ARRAY
;.orig x4000
;    .fill 3
;    .fill 2
;    .fill 4
;    .fill 9
;    .fill 3
;    .fill -6
;.end



;; Assuming the array starts at address x4000, here's how the array [1,3,2,5] represents in memory
;; Memory address           Data
;; x4000                    1
;; x4001                    3
;; x4002                    2
;; x4003                    5
