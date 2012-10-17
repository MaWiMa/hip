#!/usr/bin/ruby
# Gerade Pyramide mit quadratischer Grundfläche
# Kantenlaengen, Hoehen

a = ARGV[0].to_f
h = ARGV[1].to_f

if (a == 0.0 or h == 0.0)  and h != a # beide Werte 0, z.B. keine Parameterangabe, dann wird 1.0 gesetzt, s. b==a
puts "a und b müssen ein Wert größer 0 haben!"
exit

elsif h == 0 and a == 0 then
a,h = 1.0,1.0

end


	ha = Math.sqrt( a**2/4 + h**2 )
	g = Math.sqrt( a**2/4 + ha**2 )
	hg = a*ha/g	# hg = a * sin beta 
# Schmiegen
	alpha = Math.asin(h/ha)
	beta = Math.asin(ha/g)
	omega = Math.asin((Math.sqrt(2)*a/2)/hg) # asin(0.5d/hg)

# Bogenmass in Grad	
	alpha = alpha * 180.0 / Math::PI
	beta = beta * 180.0 / Math::PI
	omega =	omega * 180.0 / Math::PI


puts "Gerade Pyramide mit quadratischer Grundfläche"
puts "Seitenlänge, a:             #{a}"	
puts "Höhe der Pyramide, h:       #{h}"	
puts "Höhe auf a, ha              #{ha}"
puts "Grat der Pyramide, g:       #{g}"	
puts "Grathöhe zum Eckpunkt, hg:  #{hg}"
puts "Winkel alpha:               #{alpha}"
puts "Winkel beta:                #{beta}"
puts "Winkel omega:               #{omega}"

