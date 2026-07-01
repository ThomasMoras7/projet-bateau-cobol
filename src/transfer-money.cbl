       IDENTIFICATION DIVISION.
       PROGRAM-ID. TRANSFER-MONEY.
       AUTHOR Thomas Moras.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
            SELECT ACCOUNTS-FILE ASSIGN TO "ACCOUNTS.DAT"
            ORGANIZATION IS INDEXED
            ACCESS MODE IS DYNAMIC
            RECORD KEY IS ACCOUNT-ID
            FILE STATUS IS WS-ACCOUNTS-STATUS.
            SELECT TRANSACTIONS-FILE ASSIGN TO "TRANSACTIONS.DAT"
            ORGANIZATION IS INDEXED
            ACCESS MODE IS DYNAMIC
            RECORD KEY IS TRANSACTION-ID
            FILE STATUS IS WS-TRANSACTIONS-STATUS.
            SELECT TRANSACTIONS-COUNTER-FILE
                ASSIGN TO "TRANSACTIONS-COUNTER.DAT"
            ORGANIZATION IS SEQUENTIAL
            FILE STATUS IS WS-TRANSACTIONS-COUNTER-STATUS.

       DATA DIVISION.
       FILE SECTION.
       FD ACCOUNTS-FILE.
       COPY "ACC-REC".
       FD TRANSACTIONS-FILE.
       COPY "TRAN-REC".
       FD TRANSACTIONS-COUNTER-FILE.
       01 TRANSACTION-COUNTER-RECORD.
           05 LAST-TRANSACTION-ID  PIC 9(10).

       WORKING-STORAGE SECTION.
       01 WS-ACCOUNTS-STATUS       PIC XX.
       01 WS-TRANSACTIONS-STATUS          PIC XX.
       01 WS-TRANSACTIONS-COUNTER-STATUS  PIC XX.
       01 WS-AMOUNT                PIC 9(10)V99.
       01 WS-DEBIT-STATUS          PIC X.
           88 DEBIT-SUCCESSFUL      VALUE "Y".
           88 DEBIT-FAILED          VALUE "N".

       01 WS-SOURCE-ACCOUNT-DATA.
           05 WS-SOURCE-ID            PIC 9(10).
           05 WS-SOURCE-NAME          PIC X(20).
           05 WS-SOURCE-BALANCE       PIC S9(10)V99.

       01 WS-DESTINATION-ACCOUNT-DATA.
           05 WS-DESTINATION-ID           PIC 9(10).
           05 WS-DESTINATION-NAME         PIC X(20).
           05 WS-DESTINATION-BALANCE      PIC S9(10)V99.

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

           *> Ask for Source Account
           DISPLAY "Entrez l'ID du compte a debiter : ".
           ACCEPT WS-SOURCE-ID.
           MOVE WS-SOURCE-ID TO ACCOUNT-ID.
           READ ACCOUNTS-FILE
               INVALID KEY
                   DISPLAY "Erreur : aucun compte trouve."
                   CLOSE ACCOUNTS-FILE
                   STOP RUN
           END-READ.
           MOVE ACCOUNT-RECORD TO WS-SOURCE-ACCOUNT-DATA.

           *> Ask for Destination Account
           DISPLAY "Entrez l'ID du compte a crediter : ".
           ACCEPT WS-DESTINATION-ID.
           MOVE WS-DESTINATION-ID TO ACCOUNT-ID.
           READ ACCOUNTS-FILE
               INVALID KEY
                   DISPLAY "Erreur : aucun compte trouve."
                   CLOSE ACCOUNTS-FILE
                   STOP RUN
           END-READ.
           MOVE ACCOUNT-RECORD TO WS-DESTINATION-ACCOUNT-DATA.

           *> Ask for Amount
           DISPLAY "Entrez le montant a virer : ".
           ACCEPT WS-AMOUNT.

           *> Debit from Source Account
           MOVE "N" TO WS-DEBIT-STATUS
           SUBTRACT WS-AMOUNT FROM WS-SOURCE-BALANCE
           MOVE WS-SOURCE-ACCOUNT-DATA TO ACCOUNT-RECORD
           REWRITE ACCOUNT-RECORD
               INVALID KEY
                   DISPLAY "Erreur : debit impossible."
               NOT INVALID KEY
                   SET DEBIT-SUCCESSFUL TO TRUE
           END-REWRITE.

           *> Update Destination if debit is successful
           IF DEBIT-SUCCESSFUL
               ADD WS-AMOUNT TO WS-DESTINATION-BALANCE
               MOVE WS-DESTINATION-ACCOUNT-DATA TO ACCOUNT-RECORD
               REWRITE ACCOUNT-RECORD
                    INVALID KEY
                        DISPLAY "Erreur : credit impossible."
               END-REWRITE

               *> Open TRANSACTIONS file
               OPEN I-O TRANSACTIONS-FILE
               IF WS-TRANSACTIONS-STATUS = "35"
                    DISPLAY "Erreur : impossible"
                    DISPLAY "d'ouvrir TRANSACTIONS.DAT"
                    OPEN OUTPUT TRANSACTIONS-FILE
                    CLOSE TRANSACTIONS-FILE
                    OPEN I-O TRANSACTIONS-FILE
                    DISPLAY "TRANSACTIONS.DAT cree"
                    DISPLAY "et ouvert avec succes"
               END-IF

               *> Open TRANSACTIONS-COUNTER file
               OPEN I-O TRANSACTIONS-COUNTER-FILE
               IF WS-TRANSACTIONS-COUNTER-STATUS = "35"
                    DISPLAY "Erreur : impossible d'ouvrir"
                    DISPLAY "TRANSACTIONS-COUNTER.DAT"
                    OPEN OUTPUT TRANSACTIONS-COUNTER-FILE
                    MOVE 0 TO LAST-TRANSACTION-ID
                    WRITE TRANSACTION-COUNTER-RECORD
                    CLOSE TRANSACTIONS-COUNTER-FILE
                    OPEN I-O TRANSACTIONS-COUNTER-FILE
                    DISPLAY "TRANSACTIONS-COUNTER.DAT cree"
                    DISPLAY "et ouvert avec succes"
               END-IF

               *> Increment ID
               DISPLAY "Generation de l'ID..."
               READ TRANSACTIONS-COUNTER-FILE
                   IF WS-TRANSACTIONS-COUNTER-STATUS = "10"
                        DISPLAY "Erreur : TRANSACTIONS-COUNTER.DAT"
                        DISPLAY "illisible"
                        MOVE 0 TO LAST-TRANSACTION-ID
                        DISPLAY "TRANSACTIONS-COUNTER repare avec"
                        DISPLAY "succes"
                   END-IF
                   ADD 1 TO LAST-TRANSACTION-ID
               MOVE LAST-TRANSACTION-ID TO TRANSACTION-ID
               REWRITE TRANSACTION-COUNTER-RECORD
   
               *> Write transaction to history
               MOVE WS-SOURCE-ID TO SOURCE-ID
               MOVE WS-DESTINATION-ID TO DESTINATION-ID
               MOVE WS-AMOUNT TO TRANSACTION-AMOUNT
               MOVE FUNCTION CURRENT-DATE TO TRANSACTION-TIMESTAMP
               WRITE TRANSACTION-RECORD
               MOVE LAST-TRANSACTION-ID TO TRANSACTION-COUNTER-RECORD

               *> Display New Balances
               DISPLAY "Virement reussi."
               DISPLAY "Nouveau solde du compte a debiter : "
               DISPLAY WS-SOURCE-BALANCE
               DISPLAY "Nouveau solde du compte a crediter : "
               DISPLAY WS-DESTINATION-BALANCE
           END-IF.

           *> Close all files
           CLOSE ACCOUNTS-FILE.
           CLOSE TRANSACTIONS-FILE.
           CLOSE TRANSACTIONS-COUNTER-FILE.
           STOP RUN.
