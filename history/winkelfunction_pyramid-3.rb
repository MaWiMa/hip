#!/usr/bin/ruby
# 04.Jan.2011
# Gerade Pyramide mit gleichseitiger Dreiecksgrundfläche
# Kantenlaengen, Hoehen

a = ARGV[0].to_f
h = ARGV[1].to_f

if (a == 0.0 or h == 0.0)  and h != a # beide Werte 0, z.B. keine Parameterangabe, dann wird 1.0 gesetzt, s. b==a
puts "a und b müssen ein Wert größer 0 haben!"
exit

elsif h == 0 and a == 0 then
a,h = 1.0,1.0

end	
	lamda = Math::PI / 3 # Bogenmaß von 60°
	# Winkelhalbierende dw -> Eckpunkt Grundfläche auf a/2
	dw =  Math.sqrt(a**2 - a**2/4)
	dwk = (a/2)/Math.tan(lamda) # dwk kurzer Abschnitt der Winkelhalbierenden dw  
	dwl = dw - dwk
	ha = Math.sqrt( dwk**2 + h**2 )
	g = Math.sqrt( a**2/4 + ha**2 ) 
	hg = a*ha/g # hg = a * sin beta 
# Schmiegen
	alpha = Math.asin(h/ha)
	beta = Math.asin(ha/g)
	omega = Math.asin(0.5*a/hg)
#omega = a/hg

# Bogenmass in Grad	
	alpha = alpha * 180.0 / Math::PI
	beta = beta * 180 / Math::PI
	lamda = lamda * 180 / Math::PI
	omega =	omega * 180 / Math::PI


puts "Gerade Pyramide mit gleichseitiger Dreiecksgrundfläche"
puts lamda
puts "Seitenlänge, a:             #{a}"	
puts "Höhe der Pyramide, h:       #{h}"	
puts "Winkelhalbierende dw:       #{dw}"
puts "Winkelhalbierende dwk:      #{dwk}"
puts "Winkelhalbierende dwl:      #{dwl}"
puts "Höhe auf a, ha              #{ha}"
puts "Grat der Pyramide, g:       #{g}"	
puts "Grathöhe zum Eckpunkt, hg:  #{hg}"
puts "Winkel alpha:               #{alpha}"
puts "Winkel beta:                #{beta}"
puts "Winkel omega:               #{omega}"

