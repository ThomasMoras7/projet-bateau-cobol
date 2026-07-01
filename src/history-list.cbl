       IDENTIFICATION DIVISION.
       PROGRAM-ID. HISTORY-LIST.
       AUTHOR Thomas Moras.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT TRANSACTIONS-FILE ASSIGN TO "TRANSACTIONS.DAT"
           ORGANIZATION IS INDEXED
           ACCESS MODE IS DYNAMIC
           RECORD KEY IS TRANSACTION-ID
           FILE STATUS IS WS-TRANSACTIONS-STATUS.

       DATA DIVISION.
       FILE SECTION.
       FD TRANSACTIONS-FILE.
       COPY "TRAN-REC".

       WORKING-STORAGE SECTION.
       01 WS-TRANSACTIONS-STATUS       PIC XX.
       01 WS-END-OF-FILE-FLAG          PIC 9.
           88 IS-END-OF-FILE           VALUE 1.
           88 IS-NOT-END-OF-FILE       VALUE 0.

       PROCEDURE DIVISION.

           *> Open TRANSACTIONS file
           OPEN I-O TRANSACTIONS-FILE.
           IF WS-TRANSACTIONS-STATUS = "35"
               DISPLAY "Erreur : impossible d'ouvrir TRANSACTIONS.DAT"
               OPEN OUTPUT TRANSACTIONS-FILE
               CLOSE TRANSACTIONS-FILE
               OPEN I-O TRANSACTIONS-FILE
               DISPLAY "TRANSACTIONS.DAT cree et ouvert avec succes"
           END-IF.

           *> Read everything
           MOVE 0 TO WS-END-OF-FILE-FLAG.
           PERFORM UNTIL IS-END-OF-FILE
               READ TRANSACTIONS-FILE NEXT RECORD
                   AT END
                       MOVE 1 TO WS-END-OF-FILE-FLAG
                   NOT AT END
                       DISPLAY "------------------- "
                       DISPLAY "Transaction : " TRANSACTION-ID
                       DISPLAY "Source      : " SOURCE-ID
                       DISPLAY "Destination : " DESTINATION-ID
                       DISPLAY "Montant     : " TRANSACTION-AMOUNT
                       DISPLAY "Date        : " TRANSACTION-TIMESTAMP
                       DISPLAY " "
               END-READ
           END-PERFORM.

           CLOSE TRANSACTIONS-FILE.
           STOP RUN.
