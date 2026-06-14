       IDENTIFICATION DIVISION.
       PROGRAM-ID. PORT-SCREEN.
       AUTHOR. Thomas Moras.

       DATA DIVISION.
       WORKING-STORAGE SECTION.

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
           DISPLAY "1 - Voyager"
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
               WHEN 3
                   DISPLAY "Placeholder: vendre"
               WHEN 4
                   DISPLAY "Placeholder: remplir"
               WHEN OTHER
                   DISPLAY "Choix invalide."
           END-EVALUATE

           GOBACK.
