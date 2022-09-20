;;=============================================================
;; CS 2110 - Fall 2022
;; Homework 5 - buildMaxArray
;;=============================================================
;; Name: Donaven Lobo
;;=============================================================


;; Pseudocode (see PDF for explanation)
;;
;;	int A[] = {1,2,3};
;;	int B[] = {-1, 7, 8};
;;	int C[3];
;;
;;	int i = 0;
;;
;;	while (i < A.length) {
;;		if (A[i] < B[i])
;;			C[i] = B[i];
;;		else
;;			C[i] = A[i];
;;
;;		i += 1;
;;	}


.orig x3000
	AND R0,R0,#0 ;; Clear R0, i = 0
	;; Get A.length and negate it
	LD R1,LEN
	NOT R1,R1
	ADD R1,R1,#1
	
WHILE1 ADD R2,R0,R1 ;; Set condition code using i - A.length
	BRzp ENDW1 ;; Loop whilst i < A.length
	LD R2,A ;; Get initial address of A
	ADD R2,R2,R0 ;; Get current address
	LDR R2,R2,#0; Get value from index value of array A
	
	LD R3,B ;; Get initial address of B
	ADD R3,R3,R0 ;; Get current address
	LDR R3,R3,#0; Get value from index value of array B
	
	;; Negate value from B[i]
	NOT R3,R3
	ADD R3,R3,#1
	
	;; If Statement
	ADD R3,R2,R3 ;; A[i] - B[i]
	BRzp ELSE1 ;; Branch to else block is A[i] - B[i] >= 0
	LD R2,B ;; Get initial address of B
	ADD R2,R2,R0 ;; Get current address
	LDR R2,R2,#0; Get value from index value of array B
	
	;;Store value of B[i] in C[i]
	LD R3,C
	ADD R3,R3,R0
	STR R2,R3,#0
	BR ENDIF1 ;; Finish the if statement
	;; Else Block
ELSE1 NOP
	;;Store value of A[i] in C[i]
	LD R3,C
	ADD R3,R3,R0
	STR R2,R3,#0
ENDIF1 NOP ;; End of if statement
	ADD R0,R0,#1 ;;Increment i by 1	
	BR WHILE1 ;; Unconditional Branch for while
ENDW1 NOP
	
	HALT


A 	.fill x3200
B 	.fill x3300
C 	.fill x3400
LEN .fill 4

.end

.orig x3200
	.fill -1
	.fill 2
	.fill 7
	.fill -3
.end

.orig x3300
	.fill 3
	.fill 6
	.fill 0
	.fill 5
.end

.orig x3400
	.blkw 4
.end


