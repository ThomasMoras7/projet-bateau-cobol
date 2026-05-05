       IDENTIFICATION DIVISION.
       PROGRAM-ID. ACCOUNT-DELETION.
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
       01 ACCOUNT-RECORD.
           05 ACCOUNT-ID       PIC 9(10).
           05 ACCOUNT-NAME     PIC X(20).
           05 ACCOUNT-BALANCE  PIC S9(10)V99.

       WORKING-STORAGE SECTION.
       01 WS-ACCOUNT-TO-DELETE-ID PIC 9(10).
       01 WS-ACCOUNTS-STATUS  PIC XX.

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
           DISPLAY "Entrez l'ID du compte a supprimer :"
           ACCEPT WS-ACCOUNT-TO-DELETE-ID

           *> Delete account
           MOVE WS-ACCOUNT-TO-DELETE-ID TO ACCOUNT-ID
           READ ACCOUNTS-FILE KEY IS ACCOUNT-ID
              INVALID KEY DISPLAY "Erreur : compte introuvable"
              NOT INVALID KEY
              DELETE ACCOUNTS-FILE
                  INVALID KEY DISPLAY "Erreur : impossible de supprimer"
                  NOT INVALID KEY DISPLAY "Compte supprime !"
              END-DELETE
           END-READ.

           CLOSE ACCOUNTS-FILE.
           STOP RUN.
