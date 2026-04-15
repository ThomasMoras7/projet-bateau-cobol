       IDENTIFICATION DIVISION.
       PROGRAM-ID. ACCOUNT-CREATION.
       AUTHOR Thomas Moras.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT ACCOUNTS-FILE ASSIGN TO "ACCOUNTS.DAT"
                  ORGANIZATION IS SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD ACCOUNTS-FILE.
       01 ACCOUNT-RECORD.
           05 ACCOUNT-ID       PIC X(10).
           05 ACCOUNT-NAME     PIC X(20).
           05 ACCOUNT-BALANCE  PIC S9(10)V99.

       WORKING-STORAGE SECTION.
       01 WS-ACCOUNT-RECORD.
           05 WS-ACCOUNT-ID       PIC X(10).
           05 WS-ACCOUNT-NAME     PIC X(20).
           05 WS-ACCOUNT-BALANCE  PIC S9(10)V99.

       PROCEDURE DIVISION.
           
           MOVE "ACC001"                  TO WS-ACCOUNT-ID.
           MOVE "Jean Dupont         "    TO WS-ACCOUNT-NAME.
           MOVE 1000.00                   TO WS-ACCOUNT-BALANCE.

           OPEN EXTEND ACCOUNTS-FILE.
           IF RETURN-CODE NOT EQUAL 0
               CLOSE ACCOUNTS-FILE
               DISPLAY "Erreur. Impossible d'ouvrir."
               STOP RUN
           END-IF.

           WRITE ACCOUNT-RECORD FROM WS-ACCOUNT-RECORD.
           IF RETURN-CODE NOT EQUAL 0
               CLOSE ACCOUNTS-FILE
               DISPLAY "Erreur. Impossible d'écrire."
               STOP RUN
           END-IF.
s
           CLOSE ACCOUNTS-FILE.
           DISPLAY "Compte ACC001 ajoute."
           STOP RUN.
           