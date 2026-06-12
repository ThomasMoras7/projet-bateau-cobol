       IDENTIFICATION DIVISION.
       PROGRAM-ID. INITIALISATION.
       AUTHOR. Thomas Moras.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       COPY goods-data.
       01 WS-I PIC 9(10).
       01 WS-J PIC 9(10).

       LINKAGE SECTION.
       COPY game-data.
       COPY gd-price.

       PROCEDURE DIVISION USING WS-GAME-DATA WS-GOODS-PRICES-LIST.

           *> Setup state
           MOVE 500 TO WS-MONEY
           MOVE 1 TO WS-CURRENT-PORT
           MOVE 0 TO WS-VISITED-PORTS-COUNT
           MOVE "PLAYING" TO WS-STATUS

           *> Setup goods
           MOVE 1 TO WS-GOOD-ID(1)
           MOVE "Coffee" TO WS-GOOD-NAME(1)
           MOVE 50 TO WS-GOOD-BASE-PRICE(1)
           MOVE 2 TO WS-GOOD-ID(2)
           MOVE "Cotton" TO WS-GOOD-NAME(2)
           MOVE 40 TO WS-GOOD-BASE-PRICE(2)
           MOVE 3 TO WS-GOOD-ID(3)
           MOVE "Spices" TO WS-GOOD-NAME(3)
           MOVE 80 TO WS-GOOD-BASE-PRICE(3)
           MOVE 4 TO WS-GOOD-ID(4)
           MOVE "Wine" TO WS-GOOD-NAME(4)
           MOVE 60 TO WS-GOOD-BASE-PRICE(4)
           MOVE 5 TO WS-GOOD-ID(5)
           MOVE "Electronics" TO WS-GOOD-NAME(5)
           MOVE 120 TO WS-GOOD-BASE-PRICE(5)

           *> Setup prices
           PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I > 5
               MOVE WS-I TO WS-GOODS-PRICES-PORT-ID(WS-I)
               PERFORM VARYING WS-J FROM 1 BY 1 UNTIL WS-J > 5
                   MOVE WS-J TO WS-GOODS-PRICES-GOOD-ID(WS-I, WS-J)
                   COMPUTE WS-GOODS-PRICES-PRICE(WS-I, WS-J) =
                       WS-GOOD-BASE-PRICE(WS-J) *
                       (0.5 + FUNCTION RANDOM)
               END-PERFORM
           END-PERFORM

           GOBACK.
