; Registres utilisés dans le programme
; R0 le résultat
; R1 argument pour les sous routines
; R2 
; R6 pile
; R7
; Pour clz et ctz de 0 la valeur de retour est 16
.ORIG x3000
psp:                .FILL stackend
                    LD R6, psp      ; initialisation pile
main:               LD R1, val_13   
                    JSR clz
                    JSR ctz
                    LD R1, val_n8
                    JSR clz
                    JSR ctz
                    AND R1, R1, #0
                    JSR clz
                    JSR ctz
exit:               HALT

; Registres sauvegardés par la sous-routine dans l'ordre
; R1
clz:                ADD R6, R6, #-1 ; on sauvegarde l'argument avant manipulation
                    STR R1, R6, #0
                    AND R0, R0, #0

; vérifie si l'entier est 0           
clz_zero:           ADD R1, R1, #0
                    BRnp clz_loop
                    ADD R0, R0, #15
                    ADD R0, R0, #1
                    BR end_clz

clz_loop:           ADD R1, R1, #0  ; pour vérifier la valeur bit de signe
                    BRnz end_clz    
                    ADD R0, R0, #1  ; on incrémente le résultat
                    ADD R1, R1, R1  ; on left shift
                    BRp clz_loop

end_clz:            LDR R1, R6, #0  ; restauration de R1
                    ADD R6, R6, #1
                    RET

; Pas de besoin de la pile la valeur de R1 ne change pas
ctz:                AND R0, R0, #0

; vérification de la valeur 0
ctz_zero:           ADD R1, R1, #0
                    BRnp ctz_main
                    ADD R0, R0, #15
                    ADD R0, R0, #1
                    BR ctz_end

; ctz(x) = POPCNT(x ⊕ (x − 1)) − 1
ctz_main:           ADD R0, R1, #0
                    ADD R0, R0, #-1
                    XOR R0, R0, R1
                    POPCNT R0, R0
                    ADD R0, R0, #-1 

ctz_end:            RET

val_13:              .FILL #13
val_n8:              .FILL #-8
val_0:               .FILL #0
val_x7FFF:           .FILL x7FFF

; Réservation de l’espace pour la pile
.BLKW x100                          ; Taille de la pile : 256 octets
stackend:                           ; Adresse de mot mémoire suivant

.END