;;=============================================================
;; CS 2110 - Spring 2022
;; Final Exam - Range Search
;;=============================================================
;; Name: Donaven Lobo
;;=============================================================

;; Pseudocode (see PDF for additional information)
;;     int list = [2, 1, 1, 0, 4, 2, 9, 0];
;;     int size = 8;
;;     int target = 10;
;;     int range = 2;
;;     int answer;
;;
;;     int element = -1;
;;     for (int i = 0; i < size; i++) {
;;         if (target - range <= list[i] <= target + range) {
;;             element = list[i];
;;             break;
;;         }
;;     }
;;     answer = element;
;;
;;
.orig x3000

AND R4,R4,0
ADD R4,R4,-1 ;; R4 = element = -1

AND R0,R0,0 ;; R0 = i = 0
FOR LD R1,SIZE ;; R1 = SIZE
NOT R1,R1
ADD R1,R1,1 ;;R1= -size
ADD R1,R0,R1 ;; R1 = i - SIZE
BRzp ENDFOR
LD R1,TARGET ;; R1 = TARGET
LD R2, RANGE ;; R2 = Range
NOT R2,R2
ADD R2,R2,1 ;; R2 = -RANGE
ADD R1,R1,R2 ;; R1 = TARGET - Range
LD R2,LIST ;; Mem add of List
ADD R2,R2,R0 ;; MEM add of list[i]
LDR R2,R2,0 ;; Value at list[i]
NOT R2,R2
ADD R2,R2,1 ;; R2 = -list[i]
ADD R1,R1,R2 ;; R1 = TARGET - Range - list[i]
BRp ENDIF
LD R1,LIST ;; Mem add of List
ADD R1,R1,R0 ;; MEM add of list[i]
LDR R1,R1,0 ;; Value at list[i]
LD R2,TARGET ;; R2 = TARGET
LD R3, RANGE ;; R3 = Range
ADD R2,R2,R3 ;; R2 = TARGET + Range
NOT R2,R2
ADD R2,R2,1 ;; R2 = - (TARGET + Range)
ADD R1,R1,R2 ;; R1 = list[i] - (TARGET + Range)
BRp ENDIF
LD R1,LIST ;; Mem add of List
ADD R1,R1,R0 ;; MEM add of list[i]
LDR R4,R1,0 ;; Value at list[i]
BR ENDFOR
ENDIF ADD R0,R0,1 ;; i++
BR FOR
ENDFOR NOP
ST R4,ANSWER

HALT

LIST    .fill x4000
SIZE    .fill 8
TARGET  .fill 10
RANGE   .fill 2
ANSWER  .blkw 1

.end

.orig x4000
    .fill 2
    .fill 1
    .fill 1
    .fill 0
    .fill 4
    .fill 2
    .fill 9
    .fill 0
.end
