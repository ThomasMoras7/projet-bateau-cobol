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

           GOBACK.
