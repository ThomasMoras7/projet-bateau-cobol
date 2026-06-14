       IDENTIFICATION DIVISION.
       PROGRAM-ID. END-SCREEN.

       DATA DIVISION.
       WORKING-STORAGE SECTION.

       LINKAGE SECTION.
       COPY game-dat.

       PROCEDURE DIVISION USING WS-GAME-DATA.

           CALL "SYSTEM" USING "cls"

           DISPLAY "====================================="
           DISPLAY "====================================="
           DISPLAY " "
           EVALUATE WS-STATUS
               WHEN "WON"
                   DISPLAY "  BRAVO ! Vous avez visite tous les"
                   DISPLAY "  ports. Le monde est a vous !"
               WHEN "LOST"
                   DISPLAY "  GAME OVER - Plus assez d'argent"
                   DISPLAY "  pour le carburant."
               WHEN OTHER
                   DISPLAY "  Partie quittee. A bientot !"
           END-EVALUATE
           DISPLAY " "
           DISPLAY "  Argent final: " WS-MONEY "€"
           DISPLAY "  Ports visites: " WS-VISITED-PORTS-COUNT
           DISPLAY " "
           DISPLAY "====================================="
           DISPLAY "====================================="

           GOBACK.
