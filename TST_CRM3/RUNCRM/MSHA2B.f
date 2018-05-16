      PROGRAM MSHA2B
C
C     Convert the ASCII version of the magnetosheath database to binary.
C
      PARAMETER (MAXKP = 9)
C
      CHARACTER*1 SKIP
      REAL FLXKP(MAXKP)
      INTEGER NUMKP(MAXKP)
C
      OPEN(50,FILE='MSheath_Kp_PROT.BIN',
     $  ACCESS='SEQUENTIAL',FORM='UNFORMATTED',STATUS='UNKNOWN')
C
      OPEN(60,FILE='MSheath_Kp_PROT.ASC',
     $  ACCESS='SEQUENTIAL',FORM='FORMATTED',STATUS='OLD')
C
C     Read the header record in the data file.
      READ(60,1) SKIP
      WRITE(*,*) SKIP
      WRITE(50) SKIP
C
C     Read in the data.
      DO 1000 II = 1,5000000
        ICNT = ICNT + 1
        IF(ICNT.EQ.1000) THEN
          ICNT = 0
          WRITE(*,*)' II = ',II
        END IF
C
        READ(60,100,ERR=1001,END=1002) I,J,K,XD,YD,ZD,
     $    (FLXKP(JJ),JJ=1,MAXKP),(NUMKP(KK),KK=1,MAXKP)
C
D       WRITE(*,*)' II,I,J,K,XD,YD,ZD = ',II,I,J,K,XD,YD,ZD
D       WRITE(*,*)' II,FLXKP(1-9) = ',(FLXKP(JJ),JJ=1,MAXKP)
D       WRITE(*,*)' II,NUMKP(1-9) = ',(NUMKP(JJ),JJ=1,MAXKP)
D       PAUSE
C
        WRITE(50) I,J,K,XD,YD,ZD,
     $    (FLXKP(JJ),JJ=1,MAXKP),(NUMKP(KK),KK=1,MAXKP)
C
1000  CONTINUE
1001  CONTINUE
      WRITE(*,*)
      WRITE(*,*)' Error reading data!  II = ',II
      PAUSE
      STOP 1
1002  CONTINUE
      CLOSE(50)
      CLOSE(60)
C
1     FORMAT(A)
100   FORMAT(1X,3I10,12E12.4,9I12)
C
      STOP
      END
C
C
