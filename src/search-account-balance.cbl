       IDENTIFICATION DIVISION.
       PROGRAM-ID. SEARCH-ACCOUNT-BALANCE.
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
       01 WS-SEARCH-ID             PIC 9(10).

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

           *> Ask for ID
           DISPLAY "Entrez l'ID du compte : ".
           ACCEPT WS-SEARCH-ID.

           *> Read record
           MOVE WS-SEARCH-ID TO ACCOUNT-ID.
           READ ACCOUNTS-FILE
               INVALID KEY
                   DISPLAY "Erreur : aucun compte trouvé."
               NOT INVALID KEY
                   DISPLAY "Solde du compte " ACCOUNT-ID " : "
                   DISPLAY ACCOUNT-BALANCE
           END-READ.

           CLOSE ACCOUNTS-FILE.
           STOP RUN.
