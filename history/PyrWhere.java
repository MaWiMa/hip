import java.awt.*;
import java.awt.event.*;
import java.applet.*;
import java.text.*;

public class PyrWhere implements ActionListener {

  private PyrCalc calc;
  private PyrApplet applet;

  public PyrWhere (PyrApplet ba, PyrCalc bm) {
    this.applet = ba;
    this.calc = bm;
  }

  public void actionPerformed (ActionEvent e) {
    try {
      calc.setA( Double.valueOf (
        applet.aField.getText().trim()
        ).doubleValue() );
      calc.setH( Double.valueOf (
        applet.hField.getText().trim()
        ).doubleValue() );

      applet.errorLabel.setText("");
      applet.messLabel.setText(applet.mess1);
      applet.pyrWhat.repaint();
//      applet.pyrDiagram.repaint();

    } catch (Exception ex) {
        applet.errorLabel.setText("Fehler:");
        applet.messLabel.setText(applet.mess2);
    }
  }
}