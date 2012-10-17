/** V.1.0 nore 17.jul.2000
* Original  von Hubert Partl
* uups, Rundungsfehler in netscape4.72 und ie5.0; beide runden immer nach unten, im appletviewer wird korrekt gerundet
*/


import java.awt.*;
import java.awt.event.*;
import java.text.*;

public class PyrWhat extends Canvas {

  private PyrCalc pyrCalc;
  private double alpha, beta, omega ,a , h, ha, grat, hg;
  private DecimalFormat df =
    new DecimalFormat("0.00 mm");
  private DecimalFormat dfgrad =
    new DecimalFormat("0.00 °");

  public PyrWhat (PyrCalc bm) {
    this.pyrCalc = bm;
  }

  public Dimension getMinimumSize() {
    return new Dimension(300,300);
  }
  public Dimension getPreferredSize() {
    return getMinimumSize();
  }

  public void paint (Graphics g) {
	//wird aus PyrCalc eingelesen
	//Winkel
	alpha = pyrCalc.getAlpha();
    	beta  = pyrCalc.getBeta();
    	omega = pyrCalc.getOmega();
    	//Kantenlaengen
    	a = pyrCalc.getA(); //Eingabekontrolle
    	h = pyrCalc.getH(); //Eingabekontrolle
	ha= pyrCalc.getHa();
    	grat = pyrCalc.getGrat();
    	hg= pyrCalc.getHg();
    	
    Dimension mySize = getSize();
    int width = mySize.width;
    int height = mySize.height;
    int x1 = 10;
    int x2 = width / 2;
    int x3 = width - 10;
    int y1 = 10;
    int dy = (height - 20) / 13;
    int y;



    g.setColor (Color.red);
             y=y1+10;
     g.drawString ("Die berechneten Werte sind auf", x1, y);
y = y + 15;
     g.drawString ("zwei Dezimalstellen gerundet!", x1, y);
y = y + 20;
    	g.setColor (Color.gray);
	g.drawString ("Eingabe", x1, y);
    	g.drawString ("Wert", x2, y);
y = y + 15;
     try {
 	g.setColor (Color.blue);
        g.drawString ("a: ", x1, y);
	g.drawString (df.format(a), x2, y);
	y = y + 15;
 	g.drawString ("h: ", x1, y);
	g.drawString (df.format(h), x2, y);
        }
     catch (Exception e) {
        System.out.println(e);
    }
y = y + 20;
    g.setColor (Color.gray);
	g.drawString ("berechnete Größen", x1, y);
y = y + 15;
    g.drawString ("Kantenlänge", x1, y);
    g.drawString ("Wert", x2, y);
    try {
        y = y + 15;
        g.setColor (Color.blue);
	g.drawString ("ha", x1, y);
	g.drawString (df.format(ha), x2, y);
	y = y + 15;
 	g.drawString ("g:", x1, y);
	g.drawString (df.format(grat), x2, y);
	y = y + 15;
 	g.drawString ("hg:", x1, y);
	g.drawString (df.format(hg), x2, y);
}
catch (Exception e) {
        System.out.println(e);
    }
	
y = y + 15;
        g.setColor (Color.gray);
    	g.drawString ("Winkel", x1, y);
    	g.drawString ("Wert", x2, y);

    try {
	y = y + 15;
 	g.setColor (Color.blue);
 	g.drawString ("alpha:", x1, y);
	g.drawString (dfgrad.format(alpha), x2, y);
        y = y + 15;
 	g.drawString ("beta:", x1, y);
	g.drawString (dfgrad.format(beta), x2, y);
	y = y + 15;
 	g.drawString ("omega:", x1, y);
	g.drawString (dfgrad.format(omega), x2, y);
        }
     catch (Exception e) {
        System.out.println(e);

    }
  }
}