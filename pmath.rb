#!/usr/bin/ruby
# encoding: utf-8
# pmath.rb
# https://github.com/MaWiMa/hip
# Norbert Reschke
# Kantenwinkel ω am Grat (hip-angle) einer geraden Pyramide mit regelmäßiger Grundfläche
# Skizze siehe images/polygon-pyramid-hip-angleGL.png

require 'matrix'
include Math

class Pyramid
attr_reader :g,:hg_M, :alpha,:beta,:gamma,:omega, :z,:r,:m, :vec_G,:vec_M,:vec_S,:base

def initialize(n,a,h)

@n = n # number of edges
@a = a # edge length
@h = h # height


@gamma = (n-2) * PI * (2*n)**-1
@r       = (a/2) * cos(@gamma)**-1
@beta    = atan(h * @r**-1)
@alpha = PI*2**-1 -@beta
#@h_aM    = sin(@gamma) * @r
@m       = tan(@gamma) * @r
@h_gM    = @r * sin(@beta)
@omega = atan(@m * @h_gM**-1)
@z     = sqrt(@h_gM**2 + @m**2)


phi = 2 * PI/n
#phi_g = phi*180*PI**-1
#puts "phi, "+phi_g.to_s
r_o  = sin(@beta) * @h_gM
h_gr = sqrt(@h_gM**2 - r_o**2)
@g = sqrt(@r**2 + @h**2)         # Grat der Pyramide

#Schnittebene
z_E = sin(@alpha) * @r * 1.1
y_E = cos(@alpha) * @r * 1.1

@vec_M = Vector[0,0,0]           # center of polygon  
@vec_G = Vector[0,-r_o,h_gr]     # point on hip (g,h_gM)
@vec_S = Vector[0,0,h]           # top
@vec_ME1= Vector[@m,0,0]     # Winkelebene Fußpunkt 1
@vec_ME2= Vector[-@m,0,0]    # Winkelebene Fußpunkt 2
@vec_GE = Vector[0,-y_E,z_E]  
@vec_GE1 = Vector[@m,-y_E,z_E]   # Winkelebene Oberkantenpunkt 1
@vec_GE2 = Vector[-@m,-y_E,z_E]  # Winkelebene Oberkantenpunkt 2

base_polygon = [] # create empty array
for i in (1..n)
u    = (@r * sin(phi * i - phi)).round(6) # x-axis
t    = (@r * cos(phi * i - phi)* (-1)).round(6)  # y-axis here points to the left (deshalb Vorzeichenumkehrung)
#base_polygon.push([u,t]) # z-surface is not needed
base_polygon << [u,t,0.0] # maybe << instead of push simplifies reading

@base = base_polygon
#puts "i: #{i}, u: #{u}, r: #{@r}"
#puts "i: #{i}, t: #{t}, r: #{@r}"
#vec_i = "vec_" + i.to_s
#@vec_i = Vector[u,t,0.0]         
#puts vec_i
#puts base_polygon.length
#puts base_polygon
#return @vec_i
end

###


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

# Normalenvektor als Einheitsvektor
def n_vec(a,b,c)                     
	v = c - a
	w = a - b		
	n = cross(v,w)
  normalize(n)
end



def draw_lines
glLineWidth(2)
glBegin(GL_LINES)	
glColor(0.6,0.6,0.6)	
glVertex(@vec_M.to_a)   # h
glVertex(@vec_S.to_a)	

for i in (1..@base.length) # base-area outlines
glVertex(@base[i-2])
glVertex(@base[i-1])
end

for i in (1..@base.length) # lines in base-area
glVertex(@base[i-1])
glVertex(@vec_M.to_a)	
end

for i in (1..@base.length) # lines on outside-surface
glVertex(@base[i-1])
glVertex(@vec_S.to_a)	
end

glColor(0.6,0.6,1.0)	
glVertex(@vec_ME1.to_a)# Winkelebene Schnittkante an Pyramide, Fußpunkt 2
glVertex(@vec_G.to_a)  # Winkelebene Schnittkante an Pyramide, Gratpunkt	

glVertex(@vec_G.to_a)  # Winkelebene Schnittkante an Pyramide, Gratpunkt	
glVertex(@vec_ME2.to_a)# Winkelebene Schnittkante an Pyramide, Fußpunkt n
 
glVertex(@vec_M.to_a)  # Fußpunkt M
glVertex(@vec_GE.to_a) # Winkelebene Schnittlinie durch den Grat

glVertex(@vec_ME1.to_a)# Winkelebene Schnittkante an Pyramide, Fußpunkt 2
glVertex(@vec_ME2.to_a)# Winkelebene Schnittkante an Pyramide, Fußpunkt n

glVertex(@vec_GE1.to_a)# Winkelebene 
glVertex(@vec_GE2.to_a)# Winkelebene 

glVertex(@vec_GE2.to_a)
glVertex(@vec_ME2.to_a)

glVertex(@vec_GE1.to_a)
glVertex(@vec_ME1.to_a)

glEnd
end

def draw_base
r,g,b = 0.2,0.1,0.9   # blue
glColor(r,g,b,1.0)
glBegin(GL_POLYGON)
#glNormal(n_vec(@base[-3],@base[-2],@base[-1]))
for i in (1..@base.length)
glVertex(@base[i-1])
end
glEnd
end

def draw_Ebene
r,g,b = 0.5,0.5,0.2   #
glColor(r,g,b,1.0)
glBegin(GL_POLYGON)
glNormal(n_vec(@vec_ME1,@vec_ME2,@vec_GE2))
glVertex(@vec_ME1.to_a)# Winkelebene Schnittkante an Pyramide, Fußpunkt 2
glVertex(@vec_ME2.to_a)# Winkelebene Schnittkante an Pyramide, Fußpunkt n
glVertex(@vec_GE2.to_a)# Winkelebene 
glVertex(@vec_GE1.to_a)# Winkelebene 
glEnd
end



=begin

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
=end

### Grundfläche/Basearea
#def draw_base
#r,g,b = 0.2,0.1,0.9   # blue
#glColor(r,g,b,1.0)
#glBegin(GL_POLYGON)
#glNormal(n_vec(@vec_2,@vec_3,@vec_4).to_a)
#for i in (1..@base.length)
#glVertex(1,1,0)
#end
#glEnd
#end

def output
system "clear"
def opline (x)
 if x == 1
 puts "+"+"-"*27+"+"+"-"*6+"+"+"-"*22+"+"
 elsif x == 2
 puts "+"+"-"*57+"+"
 elsif x == 3
 puts "|"+" "*57+"|"
 end
end

opline(2)
opline(3)
printf "| %-55s |\n","Kantenwinkel ω"
printf "| %-55s |\n","am Grat einer Pyramide mit regelmäßiger Grundfläche"
opline(3)
opline(1)
printf "| %-25s |%6s| %-20s |\n","Bezeichnung","Var ","Zahlenwert"
opline(1)
printf "| %-25s | %+4s | %20.0f |\n","Anzahl der Ecken", "n",@n
opline(1)
printf "| %-25s | %+4s | %20.2f |\n","Kantenlänge Grundfläche", "a",@a
opline(1)
printf "| %-25s | %+4s | %20.2f |\n","Pyramidenhöhe","h",@h
opline(1)
printf "| %-25s | %+4s | %20.2f |\n","Umkreisradius","r",@r
opline(1)
printf "| %-25s | %+4s | %20.2f |\n","Winkel Grat/Radius","ɣ",@gamma*180/PI
opline(1)
printf "| %-25s | %+4s | %20.2f |\n","Grat der Pyramide","g",@g
opline(1)
printf "| %-25s | %+4s | %20.2f |\n","Höhe auf dem Grat","h_gM",@h_gM
opline(1)
printf "| %-25s | %+4s | %20.2f |\n","Winkel Grat/Radius","β",@beta*180/PI
opline(1)
printf "| %-25s | %+4s | %20.2f |\n","Kantenwinkel","ω",@omega*180/PI	
opline(1)

end

#puts""
#puts "Vektor M #{@vec_M}"
#puts "Vektor S #{@vec_S}"
#puts "Vektor G #{@vec_G}"
end
#end
