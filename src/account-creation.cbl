       IDENTIFICATION DIVISION.
       PROGRAM-ID. ACCOUNT-CREATION.
       AUTHOR Thomas Moras.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT ACCOUNTS-FILE ASSIGN TO "ACCOUNTS.DAT"
                  ORGANIZATION IS INDEXED
                  ACCESS MODE IS DYNAMIC
                  RECORD KEY IS ACCOUNT-ID
                  FILE STATUS IS WS-ACCOUNTS-STATUS.
           SELECT COUNTER-FILE ASSIGN TO "ACCOUNTS-COUNTER.DAT"
                  ORGANIZATION IS SEQUENTIAL
                  FILE STATUS IS WS-COUNTER-STATUS.

       DATA DIVISION.
       FILE SECTION.
       FD ACCOUNTS-FILE.
       COPY "ACC-REC".
       FD COUNTER-FILE.
       01 ACCOUNT-COUNTER-RECORD.
           05 LAST-ACCOUNT-ID  PIC 9(10).

       WORKING-STORAGE SECTION.
       01 WS-ACCOUNT-RECORD.
           05 WS-ACCOUNT-ID       PIC X(10).
           05 WS-ACCOUNT-NAME     PIC X(20).
           05 WS-ACCOUNT-BALANCE  PIC S9(10)V99    VALUE 0.
       01 WS-ACCOUNTS-STATUS  PIC XX.
       01 WS-COUNTER-STATUS   PIC XX.

       PROCEDURE DIVISION.

           *> Open ACCOUNTS file
           OPEN I-O ACCOUNTS-FILE.
           IF WS-ACCOUNTS-STATUS = "35"
               DISPLAY "Erreur : impossible d'ouvrir ACCOUNTS.DAT"
               OPEN OUTPUT ACCOUNTS-FILE
               CLOSE ACCOUNTS-FILE
               OPEN I-O ACCOUNTS-FILE
               DISPLAY "ACCOUNTS.DAT cree et ouvert avec succes"
           END-IF.

           *> Open COUNTER file
           OPEN I-O COUNTER-FILE.
           IF WS-COUNTER-STATUS = "35"
               DISPLAY "Erreur : "
               DISPLAY "Impossible d'ouvrir ACCOUNTS-COUNTER.DAT"
               OPEN OUTPUT COUNTER-FILE
               MOVE 0 TO LAST-ACCOUNT-ID
               WRITE ACCOUNT-COUNTER-RECORD
               CLOSE COUNTER-FILE
               OPEN I-O COUNTER-FILE
               DISPLAY "ACCOUNTS-COUNTER.DAT cree et ouvert avec succes"
           END-IF.

           *> Increment ID
           DISPLAY "Recuperation de votre ID..."
           READ COUNTER-FILE.
               IF WS-COUNTER-STATUS = "10"
                    DISPLAY "Erreur : ACCOUNTS-COUNTER.DAT illisible"
                    MOVE 0 TO LAST-ACCOUNT-ID
                    DISPLAY "ACCOUNTS-COUNTER repare avec succes"
               END-IF.
               ADD 1 TO LAST-ACCOUNT-ID
           MOVE LAST-ACCOUNT-ID TO ACCOUNT-COUNTER-RECORD
           REWRITE ACCOUNT-COUNTER-RECORD
           MOVE LAST-ACCOUNT-ID TO WS-ACCOUNT-ID
           DISPLAY "ID : " WS-ACCOUNT-ID

           *> Ask for name
           PERFORM UNTIL WS-ACCOUNT-NAME NOT EQUAL SPACES
           DISPLAY "Entrez votre nom (20 caracteres max) : "
           ACCEPT WS-ACCOUNT-NAME
           IF WS-ACCOUNT-NAME EQUAL SPACES
                   DISPLAY "Erreur : Le nom ne peut pas être vide."
               END-IF
           END-PERFORM.

           *> Write new account
           WRITE ACCOUNT-RECORD FROM WS-ACCOUNT-RECORD.
           IF RETURN-CODE NOT EQUAL 0
               CLOSE ACCOUNTS-FILE
               DISPLAY "Erreur. Impossible d'ecrire ACCOUNTS.DAT"
           ELSE
                DISPLAY "Compte ajoute avec succes !"
           END-IF.

           *> Close all file
           CLOSE ACCOUNTS-FILE.
           CLOSE COUNTER-FILE.

           STOP RUN.
