       IDENTIFICATION DIVISION.
       PROGRAM-ID. PORT-SCREEN.
       AUTHOR. Thomas Moras.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-GOODS-INDEX PIC 9(10).
       01 WS-PORT-INDEX PIC 9(10).
       01 WS-I PIC 9(10).
       01 WS-J PIC 9(10).
       01 WS-PRICE PIC 9(10).
       01 WS-EXIT-FLAG PIC 9(01).
       01 WS-QUANTITY PIC 9(10).

       LINKAGE SECTION.
       01 WS-ACTION PIC 9(01).
       01 WS-ARG PIC 9(10).
       COPY game-dat.
       COPY port-dat.
       COPY gds-dat.
       COPY pric-dat.

       PROCEDURE DIVISION USING WS-ACTION WS-ARG WS-GAME-DATA
               WS-PORT-TABLE WS-GOODS-LIST WS-GOODS-PRICES-LIST.

           CALL "SYSTEM" USING "cls"

           DISPLAY "=== PORT ==============================="
           DISPLAY "Port: " WS-PORT-NAME(WS-CURRENT-PORT)
           DISPLAY WS-PORT-DESCRIPTION(WS-CURRENT-PORT)
           DISPLAY "========================================"
           DISPLAY "Argent: " WS-MONEY "$"
           DISPLAY "Carburant: " WITH NO ADVANCING
           IF WS-FUEL-FLAG = 1
               DISPLAY "Plein"
           ELSE
               DISPLAY "Vide"
           END-IF
           DISPLAY "1 - Naviguer"
           DISPLAY "2 - Acheter"
           DISPLAY "3 - Vendre"
            DISPLAY "4 - Remplir l'essence (50 000$)"
            DISPLAY "5 - Sauvegarder"
            DISPLAY "6 - Charger"
            DISPLAY " "
           IF WS-NOTIFICATION NOT = SPACES
               DISPLAY "----------------------------------------"
               DISPLAY WS-NOTIFICATION
               MOVE SPACES TO WS-NOTIFICATION
           END-IF
           DISPLAY "----------------------------------------"
           DISPLAY "Votre choix: " WITH NO ADVANCING
           ACCEPT WS-ACTION

           EVALUATE WS-ACTION
               WHEN 0
                   MOVE "Placeholder: quitter"
                       TO WS-NOTIFICATION
                WHEN 1
                    IF WS-FUEL-FLAG = 1
                        PERFORM PROCESS-NAVIGATION
                    ELSE
                        IF WS-MONEY >= 50000
                            MOVE "Faites le plein d'abord !"
                                TO WS-NOTIFICATION
                        ELSE
                            MOVE "LOST" TO WS-STATUS
                        END-IF
                    END-IF
                WHEN 2
                    PERFORM BUY-GOODS
                WHEN 3
                    PERFORM SELL-GOODS
                WHEN 4
                    IF WS-FUEL-FLAG = 1
                        MOVE "Plein deja fait !"
                            TO WS-NOTIFICATION
                    ELSE
                        IF WS-MONEY >= 50000
                            SUBTRACT 50000 FROM WS-MONEY
                            MOVE 1 TO WS-FUEL-FLAG
                            MOVE "Plein fait !"
                                TO WS-NOTIFICATION
                        ELSE
                            MOVE "Pas assez d'argent !"
                                TO WS-NOTIFICATION
                        END-IF
                    END-IF
                WHEN 5
                    CONTINUE
                WHEN 6
                    CONTINUE
                WHEN OTHER
                   MOVE "Choix invalide."
                       TO WS-NOTIFICATION
           END-EVALUATE

           GOBACK.

       PROCESS-NAVIGATION.
           PERFORM DISPLAY-PORTS-LIST
               MOVE 0 TO WS-FUEL-FLAG
               MOVE WS-ARG TO WS-CURRENT-PORT
               IF WS-PORT-VISITED(WS-CURRENT-PORT) = 0
                   MOVE 1 TO WS-PORT-VISITED(WS-CURRENT-PORT)
                   ADD 1 TO WS-VISITED-PORTS-COUNT
               END-IF
               PERFORM FLUCTUATE-PRICES
                MOVE "Arrive a bon port !" TO WS-NOTIFICATION
               IF WS-VISITED-PORTS-COUNT >= 5
                   MOVE "WON" TO WS-STATUS
           END-IF
           .
 
       BUY-GOODS.
           PERFORM DISPLAY-GOODS-TABLE
           MOVE 0 TO WS-EXIT-FLAG
           PERFORM UNTIL WS-EXIT-FLAG = 1
               DISPLAY "Quel produit (1-5, 0 = annuler) ? "
                   WITH NO ADVANCING
               ACCEPT WS-ARG
               IF WS-ARG = 0
                   MOVE "Achat annule." TO WS-NOTIFICATION
                   MOVE 1 TO WS-EXIT-FLAG
               ELSE
                   IF WS-ARG >= 1 AND WS-ARG <= 5
                       DISPLAY "Quantite: " WITH NO ADVANCING
                       ACCEPT WS-QUANTITY
                       IF WS-QUANTITY > 0
                           COMPUTE WS-PRICE = WS-GOODS-PRICES-PRICE(
                               WS-CURRENT-PORT WS-ARG) * WS-QUANTITY
                           IF WS-MONEY >= WS-PRICE
                               SUBTRACT WS-PRICE FROM WS-MONEY
                               ADD WS-QUANTITY TO
                                   WS-CARGO-QUANTITY(WS-ARG)
                               MOVE "Achat effectue !"
                                   TO WS-NOTIFICATION
                           ELSE
                               MOVE "Pas assez d'argent !"
                                   TO WS-NOTIFICATION
                           END-IF
                       ELSE
                           MOVE "Quantite invalide."
                               TO WS-NOTIFICATION
                       END-IF
                       MOVE 1 TO WS-EXIT-FLAG
                   ELSE
                       DISPLAY "Produit invalide."
                   END-IF
               END-IF
           END-PERFORM
           .
 
       SELL-GOODS.
           DISPLAY " "
           DISPLAY "=== Cargo =============================="
           DISPLAY "ID  Nom              Quantite  Prix"
           DISPLAY "----------------------------------------"
           PERFORM VARYING WS-GOODS-INDEX FROM 1 BY 1
                   UNTIL WS-GOODS-INDEX > 5
               IF WS-CARGO-QUANTITY(WS-GOODS-INDEX) > 0
                   DISPLAY WS-GOOD-ID(WS-GOODS-INDEX) "  "
                       WS-GOOD-NAME(WS-GOODS-INDEX) "  "
                       WS-CARGO-QUANTITY(WS-GOODS-INDEX) "  "
                       WS-GOODS-PRICES-PRICE(
                           WS-CURRENT-PORT WS-GOODS-INDEX) "$"
               END-IF
           END-PERFORM
           DISPLAY "----------------------------------------"
           MOVE 0 TO WS-EXIT-FLAG
           PERFORM UNTIL WS-EXIT-FLAG = 1
               DISPLAY "Quel produit vendre (1-5, 0 = annuler) ? "
                   WITH NO ADVANCING
               ACCEPT WS-ARG
               IF WS-ARG = 0
                   MOVE "Vente annulee." TO WS-NOTIFICATION
                   MOVE 1 TO WS-EXIT-FLAG
               ELSE
                   IF WS-ARG >= 1 AND WS-ARG <= 5
                       IF WS-CARGO-QUANTITY(WS-ARG) > 0
                           DISPLAY "Quantite: " WITH NO ADVANCING
                           ACCEPT WS-QUANTITY
                           IF WS-QUANTITY > 0 AND
                                   WS-QUANTITY <=
                                   WS-CARGO-QUANTITY(WS-ARG)
                           COMPUTE WS-PRICE = WS-GOODS-PRICES-PRICE(
                               WS-CURRENT-PORT WS-ARG) * WS-QUANTITY
                           ADD WS-PRICE TO WS-MONEY
                           SUBTRACT WS-QUANTITY FROM
                                   WS-CARGO-QUANTITY(WS-ARG)
                               MOVE "Vente effectuee !"
                                   TO WS-NOTIFICATION
                           ELSE
                               MOVE "Quantite invalide."
                                   TO WS-NOTIFICATION
                           END-IF
                       ELSE
                           MOVE "Vous n'avez pas ce produit."
                               TO WS-NOTIFICATION
                       END-IF
                       MOVE 1 TO WS-EXIT-FLAG
                   ELSE
                       DISPLAY "Produit invalide."
                   END-IF
               END-IF
           END-PERFORM
           .
 
       DISPLAY-PORTS-LIST.
           DISPLAY " "
           DISPLAY "=== Ports disponibles =================="
           PERFORM VARYING WS-PORT-INDEX FROM 1 BY 1
                   UNTIL WS-PORT-INDEX > 5
               IF WS-PORT-INDEX NOT = WS-CURRENT-PORT
                    DISPLAY WS-PORT-ID(WS-PORT-INDEX) " - "
                        WS-PORT-NAME(WS-PORT-INDEX) WITH NO ADVANCING
                   IF WS-PORT-VISITED(WS-PORT-INDEX) = 1
                       DISPLAY "   Deja visite"
                   ELSE
                       DISPLAY "   Nouveau port"
                   END-IF
               END-IF
           END-PERFORM
           DISPLAY " "
           MOVE 0 TO WS-EXIT-FLAG
           PERFORM UNTIL WS-EXIT-FLAG = 1
               DISPLAY "Choisissez une destination: "
                   WITH NO ADVANCING
               ACCEPT WS-ARG
               IF WS-ARG >= 1 AND WS-ARG <= 5
                       AND WS-ARG NOT = WS-CURRENT-PORT
                   MOVE 1 TO WS-EXIT-FLAG
               ELSE
                   DISPLAY "Port invalide. Choisissez parmi la liste."
               END-IF
           END-PERFORM
           .

       DISPLAY-GOODS-TABLE.
           DISPLAY " "
           DISPLAY "=== Marchandises disponibles ==========="
           DISPLAY "ID  Nom              Prix"
           DISPLAY "----------------------------------------"
           PERFORM VARYING WS-GOODS-INDEX FROM 1 BY 1
                   UNTIL WS-GOODS-INDEX > 5
               DISPLAY WS-GOOD-ID(WS-GOODS-INDEX) "  "
                   WS-GOOD-NAME(WS-GOODS-INDEX) "  "
                    WS-GOODS-PRICES-PRICE(
                        WS-CURRENT-PORT WS-GOODS-INDEX) "$"
           END-PERFORM
           DISPLAY "----------------------------------------"
           .

        FLUCTUATE-PRICES.
           PERFORM VARYING WS-I FROM 1 BY 1
                   UNTIL WS-I > 5
               PERFORM VARYING WS-J FROM 1 BY 1
                       UNTIL WS-J > 5
                   COMPUTE WS-GOODS-PRICES-PRICE(WS-I,
                       WS-J) =
                       WS-GOODS-PRICES-PRICE(WS-I,
                       WS-J) *
                       (0.9 + FUNCTION RANDOM * 0.2)
               END-PERFORM
           END-PERFORM
           .
