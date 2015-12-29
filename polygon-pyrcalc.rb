#!/usr/bin/ruby
# encoding: utf-8
# polygon-pyrcalc.rb
# https://github.com/MaWiMa/hip
# Norbert Reschke
# Kantenwinkel ω am Grat (hip-angle) einer geraden Pyramide mit regelmäßiger Grundfläche
# Skizze siehe images/polygon-pyramid-hip-angleGL.png

require 'matrix'
include Math

class Pyramid
attr_reader :d, :ha, :g, :hg, :hgm, :alpha, :beta, :gamma, :r, :omega, :z, :y, :x, :vec_G, :vec_1, :vec_2, :vec_3, :vec_4, :vec_5, :vec_6

def initialize(n,a,h)

@n = n # number of edges
@a = a # edge length
@h = h # height


@gamma = (n-2) * PI * (2*n)**-1
@r       = (a/2) * cos(@gamma)**-1
@beta    = atan(h * @r**-1)
#@h_aM    = sin(@gamma) * @r
@m       = tan(@gamma) * @r
@h_gM    = @r * sin(@beta)
@omega = atan(@m * @h_gM**-1)
@z     = sqrt(h_gM**2 + m**2)


phi = PI * 2**-1 - @gamma * 2 # pi - ɣ

r_o  = sin(@beta) * @h_gM
h_gr = sqrt(@h_gM**2 - ro**2)


for i in (2..n)

t    = @r * cos(phi * (i-1))
u    = @r * sin(phi * (i-1))

vec_i = "vec_" + i.to_s
@vec_i = Vector[u,t,0.0]         

return @vec_i
end


###
#@d = sqrt(2)*a                       # Diagonale der Pyramidengrundseite
#@ha = sqrt( a**2/4 + h**2 )          # Höhe der Pyramidenseitenfläche auf a
#@g = sqrt( a**2/4 + @ha**2 )         # Grat der Pyramide
#@hg = a*@ha/@g                       # Höhe der Pyramidenseitenfläche auf dem Grat, linker Schenkel OMEGA
                                     # Vektorpunkt auf dem Grat (Ursprung Omega)
@hgm = sqrt(@hg**2 - (@d/2)**2)      # rechter Schenkel OMEGA


# Schmiegen der Pyramide im Bogenmaß
#@alpha_b = asin(h/@ha)               # Winkel zwischen Grundfläche und Seitenfläche (Winkelebene schneidet beide Flächen senkrecht)
#@beta_b = asin(@ha/@g)               # Winkel zwischen Grad und Grundseite (beide Kanten liegen in der Winkelebene) 
#@gamma_b = acos(@hgm/(@d/2))         # Winkel am Mittelpunkt zwischen Grundfläche und der von OMEGA aufgespannten Fläche (Winkelebene schneidet beide Flächen senkrecht)
#@omega_b = asin(sqrt(2)*a/(2*@hg))

# in Grad (für die Ausgabe)	
#@alpha = @alpha_b * 180.0 / PI
#@beta  = (asin(@ha/@g)) * 180 / PI
#@gamma = @gamma_b * 180.0 / PI
#@omega = (asin(sqrt(2)*a/(2*@hg))) * 180 / PI

#	Vektorpunkte (x,y,z)

#@x_g = 0     
#@y_g = -r_o
#@z_g = h_gr 


@vec_M = Vector[0,0,0]           # center of polygon  
@vec_G = Vector[0,-r_o,h_gr]  # point on hip (g,h_gM)
@vec_S = Vector[0,0,h]           # top


@vec_1 = Vector[0.0,-@r,0.0]       
@vec_2 = Vector[u,-t,0.0]         
@vec_n = Vector[-u,-t,0.0]         


@vec_3 = Vector[a,0.0,0.0]           # Fußpunkt unten links
@vec_4 = Vector[a,a,0.0]             # Fußpunkt unten rechts
@vec_5 = Vector[0.0,a,0.0]           # Fußpunkt oben rechts
@vec_6 = Vector[a/2,a/2,0.0]         # Mittelpunkt der Grundfläche
end

### Normalenvektorenberechnungen für die Beleuchtung
# v and w are Vectors (see http://www.ruby-doc.org/core/classes/Vector.html, http://gpwiki.org/index.php/MathGem:Vector_Operations#Ruby); ruby needs require 'matrix'
# 0 -> x, 1 -> y, 2 -> z
def cross( v, w )
    x = v[1]*w[2] - v[2]*w[1]
    y = v[2]*w[0] - v[0]*w[2]
    z = v[0]*w[1] - v[1]*w[0]
    Vector[x,y,z]
end

# v is a Vector (see http://www.ruby-doc.org/core/classes/Vector.html); ruby needs require 'matrix'
def length(v)                        # Betrag des Vektors
  sqrt( v[0]**2 + v[1]**2 + v[2]**2 )
end


# v is a Vector (see http://www.ruby-doc.org/core/classes/Vector.html); ruby needs require 'matrix'
def normalize(v)                     # umwandeln in Einheitsvektor 
  len = length(v)
  Vector[v[0]/len,v[1]/len,v[2]/len]
end

# hopefully correct, nore
def n_vec(a,b,c)                     # Normalenvektor als Einheitsvektor
	v = c - a
	w = a - b		
	n = cross(v,w)
  normalize(n)
end


def draw_lines	
glBegin(GL_LINES)	
glColor(0.6,0.6,0.6)	
glVertex(@vec_6.to_a)	
glVertex(@vec_4.to_a)	

glVertex(@vec_3.to_a)
glVertex(@vec_5.to_a)

glVertex(@vec_G.to_a)
glVertex(@vec_6.to_a)

glVertex(@vec_G.to_a)
glVertex(@vec_5.to_a)

glVertex(@vec_1.to_a)
glVertex(@vec_6.to_a)

glEnd
end

def draw_omega
glBegin(GL_TRIANGLES)
# OIFL Innenfläche des Winkels Omega auf der linken Seite
#r,g,b = 0.4,0.4,1                     # blau
r,g,b = 205.0/256,55.0/256,1.0/256   # braun
glColor(r,g,b,1.0)
glNormal(n_vec(@vec_G,@vec_3,@vec_6).to_a)
glVertex(@vec_G.to_a)	# Vg
glVertex(@vec_3.to_a)  	# V3
glVertex(@vec_6.to_a)	# V6
glEnd
end

# Westen (linke Seite s. Omega)
def draw_triangle_west
glBegin(GL_TRIANGLES)
#r,g,b = 72.0/256,118.0/256,255.0/256 # blau
r,g,b = 244.0/256,164.0/256,96.0/256  # braun
glColor(r,g,b,1.0)
glNormal(n_vec(@vec_1,@vec_2,@vec_3).to_a)
glVertex(@vec_1.to_a)                 # Spitze
glVertex(@vec_2.to_a)                 # V2
glVertex(@vec_3.to_a)                 # V3
glEnd
end

def draw_triangle_south
glBegin(GL_TRIANGLES)
#r,g,b = 72.0/256,118.0/256,255.0/256 # blau
r,g,b = 244.0/256,164.0/256,96.0/256  # braun
glColor(r,g,b,1.0)
glNormal(n_vec(@vec_1,@vec_3,@vec_4).to_a)
glVertex(@vec_1.to_a)	              # V1
glVertex(@vec_3.to_a)  	              # V3
glVertex(@vec_4.to_a)	              # V4
glEnd
end

def draw_triangle_east
glBegin(GL_TRIANGLES)
#r,g,b = 72.0/256,118.0/256,255.0/256 # blau
r,g,b = 244.0/256,164.0/256,96.0/256  # braun
glColor(r,g,b,1.0)
glNormal(n_vec(@vec_1,@vec_4,@vec_5).to_a)
glVertex(@vec_1.to_a)	# V1
glVertex(@vec_4.to_a)	# V4
glVertex(@vec_5.to_a)	# V5
glEnd
end

def draw_triangle_north
glBegin(GL_TRIANGLES)
#r,g,b = 72.0/256,118.0/256,255.0/256 # blau
r,g,b = 244.0/256,164.0/256,96.0/256  # braun
glColor(r,g,b,1.0)
glNormal(n_vec(@vec_1,@vec_5,@vec_2).to_a)
glVertex(@vec_1.to_a)	              # V1
glVertex(@vec_5.to_a)	              # V5
glVertex(@vec_2.to_a)	              # V2
glEnd
end

### Grundfläche
def draw_grund
#r,g,b = 176.0/256,225.0/256,255.0/256
#r,g,b = 0.2,0.1,0.9                 # blau
r,g,b = 50.0/256,50.0/256,50.0/256   # braun
glColor(r,g,b,1.0)
glBegin(GL_QUADS)
glNormal(n_vec(@vec_2,@vec_3,@vec_4).to_a)
glVertex(@vec_2.to_a)
glVertex(@vec_3.to_a)
glVertex(@vec_4.to_a)
glVertex(@vec_5.to_a)
glEnd
end


def output
system "clear"
puts "  Kantenwinkel ω am Grat der Pyramide"
puts ""
#puts "+"+"-"*27+"+"+"-"*5+"+"+"-"*22+"+"
#printf "| %-25s |%+3s| %-20s |\n","Bezeichnung","Kurzf","Zahlenwert"
puts "+"+"-"*27+"+"+"-"*5+"+"+"-"*22+"+"
printf "| %-25s | %+3s | %20.12f |\n","Kantenlänge der Pyramide", "a",@a
puts "+"+"-"*27+"+"+"-"*5+"+"+"-"*22+"+"
printf "| %-25s | %+3s | %20.12f |\n","Pyramidenhöhe","h",@h
puts "+"+"-"*27+"+"+"-"*5+"+"+"-"*22+"+"
printf "| %-25s | %+3s | %20.12f |\n","Diagonale der Grundseite","d",@d
puts "+"+"-"*27+"+"+"-"*5+"+"+"-"*22+"+"
printf "| %-25s | %+3s | %20.12f |\n","Höhe einer Pyramidenseite","ha",@ha
puts "+"+"-"*27+"+"+"-"*5+"+"+"-"*22+"+"
printf "| %-25s | %+3s | %20.12f |\n","Grat der Pyramide","g",@g
puts "+"+"-"*27+"+"+"-"*5+"+"+"-"*22+"+"
printf "| %-25s | %+3s | %20.12f |\n","Höhe des Grates zur Seite","hg",@hg
puts "+"+"-"*27+"+"+"-"*5+"+"+"-"*22+"+"
#printf "| %-25s | %+3s | %20.12f |\n","Höhe Grat-Mitte","hgm",@hgm
#puts "+"+"-"*27+"+"+"-"*5+"+"+"-"*22+"+"
printf "| %-25s | %+3s | %20.12f |\n","Winkel Seite/Grundfläche","α",@alpha
puts "+"+"-"*27+"+"+"-"*5+"+"+"-"*22+"+"
printf "| %-25s | %+3s | %20.12f |\n","Winkel Grat/Kantenlänge","β",@beta
#printf "%-25s =>%+3s:%20.12f\n", "γ",@gamma
puts "+"+"-"*27+"+"+"-"*5+"+"+"-"*22+"+"
printf "| %-25s | %+3s | %20.12f |\n","Kantenwinkel","ω",@omega
puts "+"+"-"*27+"+"+"-"*5+"+"+"-"*22+"+"

=begin
puts "Vektor am Grad #{@vec_G}"
puts "Vektor 1 #{@vec_1}"
puts "Vektor 2 #{@vec_2}"
puts "Vektor 3 #{@vec_3}"
puts "Vektor 4 #{@vec_4}"
puts "Vektor 5 #{@vec_5}"
puts "Vektor 6 #{@vec_6}"
=end
end

end
