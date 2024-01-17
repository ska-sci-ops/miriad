C***********************************************************************
c*SPOCO -- Factor a real symmetrix positive definite matrix.
c:LINPACK
c+
      SUBROUTINE SPOCO(A,LDA,N,RCOND,Z,INFO)
      INTEGER LDA,N,INFO
      REAL A(LDA,1),Z(1)
      REAL RCOND
C
C     SPOCO FACTORS A REAL SYMMETRIC POSITIVE DEFINITE MATRIX
C     AND ESTIMATES THE CONDITION OF THE MATRIX.
C
C     IF  RCOND	 IS NOT NEEDED, SPOFA IS SLIGHTLY FASTER.
C     TO SOLVE	A*X = B , FOLLOW SPOCO BY SPOSL.
C     TO COMPUTE  INVERSE(A)*C , FOLLOW SPOCO BY SPOSL.
C     TO COMPUTE  DETERMINANT(A) , FOLLOW SPOCO BY SPODI.
C     TO COMPUTE  INVERSE(A) , FOLLOW SPOCO BY SPODI.
C
C     ON ENTRY
C
C	 A	 REAL(LDA, N)
C		 THE SYMMETRIC MATRIX TO BE FACTORED.  ONLY THE
C		 DIAGONAL AND UPPER TRIANGLE ARE USED.
C
C	 LDA	 INTEGER
C		 THE LEADING DIMENSION OF THE ARRAY  A .
C
C	 N	 INTEGER
C		 THE ORDER OF THE MATRIX  A .
C
C     ON RETURN
C
C	 A	 AN UPPER TRIANGULAR MATRIX  R	SO THAT	 A = TRANS(R)*R
C		 WHERE	TRANS(R)  IS THE TRANSPOSE.
C		 THE STRICT LOWER TRIANGLE IS UNALTERED.
C		 IF  INFO .NE. 0 , THE FACTORIZATION IS NOT COMPLETE.
C
C	 RCOND	 REAL
C		 AN ESTIMATE OF THE RECIPROCAL CONDITION OF  A .
C		 FOR THE SYSTEM	 A*X = B , RELATIVE PERTURBATIONS
C		 IN  A	AND  B	OF SIZE	 EPSILON  MAY CAUSE
C		 RELATIVE PERTURBATIONS IN  X  OF SIZE	EPSILON/RCOND .
C		 IF  RCOND  IS SO SMALL THAT THE LOGICAL EXPRESSION
C			    1.0 + RCOND .EQ. 1.0
C		 IS TRUE, THEN	A  MAY BE SINGULAR TO WORKING
C		 PRECISION.  IN PARTICULAR,  RCOND  IS ZERO  IF
C		 EXACT SINGULARITY IS DETECTED OR THE ESTIMATE
C		 UNDERFLOWS.  IF INFO .NE. 0 , RCOND IS UNCHANGED.
C
C	 Z	 REAL(N)
C		 A WORK VECTOR WHOSE CONTENTS ARE USUALLY UNIMPORTANT.
C		 IF  A	IS CLOSE TO A SINGULAR MATRIX, THEN  Z	IS
C		 AN APPROXIMATE NULL VECTOR IN THE SENSE THAT
C		 NORM(A*Z) = RCOND*NORM(A)*NORM(Z) .
C		 IF  INFO .NE. 0 , Z  IS UNCHANGED.
C
C	 INFO	 INTEGER
C		 = 0  FOR NORMAL RETURN.
C		 = K  SIGNALS AN ERROR CONDITION.  THE LEADING MINOR
C		      OF ORDER	K  IS NOT POSITIVE DEFINITE.
C
C--
C     LINPACK.	THIS VERSION DATED 08/14/78 .
C     CLEVE MOLER, UNIVERSITY OF NEW MEXICO, ARGONNE NATIONAL LAB.
C
C     SUBROUTINES AND FUNCTIONS
C
C     LINPACK SPOFA
C     BLAS SAXPY,SDOT,SSCAL,SASUM
C     FORTRAN ABS,AMAX1,REAL,SIGN
C
C     INTERNAL VARIABLES
C
      REAL SDOT,EK,T,WK,WKM
      REAL ANORM,S,SASUM,SM,YNORM
      INTEGER I,J,JM1,K,KB,KP1
C
C
C     FIND NORM OF A USING ONLY UPPER HALF
C
      DO 30 J = 1, N
	 Z(J) = SASUM(J,A(1,J),1)
	 JM1 = J - 1
	 IF (JM1 .LT. 1) GO TO 20
	 DO 10 I = 1, JM1
	    Z(I) = Z(I) + ABS(A(I,J))
   10	 CONTINUE
   20	 CONTINUE
   30 CONTINUE
      ANORM = 0.0E0
      DO 40 J = 1, N
	 ANORM = AMAX1(ANORM,Z(J))
   40 CONTINUE
C
C     FACTOR
C
      CALL SPOFA(A,LDA,N,INFO)
      IF (INFO .NE. 0) GO TO 180
C
C	 RCOND = 1/(NORM(A)*(ESTIMATE OF NORM(INVERSE(A)))) .
C	 ESTIMATE = NORM(Z)/NORM(Y) WHERE  A*Z = Y  AND	 A*Y = E .
C	 THE COMPONENTS OF  E  ARE CHOSEN TO CAUSE MAXIMUM LOCAL
C	 GROWTH IN THE ELEMENTS OF W  WHERE  TRANS(R)*W = E .
C	 THE VECTORS ARE FREQUENTLY RESCALED TO AVOID OVERFLOW.
C
C	 SOLVE TRANS(R)*W = E
C
	 EK = 1.0E0
	 DO 50 J = 1, N
	    Z(J) = 0.0E0
   50	 CONTINUE
	 DO 110 K = 1, N
	    IF (Z(K) .NE. 0.0E0) EK = SIGN(EK,-Z(K))
	    IF (ABS(EK-Z(K)) .LE. A(K,K)) GO TO 60
	       S = A(K,K)/ABS(EK-Z(K))
	       CALL SSCAL(N,S,Z,1)
	       EK = S*EK
   60	    CONTINUE
	    WK = EK - Z(K)
	    WKM = -EK - Z(K)
	    S = ABS(WK)
	    SM = ABS(WKM)
	    WK = WK/A(K,K)
	    WKM = WKM/A(K,K)
	    KP1 = K + 1
	    IF (KP1 .GT. N) GO TO 100
	       DO 70 J = KP1, N
		  SM = SM + ABS(Z(J)+WKM*A(K,J))
		  Z(J) = Z(J) + WK*A(K,J)
		  S = S + ABS(Z(J))
   70	       CONTINUE
	       IF (S .GE. SM) GO TO 90
		  T = WKM - WK
		  WK = WKM
		  DO 80 J = KP1, N
		     Z(J) = Z(J) + T*A(K,J)
   80		  CONTINUE
   90	       CONTINUE
  100	    CONTINUE
	    Z(K) = WK
  110	 CONTINUE
	 S = 1.0E0/SASUM(N,Z,1)
	 CALL SSCAL(N,S,Z,1)
C
C	 SOLVE R*Y = W
C
	 DO 130 KB = 1, N
	    K = N + 1 - KB
	    IF (ABS(Z(K)) .LE. A(K,K)) GO TO 120
	       S = A(K,K)/ABS(Z(K))
	       CALL SSCAL(N,S,Z,1)
  120	    CONTINUE
	    Z(K) = Z(K)/A(K,K)
	    T = -Z(K)
	    CALL SAXPY(K-1,T,A(1,K),1,Z(1),1)
  130	 CONTINUE
	 S = 1.0E0/SASUM(N,Z,1)
	 CALL SSCAL(N,S,Z,1)
C
	 YNORM = 1.0E0
C
C	 SOLVE TRANS(R)*V = Y
C
	 DO 150 K = 1, N
	    Z(K) = Z(K) - SDOT(K-1,A(1,K),1,Z(1),1)
	    IF (ABS(Z(K)) .LE. A(K,K)) GO TO 140
	       S = A(K,K)/ABS(Z(K))
	       CALL SSCAL(N,S,Z,1)
	       YNORM = S*YNORM
  140	    CONTINUE
	    Z(K) = Z(K)/A(K,K)
  150	 CONTINUE
	 S = 1.0E0/SASUM(N,Z,1)
	 CALL SSCAL(N,S,Z,1)
	 YNORM = S*YNORM
C
C	 SOLVE R*Z = V
C
	 DO 170 KB = 1, N
	    K = N + 1 - KB
	    IF (ABS(Z(K)) .LE. A(K,K)) GO TO 160
	       S = A(K,K)/ABS(Z(K))
	       CALL SSCAL(N,S,Z,1)
	       YNORM = S*YNORM
  160	    CONTINUE
	    Z(K) = Z(K)/A(K,K)
	    T = -Z(K)
	    CALL SAXPY(K-1,T,A(1,K),1,Z(1),1)
  170	 CONTINUE
C	 MAKE ZNORM = 1.0
	 S = 1.0E0/SASUM(N,Z,1)
	 CALL SSCAL(N,S,Z,1)
	 YNORM = S*YNORM
C
	 IF (ANORM .NE. 0.0E0) RCOND = YNORM/ANORM
	 IF (ANORM .EQ. 0.0E0) RCOND = 0.0E0
  180 CONTINUE
      RETURN
      END