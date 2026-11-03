; R0 l'entier renversé
; R1 l'entier
; R2 position actuelle
.ORIG x3000
psp:                .FILL stackend
                    LD R6, psp      ; initialisation pile
                    LD R1, integer
                    JSR reverse
exit:               HALT

; Registres sauvegardés par la sous-routine dans l'ordre
; R1
; R2
reverse:            ADD R6, R6, #-1
                    STR R1, R6, #0
                    ADD R6, R6, #-1
                    STR R2, R6, #0
                    AND R0, R0, #0 
                    AND R2, R2, #0
                    ADD R2, R2, #1  ; commencer à la position 1

; boucle de reverse
reverse_loop:       ADD R1, R1, #0  ; vérifier si le bit de poids fort = 1
                    BRn reverse_add
                    ADD R2, R2, R2  ; left shift le bit de position
                    ADD R1, R1, R1  ; left shift R1 pour préparer à la prochaine itération
                    BRnp reverse_loop       ; tant que R1 est différent de 0 il reste des bits à ajouter à R0
                    BR reverse_end

; ajouter le bit de position à R0
reverse_add:        ADD R0, R0, R2
                    ADD R2, R2, R2  
                    ADD R1, R1, R1  
                    BRnp reverse_loop      

; retour de la sous-routine reverse
reverse_end:        LDR R2, R6, #0
                    ADD R6, R6, #1
                    LDR R1, R6, #0
                    ADD R6, R6, #1
                    RET

integer:            .FILL #24       ; entier à renverser

; Réservation de l’espace pour la pile
.BLKW x100                          ; Taille de la pile : 256 octets
stackend:                           ; Adresse de mot mémoire suivant
.END
