;;=============================================================
;; CS 2110 - Fall 2022
;; Homework 5 - summation
;;=============================================================
;; Name: Donaven Lobo
;;=============================================================

;; Pseudocode (see PDF for explanation)
;;
;;    int result; (to save the summation of x)
;;    int x= -9; (given integer)
;;    int answer = 0;
;;    while (x > 0) {
;;        answer += x;
;;        x--;
;;    }
;;    result = answer;
.orig x3000
    ;; YOUR CODE HERE
	AND R0,R0,#0 ;;Clearing R0 to 0, answer = 0
	LD R1, x ;; Load x into R1

WHILE1 ADD R1,R1,#0 ;; Begining of while loop and setting condition codes based on x
	BRnz ENDW1 ;;  Loop ends if x is negative or 0
	ADD R0,R0,R1 ;; Add x to answer and store in answer
	ADD R1,R1,#-1 ;; decrement x by 1
	BR WHILE1 ;; Unconditional Branch for while
ENDW1 NOP
	ST R0, result ;; Store the final result in memory
	
    HALT

    x .fill -9
    result .blkw 1
.end

