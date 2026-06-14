       IDENTIFICATION DIVISION.
       PROGRAM-ID. PORT-SCREEN.
       AUTHOR. Thomas Moras.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-GOODS-INDEX PIC 9(10).
       01 WS-PORT-INDEX PIC 9(10).

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
                       PERFORM DISPLAY-PORTS-LIST
                   ELSE
                       MOVE "Faites le plein d'abord !"
                           TO WS-NOTIFICATION
                   END-IF
               WHEN 2
                   MOVE "Placeholder: acheter"
                       TO WS-NOTIFICATION
                   PERFORM DISPLAY-GOODS-TABLE
               WHEN 3
                   MOVE "Placeholder: vendre"
                       TO WS-NOTIFICATION
                   PERFORM DISPLAY-GOODS-TABLE
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
               WHEN OTHER
                   MOVE "Choix invalide."
                       TO WS-NOTIFICATION
           END-EVALUATE

           GOBACK.

       DISPLAY-PORTS-LIST.
           DISPLAY " "
           DISPLAY "=== Ports disponibles =================="
           PERFORM VARYING WS-PORT-INDEX FROM 1 BY 1
                   UNTIL WS-PORT-INDEX > 5
               IF WS-PORT-INDEX NOT = WS-CURRENT-PORT
                   DISPLAY WS-PORT-NAME(WS-PORT-INDEX) WITH NO ADVANCING
                   IF WS-PORT-VISITED(WS-PORT-INDEX) = 1
                       DISPLAY "   Deja visite"
                   ELSE
                       DISPLAY "   Nouveau port"
                   END-IF
               END-IF
           END-PERFORM
           DISPLAY " "
           DISPLAY "Choisissez une destination: " WITH NO ADVANCING
           ACCEPT WS-ARG
           .

       DISPLAY-GOODS-TABLE.
           DISPLAY " "
           DISPLAY "--- Marchandises disponibles ---"
           DISPLAY "ID  Nom              Prix"
           DISPLAY "-------------------------------"
           PERFORM VARYING WS-GOODS-INDEX FROM 1 BY 1
                   UNTIL WS-GOODS-INDEX > 5
               DISPLAY WS-GOOD-ID(WS-GOODS-INDEX) "  "
                   WS-GOOD-NAME(WS-GOODS-INDEX) "  "
                    WS-GOODS-PRICES-PRICE(
                        WS-CURRENT-PORT WS-GOODS-INDEX) "$"
           END-PERFORM
           DISPLAY "-------------------------------"
           .
