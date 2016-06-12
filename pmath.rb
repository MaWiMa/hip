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

require_relative 'nvec'
require 'matrix'
include Math

class Pyramid
attr_reader :g,:hg_M, :alpha,:beta,:gamma,:omega, :z,:r,:m,:n, :vec_G,:vec_M,:vec_S,:base

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

#section plane, Schnittebene
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

def draw_height
glLineWidth(2)
glBegin(GL_LINES)	
r,g,b = 0.6,0.6,0.6   #grey
glColor(r,g,b,1.0)	
# height of pyramid, Höhe der Pyramide
glVertex(@vec_M)
glVertex(@vec_S)	
glEnd
end

def draw_base_lines
glLineWidth(2)
glBegin(GL_LINES)	
r,g,b = 0.6,0.6,0.6   #grey
glColor(r,g,b,1.0)	
# polygon lines, Polygonlinien 
 for i in (0..@n-1) # base-area outlines
  glVertex(@base[i])
  glVertex(@base[i-1])
end

# lines from edges to center, Linien Polygoneckpunkte zum Mittelpunkt
 for i in (0..@n-1) # lines in base-area
  glVertex(@base[i])
  glVertex(@vec_M)	
 end
glEnd
end

def draw_surface_lines
glLineWidth(2)
glBegin(GL_LINES)	
r,g,b = 0.6,0.6,0.6   #grey
glColor(r,g,b,1.0)	
 # lateral surface lines, Mantelflächenlinien
 for i in (0..@n-1) # lines on outside-surface
  glVertex(@base[i])
  glVertex(@vec_S)	
 end
glEnd
end

def draw_section_plane_lines
glLineWidth(2)
glBegin(GL_LINES)	
r,g,b = 0.6,0.6,0.6   #grey
glColor(r,g,b,1.0)	

# Winkelebene, Schenkel Omega von Fußpunkt 1 zum Gratpunkt G
glVertex(@vec_ME1)
glVertex(@vec_G)  	

# Winkelebene, Schenkel Omega von Fußpunkt 2 zum Gratpunkt G
glVertex(@vec_ME2)
glVertex(@vec_G)  
 
# Winkelebene, Mittellinie von M zu Kopfpunkt 
glVertex(@vec_M)  # Fußpunkt M
glVertex(@vec_GE) # Schnittpunkt h_gM mit Strecke (GE1-GE2)

# Winkelebene, untere Linie von Fußpunkt 1 zu 2 (ME1-M2)
glVertex(@vec_ME1)
glVertex(@vec_ME2)

# Winkelebene, obere Linie von Kopfpunkt 1 zu 2 (GE1-GE2)
glVertex(@vec_GE1)
glVertex(@vec_GE2)

# Winkelebene, Seitenlinie von Fußpunkt 2 zu Kopfpunkt 2 (ME2-GE2)
glVertex(@vec_GE2)
glVertex(@vec_ME2)

# Winkelebene, Seitenlinie von Fußpunkt 1 zu Kopfpunkt 1 (GE1-ME1)
glVertex(@vec_GE1)
glVertex(@vec_ME1)
glEnd
end

def draw_base
r,g,b = 0.7,0.7,0.7   #grey
glColor(r,g,b,1.0)
glBegin(GL_POLYGON)
#glNormal(n_vec(Vector[@base[-1][0],@base[-1][1],@base[-1][2]], Vector[@base[-2][0],@base[-2][1],@base[-2][2]],Vector[@base[-3][0],@base[-3][1],@base[-3][2]]).to_a)
glNormal(n_vec(Vector[@base[0][0],@base[0][1],@base[0][2]], Vector[@base[1][0],@base[1][1],@base[1][2]],Vector[@base[2][0],@base[2][1],@base[2][2]]).to_a)
 for i in (0..@n-1)
 glVertex(@base[i-1])   
 glVertex(@base[i])
 end
glEnd
end

def draw_plane
r,g,b = 0.5,0.7,0.9   # blue
glColor(r,g,b,1.0)
glBegin(GL_POLYGON)
glNormal(n_vec(@vec_ME1,@vec_ME2,@vec_GE2).to_a)
glVertex(@vec_ME1)# Winkelebene Schnittkante an Pyramide, Fußpunkt 2
glVertex(@vec_ME2)# Winkelebene Schnittkante an Pyramide, Fußpunkt n
glVertex(@vec_GE2)# Winkelebene 
glVertex(@vec_GE1)# Winkelebene 
glEnd
end

 def draw_surface
  glBegin(GL_TRIANGLES)
  r,g,b = 0.5,0.7,0.5  # green
  glColor(r,g,b,1.0)
   for i in (0..@n-1)
    glNormal(n_vec(Vector[@base[i-2][0],@base[i-2][1],@base[i-2][2]], Vector[@base[i-1][0],@base[i-1][1],@base[i-1][2]],@vec_S).to_a)
    glVertex(@base[i-1])
    glVertex(@base[i])
    glVertex(@vec_S)
   end
glEnd
end

 def draw_triangles
  glBegin(GL_TRIANGLES)
  r,g,b = 0.5,1.0,0.5  # green
  glColor(r,g,b,1.0)
glNormal(n_vec(Vector[@base[0][0],@base[0][1],@base[0][2]], Vector[@base[1][0],@base[1][1],@base[1][2]],@vec_S).to_a)
  glVertex(@base[0])
  glVertex(@base[1])
  glVertex(@vec_S)

glNormal(n_vec(Vector[@base[-1][0],@base[-1][1],@base[-1][2]], Vector[@base[0][0],@base[0][1],@base[0][2]],@vec_S).to_a)
  glVertex(@base[-1])
  glVertex(@base[0])
  glVertex(@vec_S)
glEnd
end

 def draw_omega_plane
  glBegin(GL_TRIANGLES)
  r,g,b = 1.0,0.5,0.1  # orange
  glColor(r,g,b,1.0)
  glNormal(n_vec(@vec_ME1,@vec_M,@vec_G).to_a)
  glVertex(@vec_ME1)
  glVertex(@vec_M)
  glVertex(@vec_G)
glEnd
end


def output
system "clear"
def opline (x)
 if x == 1
 puts "+"+"-"*27+"+"+"-"*6+"+"+"-"*12+"+"
 elsif x == 2
 puts "+"+"-"*47+"+"
 elsif x == 3
 puts "|"+" "*47+"|"
 end
end

opline(2)
opline(3)
printf "| %-45s |\n","Kantenwinkel ω am Grat einer Pyramide"
printf "| %-45s |\n","mit regelmäßiger Grundfläche"
opline(3)
opline(1)
printf "| %-25s |%6s| %-10s |\n","Bezeichnung","Var ","Zahlenwert"
opline(1)
printf "| %-25s | %+4s | %10.0f |\n","Anzahl der Ecken", "n",@n
opline(1)
printf "| %-25s | %+4s | %10.2f |\n","Kantenlänge Grundfläche", "a",@a
opline(1)
printf "| %-25s | %+4s | %10.2f |\n","Pyramidenhöhe","h",@h
opline(1)
printf "| %-25s | %+4s | %10.2f |\n","Umkreisradius","r",@r
opline(1)
printf "| %-25s | %+4s | %10.2f |\n","Winkel Grat/Radius","ɣ",@gamma*180/PI
opline(1)
printf "| %-25s | %+4s | %10.2f |\n","Grat der Pyramide","g",@g
opline(1)
printf "| %-25s | %+4s | %10.2f |\n","Höhe auf dem Grat","h_gM",@h_gM
opline(1)
printf "| %-25s | %+4s | %10.2f |\n","Winkel Grat/Radius","β",@beta*180/PI
opline(1)
printf "| %-25s | %+4s | %10.2f |\n","Kantenwinkel","ω",@omega*180/PI	
opline(1)
end

end

