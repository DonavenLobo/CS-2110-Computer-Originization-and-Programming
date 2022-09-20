;;=============================================================
;; CS 2110 - Fall 2022
;; Homework 5 - fourCharacterStrings
;;=============================================================
;; Name: Donaven Lobo
;;=============================================================


;; Pseudocode (see PDF for explanation)
;;
;; int count = 0;
;; int chars = 0;
;; int i = 0;
;;
;;  while(str[i] != '\0') {
;;      if (str[i] != ' ') 
;;          chars++;
;;      
;;      else {
;;          if (chars == 4) 
;;              count++;   
;;          chars = 0;
;;      }
;;      i++;
;;  }
;; ***IMPORTANT***
;; - Assume that all strings provided will end with a space (' ').
;; - Special characters do not have to be treated differently. For instance, strings like "it's" and "But," are considered 4 character strings.
;;

.orig x3000
	AND R0,R0,#0 ;; i = 0
	AND R1,R1,#0 ;; count = 0
	AND R2,R2,#0 ;; chars = 0
	
	
	;;While Loop
	LD R3,STRING ;; Get Effective address
	ADD R3,R3,R0;; get index value
	LDR R3,R3,#0 ;; R3 = str[i]
WHILE1 ADD R3,R3,#0 ;;Sets condition code
	BRz ENDW1;; End loop if condition code is zero
	
	;;If Statement
	ADD R3,R3,#-16 ;; str[i] - 32 
	ADD R3,R3,#-16
	BRz ELSE1 ;; Branch if result is zero
	ADD R2,R2,#1; chars++
	BR ENDIF1 ;; End if block
ELSE1 NOP
	ADD R3,R2,#-4 ; R3 = chars - 4
	BRnp ENDIF2
	ADD R1,R1,#1 ;; count++
ENDIF2 NOP
	AND R2,R2,#0 ;; chars = 0
ENDIF1 NOP 
	ADD R0,R0,#1 ;; i++
	LD R3,STRING ;; Get Effective address
	ADD R3,R3,R0;; get index value
	LDR R3,R3,#0 ;; R3 = str[i]
	BR WHILE1 ;; Unconditional Branch for while
ENDW1 NOP
	LEA R0,ANSWER ;; Store answer address in R0
	STR R1,R0,#0
	HALT


SPACE 	.fill #-32
STRING	.fill x4000
ANSWER .blkw 1

.end


.orig x4000

.stringz "I love CS 2110 and assembly is very fun! "

.end
