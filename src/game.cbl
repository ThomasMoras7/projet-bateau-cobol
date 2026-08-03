       IDENTIFICATION DIVISION.
       PROGRAM-ID. GAME.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT SAVE-FILE ASSIGN TO WS-FILE-NAME
               ORGANIZATION IS SEQUENTIAL
               FILE STATUS IS WS-SAVE-FILE-STATUS.

       DATA DIVISION.
       FILE SECTION.
       FD SAVE-FILE.
       COPY save-dat.

       WORKING-STORAGE SECTION.
       01 WS-ACTION PIC 9(01).
       01 WS-ARG PIC 9(10).
       01 WS-SAVE-FILE-STATUS PIC XX.
       01 WS-SLOT-NUMBER PIC 9(01).
       01 WS-FILE-NAME PIC X(30).
       01 WS-LOAD-CHOICE PIC 9(01).
       01 WS-SLOT-OCCUPIED PIC X(01) OCCURS 5.
       01 WS-SAVE-COUNT PIC 9(01).
        01 WS-VALID-SLOT-CHOSEN PIC 9(01).
       01 WS-SLOT-INDEX PIC 9(10).
       01 WS-PRICE-INDEX PIC 9(10).
       01 WS-I PIC 9(10).
       01 WS-J PIC 9(10).
       COPY game-dat.
       COPY port-dat.
       COPY gds-dat.
       COPY pric-dat.

       PROCEDURE DIVISION.

           CALL "INITIALISATION" USING WS-GAME-DATA WS-PORT-TABLE
               WS-GOODS-LIST WS-GOODS-PRICES-LIST

            PERFORM CHECK-EXISTING-SAVES

            *> If save found, asks for load or new game
           IF WS-SAVE-COUNT > 0
                PERFORM DISPLAY-SAVE-LIST

                DISPLAY "Charger (1) ou nouvelle partie (0) ? "
                ACCEPT WS-LOAD-CHOICE
                
                *> If load, asks for slot
                IF WS-LOAD-CHOICE = 1
                    PERFORM ASK-LOAD-SLOT
                    IF WS-VALID-SLOT-CHOSEN = 1
                        PERFORM LOAD-GAME
                    END-IF
                END-IF
           END-IF

           PERFORM UNTIL WS-STATUS NOT = "PLAYING"

               CALL "PORT-SCREEN" USING WS-ACTION WS-ARG WS-GAME-DATA
                   WS-PORT-TABLE WS-GOODS-LIST WS-GOODS-PRICES-LIST

                *> if quit, asks for save
                IF WS-ACTION = 0
                    DISPLAY "Sauvegarder avant de quitter ?"
                    PERFORM ASK-SAVE-SLOT
                    MOVE "QUIT" TO WS-STATUS
                END-IF

                *> if save, asks for slot
                IF WS-ACTION = 5
                    PERFORM ASK-SAVE-SLOT
                END-IF

                *> if load, checks saves and loads
                IF WS-ACTION = 6
                    PERFORM CHECK-EXISTING-SAVES
                    IF WS-SAVE-COUNT > 0
                        PERFORM DISPLAY-SAVE-LIST
                        PERFORM ASK-LOAD-SLOT
                        IF WS-VALID-SLOT-CHOSEN = 1
                            PERFORM LOAD-GAME
                        END-IF
                    ELSE
                        DISPLAY "Aucune sauvegarde disponible."
                    END-IF
                END-IF

           END-PERFORM

           CALL "END-SCREEN" USING WS-GAME-DATA

           STOP RUN.

        CHECK-EXISTING-SAVES.
            
           MOVE 0 TO WS-SAVE-COUNT
            
            *> Scans every 5 slots
            PERFORM VARYING WS-SLOT-INDEX FROM 1 BY 1
                    UNTIL WS-SLOT-INDEX > 5
                
                MOVE '0' TO WS-SLOT-OCCUPIED(WS-SLOT-INDEX)
                
                *> Attemps opening file
                MOVE WS-SLOT-INDEX TO WS-SLOT-NUMBER
                PERFORM BUILD-FILE-NAME
                OPEN INPUT SAVE-FILE
                
                *> If file opens, add to found saves
                IF WS-SAVE-FILE-STATUS = "00"
                    MOVE '1' TO WS-SLOT-OCCUPIED(WS-SLOT-INDEX)
                    ADD 1 TO WS-SAVE-COUNT
                    CLOSE SAVE-FILE
                END-IF

            END-PERFORM
            .

        DISPLAY-SAVE-LIST.

           DISPLAY "Parties sauvegardees:"

           *> Displays each occupied save slot
           PERFORM VARYING WS-SLOT-INDEX FROM 1 BY 1
                    UNTIL WS-SLOT-INDEX > 5
                
                *> If occupied, displays slot
                IF WS-SLOT-OCCUPIED(WS-SLOT-INDEX) = '1'
                    MOVE WS-SLOT-INDEX TO WS-SLOT-NUMBER
                    DISPLAY "  Slot " WS-SLOT-NUMBER
                END-IF

           END-PERFORM
           .

        ASK-LOAD-SLOT.
            MOVE 0 TO WS-VALID-SLOT-CHOSEN

           *> Gets valid answer, 0 to cancel
           PERFORM UNTIL WS-VALID-SLOT-CHOSEN NOT = 0
                DISPLAY "Numero de slot (1-5) ou 0 pour annuler: "
                    WITH NO ADVANCING
                ACCEPT WS-SLOT-NUMBER

                *> if cancel, validates answer but not slot
                IF WS-SLOT-NUMBER = 0
                    MOVE 2 TO WS-VALID-SLOT-CHOSEN
                *> else, validates answer and slot
                ELSE
                    IF WS-SLOT-NUMBER < 1 OR WS-SLOT-NUMBER > 5
                        DISPLAY "Slot invalide."
                    ELSE
                        IF WS-SLOT-OCCUPIED(WS-SLOT-NUMBER) = '1'
                            MOVE 1 TO WS-VALID-SLOT-CHOSEN
                        ELSE
                            DISPLAY "Ce slot est vide."
                        END-IF
                    END-IF
                END-IF
           END-PERFORM
           .

       ASK-SAVE-SLOT.
           MOVE 0 TO WS-VALID-SLOT-CHOSEN

           *> Gets valid answer, 0 to cancel
           PERFORM UNTIL WS-VALID-SLOT-CHOSEN NOT = 0
                DISPLAY "Slot (1-5) ou 0 pour annuler: "
                    WITH NO ADVANCING
                ACCEPT WS-SLOT-NUMBER

                *> If cancel, validates answer but not slot
                IF WS-SLOT-NUMBER = 0
                    MOVE 2 TO WS-VALID-SLOT-CHOSEN
                *> Else, validates answer and slot
                ELSE
                    IF WS-SLOT-NUMBER < 1 OR WS-SLOT-NUMBER > 5
                        DISPLAY "Slot invalide."
                    ELSE
                        MOVE 1 TO WS-VALID-SLOT-CHOSEN
                    END-IF
                END-IF
           END-PERFORM

           IF WS-VALID-SLOT-CHOSEN = 1
                PERFORM SAVE-GAME
           END-IF
           .

       BUILD-FILE-NAME.
           STRING "data/GAME" WS-SLOT-NUMBER ".DAT"
               DELIMITED BY SIZE
               INTO WS-FILE-NAME
           .

       SAVE-GAME.

           *> Saves simple variables
           MOVE WS-MONEY TO WS-SAVE-MONEY
           MOVE WS-CURRENT-PORT TO WS-SAVE-CURRENT-PORT
           MOVE WS-VISITED-PORTS-COUNT TO WS-SAVE-VISITED-PORTS-COUNT
           MOVE WS-STATUS TO WS-SAVE-STATUS
           MOVE WS-FUEL-FLAG TO WS-SAVE-FUEL-FLAG

           *> Save carge table
           PERFORM VARYING WS-I FROM 1 BY 1
                   UNTIL WS-I > 5
               MOVE WS-CARGO-QUANTITY(WS-I)
                   TO WS-SAVE-CARGO-QUANTITY(WS-I)
               MOVE WS-PORT-VISITED(WS-I)
                   TO WS-SAVE-PORT-VISITED(WS-I)
           END-PERFORM

           *> Save price table
           PERFORM VARYING WS-I FROM 1 BY 1
                   UNTIL WS-I > 5
               PERFORM VARYING WS-J FROM 1 BY 1
                       UNTIL WS-J > 5
                   COMPUTE WS-PRICE-INDEX = (WS-I - 1) * 5 + WS-J
                   MOVE WS-GOODS-PRICES-PRICE(WS-I WS-J)
                       TO WS-SAVE-GOODS-PRICES(WS-PRICE-INDEX)
               END-PERFORM
           END-PERFORM

           *> Writes save record
           PERFORM BUILD-FILE-NAME
           OPEN OUTPUT SAVE-FILE

           *> If file can't open, error
           IF WS-SAVE-FILE-STATUS NOT = "00"
                DISPLAY "Echec de l'ouverture du fichier."
           ELSE
                WRITE WS-SAVE-RECORD
                IF WS-SAVE-FILE-STATUS NOT = "00"
                    DISPLAY "Echec de l'ecriture de la sauvegarde."
                ELSE
                    DISPLAY "Sauvegarde effectuee dans le slot "
                        WS-SLOT-NUMBER
                END-IF
                CLOSE SAVE-FILE
           END-IF
           .

       LOAD-GAME.
           *> Opens save
           PERFORM BUILD-FILE-NAME
           OPEN INPUT SAVE-FILE

           *> If save don't opens, error
           IF WS-SAVE-FILE-STATUS NOT = "00"
               DISPLAY "Slot vide."
           *> If save opens, read it
           ELSE
               READ SAVE-FILE

               *> If can't read save, error
               IF WS-SAVE-FILE-STATUS NOT = "00"
                   DISPLAY "Lecture impossible."
                   CLOSE SAVE-FILE
               *> Else, restore state
               ELSE
                   PERFORM RESTORE-STATE
                   CLOSE SAVE-FILE
               END-IF
           END-IF
           .

       RESTORE-STATE.
           
           *> Restores simple variables
           MOVE WS-SAVE-MONEY TO WS-MONEY
           MOVE WS-SAVE-CURRENT-PORT TO WS-CURRENT-PORT
           MOVE WS-SAVE-VISITED-PORTS-COUNT TO WS-VISITED-PORTS-COUNT
           MOVE WS-SAVE-STATUS TO WS-STATUS
           MOVE WS-SAVE-FUEL-FLAG TO WS-FUEL-FLAG
           
           *> Restores cargo table
           PERFORM VARYING WS-I FROM 1 BY 1
                   UNTIL WS-I > 5
               MOVE WS-SAVE-CARGO-QUANTITY(WS-I)
                   TO WS-CARGO-QUANTITY(WS-I)
               MOVE WS-SAVE-PORT-VISITED(WS-I)
                   TO WS-PORT-VISITED(WS-I)
           END-PERFORM

           *> Restores price table
           PERFORM VARYING WS-I FROM 1 BY 1
                   UNTIL WS-I > 5
               PERFORM VARYING WS-J FROM 1 BY 1
                       UNTIL WS-J > 5
                   COMPUTE WS-PRICE-INDEX = (WS-I - 1) * 5 + WS-J
                   MOVE WS-SAVE-GOODS-PRICES(WS-PRICE-INDEX)
                       TO WS-GOODS-PRICES-PRICE(WS-I WS-J)
               END-PERFORM
           END-PERFORM

           MOVE "Partie chargee." TO WS-NOTIFICATION
           .
