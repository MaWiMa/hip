#!/usr/bin/ruby
# Norbert Reschke, 2015-06-18, s. Skizze images/polygon-angle.png
# Polygon mit regelmäßiger Grundfläche
# n=Anzahl der Ecken, a=Kantenlänge,
# Berechnung des Innenwinkels zwischen zwei Kanten, gamma (strg+u0263 ->ɣ)
# Berechnung des Umkreisradius (Strecke C,M), r_u = s
# Berechnung der Mittelsenkrechten auf a durch M, h_a,M

include Math

n = ARGV[0].to_i
a = ARGV[1].to_f
	
if (n == 0.0 or a == 0.0)  and a != n # beide Werte 0, z.B. keine Parameterangabe, dann wird 1.0 gesetzt, s. b==a
puts "n und a müssen ein Wert größer 0 haben!"
exit
elsif n == 0 and a == 0 then
puts "n und a müssen ein Wert größer 0 haben!"
exit
end


# Schmiege
gamma05 = (n-2) * PI * (2*n)**-1

# Strecken
 r_u = (a/2) * cos(gamma05)**-1
 h_aM = sin(gamma05) * r_u

# Umrechnung Bogenmaß in Grad	
 gamma05 = gamma05 * 180 *PI**-1
 gamma = gamma05*2

puts "-----"
puts "Polygon mit regelmäßiger #{n}-eck-Fläche"
puts "Skizze s. images/polygon-angle.svg"
puts "-----"
puts "Seitenlänge, a: #{a}"	
puts "Winkel ɣ: #{gamma.round(5)}"
puts "-----"
puts "Radius des Umkreises, r_u: #{r_u.round(5)}"	
puts "Höhe auf a zu M, h_a,M: #{h_aM.round(5)}"
puts "-----"
