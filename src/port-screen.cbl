       IDENTIFICATION DIVISION.
       PROGRAM-ID. PORT-SCREEN.
       AUTHOR. Thomas Moras.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-GOODS-INDEX PIC 9(10).

       LINKAGE SECTION.
       01 WS-ACTION PIC 9(01).
       01 WS-ARG PIC 9(10).
       COPY game-dat.
       COPY port-dat.
       COPY gds-dat.
       COPY pric-dat.

       PROCEDURE DIVISION USING WS-ACTION WS-ARG WS-GAME-DATA
               WS-PORT-TABLE WS-GOODS-LIST WS-GOODS-PRICES-LIST.

           DISPLAY "=== PORT ==============================="
           DISPLAY "Port: " WS-PORT-NAME(WS-CURRENT-PORT)
           DISPLAY WS-PORT-DESCRIPTION(WS-CURRENT-PORT)
           DISPLAY "----------------------------------------"
           DISPLAY "Argent: " WS-MONEY "$"
           DISPLAY " "
           DISPLAY "1 - Naviguer"
           DISPLAY "2 - Acheter"
           DISPLAY "3 - Vendre"
           DISPLAY "4 - Remplir l'essence (50 000$)"
           DISPLAY " "
           DISPLAY "Votre choix: " WITH NO ADVANCING
           ACCEPT WS-ACTION

           EVALUATE WS-ACTION
               WHEN 0
                   DISPLAY "Placeholder: quitter"
               WHEN 1
                   DISPLAY "Placeholder: naviguer"
               WHEN 2
                   DISPLAY "Placeholder: acheter"
                   PERFORM DISPLAY-GOODS-TABLE
               WHEN 3
                   DISPLAY "Placeholder: vendre"
                   PERFORM DISPLAY-GOODS-TABLE
               WHEN 4
                   DISPLAY "Placeholder: remplir"
               WHEN OTHER
                   DISPLAY "Choix invalide."
           END-EVALUATE

           GOBACK.

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
