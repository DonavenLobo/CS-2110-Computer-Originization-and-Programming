;;=============================================================
;; CS 2110 - Fall 2022
;; Homework 5 - binaryStringToInt
;;=============================================================
;; Name: Donaven Lobo
;;=============================================================

;; Pseudocode (see PDF for explanation)
;;
;;    int result = x4000; (given memory address to save the converted value)
;;    String binaryString= "01000000"; (given binary string)
;;    int length = 8; (given length of the above binary string)
;;    int base = 1;
;;    int value = 0;
;;    while (length > 0) {
;;        int y = binaryString.charAt(length - 1) - 48;
;;        if (y == 1) {
;;            value += base;
;;        }     
;;            base += base;
;;            length--;
;;    }
;;    mem[result] = value;
.orig x3000
	LD R0,length
	AND R3,R3,#0 ;; Clear register 3
	ADD R3,R3,#1 ;; Base = 1
	AND R4,R4,#0 ;; Value = 0
	WHILE1 ADD R0,R0,#0 ;; Set condition code using current length
	BRnz ENDW1
	;;Negate Length
	;;NOT R1,R0
	;;ADD R1,R1,#1
	;; Find index of MSB
	;;ADD R1, R1, #8
	LD R2,binaryString ;; Go to string memory
	ADD R2,R2,R0 ;;set index
	ADD R2,R2,#-1
	LDR R1,R2,#0 ;; Get Bit Character
	ADD R1,R1,#-16 ;; Get actual decimal value
	ADD R1,R1,#-16
	ADD R1,R1,#-16	
	
	;;If statement
	ADD R1,R1,#-1 ;; Check if the bit is equal to 1
	BRnp ENDIF1
	ADD R4,R4,R3 ;; value += base
ENDIF1 NOP
	ADD R3,R3,R3 ;; base += base
	ADD R0,R0,#-1 ;; length--

	;;Now store final value in result
	
	BR WHILE1 ;; Unconditional Branch for while
ENDW1 NOP
	STI R4,result
    HALT

    binaryString .fill x5000
    length .fill 8
    result .fill x4000
.end 

.orig x5000
    .stringz "00000011"
.end
