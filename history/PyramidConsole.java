// PyramidConsole.java- V.1.02 - Norbert Reschke (fortran 16.jun.1993 - java 10.jul.2000)
/** 	Berechnung der Schmiegen von Seiten einer Pyramide mit quadratischem Grundriss
*	s. http://www.fichtenhain.de/wood/pyramide
*	Grundseite= a; Hoehe= h; Grat= g; Hoehe auf die Grundseite= ha; Hoehe auf den Grat= hg;
*	Schmiege zwischen Grund- und Seitenflaeche= alpha; Schmiege zwischen Grat und Grundseite= beta;
*	Schmiege einer Pyramidenseite= omega */

// Rufen sie javac PyramidConsole.java auf; anschliessend java PyramidConsole

import java.io.*;
public class PyramidConsole
{
	public static void main(String args[])	
	throws IOException
       	{
	System.out.println("::::::::::::::::::::::::::::::::::::::::::::::");
	System.out.println("- PyramidConsole -V.1.01 - dient zur Berechnung von Kantenlaengen, Hoehen und Schmiegen einer Pyramide.");
	System.out.println("Die noetigen Formeln koennen sie im Quelltext (PyramidConsole.java) nachlesen.");
	System.out.println("Ueberpruefen sie mit Taschenrechner oder anderen Hilfsmitteln die Berechnung!");
	System.out.println("::::::::::::::::::::::::::::::::::::::::::::::");
	System.out.println("Der Sinngehalt der Eingaben und Ausgaben ist nur mit zusaetzlichen Erlaeuterungen");
	System.out.println("und entsprechendem Bildmaterial zugaenglich.");
	System.out.println("Naeheres erfahren sie unter www.fichtenhain.de/wood/pyramid/");
       	System.out.println("::::::::::::::::::::::::::::::::::::::::::::::");	
	double a, h, g, ha, hg;
	double alpha, beta, omega;
	
//io-Routine aus www.gkrueger.com/k100026.html#sectlevel3id003005003       	
       	BufferedReader din = new BufferedReader(
       	new InputStreamReader(System.in));
	System.out.println("::-> Bitte geben sie einen Wert fuer die Grundseite a ein:");
       	a = Integer.parseInt(din.readLine());
       	System.out.println("::-> Bitte geben sie einen Wert fuer die Hoehe h ein:");
       	h = Integer.parseInt(din.readLine());	
// Ueberpruefen sie diese Formeln mit dem Taschenrechner!
// Beurteilen sie anhand des Bildes -Pyramide01- auf -www.fichtenhain.de/wood/pyramid/ den Loesungsweg!
// Start- Diese Formeln werden zur Berechnung (vergl. Bild1 auf www.fichtenhain.de/wood/pyramid/) gebraucht.		
		// Kantenlaengen
		ha    = Math.sqrt (Math.pow (a,2)/4 +Math.pow (h,2))  ;
		g     = Math.sqrt (Math.pow (a,2)/4 +Math.pow (ha,2))  ;
		hg    = a*ha/g ;
		// Winkel
		alpha = Math.asin(h/ha);
		beta  = Math.asin(ha/g);
		omega = Math.asin(Math.sqrt(2)*a/(2*hg));
// stop		
// Gibt es eine zeichnerische Variante?
// Suchen sie eine schnelle zeichnerische Loesung!   		

		{
			System.out.println("::::::::::::::::::::::::::::::::::::::");
			System.out.println("::::::::::::::::::::::::::::::::::::::");			
			System.out.println("-> Ihre Eingabe   ::::::::::::::::::::");
			System.out.println("   a      = "+a);
			System.out.println("   h      = "+h);
			System.out.println("::::::::::::::::::::::::::::::::::::::");
			System.out.println("::::::::::::::::::::::::::::::::::::::");
			System.out.println("-> Kantenlaenge/ Hoehen   ::::::::::::");
			System.out.println("::::::::::::::::::::::::::::::::::::::");
			System.out.println("   ha     = "+ha);
			System.out.println("   g      = "+g);
			System.out.println("   hg     = "+hg);
			System.out.println("-> Schmiegen   :::::::::::::::::::::::");
			System.out.println("::::::::::::::::::::::::::::::::::::::");
			System.out.println("   alpha  = "+alpha*180/Math.PI);
                        System.out.println("   beta   = "+beta*180/Math.PI);
                        System.out.println("   omega  = "+omega*180/Math.PI);
                        System.out.println("::::::::::::::::::::::::::::::::::::::");
			System.out.println("::::::::::::::::::::::::::::::::::::::");		
		}
	}
}









