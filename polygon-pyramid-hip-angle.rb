#!/usr/bin/ruby
# Norbert Reschke, 2015-07-16, s. Skizze images/polygon-pyramid-hip-angle.png
# Polygon mit regelmäßiger Grundfläche
# n=Anzahl der Ecken, a=Kantenlänge, h=Höhe
# Berechnung des Innenwinkels zwischen zwei Kanten, gamma (strg+u0263 ->ɣ)
# Berechnung des Umkreisradius (Strecke C,M), r = s
# Berechnung der Mittelsenkrechten auf a durch M, h_a,M
# Berechnung des Kantenwinkels am Grat, omega (strg+u+03C9)
# Berechnung des Winkels zwischen Grat und Radius, beta (strg+u+03B2 -> β)

include Math

BEGIN {	
 unless ARGV.length > 2 && ARGV.length < 4
 puts "n,a und h müssen ein Wert größer 0 haben!"
 abort
 end

n = ARGV[0].to_i
a = ARGV[1].to_f
h = ARGV[2].to_f
 
 if n < 3
 puts "Ein Polygon sollte mindestens 3 Ecken haben!"
 abort
 end

}

# Schmiege
gamma05 = (n-2) * PI * (2*n)**-1

# Strecken
 r    = (a/2) * cos(gamma05)**-1
beta  = atan(h * r**-1)
 h_aM = sin(gamma05) * r
 m    = tan(gamma05) * r
 h_gM = r * sin(beta)
omega = atan(m * h_gM**-1)



# Umrechnung Bogenmaß in Grad	
 gamma05  = gamma05 * 180 *PI**-1
 gamma    = gamma05*2
 beta     = beta * 180 *PI**-1
 omega    = omega * 	180 *PI**-1


puts "-----"
puts "Polygon mit regelmäßiger #{n}-eck-Fläche"
puts "Skizze s. images/polygon-pyramid-hip-angle.svg"
puts "-----"
puts "Seitenlänge, a: #{a}"	
puts "Höhe, h: #{h}"	
puts "-----"
puts "Radius des Umkreises, r: #{r.round(5)}"	
puts "Höhe auf a zu M, h_a,M: #{h_aM.round(5)}"

puts "Winkel ɣ: #{gamma.round(5)}"
puts "Winkel β: #{beta.round(5)}"
puts "Winkel ω: #{omega.round(5)}"

puts "-----"
