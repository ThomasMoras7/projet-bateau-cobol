       IDENTIFICATION DIVISION.
       PROGRAM-ID. INITIALISATION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-I PIC 9(10).
       01 WS-J PIC 9(10).

       LINKAGE SECTION.
       COPY game-dat.
       COPY port-dat.
       COPY gds-dat.
       COPY pric-dat.

       PROCEDURE DIVISION USING WS-GAME-DATA WS-PORT-TABLE
               WS-GOODS-LIST WS-GOODS-PRICES-LIST.

           MOVE 120000 TO WS-MONEY
           MOVE 1 TO WS-CURRENT-PORT
           MOVE 0 TO WS-VISITED-PORTS-COUNT
           MOVE "PLAYING" TO WS-STATUS
           MOVE 0 TO WS-FUEL-FLAG
            MOVE SPACES TO WS-NOTIFICATION

            PERFORM VARYING WS-I FROM 1 BY 1
                    UNTIL WS-I > 5
                MOVE 0 TO WS-CARGO-QUANTITY(WS-I)
            END-PERFORM

            MOVE 1 TO WS-GOOD-ID(1)
           MOVE "Cafe" TO WS-GOOD-NAME(1)
           MOVE 3000 TO WS-GOOD-BASE-PRICE(1)
           MOVE 2 TO WS-GOOD-ID(2)
           MOVE "Coton" TO WS-GOOD-NAME(2)
           MOVE 2000 TO WS-GOOD-BASE-PRICE(2)
           MOVE 3 TO WS-GOOD-ID(3)
           MOVE "Epices" TO WS-GOOD-NAME(3)
           MOVE 5500 TO WS-GOOD-BASE-PRICE(3)
           MOVE 4 TO WS-GOOD-ID(4)
           MOVE "Vin" TO WS-GOOD-NAME(4)
           MOVE 4000 TO WS-GOOD-BASE-PRICE(4)
           MOVE 5 TO WS-GOOD-ID(5)
           MOVE "Electronique" TO WS-GOOD-NAME(5)
           MOVE 9000 TO WS-GOOD-BASE-PRICE(5)

           MOVE 1 TO WS-PORT-ID(1)
           MOVE "Shanghai (Chine)" TO WS-PORT-NAME(1)
           MOVE "Le plus grand port du monde. Trafic non-stop."
               TO WS-PORT-DESCRIPTION(1)
           MOVE 0 TO WS-PORT-VISITED(1)
           MOVE 2 TO WS-PORT-ID(2)
           MOVE "Rotterdam (Pays-Bas)" TO WS-PORT-NAME(2)
           MOVE "Porte d'entree de l'Europe. Attention aux ecluses."
               TO WS-PORT-DESCRIPTION(2)
           MOVE 0 TO WS-PORT-VISITED(2)
           MOVE 3 TO WS-PORT-ID(3)
           MOVE "Singapour (Singapour)" TO WS-PORT-NAME(3)
           MOVE "Plateforme asiatique ultramoderne. Taxes ultra basses."
               TO WS-PORT-DESCRIPTION(3)
           MOVE 0 TO WS-PORT-VISITED(3)
           MOVE 4 TO WS-PORT-ID(4)
           MOVE "New York (Etats-Unis)" TO WS-PORT-NAME(4)
           MOVE "La statue de la Liberte veille sur les bateaux."
               TO WS-PORT-DESCRIPTION(4)
           MOVE 0 TO WS-PORT-VISITED(4)
           MOVE 5 TO WS-PORT-ID(5)
           MOVE "Marseille (France)" TO WS-PORT-NAME(5)
           MOVE "Le premier port de France. Le pastis coule a flots."
               TO WS-PORT-DESCRIPTION(5)
           MOVE 0 TO WS-PORT-VISITED(5)

            PERFORM VARYING WS-I FROM 1 BY 1
                    UNTIL WS-I > 5
                MOVE WS-I TO
                    WS-GOODS-PRICES-PORT-ID(WS-I)
                PERFORM VARYING WS-J FROM 1 BY 1
                        UNTIL WS-J > 5
                    MOVE WS-J TO
                        WS-GOODS-PRICES-GOOD-ID(WS-I,
                        WS-J)
                    COMPUTE WS-GOODS-PRICES-PRICE(WS-I,
                        WS-J) =
                        WS-GOOD-BASE-PRICE(WS-J) *
                        (0.5 + FUNCTION RANDOM)
                END-PERFORM
            END-PERFORM

           GOBACK.
