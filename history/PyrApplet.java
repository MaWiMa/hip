/* nore V.1.0 - 18.jul.2000
* Berechnung der
* Original von Hubert Partl
* http://homepage.boku.ac.at/partl/
*
* */
import java.awt.*;
import java.awt.Color;
import java.awt.event.*;
import java.applet.*;
import java.text.*;

public class PyrApplet extends Applet {

  private PyrCalc pyrCalc;
  private PyrWhere pyrWhere;

  protected Label aLabel, hLabel, errorLabel, messLabel;
  protected TextField aField, hField;
  protected PyrWhat pyrWhat;
//  protected PyrDiagram pyrDiagram;
  protected Panel northPanel;
  protected String mess1 = "Mit [Enter] bestätigen!";
  protected String mess2 = "Format 000.00 beachten!";

  public void init () {

    pyrCalc = new PyrCalc();
    pyrWhere = new PyrWhere (this, pyrCalc);

    setLayout (new BorderLayout() );

    // north panel = input fields and labels

    northPanel = new Panel();
    northPanel.setLayout (new GridLayout(3,2));

    aLabel = new Label("Grundseite a: ", Label.RIGHT);
    northPanel.add(aLabel);
    aField = new TextField("",10);
    aField.addActionListener( pyrWhere );
    northPanel.add(aField);

    hLabel = new Label("Hoehe h: ", Label.RIGHT);
    northPanel.add(hLabel);
    hField = new TextField("",10);
    hField.addActionListener( pyrWhere );
    northPanel.add(hField);

    errorLabel = new Label("", Label.RIGHT);
    errorLabel.setForeground(Color.red);
    northPanel.add(errorLabel);
    messLabel = new Label(mess1, Label.LEFT);
    messLabel.setForeground(Color.green);
    northPanel.add(messLabel);

    add (northPanel, "North");

    // east = table canvas

    pyrWhat = new PyrWhat( pyrCalc );
    add (pyrWhat, "South");

    // center = diagram canvas

//   pyrDiagram = new PyrDiagram(pyrCalc);
//   add (pyrDiagram, "Center");

    setVisible(true);
            setBackground(Color.white);

  }
}