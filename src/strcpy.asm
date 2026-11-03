; R1 chaine de caracteres
; R2 destination 
; R3 valeur de R1
; R4 temporaire pour tester si fin de chaine
.ORIG	x3000
                    AND R2, R2, #0
                    AND R4, R4, #0
                    LEA R1, str
                    LEA R2, dest

loop:               LDR R3, R1, #0  ; récupéré l'adresse de l'élément dans R3
                    ADD R4, R3, #0  ; Tester si on est fin de la chaine
                    BRz exit
                    STR R3, R2, #0  ; écrire le caractère a l'adresse R2
                    ADD R1, R1, #1  ; avancer le pointeur de 1 sur la chaine str
                    ADD R2, R2, #1  ; avancer le pointeur de 1 sur la chaine destination
                    BR loop

exit:               ADD R2, R2, 0   ; mettre caractère nul en fin de chaine
                    HALT

str:                .STRINGZ "Hello World!"
dest:               .BLKW 10

.END