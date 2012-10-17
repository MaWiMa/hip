/** PyrCalc.java- Norbert Reschke- Berechnungen  17.jul.2000
*  www/fichtenhain.de/wood/pyramid/
*  benoetigt PyrApplet.java, PyrWhere.java, PyrWhat.java
*
 */
	public class PyrCalc
	{	
	private	double a, h, grat, ha, hg;
	private double alpha, beta, omega;
// die Seite a	
  public void setA (double a) {
    this.a = a;
    calculateOmega();
  }
  public double getA () {
    return a;
  }
// die Hoehe h
  public void setH (double h) {
    this.h = h;
    calculateOmega();
  }
  public double getH () {
    return h;
  }
// die Berechnung
  private void calculateOmega() {  		
		// Kantenlaengen, Hoehen
		ha    = Math.sqrt (Math.pow (a,2)/4 +Math.pow (h,2))  ;
		grat  = Math.sqrt (Math.pow (a,2)/4 +Math.pow (ha,2))  ;
		hg    = a*ha/grat ;
		// Schmiegen
		alpha = Math.asin(h/ha);
		beta  = Math.asin(ha/grat);
		omega = Math.asin(Math.sqrt(2)*a/(2*hg));
		// Bogenmass in Grad	
		alpha = alpha*180/Math.PI;
		beta  = beta*180/Math.PI;
		omega =	omega*180/Math.PI;	
				}
//Ausgabe in PyrWhat
public double getHa() {
    return ha;
    }	
public double getGrat() {
    return grat;
    }	
public double getHg() {
    return hg;
    }	
public double getAlpha() {
    return alpha;
    }	
public double getBeta() {
    return beta;
    }	
public double getOmega() {
    return omega;
       }
//          PyrWhat
}