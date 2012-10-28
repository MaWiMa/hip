#!/usr/bin/ruby
# encoding: utf-8
##########
# Norbert Reschke 1988-2012
# Gerade Pyramide mit quadratischer Grundfläche
# Eine Pyramide mit einer Grundfläche aus einem regelmäßigen Vieleck heißt gerade,
# wenn die Höhe h durch den Mittelpunkt der Grundfläche verläuft, damit sind alle Grate gleich lang.
# h => Höhe; a => Grundseite (s. images/PyramideSkizzeOpenGL.pdf)
##########

require 'opengl'
require 'matrix'

###
zoom = -3.0 # keyboard n,N; i,I;o,O 
x_rotA = -90.0		# x Variable für glRotate(); Rotationsstartwinkel um die X-Achse
x_rot= x_rotA

z_rot = -65.0		# z Variable für glRotate(); Rotationsstartwinkel um die Z-Achse

$rgb_v,$rgb_a = 256.0,1.0	# Nenner zur RGB-Farben Berechnung,Transparenz (0.0 <= a <= 1.0) 
###


### read parameter from commandline (if given)
unless ARGV.length < 3
puts "Bitte geben Sie nicht mehr als 2 Parameter (für a und h) an!"
puts "Beispiel: #{__FILE__} 100 50"
exit
end

###
a = ARGV[0].to_f
h = ARGV[1].to_f

if (a == 0.0 or h == 0.0) and h != a
puts "Bitte geben Sie mehr als einen Parameter an!"
exit
end


if (a == 0 and h == 0) # beide Werte 0, z.B. keine Parameterangabe, dann wird 1.0 gesetzt, s. b==a
a,h = 1.0,1.0
end

### Berechnungen zur Schmiege
def pyrvar(a,h)

d = Math.sqrt(2)*a		# Diagonale der Pyramidengrundseite
ha = Math.sqrt( a**2/4 + h**2 )	# Höhe der Pyramidenseitenfläche auf a
g = Math.sqrt( a**2/4 + ha**2 )	# Grat der Pyramide
hg = a*ha/g		# Höhe der Pyramidenseitenfläche auf dem Grat, linker Schenkel OMEGA
# 						# Vektorpunkt auf dem Grat (Ursprung Omega)
hgm = Math.sqrt(hg**2 - (d/2)**2) # rechter Schenkel OMEGA


# Schmiegen der Pyramide im Bogenmaß
	alpha_b = Math.asin(h/ha)
	beta_b = Math.asin(ha/g)
	gamma_b = Math.acos(hgm/(d/2))	# Winkel am Mittelpunkt zwischen Grundfläche und der von OMEGA aufgespannten Fläche 
	omega_b = Math.asin(Math.sqrt(2)*a/(2*hg))

# in Grad (für die Ausgabe)	
	alpha_g = alpha_b * 180.0 / Math::PI
	beta_g  = (Math.asin(ha/g)) * 180 / Math::PI
	gamma_g = gamma_b * 180.0 / Math::PI
	omega_g = (Math.asin(Math.sqrt(2)*a/(2*hg))) * 180 / Math::PI

#	Vektorpunkte (x,y,z)
	z = Math.sin(gamma_b)* hgm	# Z Lot vom Vektorpunkt auf Grundfläche
	x = z/Math.tan(alpha_b) 	# X Abstand in x Richtung zum Lotpunkt 
	y = x				# Y = X, gilt für alle regelmäßigen und geraden Pyramiden  

return a,h,d,ha,g,hg,hgm,alpha_b,beta_b,gamma_b,omega_b,alpha_g,beta_g,gamma_g,omega_g,z,x,y
end

a,b,d,ha,g,hg,hgm,alpha_b,beta_b,gamma_b,omega_b,alpha_g,beta_g,gamma_g,omega_g,z,x,y = pyrvar(a,h)


puts "Gerade Pyramide mit quadratischer Grundfläche"
puts "Seitenlänge, a:                #{a}"	# a
puts "Höhe der Pyramide, h:          #{h}"	# h
puts "Diagonale, d:                  #{d}"	# d
puts "Höhe auf a, ha                 #{ha}"	# ha
puts "Grat der Pyramide, g:          #{g}"	# g
puts "Grathöhe zum Eckpunkt, hg:     #{hg}"	# hg
puts "Grathöhe zum Mittelpunkt, hgm: #{hgm}"	# hg
puts "Winkel alpha:         #{alpha_g}"	# alpha
puts "Winkel beta:          #{beta_g}"	# beta
puts "Winkel gamma:         #{gamma_g}"	# gamma
puts "Winkel omega:         #{omega_g}"	# omega

#puts "Ruby Version:   #{RUBY_VERSION}"


### opengl

### Die Werte zu a und h werden auf den Wertebereich 0 < a,h <= 1 umgerechnet
if a > h then
a,h = a/a,h/a
elsif h > a then
a,h = a/h,h/h
elsif h == a then
a,h = 1.0,1.0
else
exit
end

###
a,b,d,ha,g,hg,hgm,alpha_b,beta_b,gamma_b,omega_b,alpha_g,beta_g,gamma_g,omega_g,z,x,y = pyrvar(a,h)

def rvec(x,y,z,a,h)
###
# Vektorpunkte s. Skizze
$vec_G = Vector[x,y,z]		# Vektorpunkt auf dem Grat (Schnittpunkt g,hg)
$vec_1 = Vector[a/2,a/2,h]	# Spitze
$vec_2 = Vector[0.0,0.0,0.0]	# Fußpunkt oben links
$vec_3 = Vector[a,0.0,0.0]	# Fußpunkt unten links
$vec_4 = Vector[a,a,0.0]	# Fußpunkt unten rechts
$vec_5 = Vector[0.0,a,0.0]	# Fußpunkt oben rechts
$vec_6 = Vector[a/2,a/2,0.0]	# Mittelpunkt der Grundfläche
return $vec_G,$vec_1,$vec_2,$vec_3,$vec_4,$vec_5,$vec_6
end

###
$vec_G,$vec_1,$vec_2,$vec_3,$vec_4,$vec_5,$vec_6 = rvec(x,y,z,a,h)
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
def length(v) # Betrag des Vektors
  Math.sqrt( v[0]**2 + v[1]**2 + v[2]**2 )
end


# v is a Vector (see http://www.ruby-doc.org/core/classes/Vector.html); ruby needs require 'matrix'
def normalize(v) # umwandeln in Einheitsvektor 
  len = length(v)
  Vector[v[0]/len,v[1]/len,v[2]/len]
end

# hopefully correct, nore
def n_vec(a,b,c) # Normalenvektor als Einheitsvektor
	v = c - a
	w = a - b		
	n = cross(v,w)
  normalize(n)
end
###



def init(width=16,height=9)

#glClearColor(red,green,blue,alpha)	# Hintergrundfarbe alpha 0.0 -> transparent;alpha 1.0 -> undurchsichtig
#glClearColor(1.0,1.0,1.0,1.0)		# Hintergrundfarbe weiss
glEnable(GL_BLEND)
glBlendFunc(GL_SRC_ALPHA,GL_ONE) # transparent
#glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA) # Opak
glClearDepth(1.0)
glEnable(GL_LIGHTING)
#glDisable(GL_LIGHTING)		# keine Beleuchtung
#glEnable(GL_CULL_FACE)		# Front/Rückseite einblenden/ausblenden
#glFrontFace(GL_CCW)		# xyz positive Drehrichtung
#glCullFace(GL_BACK)
#glColorMaterial( GL_FRONT, GL_AMBIENT_AND_DIFFUSE )
glEnable(GL_LIGHT0)
#glEnable(GL_LIGHT1)
glEnable(GL_COLOR_MATERIAL)

#glPolygonMode(GL_FRONT_AND_BACK,GL_LINE)
#glPolygonMode(GL_FRONT_AND_BACK,GL_FILL)
#glPolygonMode(GL_FRONT_AND_BACK,GL_POINT)
glPolygonMode(GL_BACK,GL_LINE)
glPolygonMode(GL_FRONT,GL_FILL)
#
# Viewing
glMatrixMode(GL_PROJECTION)
glLoadIdentity()
# gluPerspective( fovy,aspect,znear,zfar)
# fovy:   großer Winkel -> Weitwinkelobjektiv , kleiner Winkel Teleobjektiv
# aspect: Verhältnis x/y
# znear:  Abstand nahe Projektionsebene
# zfar:   Abstand entfernte Projektionsebene
gluPerspective(35.0,width/height,0.01,10000.0)
glMatrixMode(GL_MODELVIEW)
end



def pyramid_lines	
glBegin(GL_LINES)	
glColor(0.6,0.6,0.6)	
glVertex($vec_6.to_a)	
glVertex($vec_4.to_a)	

glVertex($vec_3.to_a)
glVertex($vec_5.to_a)

glVertex($vec_G.to_a)
glVertex($vec_6.to_a)

glVertex($vec_G.to_a)
glVertex($vec_5.to_a)

glVertex($vec_1.to_a)
glVertex($vec_6.to_a)

glEnd
end

### OMEGA
def pyramid_omega
glBegin(GL_TRIANGLES)

# OIFL Innenfläche des Winkels Omega auf der linken Seite
r,g,b = 205/$rgb_v,55/$rgb_v,1/$rgb_v
glColor(r,g,b,$rgb_a)
glNormal(n_vec($vec_G,$vec_3,$vec_6).to_a)
glVertex($vec_G.to_a)	# Vg
glVertex($vec_3.to_a)  	# V3
glVertex($vec_6.to_a)	# V6

# OAFL Außenseite zu OFL
#r,g,b = 256/$rgb_v,256/$rgb_v,256/$rgb_v
#glColor(r,g,b,$rgb_a)
#glNormal(n_vec($vec_G,$vec_2,$vec_3).to_a)
#glVertex($vec_G.to_a) 	 # Vg
#glVertex($vec_2.to_a) 	 # V2
#glVertex($vec_3.to_a) 	 # V3

# OIFR Innenfläche des Winkels Omega auf der rechten Seite
#r,g,b = 150/$rgb_v,55/$rgb_v,1/$rgb_v
#glColor(r,g,b,$rgb_a)
#glNormal(n_vec($vec_G,$vec_6,$vec_5).to_a)
#glVertex($vec_G.to_a)	# Vg
#glVertex($vec_6.to_a)  # V6
#glVertex($vec_5.to_a)	# V5

# OAFR Außenseite zu OFR
#r,g,b = 256/$rgb_v,256/$rgb_v,256/$rgb_v
#glColor(r,g,b,$rgb_a)
#glNormal(n_vec($vec_G,$vec_5,$vec_2).to_a)
#glVertex($vec_G.to_a)	# Vg
#glVertex($vec_5.to_a)	# V5
#glVertex($vec_2.to_a)	# V2

glEnd
end



### Normalen Vektoren
def normalen_vektor
#glTranslate(0.5,0.0,0.0)
p = n_vec($vec_1,$vec_2,$vec_3)
n0 = n_vec($vec_1,$vec_2,$vec_3)-n_vec($vec_1,$vec_2,$vec_3)
glBegin(GL_LINES)	# 
glColor(1.0,0.0,0.0)	# in rot
glVertex(n0.to_a)	# in der Ebene (Anfangspunkt Normalenvektor)
glVertex(p.to_a)	# auf der Ebene + 1 (Endpunkt Normalenvektor)

#glTranslate(0.5,0.5,0.0)
q = n_vec($vec_1,$vec_5,$vec_2)
n0 = n_vec($vec_1,$vec_5,$vec_2)-n_vec($vec_1,$vec_5,$vec_2)

glColor(0.0,0.0,1.0)	# in blau
glVertex(n0.to_a)	# in der Ebene (Anfangspunkt Normalenvektor)
glVertex(q.to_a)	# auf der Ebene + 1 (Endpunkt Normalenvektor)


glEnd

end




# Westen (linke Seite s. Omega)
def pyramid_triangle_west
glBegin(GL_TRIANGLES)
r,g,b = 244/$rgb_v,164/$rgb_v,96/$rgb_v
glColor(r,g,b,$rgb_a)
glNormal(n_vec($vec_1,$vec_2,$vec_3).to_a)
glVertex($vec_1.to_a) 	 # Spitze
glVertex($vec_2.to_a) 	 # V2
glVertex($vec_3.to_a) 	 # V3
glEnd
end

def pyramid_triangle_south
glBegin(GL_TRIANGLES)
r,g,b = 244/$rgb_v,164/$rgb_v,96/$rgb_v
glColor(r,g,b,$rgb_a)
glNormal(n_vec($vec_1,$vec_3,$vec_4).to_a)
glVertex($vec_1.to_a)	# V1
glVertex($vec_3.to_a)  	# V3
glVertex($vec_4.to_a)	# V4
glEnd
end

def pyramid_triangle_east
glBegin(GL_TRIANGLES)
r,g,b = 244/$rgb_v,164/$rgb_v,96/$rgb_v
glColor(r,g,b,$rgb_a)
glNormal(n_vec($vec_1,$vec_4,$vec_5).to_a)
glVertex($vec_1.to_a)	# V1
glVertex($vec_4.to_a)	# V4
glVertex($vec_5.to_a)	# V5
glEnd
end

def pyramid_triangle_north
glBegin(GL_TRIANGLES)
r,g,b = 244/$rgb_v,164/$rgb_v,96/$rgb_v
glColor(r,g,b,$rgb_a)
glNormal(n_vec($vec_1,$vec_5,$vec_2).to_a)
glVertex($vec_1.to_a)	# V1
glVertex($vec_5.to_a)	# V5
glVertex($vec_2.to_a)	# V2
glEnd
end

### Grundfläche
def grund
r,g,b = 50/$rgb_v,50/$rgb_v,50/$rgb_v
glColor(r,g,b,$rgb_a)
glNormal(n_vec($vec_2,$vec_3,$vec_4).to_a)
glBegin(GL_QUADS)
glVertex($vec_2.to_a)
glVertex($vec_3.to_a)
glVertex($vec_4.to_a)
glVertex($vec_5.to_a)

glEnd
end




reshape = lambda do |width,height|
end
#widthglViewport 0, 0, width,height

###
#glEnable(GL_BLEND)
#glBlendFunc(GL_SRC_ALPHA,GL_ONE) # transparent
#glClearDepth(1.0)
#glEnable(GL_LIGHTING)
#glEnable(GL_LIGHT0)
#glEnable(GL_COLOR_MATERIAL)

#glPolygonMode(GL_BACK,GL_LINE)
#glPolygonMode(GL_FRONT,GL_FILL)
#
# Viewing
#glMatrixMode(GL_PROJECTION)
#glLoadIdentity()
#gluPerspective(35.0,width/height,0.01,10000.0)
#glMatrixMode(GL_MODELVIEW)
#glLoadIdentity()
###     
#end


############ display
display = Proc.new do
glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT )
glLoadIdentity		# Matrix einlesen/speichern
glTranslate(-0.05,-0.5*a,zoom)	# Verschieben, Zentrieren
glRotate(x_rot,a,0.0,0.0)	# um die X-Achse drehen 
glRotate(z_rot,0.0,0.0,h)	# um die Z-Achse drehen
glTranslate(-0.5*a,-0.5*a,0.0)	# z-Rotationsachse ins Zentrum des Kubus verschieben
#glEnable(GL_DEPTH_TEST)
### draw this
glDisable(GL_BLEND)
grund
pyramid_lines
pyramid_omega
glEnable(GL_BLEND)

#normalen_vektor
# draw last for transparency
#glDepthMask(GL_FALSE)
#glEnable(GL_BLEND)
#glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
#glDepthMask(GL_FALSE)
pyramid_triangle_north
pyramid_triangle_west
pyramid_triangle_south
pyramid_triangle_east

#glDepthMask(GL_TRUE)
#glDisable(GL_BLEND)

glutSwapBuffers
end
###

############ keyboard actions
keyboard = Proc.new do|key, x, y|
	case (key)
		when ?s,?S #reduziere die Höhe
		if h > 0.011 then			
		h = h-0.01 
		end		
		a,b,d,ha,g,hg,hgm,alpha_b,beta_b,gamma_b,omega_b,alpha_g,beta_g,gamma_g,omega_g,z,x,y = pyrvar(a,h)			
		$vec_G,$vec_1,$vec_2,$vec_3,$vec_4,$vec_5,$vec_6 = rvec(x,y,z,a,h)

puts "Gerade Pyramide mit quadratischer Grundfläche"
puts "Seitenlänge, a:                #{a}"	# a
puts "Höhe der Pyramide, h:          #{h}"	# h
puts "Diagonale, d:                  #{d}"	# d
puts "Höhe auf a, ha                 #{ha}"	# ha
puts "Grat der Pyramide, g:          #{g}"	# g
puts "Grathöhe zum Eckpunkt, hg:     #{hg}"	# hg
puts "Grathöhe zum Mittelpunkt, hgm: #{hgm}"	# hg
puts "Winkel alpha:         #{alpha_g}"	# alpha
puts "Winkel beta:          #{beta_g}"	# beta
puts "Winkel gamma:         #{gamma_g}"	# gamma
puts "Winkel omega:         #{omega_g}"	# omegas

				glutPostRedisplay	

		when ?b,?B #erhöhe die Höhe
		#if h > 0.01 then			
		h = h+0.01		
		a,b,d,ha,g,hg,hgm,alpha_b,beta_b,gamma_b,omega_b,alpha_g,beta_g,gamma_g,omega_g,z,x,y = pyrvar(a,h)			
		$vec_G,$vec_1,$vec_2,$vec_3,$vec_4,$vec_5,$vec_6 = rvec(x,y,z,a,h)
			
puts "Gerade Pyramide mit quadratischer Grundfläche"
puts "Seitenlänge, a:                #{a}"	# a
puts "Höhe der Pyramide, h:          #{h}"	# h
puts "Diagonale, d:                  #{d}"	# d
puts "Höhe auf a, ha                 #{ha}"	# ha
puts "Grat der Pyramide, g:          #{g}"	# g
puts "Grathöhe zum Eckpunkt, hg:     #{hg}"	# hg
puts "Grathöhe zum Mittelpunkt, hgm: #{hgm}"	# hg
puts "Winkel alpha:         #{alpha_g}"	# alpha
puts "Winkel beta:          #{beta_g}"	# beta
puts "Winkel gamma:         #{gamma_g}"	# gamma
puts "Winkel omega:         #{omega_g}"	# omegas
			
			
			
			
			
			
						
			glutPostRedisplay	



		when ?n,?N #zoom Ausgangsperspektive
			zoom = -3.0
			x_rot = -90.0
			z_rot = -65.0
			a,h = 1.0,1.0
a,b,d,ha,g,hg,hgm,alpha_b,beta_b,gamma_b,omega_b,alpha_g,beta_g,gamma_g,omega_g,z,x,y = pyrvar(a,h)			
		$vec_G,$vec_1,$vec_2,$vec_3,$vec_4,$vec_5,$vec_6 = rvec(x,y,z,a,h)
			#puts "a,h:  #{a},#{h}"
		puts "ω: #{omega_g}"
			glutPostRedisplay	

		when ?o,?O #zoom out
			zoom = zoom -0.1
			glutPostRedisplay	

		when ?i,?I #zoom in
			zoom = zoom +0.1
			glutPostRedisplay	

		when ?-
			if z_rot < 360 then
			z_rot = z_rot + 5
			else z_rot = 5
			end
			glutPostRedisplay
			#puts "Vertikale Rotation gegen den Uhrzeigersinn: #{z_rot}°"
		when ?+
			if z_rot > -360 then
			z_rot = z_rot - 5
			else z_rot = -5
			end
			glutPostRedisplay
			#puts "Vertikale Rotation im Uhrzeigersinn: #{z_rot}°"

		when ?*
			if x_rot < -0 then
			x_rot = x_rot + 5
			#puts "Horizontale Rotation gegen den Uhrzeigersinn: #{x_rot}°"			
			else x_rot = -0
			#puts "Die Rotation ist auf #{x_rot}° begrenzt!"
			end
			glutPostRedisplay
			
		when ?_
			if x_rot > x_rotA then
			x_rot = x_rot - 5
			#puts "Horizontale Rotation im Uhrzeigersinn: #{x_rot}°"
			else x_rot = x_rotA
			#puts "Die Rotation ist auf #{x_rotA}° begrenzt!"	
		end
			glutPostRedisplay

		when ?l,?L
			$light = !$light
            		if $light
	               	glDisable(GL_LIGHTING)	                
	            else
	               	glEnable(GL_LIGHTING)
		end
		glutPostRedisplay

		#when ?r,?R
			#$show_room = !$show_room
            		#if !$show_room
	               	#!room
			#puts "Koordinatensystem eingeschaltet-"              
	            #else
	               	#room
			#puts "Koordinatensystem ausgeschaltet."
		#end
		#glutPostRedisplay


		when ?\e  # Escape key
		puts "ESC pressed Programm is stopped"		
		exit
	end
end

############ keyboard special keys actions
special = Proc.new do|key, x, y|
	case (key)
		when GLUT_KEY_RIGHT
			if z_rot < 360 then
			z_rot = z_rot + 5
			else z_rot = 5
			end
			glutPostRedisplay
			#puts "Vertikale Rotation gegen den Uhrzeigersinn: #{z_rot}°"
		when GLUT_KEY_LEFT
			if z_rot > -360 then
			z_rot = z_rot - 5
			else z_rot = -5
			end
			glutPostRedisplay
			#puts "Vertikale Rotation im Uhrzeigersinn: #{z_rot}°"

		when GLUT_KEY_UP
			if x_rot < -0 then
			x_rot = x_rot + 5
			#puts "Horizontale Rotation gegen den Uhrzeigersinn: #{x_rot}°"			
			else x_rot = -0
			#puts "Die Rotation ist auf #{x_rot}° begrenzt!"
			end
			glutPostRedisplay
			
		when GLUT_KEY_DOWN
			
			if x_rot > x_rotA then
			x_rot = x_rot - 5
			#puts "Horizontale Rotation im Uhrzeigersinn: #{x_rot}°"
			else x_rot = x_rotA
			#puts "Die Rotation ist auf #{x_rotA}° begrenzt!"

			end
			glutPostRedisplay
	end
end

############ mouse actions
mouse = Proc.new do |button,state,x,y|
	if (button == GLUT_LEFT_BUTTON)
		if (state == GLUT_UP)
			if z_rot < 360 then
			z_rot = z_rot + 45
			else z_rot = 45
			end
			glutPostRedisplay
			#puts "Vertikale Rotation gegen den Uhrzeigersinn: #{z_rot}°"
		end
	end
	if (button == GLUT_RIGHT_BUTTON)
		if (state == GLUT_DOWN)
	

			if z_rot > -360 then
			z_rot = z_rot - 45
			else z_rot = -45
			end
			glutPostRedisplay
			#puts "Vertikale Rotation im Uhrzeigersinn: #{z_rot}°"

		end
	end

	if (button == GLUT_MIDDLE_BUTTON)
		if (state == GLUT_DOWN)
			if x_rot > x_rotA then
			x_rot = x_rot - 5
			#puts "Horizontale Rotation im Uhrzeigersinn: #{x_rot}°"
			else x_rot = x_rotA
			#puts "Die Rotation ist auf #{x_rotA}° begrenzt!"
			
			end
			glutPostRedisplay
		end

	end

end



glutInit
#glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB | GLUT_DEPTH | GLUT_MULTISAMPLE)
glutInitDisplayMode(GLUT_RGB | GLUT_DOUBLE | GLUT_ALPHA | GLUT_DEPTH)
glutInitWindowSize(600,600)
glutInitWindowPosition(600, 0)
glutCreateWindow("Pyramid Project")
#init
glutDisplayFunc(display)
glutReshapeFunc(reshape)

glutKeyboardFunc(keyboard)
glutSpecialFunc(special) # rechts,links,hoch...
glutMouseFunc(mouse)
init
glutMainLoop()
