;; TLDR Linked List Structure:
;;
;; For this Timed Lab, you are given a doubly-linked list and you need to check
;; if its data is a palindrome ignoring case.
;; Each node in the doubly-linked list is represented by three consecutive words in memory.
;; Each node has data, the address of the previous node, and the address of the next node.
;;
;; Given the address `node`, you can do
;; * `mem[node]` to get the data
;; * `mem[node + 1]` to get the address of the previous node
;; * `mem[node + 2]` to get the address of the next node

; Data for the one test
.orig x6000
        .fill 'a'
        .fill x0000
        .fill x4000
.end

.orig x4000
        .fill 'b'
        .fill x6000
        .fill x5000
.end

.orig x5000
        .fill 'A'
        .fill x4000
        .fill x0000
.end

.orig x3000

    ; One test is at the bottom of this file
    BR test_start


;; to_lowercase function
;; Parameter c: Character encoded in ASCII
;; Returns: Lowercase version of c if it's in the range 'A' to 'Z'; otherwise
;;          just c unchanged
;;
;; Examples:
;; * to_lowercase('a') == 'a'
;; * to_lowercase('A') == 'a'
;; * to_lowercase('5') == '5'

to_lowercase
.fill x1dba
.fill x7f84
.fill x7b83
.fill x1ba2
.fill x7180
.fill x7381
.fill x6344
.fill x2015
.fill x1040
.fill x080c
.fill x2013
.fill x1040
.fill x0209
.fill x2011
.fill x1040
.fill x7143
.fill x6180
.fill x6381
.fill x1d63
.fill x6f42
.fill x6b41
.fill xc1c0
.fill x7343
.fill x6180
.fill x6381
.fill x1d63
.fill x6f42
.fill x6b41
.fill xc1c0
.fill xffbf
.fill xffa6
.fill x0020


;; This function takes in two nodes from the doubly-linked list as input. It
;; outputs whether they contain equal data ignoring case. Note that case is
;; ignored. All the characters should be taken to lowercase before comparing
;; them.
;;
;; Parameter node1: The address of a node in the doubly-linked list
;; Parameter node2: The address of a node in the doubly-linked list
;; Returns: 1 if both nodes have the same data ignoring case, 0 otherwise
;;
;; Examples:
;; * are_letters_equal on node1 containing 'A' and node2 containing 'A' returns 1
;; * are_letters_equal on node1 containing 'A' and node2 containing 'a' returns 1
;; * are_letters_equal on node1 containing '5' and node2 containing '6' returns 0
;;
;; Pseudocode:
;; // (Checkpoint 1)
;; are_letters_equal(Node node1 (address), Node node2 (address)) {
;;      char letter1 = mem[node1];
;;      char letter2 = mem[node2];
;;
;;      letter1 = to_lowercase(letter1);
;;      letter2 = to_lowercase(letter2);
;;
;;      if (letter1 == letter2) {
;;          return 1;
;;      } else {
;;          return 0;
;;      }
;; }

are_letters_equal

    ;; Stack Build up
    ADD R6,R6,-4 ; push 4 words for ret value, old ret add, old frame ptr, local variable (answer)
    STR R7,R6,2 ; Save old RA
    STR R5,R6,1 ; Save old FP
    ADD R5,R6,0 ; Set FP = SP
    ADD R6,R6,-6 ; Push 6 words onto stack
    STR R0,R5,-2 ; Save old R0
    STR R1,R5,-3 ; Save old R1
    STR R2,R5,-4 ; Save old R2
    STR R3,R5,-5 ; Save old R3
    STR R4,R5,-6 ; Save old R4
    ;; End of Stack build up

    LDR R0,R5,4 ;; Load Node 1 addr
    LDR R0,R0,0 ;; Load Node 1 value

    ADD R6,R6,-1
    STR R0,R6,0 ;; push(letter1)
    JSR to_lowercase
    LDR R0,R6,0 ;; Store Lowercase letter of node 1 in R0
    ADD R6,R6,2 ;; Pop off remaining arguments (RV, arg 1)
    STR R0,R5,0 ;; Store value in first local variables

    LDR R0,R5,5 ;; Load Node 2 addr
    LDR R0,R0,0 ;; Load Node 2 value

    ADD R6,R6,-1
    STR R0,R6,0 ;; push(letter2)
    JSR to_lowercase
    LDR R0,R6,0 ;; Store Lowercase letter of node 2 in R0
    ADD R6,R6,2 ;; Pop off remaining arguments (RV, arg 1)
    STR R0,R5,-1 ;; Store value in second local variables

    LDR R0,R5,0 ;; load lowercase letter1 into R0
    LDR R1,R5,-1 ;; load lowercase letter2 into R1
    NOT R1,R1
    ADD R1,R1,1 ;; R1 = -R1
    ADD R0,R0,R1 ;; R0 = letter1 - letter2
    BRnp ELSE1
    AND R0,R0,0 ;; R0 = 0
    ADD R0,R0,1 ;; R0 = 1
    BR ENDIF1
ELSE1 NOP
    AND R0,R0,0 ;; R0 = 0
ENDIF1 NOP
    STR R0,R5,3 ;; Store return value in stack

    ;; Tear down the stack frame
    LDR R4,R5,-6 ;; Restore R4
    LDR R3,R5,-5 ;; Restore R3
    LDR R2,R5,-4 ;; Restore R2
    LDR R1,R5,-3 ;; Restore R1
    LDR R0,R5,-2 ;; Restore R0
    ADD R6,R5,0 ;; pop all saved registers and local variables
    LDR R7,R5,2 ;; R7 = OLD return address
    LDR R5,R5,1 ;; FP = OLD FP
    ADD R6,R6,3 ;; Pop last 3 words
    ;; STACK Tear down complete

    RET

;; Takes in both the head and tail addresses for a doubly-linked list, and
;; returns whether the data contained inside is a palindrome ignoring case. Note
;; that case is ignored. All the characters should be taken to lowercase before
;; comparing them.
;;
;;
;; Parameter head: The address of the first node in the doubly-linked list
;; Parameter tail: The address of the last node in the doubly-linked list
;; Returns: 1 if the list's data represents a palindrome ignoring case; 0
;;          otherwise
;;
;; Examples:
;; * is_palindrome on "aba" returns 1
;; * is_palindrome on "abA" returns 1
;; * is_palindrome on "abba" returns 1
;; * is_palindrome on "ab!" returns 0
;; * is_palindrome on "Happy Birthday!" returns 0
;;
;; Pseudocode:
;; is_palindrome(Node head (address), Node tail (address)) {
;;      // (Checkpoint 2 - Base Case)
;;      if (head == 0 || tail == 0) {
;;          return 1;
;;      }
;;
;;      if (are_letters_equal(head, tail) == 0) {
;;          return 0;
;;      }
;;
;;      // (Checkpoint 3 - Recursion)
;;      Node new_head = mem[head + 2];
;;      Node new_tail = mem[tail + 1];
;;
;;      return is_palindrome(new_head, new_tail);
;; }

is_palindrome

    ;; Stack Build up
    ADD R6,R6,-4 ; push 4 words for ret value, old ret add, old frame ptr, local variable (answer)
    STR R7,R6,2 ; Save old RA
    STR R5,R6,1 ; Save old FP
    ADD R5,R6,0 ; Set FP = SP
    ADD R6,R6,-6 ; Push 6 words onto stack
    STR R0,R5,-2 ; Save old R0
    STR R1,R5,-3 ; Save old R1
    STR R2,R5,-4 ; Save old R2
    STR R3,R5,-5 ; Save old R3
    STR R4,R5,-6 ; Save old R4
    ;; End of Stack build up

    LDR R0,R5,4 ;; Load memory address of the head in R0
    BRnp ENDIF2
    AND R0,R0,0 ;; R0 = 0
    ADD R0,R0,1 ;; R0 = 1
    STR R0,R5,3 ;; RV = 1
    BR TEARDOWN
ENDIF2 NOP
    LDR R0,R5,5 ;; Load memory address of the TAIL in R0
    BRnp ENDIF3
    AND R0,R0,0 ;; R0 = 0
    ADD R0,R0,1 ;; R0 = 1
    STR R0,R5,3 ;; RV = 1
    BR TEARDOWN
ENDIF3 NOP

    ;; call are_letters_equal - push arguments onto stack in reverse order
    LDR R0,R5,5 ;; Load memory address of the tail in R0
    ADD R6,R6,-1
    STR R0,R6,0 ;; push(tail addr)
    LDR R0,R5,4 ;; Load memory address of the head in R0
    ADD R6,R6,-1
    STR R0,R6,0 ;; push(head addr)
    JSR are_letters_equal
    LDR R0,R6,0 ;; Store return value in R0
    ADD R6,R6,3 ;; Push remainder of the arguments off the stack (RV, head, tail)
    ;; subroutine returns 1 if values are the same
    ADD R0,R0,0 ;; R0 = RV - 1
    BRnp ENDIF4 ;; enter is values are not the same
    AND R0,R0,0 ;; R0 = 0
    STR R0,R5,3 ;; RV = 0
    BR TEARDOWN
ENDIF4 NOP

    LDR R0,R5,4 ;; Load memory address of the head in R0
    ADD R0,R0,2 ;; R0 = head addr + 2
    LDR R0,R0,0 ;; R0 = mem[head addr + 2]
    STR R0,R5,0 ;; Store new_head in first local variable

    LDR R0,R5,5 ;; Load memory address of the tail in R0
    ADD R0,R0,1 ;; R0 = tail addr + 1
    LDR R0,R0,0 ;; R0 = mem[tail addr + 1]
    STR R0,R5,-1 ;; Store new_tail in first local variable

    ;; Call recursive call --> push arguments onto stack in reverse order
    LDR R0,R5,-1 ;; Load new_tail into R0
    ADD R6,R6,-1
    STR R0,R6,0 ;; push(new_tail)
    LDR R0,R5,0 ;; Load new_head into R0
    ADD R6,R6,-1
    STR R0,R6,0 ;; push(new_head)
    JSR is_palindrome
    LDR R0,R6,0 ;; Load return value into R0
    ADD R6,R6,3 ;; Pop off remainder of stack (RV, new_head, new_tail)
  ;;  ADD R0,R0,-1
    STR R0,R5,3 ;; Store R0 in the return value in the STACK

TEARDOWN NOP
    ;; Tear down the stack frame
    LDR R4,R5,-6 ;; Restore R4
    LDR R3,R5,-5 ;; Restore R3
    LDR R2,R5,-4 ;; Restore R2
    LDR R1,R5,-3 ;; Restore R1
    LDR R0,R5,-2 ;; Restore R0
    ADD R6,R5,0 ;; pop all saved registers and local variables
    LDR R7,R5,2 ;; R7 = OLD return address
    LDR R5,R5,1 ;; FP = OLD FP
    ADD R6,R6,3 ;; Pop last 3 words
    ;; STACK Tear down complete

    RET


; Helper code that runs one test
test_start

    ; Set up the stack
    LD R6, initial_r6

    ; Place arguments on the stack
    LD R0, head_addr
    LD R1, tail_addr
    ADD R6, R6, -2
    STR R0, R6, 0
    STR R1, R6, 1

    ; Set all the other registers to notable values
    ; Done to ease debugging
    LD R0, initial_r0
    LD R1, initial_r1
    LD R2, initial_r2
    LD R3, initial_r3
    LD R4, initial_r4
    LD R5, initial_r5
    LD R7, initial_r7

    ; Call the function
    ; Pop off return value and arguments
    JSR is_palindrome
    ADD R6, R6, 3

    HALT

; Easy to recognize initial values for registers
; Chosen to ease debugging
initial_r0 .fill xDEAD
initial_r1 .fill xBEEF
initial_r2 .fill x2110
initial_r3 .fill x2200
initial_r4 .fill x4290
initial_r5 .fill xCAFE
initial_r6 .fill xF000
initial_r7 .fill x8000

; Arguments to pass to the subroutine
head_addr .fill x6000
tail_addr .fill x5000

.end
