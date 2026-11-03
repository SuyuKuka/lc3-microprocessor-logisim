; R0 si caractere pas présent = 0 sinon = idx
; R1 chaine de caractères
; R2 caractère rechercher
; R3 valeur de R1 (valeur actuelle)
; R4 valeur négatif de R2
.ORIG x3000
                    AND R0, R0, #0
                    ADD R4, R4, #0
                    LEA	R1, str     ; load string dans R1, pointe au début de la chaine
                    LD R2, char     ; load char dans R2
                    NOT R4, R2      ; mettre la valeur négatif de R2 dans R4
                    ADD R4, R4, #1  ; mettre +1 pour avoir la bonne valeur
                    BR loop

loop:               LDR R3, R1, #0  ; mettre dans R3 la valeur de l'adresse de R1
                    ADD R0, R3, #0  ; R3 + 0 si = 0 alors R3 vaut 0 donc fin de la chaine
                    BRz not_found   ; si vrai alors pas trouvé
                    ADD R0, R3, R4  ; additionner la valeur courante de R3 et la valeur qu'on cherche R4
                    BRz found       ; si 0 dans ce cas c'est la bonne valeur (108 - 108)
                    ADD R1, R1, #1  ; passe au caractère suivant (+1 sur l'adresse) 
                    BR loop

found:              ADD R0, R1, #0  ; ajoute l'adresse actuelle de R1 dans R0
                    HALT

not_found:          HALT            ; on a déjà 0 dans R0 via le AND ligne 15

str:                .STRINGZ "Hello World!"
char:               .FILL 108 ; l

.END
