C vector_pyramid.f
C Berechnung des Winkels zwischen 2 Pyramidenseiten, einer Pyramide mit 
C quadratischem Grundriß, durch Vektorrechnung (Norbert Reschke 16.6.93, 30.11.2011)      
C Bestimmung der Variablen
      REAL HoeheZ,Seite,x1,x2,x3,y1,y2,y3,z1,z2,z3,a1,a2,a3,b1,b2,b3
      REAL scalar,BtgA,BtgB,normal
      REAL, PARAMETER :: Pi = 3.14159265358979
      WRITE (*,*)'Bitte setzen Sie anstelle von Kommata Punkte ein.'
      WRITE (*,*)'z.B. 13,8 = 13.8'  
      WRITE (*,*)
      WRITE (*,*)'Eingabe der Pyramidenhöhe '
      READ  (*,*) HoeheZ
      WRITE (*,*) 'Eingabe einer Seite der Grundfläche '
      READ  (*,*) Seite
      IF (Seite .EQ. 0.0) THEN
      WRITE (*,*) 'Das Programm ist nicht in der Lage mit einer' 
      WRITE (*,*) 'Seite der Länge 0 zu rechnen !'
          STOP
          END IF  
      x1 = Seite
      x2 = 0.0
      x3 = 0.0
       		y1 = 0.0
       		y2 = Seite
       		y3 = 0.0
        				z1 = Seite/2.0
        				z2 = Seite/2.0
        				z3 = HoeheZ
C Vektorprodukt x kreuz z
      a1 = x2*z3 - x3*z2
      a2 = x3*z1 - x1*z3
      a3 = x1*z2 - x2*z1
C Vektorprodukt z kreuz y = b
      		b1 = z2*y3 - z3*y2
      		b2 = z3*y1 - z1*y3
      		b3 = z1*y2 - z2*y1
C Scalarprodukt a * b       
      scalar = a1*b1 + a2*b2 + a3*b3   
C Betrag von a 
      BtgA = SQRT(a1**2 + a2**2 + a3**2)
C Betrag b 
      BtgB = SQRT(b1**2 + b2**2 + b3**2)       
C Winkel Alpha zwischen den Vektoren a und b im Bogenmaß
      normal = ACOS(scalar/ABS(BtgA*BtgB))
C 
      omega_g = 180 - normal * 180/Pi
C Winkel Beta zwischen zwei Pyramidenseiten , auf 
C denen die Vektoren a und b senkrecht stehen, in Grad    
C     omega = 180-(alpha*57.2957795131)

C      omega = 180.0/Pi
C Schnittwinkel Gamma beim Zuschnitt von Plattenmaterial      
      omega_halb =omega_g/2.0
      
      WRITE (*,*) 'der Winkel Alpha zwischen zwei Seiten einer Pyramide'
      WRITE (*,*) 'mit quadratischem Grundriss beträgt',omega_g,'Grad.'
      WRITE (*,*) 'der Gehrungswinkel einer Seite' 
      WRITE (*,*) 'beträgt ',omega_halb,'Grad.'
      END

