#!/usr/bin/ruby
# encoding: utf-8
# pmath.rb
# https://github.com/MaWiMa/hip
# Norbert Reschke
# hip (slant edge) angle omega of right pyramid with regular base
# Kantenwinkel ω am Grat einer geraden Pyramide mit regelmäßiger Grundfläche
# sketch can be found at:
# Skizze siehe:
# images/polygon-pyramid-hip-angleGL.png

require 'matrix'
include Math

class Pyramid
attr_reader :g,:hg_M, :alpha,:beta,:gamma,:omega, :z,:r,:m, :vec_G,:vec_M,:vec_S,:base

def initialize(n,a,h)

@n = n # number of edges, Anzahl der Eckpunkte
@a = a # edge length, Kantenlänge
@h = h # height, Höhe


@gamma = (n-2) * PI * (2*n)**-1
@r     = (a/2) * cos(@gamma)**-1
@beta  = atan(h * @r**-1)          # angle hip to base, Winkel zwischen Grat und Basisebene
@alpha = PI*2**-1 -@beta           # angle section plane to base, Winkel zwischen Schnittebene und Basisebene 
@m     = tan(@gamma) * @r          # intersection point(x-axis), Schnittpunkt (X-Richtung); ME1 (+@m) and ME2 (-@m)
@h_gM  = @r * sin(@beta)
@omega = atan(@m * @h_gM**-1)
@z     = sqrt(@h_gM**2 + @m**2)


phi  = 2 * PI/n
r_o  = sin(@beta) * @h_gM
h_gr = sqrt(@h_gM**2 - r_o**2)
@g   = sqrt(@r**2 + @h**2)       # hip, Grat

#Schnittebene
z_E = sin(@alpha) * @r * 1.1
y_E = cos(@alpha) * @r * 1.1

@vec_M = Vector[0,0,0]           # center of polygon, Mittelpunkt  
@vec_G = Vector[0,-r_o,h_gr]     # point on hip (g,h_gM), Omega Schenkelbasispunkt auf dem Grat
@vec_S = Vector[0,0,h]           # apex, Spitze
@vec_ME1= Vector[@m,0,0]         # plane angle, footpoint 1, Winkelebene Fußpunkt 1
@vec_ME2= Vector[-@m,0,0]        # plane angle, footpoint 2, Winkelebene Fußpunkt 2
@vec_GE = Vector[0,-y_E,z_E]     # plane angle , Winkelebene Mittellinie durch 0 und G
@vec_GE1 = Vector[@m,-y_E,z_E]   # Winkelebene Kopfpunkt 1
@vec_GE2 = Vector[-@m,-y_E,z_E]  # Winkelebene Kopfpunkt 2

base_polygon = [] # create empty array
 for i in (1..n)
  u    = (@r * sin(phi * i - phi)).round(6) # x-axis
  t    = (@r * cos(phi * i - phi)* (-1)).round(6)  # y-axis here points to the left (deshalb Vorzeichenumkehrung)
  base_polygon << [u,t,0.0] # maybe << instead of push simplifies reading
  @base = base_polygon
 end
end

def draw_lines
glLineWidth(2)
glBegin(GL_LINES)	
glColor(0.6,0.6,0.6)	

# Höhe der Pyramide
glVertex(@vec_M.to_a)
glVertex(@vec_S.to_a)	

# Polygonlinien 
for i in (1..@base.length) # base-area outlines
glVertex(@base[i-2])
glVertex(@base[i-1])
end

# Linien Polygoneckpunkte zum Mittelpunkt
for i in (1..@base.length) # lines in base-area
glVertex(@base[i-1])
glVertex(@vec_M.to_a)	
end

# Mantelflächenlinien
for i in (1..@base.length) # lines on outside-surface
glVertex(@base[i-1])
glVertex(@vec_S.to_a)	
end

glColor(0.6,0.6,1.0)
# Winkelebene, Schenkel Omega von Fußpunkt 1 zum Gratpunkt G
glVertex(@vec_ME1.to_a)
glVertex(@vec_G.to_a)  	

# Winkelebene, Schenkel Omega von Fußpunkt 2 zum Gratpunkt G
glVertex(@vec_ME2.to_a)
glVertex(@vec_G.to_a)  
 
# Winkelebene, Mittellinie von M zu Kopfpunkt 
glVertex(@vec_M.to_a)  # Fußpunkt M
glVertex(@vec_GE.to_a) # Schnittpunkt h_gM mit Strecke (GE1-GE2)

# Winkelebene, untere Linie von Fußpunkt 1 zu 2 (ME1-M2)
glVertex(@vec_ME1.to_a)
glVertex(@vec_ME2.to_a)

# Winkelebene, obere Linie von Kopfpunkt 1 zu 2 (GE1-GE2)
glVertex(@vec_GE1.to_a)
glVertex(@vec_GE2.to_a)

# Winkelebene, Seitenlinie von Fußpunkt 2 zu Kopfpunkt 2 (ME2-GE2)
glVertex(@vec_GE2.to_a)
glVertex(@vec_ME2.to_a)

# Winkelebene, Seitenlinie von Fußpunkt 1 zu Kopfpunkt 1
glVertex(@vec_GE1.to_a)
glVertex(@vec_ME1.to_a)

glEnd
end

def draw_base
r,g,b = 0.2,0.2,0.2   #grey
glColor(r,g,b,1.0)
glBegin(GL_POLYGON)
for i in (1..@base.length)
glVertex(@base[i-1])
end
glEnd
end

def draw_Ebene
r,g,b = 0.8,0.8,0.9   #
glColor(r,g,b,1.0)
glBegin(GL_POLYGON)
glVertex(@vec_ME1.to_a)# Winkelebene Schnittkante an Pyramide, Fußpunkt 2
glVertex(@vec_ME2.to_a)# Winkelebene Schnittkante an Pyramide, Fußpunkt n
glVertex(@vec_GE2.to_a)# Winkelebene 
glVertex(@vec_GE1.to_a)# Winkelebene 
glEnd
end

=begin
 def draw_triangles
  glBegin(GL_TRIANGLES)
  r,g,b = 244.0/256,164.0/256,96.0/256  # braun
  glColor(r,g,b,1.0)
   for i in (1..@base.length)
    glVertex(@base[i-1])
    glVertex(@base[i-2])
    glVertex(@vec_S)
   end
glEnd
end
=end

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

end
