;;=============================================================
;; CS 2110 - Fall 2021
;; Homework 6 - Factorial
;;=============================================================
;; Name: Donaven Lobo
;;============================================================

;; In this file, you must implement the 'factorial' and "mult" subroutines.

;; Little reminder from your friendly neighborhood 2110 TA staff: don't run
;; this directly by pressing 'RUN' in complx, since there is nothing put at
;; address x3000. Instead, load it and use 'Debug' -> 'Simulate
;; Subroutine Call' and choose the 'factorial' or 'mult' label.

;; Pseudocode

;; Factorial

;;    factorial(int n) {
;;        int ret = 1;
;;        for (int x = 2; x < n+1; x++) {
;;            ret = mult(ret, x);
;;        }
;;        return ret;
;;    }

;; Multiply

;;    mult(int a, int b) {
;;        int ret = 0;
;;        int copyB = b;
;;        while (copyB > 0):
;;            ret += a;
;;            copyB--;
;;        return ret;
;;    }


.orig x3000
    ;; you do not need to write anything here
HALT

factorial
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

    AND R0,R0,0
    ADD R0,R0,1 ;; Set R0 (answer) = 1
    STR R0,R5,0 ;; Store current answer in Stack Frame
    AND R0,R0,0
    ADD R0,R0,2 ;; R0 = x = 2
    LDR R1,R5,4 ;; R1 = n
    ADD R1,R1,1 ;; R1 = n+1
    NOT R1,R1 ;; R1 = ~R1
    ADD R1,R1,1 ;; R1 = -(n+1)
    ADD R2,R0,R1 ;; R2 = x - (n+1)
FOR1 ADD R2,R2,0 ;; Set CC
    BRzp ENDF1
    ;; Push Arguments for mult in reverse order
    ADD R6,R6,-1
    STR R0,R6,0 ;; push(x)
    LDR R2,R5,0 ;; R0 = R5 = ret
    ADD R6,R6,-1
    STR R2,R6,0 ;; push(ret)
    JSR mult ;; mult(ret,x)
    LDR R2,R6,0 ;; R2 = Return value
    ADD R6,R6,3 ;; pop remainder of stack
    STR R2,R5,0 ;; R5 = ret
    ADD R0,R0,1 ;; Increment x
    ADD R2,R0,R1 ;; R2 = x - (n+1)
    BR FOR1
ENDF1 NOP
    LDR R0,R5,0 ;; Load ret into R0
    STR R0,R5,3 ;; Fill the RV in the Stack frame
    ;; Tear down the stack frame
    LDR R4,R5,-5 ;; Restore R4
    LDR R3,R5,-4 ;; Restore R3
    LDR R2,R5,-3 ;; Restore R2
    LDR R1,R5,-2 ;; Restore R1
    LDR R0,R5,-1 ;; Restore R0
    ADD R6,R5,0 ;; pop all saved registers and local variables
    LDR R7,R5,2 ;; R7 = OLD return address
    LDR R5,R5,1 ;; FP = OLD FP
    ADD R6,R6,3 ;; Pop last 3 words (ret val, arg1, arg2)
    ;; STACK Tear down complete
    RET

mult
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

    AND R0,R0,0
    STR R0,R5,0 ;; R5 = ret
    LDR R0,R5,5 ;; R0 = CopyB
WHILE1 ADD R0,R0,0 ;; set CC
    BRnz ENDW1
    LDR R1,R5,0 ;; R1 = ret
    LDR R2,R5,4 ;; R2 = a
    ADD R1,R1,R2; R1 = ret + a = ret
    STR R1,R5,0 ;; Store ret
    ADD R0,R0,-1 ; copyB--
    BR WHILE1
ENDW1 NOP
    LDR R0,R5,0 ;; Load ret into R0
    STR R0,R5,3 ;; Fill the RV in the Stack frame

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
.end
