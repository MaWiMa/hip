#!/usr/bin/ruby
# 04.Jan.2011
# Tetraeder -> gerade Pyramide mit vier gleichseitigen Dreiecksflächen
# 

a = ARGV[0].to_f

if a == 0.0 
then a = 1.0


end	
	lamda = Math::PI / 3 # Bogenmaß von 60°
	# Winkelhalbierende dw -> Eckpunkt Grundfläche auf a/2
	dw =  Math.sqrt(a**2 - a**2/4)
	ha = dw
	dwk = (a/2)/Math.tan(lamda) # dwk kurzer Abschnitt der Winkelhalbierenden dw  
	dwl = dw - dwk
	h = Math.sqrt( ha**2 - dwk**2)
	g = a 
	hg = ha # hg = a * sin beta 
# Schmiegen
	alpha = Math.asin(h/ha)
	beta = Math.asin(ha/g)
	omega = Math.asin(0.5*a/hg) # omega = 2 * alpha
#omega = a/hg

# Bogenmass in Grad	
	alpha = alpha * 180.0 / Math::PI
	beta = beta * 180 / Math::PI
	lamda = lamda * 180 / Math::PI
	omega =	omega * 180 / Math::PI


puts "Gerade Pyramide mit gleichseitigen Dreiecksflächen"
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

