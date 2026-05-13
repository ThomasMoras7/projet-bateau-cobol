       IDENTIFICATION DIVISION.
       PROGRAM-ID. ACCOUNT-LIST.
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
       01 WS-END-OF-FILE-FLAG      PIC 9.
           88 IS-END-OF-FILE       VALUE 1.
           88 IS-NOT-END-OF-FILE   VALUE 0.

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

           *> Read everything
           MOVE 0 TO WS-END-OF-FILE-FLAG.
           PERFORM UNTIL IS-END-OF-FILE
               READ ACCOUNTS-FILE NEXT RECORD
                   AT END
                       MOVE 1 TO WS-END-OF-FILE-FLAG
                   NOT AT END
                       DISPLAY ACCOUNT-ID
                       DISPLAY ACCOUNT-NAME
                       DISPLAY ACCOUNT-BALANCE
                       DISPLAY "-------------------"
               END-READ
           END-PERFORM.

           CLOSE ACCOUNTS-FILE.
           STOP RUN.
