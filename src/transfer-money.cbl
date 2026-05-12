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

       DATA DIVISION.
       FILE SECTION.
       FD ACCOUNTS-FILE.
       COPY "ACC-REC".

       WORKING-STORAGE SECTION.
       01 WS-ACCOUNTS-STATUS       PIC XX.
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
           END-IF.

           *> Display New Balances
           DISPLAY "Virement reussi."
           DISPLAY "Nouveau solde du compte a debiter : "
           DISPLAY WS-SOURCE-BALANCE
           DISPLAY "Nouveau solde du compte a crediter : "
           DISPLAY WS-DESTINATION-BALANCE

           CLOSE ACCOUNTS-FILE.
           STOP RUN.
