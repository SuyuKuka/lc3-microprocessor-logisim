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

; tests prediction overflow
                    LD R2, val_13       ; R1=0 et R2=13 doit retourner un négatif
                    JSR predict     
                    LD R1, val_n8       ; clz(R1)=0 doit retourner un positif
                    JSR predict
                    LD R1, val_13   
                    AND R2, R2, #0      ; R1=13 et R2=0 doit retourner un négatif
                    JSR predict
                    LD R2, val_13       ; R1 et R2 = 13 doit retourner un négatif
                    JSR predict
                    LD R2, val_xFFFF    ; test overflow doit retourner un positif
                    JSR predict
                    AND R1, R1, #0
                    ADD R1, R1, #1
                    JSR predict         ; test R1=1 doit retourner un négatif

                    LD R1, val_5        ; 101 multiplicateur fini par 1
                    LD R2, val_21       ; 10101
                    JSR multiply16      ; retourne x0069
                    AND R1, R1, #0
                    JSR multiply16      ; retourne 0
                    ADD R1, R1, #1
                    JSR multiply16      ; retourne x0015
                    LD R1, val_13       
                    LD R2, val_xFFFF        
                    JSR multiply16      ; overflow doit retourner xFFFF
                    LD R1, val_6        ; 110 multiplicateur fini par 0
                    LD R2, val_11       ; 1011
                    JSR multiply16      ; retourne x0042

                    LD R1, val_11       ; R1 et R2 inversé
                    LD R2, val_6      
                    JSR multiply16      ; retourne x0042
                    LD R1, val_21       
                    LD R2, val_5       
                    JSR multiply16      ; retourne x0069
                    AND R2, R2, #0
                    JSR multiply16      ; retourne 0
                    ADD R2, R2, #1
                    JSR multiply16      ; retourne x0015
                    LD R1, val_xFFFF       
                    LD R2, val_13        
                    JSR multiply16      ; overflow doit retourner xFFFF
                    LD R2, val_xFFFF
                    AND R1, R1, #0      
                    JSR multiply16      ; retourne 0
                    ADD R1, R1, #1
                    JSR multiply16      ; retourne xFFFF
exit:               HALT

; Registres sauvegardés par la sous-routine dans l'ordre
; R1 l'entier à renverser
; R2 utilisé pour la position à ajouter
reverse:            ADD R6, R6, #-1
                    STR R1, R6, #0
                    ADD R6, R6, #-1
                    STR R2, R6, #0
                    AND R0, R0, #0 
                    AND R2, R2, #0
                    ADD R2, R2, #1      ; commencer à la position 1

; boucle de reverse
reverse_loop:       ADD R1, R1, #0      ; vérifier si le bit de poids fort est 1
                    BRn reverse_add
                    ADD R2, R2, R2      ; left shift le bit de position
                    ADD R1, R1, R1      ; left shift R1 pour préparer à la prochaine itération
                    BRnp reverse_loop   ; tant que R1 est différent de 0 il reste des bits à ajouter à R0
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

; Registres sauvegardés par la sous-routine dans l'ordre
; R1 doit contenir un non-signé
; R2 doit contenir un non-signé
; R7 car on fait appel à la sous-routine clz
predict:            ADD R6, R6, #-1
                    STR R1, R6, #0
                    ADD R6, R6, #-1
                    STR R2, R6, #0
                    ADD R6, R6, #-1
                    STR R7, R6, #0

; vérification des valeurs des arguments
; 1 arg 0 ou 1 ne déborde jamais
                    ADD R1, R1, #0           
                    BRz predict_never
                    ADD R2, R2, #0
                    BRz predict_never
                    ADD R0, R1, #-1
                    BRz predict_never
                    ADD R0, R2, #-1
                    BRz predict_never

; appels clz
                    JSR clz                 ; R1 contient déjà le premier argument
                    ADD R1, R2, #0          ; on prépare l'appel de clz avec la valeur R2
                    ADD R2, R0, #0          ; on sauvegarde le clz de R1 dans R2
                    JSR clz         
                    ADD R1, R0, #0          ; on remplace l'argument utilisé pour clz par le résultat

; R1=clz(R2) et R2=clz(R1)
                    AND R0, R0, #0
                    ADD R0, R0, #15
                    ADD R0, R0, #1          ; R0 à 16
                    NOT R1, R1
                    ADD R1, R1, #1          ; complément à deux
                    ADD R0, R0, R1          
                    NOT R2, R2
                    ADD R2, R2, #1
                    ADD R0, R0, R2

predict_end:        LDR R7, R6, #0
                    ADD R6, R6, #1
                    LDR R2, R6, #0
                    ADD R6, R6, #1
                    LDR R1, R6, #0
                    ADD R6, R6, #1
                    RET

predict_never:      AND R0, R0, #0
                    ADD R0, R0, #-1
                    BR predict_end

; Registres sauvegardés par la sous-routine dans l'ordre
; R1 doit contenir un non-signé
; R2 doit contenir un non-signé
; R7 car on fait appel à la sous-routine predict et reverse
multiply16:         ADD R6, R6, #-1
                    STR R1, R6, #0
                    ADD R6, R6, #-1
                    STR R2, R6, #0
                    ADD R6, R6, #-1
                    STR R7, R6, #0
                    
                    JSR predict
                    ADD R0, R0, #0
                    BRp multiply16_max
                    JSR reverse
                    ADD R1, R0, #0          ; mettre à R1 son renversement
                    AND R0, R0, #0
                    
; (x << 3) + (x << 1) # Here 10*x is computed as x*2^3 + x*2 (de wikipedia)
multiply16_shift:   ADD R1, R1, #0
                    BRzp multiply16_next
                    ADD R0, R0, #0
                    BRn mult16_overflow
                    BRzp mult16_add

mult16_overflow:    ADD R0, R0, R2
                    BRzp multiply16_max
                    BR multiply16_next

 mult16_add:        ADD R0, R0, R2

; prépare le prochain appel 
multiply16_next:    ADD R1, R1, R1
                    BRz multiply16_end
                    ADD R2, R2, R2
                    BR multiply16_shift

multiply16_end:     LDR R7, R6, #0
                    ADD R6, R6, #1
                    LDR R2, R6, #0
                    ADD R6, R6, #1
                    LDR R1, R6, #0
                    ADD R6, R6, #1
                    RET

multiply16_max:     LD R0, val_xFFFF
                    BR multiply16_end

val_13:              .FILL #13
val_11:              .FILL #11
val_6:               .FILL #6
val_21:              .FILL #21
val_5:               .FILL #5
val_n8:              .FILL #-8
val_xFFFF:           .FILL xFFFF

; Réservation de l’espace pour la pile
.BLKW x100                          ; Taille de la pile : 256 octets
stackend:                           ; Adresse de mot mémoire suivant

.END