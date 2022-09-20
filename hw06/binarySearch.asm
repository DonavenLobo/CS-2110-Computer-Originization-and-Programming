;;=============================================================
;; CS 2110 - Fall 2021
;; Homework 6 - Binary Search
;;=============================================================
;; Name: Donaven Lobo
;;============================================================

;; In this file, you must implement the 'binarySearch' subroutine.

;; Little reminder from your friendly neighborhood 2110 TA staff: don't run
;; this directly by pressing 'RUN' in complx, since there is nothing put at
;; address x3000. Instead, load it and use 'Debug' -> 'Simulate
;; Subroutine Call' and choose the 'binarySearch' label.


;; Pseudocode:

;; Nodes are blocks of size 3 in memory:

;; The data is located in the 1st memory location
;; The node's left child address is located in the 2nd memory location
;; The node's right child address is located in the 3rd memory location

;; Binary Search

;;    binarySearch(Node root (addr), int data) {
;;        if (root == 0) {
;;            return 0;
;;        }
;;        if (data == root.data) {
;;            return root;
;;        }
;;        if (data < root.data) {
;;            return binarySearch(root.left, data);
;;        }
;;        return binarySearch(root.right, data);
;;    }

.orig x3000
    ;; you do not need to write anything here
HALT

binary_search   ;; please do not change the name of your subroutine
    ;; insert your implementation for binarySearch subroutine

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

    ;; First if Statement
    LDR R0,R5,4 ;; R0 = root address
    BRnp ENDIF1 ;; Branch if R0 != 0
    STR R0,R5,3 ;; Store R0 = 0 in RV
    BR TEARDOWN
ENDIF1 NOP

    ;; Second if Statement
    LDR R0,R0,0 ;; R0 = root data
    LDR R1,R5,5 ;; R1 = data
    NOT R1,R1 ;; R1 = ~R1
    ADD R1,R1,1 ;; R1 = -data
    ADD R0,R0,R1 ;; R0 = root data - data
    BRnp ENDIF2
    LDR R0,R5,4 ;; R0 = root address
    STR R0,R5,3 ;; Store root address as RV
    BR TEARDOWN
ENDIF2 NOP

    ;; Third if Statement
    LDR R0,R5,4 ;; R0 = root address
    LDR R0,R0,0 ;; R0 = root data
    NOT R0,R0 ;; R0 = ~R0
    ADD R0,R0,1 ;; R0 = - (root data)
    LDR R1,R5,5 ;; R1 = data
    ADD R0,R0,R1 ;; data - root data
    BRzp ENDIF3
    LDR R0,R5,4 ;; R0 = root address
    ADD R0,R0,1 ;; R0 = root.left address
    LDR R0,R0,0 ;; R0 = root.left
    ;; push arguments on in reverse order for recursive call
    ADD R6,R6,-1
    STR R1,R6,0 ;; push(data)
    ADD R6,R6,-1
    STR R0,R6,0 ;; push(root.left)
    JSR binary_search
    LDR R0,R6,0 ;; R0 = RV
    STR R0,R5,3 ;; Store RV
    ADD R6,R6,3 ;; pop off the remainde of the stack
    BR TEARDOWN
ENDIF3 NOP

    ;; Default case
    LDR R0,R5,4 ;; R0 = root address
    ADD R0,R0,2 ;; R0 = root.right address
    LDR R0,R0,0 ;; R0 = root.right
    ;; push arguments on in reverse order for recursive call
    ADD R6,R6,-1
    STR R1,R6,0 ;; push(data)
    ADD R6,R6,-1
    STR R0,R6,0 ;; push(root.right)

    JSR binary_search
    LDR R0,R6,0 ;; R0 = RV
    STR R0,R5,3 ;; Store RV
    ADD R6,R6,3 ;; pop off the remainde of the stack
    BR TEARDOWN

TEARDOWN NOP
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

;; Assuming the tree starts at address x4000, here's how the tree (see below and in the pdf) represents in memory
;;
;;              4
;;            /   \
;;           2     8
;;         /   \
;;        1     3
;;
;; Memory address           Data
;; x4000                    4
;; x4001                    x4004
;; x4002                    x4008
;; x4003                    Don't Know
;; x4004                    2
;; x4005                    x400C
;; x4006                    x4010
;; x4007                    Don't Know
;; x4008                    8
;; x4009                    0(NULL)
;; x400A                    0(NULL)
;; x400B                    Don't Know
;; x400C                    1
;; x400D                    0(NULL)
;; x400E                    0(NULL)
;; x400F                    Dont't Know
;; x4010                    3
;; x4011                    0(NULL)
;; x4012                    0(NULL)
;; x4013                    Dont't Know
;;
;; *note: 0 is equivalent to NULL in assembly

;; ARRAY
;.orig x4000
;    .fill 4
;    .fill x4000
;    .fill x4008
;    .fill x6961
;    .fill 2
;    .fill x400C
;    .fill x4010
;    .fill x6962
;    .fill 8
;    .fill 0
;    .fill 0
;    .fill x6963
;    .fill 1
;    .fill 0
;    .fill 0
;    .fill x6964
;    .fill 3
;    .fill 0
;    .fill 0
;    .fill x6965
;.end
