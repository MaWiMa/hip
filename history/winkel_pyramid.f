C Berechnung der Winkel zwischen 2 Pyramidenseiten, und zwischen 
C Seite und Grundfläche, einer Pyramide mit quadratischem Grundriß, 
C Mithilfe  der Winkelfunktionen (Norbert Reschke 16.6.93)
      
C Bestimmung der Variablen

      REAL Hoehe,Seite,Grunds,b,c,d,alpha,alphaG,gamma,delta
      REAL, PARAMETER :: Pi = 3.14159265358979
      WRITE (*,*)'Bitte setzen Sie anstelle von Kommata Punkte ein.'
      WRITE (*,*)'z.B. 13,8 = 13.8'  
      WRITE (*,*)
      WRITE (*,*)'Eingabe der Pyramidenhöhe'
      READ  (*,*) Hoehe
      IF (Hoehe .EQ. 0.0) THEN 
      WRITE (*,*) 'Das Programm ist nicht in der Lage mit einer' 
      WRITE (*,*) 'Höhe der Länge 0 zu rechnen !'
          STOP        
      ELSE            
      WRITE (*,*) 'Eingabe einer Seite der Grundfläche '
         END IF
      READ  (*,*) Grunds
      IF (Grunds .EQ. 0.0) THEN
      WRITE (*,*) 'Das Programm ist nicht in der Lage mit einer' 
      WRITE (*,*) 'Seite der Länge 0 zu rechnen !'
          STOP        
         END IF            

      Seite = SQRT(Hoehe**2 + (Grunds**2/4.0))

C Winkel alpha zwischen Seite und Grundfläche im Bogenmaß

      alpha = ATAN(Hoehe/(Grunds/2.0))
      
      alphaG= alpha*180.0/Pi
     
C Lot von Seite (B) auf Mittelpunkt Grundfläche (M)

          b = SIN(alpha)*(Grunds/2.0)
      
C Lot von (B) auf (C) ,c = Strecke (C,M)            

          c = SIN(alpha)*b

C Strecke (C,C) in der Grundfläche 

          d = SQRT(2.0)*c
          
C 2Gamma = Winkel b,b
      gamma = ASIN(0.5 * d/b)
C omega = Math.asin((Math.sqrt(2)*a/2)/hg) # asin(0.5d/hg)
                                   
C delta = Hälfte des Winkels zwischen 2 Pyramiden Seiten
      delta = (1.5708 - gamma)*180/Pi    
C       delta = gamma * 180.0/Pi   
      WRITE (*,*) 'der Winkel Alpha,einer Pyramide' 
      WRITE (*,*) ' mit quadrt. Grundriss,' 
      WRITE (*,*) 'zwischen Seite und Grundfläche' 
      WRITE (*,*) 'beträgt      ',alphaG, '  Grad.'
      WRITE (*,*) 'der Gehrungswinkel einer Seite' 
      WRITE (*,*) 'beträgt      ',delta,  '  Grad.'
      END
