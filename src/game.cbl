       IDENTIFICATION DIVISION.
       PROGRAM-ID. GAME.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-ACTION PIC 9(01).
       01 WS-ARG PIC 9(10).
       COPY game-dat.
       COPY port-dat.
       COPY gds-dat.
       COPY pric-dat.

       PROCEDURE DIVISION.

           CALL "INITIALISATION" USING WS-GAME-DATA WS-PORT-TABLE
               WS-GOODS-LIST WS-GOODS-PRICES-LIST

           PERFORM UNTIL WS-STATUS NOT = "PLAYING"

               CALL "PORT-SCREEN" USING WS-ACTION WS-ARG WS-GAME-DATA
                   WS-PORT-TABLE WS-GOODS-LIST WS-GOODS-PRICES-LIST

               IF WS-ACTION = 0
                   MOVE "QUIT" TO WS-STATUS
               END-IF

           END-PERFORM

           CALL "END-SCREEN" USING WS-GAME-DATA

           STOP RUN.
