#!/usr/bin/ruby
# encoding: utf-8
# Norbert Reschke s. pmath.rb

require_relative 'pmath'           # ruby 1.9.3

require 'opengl'
require 'glu'
require 'glut'
include Math
include GL,GLU,GLUT


unless ARGV.length < 4
puts "Bitte geben Sie nicht mehr als drei Parameter an!"
puts "Beispiel: #{__FILE__} 100 50"
exit
end

n = ARGV[0].to_i                     # 1. Parameter der Eingabe 
a = ARGV[1].to_f                     # 2. Parameter der Eingabe
h = ARGV[2].to_f                     # 3. Parameter der Eingabe

if ((( a == 0.0 or h == 0.0) and h != a) or n < 3 or ARGV[0] == "-h" or ARGV[0] == "--h")
system "clear"
puts "Pyramide mit der Grundfläche eines regelmäßigen Polygons"
puts "Bitte geben Sie drei sinnvolle Parameter an!"
puts "Notation: <#{__FILE__}> <Anzahl der Ecken des Polygons> <Kantenlänge einer Grundseite> <Höhe der Pyramide>"
puts "Beispiel: #{__FILE__} 5 100 50"
puts ""
puts "Steuerung per Tastatur nachdem das Grafikfenster den Fokus erhalten hat"
puts "< s > oder < - >       -> reduzieren die Höhe der Pyramide"
puts "< b > oder < + >       -> vergrößern die Höhe der Pyramide"
puts "< n >                  -> Zoom in die Ausgangsperspektive"
puts "< o >                  -> Zoom-Out"
puts "< i >                  -> Zoom-In"
puts "up, down, left, right  -> drehen der Pyramide"
puts "< esc >                -> Exit"
exit
end

if n > 99
puts "n > 99! Was soll das werden?"
puts "Natürlich, kann ich das rechnen, mache ich aber nicht freiwillig!"
exit
end

if (a == 0 and h == 0)               # beide Werte 0, z.B. keine Parameterangabe, dann wird 1.0 gesetzt, s. b==a
a,h = 1.0,1.0
end


###
x_rot = -70.0		                 # x Variable für glRotate(); Rotationsstartwinkel um die X-Achse
y_rot = 0.0		                     # y Variable für glRotate(); Rotationsstartwinkel um die y-Achse
z_rot = 90.0		                 # z Variable für glRotate(); Rotationsstartwinkel um die Z-Achse

###
maxh = 10000
pyr = Pyramid.new(n,a,h)
zoom = -5.5*pyr.r                    # keyboard n,N; i,I;o,O 
pyr.output

def init(width=16,height=10)
#glClearColor(red,green,blue,alpha)	# Hintergrundfarbe alpha 0.0 -> transparent;alpha 1.0 -> undurchsichtig
glClearColor(0.0,0.0,0.0,1.0)		# Hintergrundfarbe schwarz

glEnable(GL_BLEND)

glBlendFunc(GL_SRC_ALPHA,GL_ONE) # transparent
#glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA) # Opak
#glEnable (GL_DEPTH_TEST)
#glClearDepth(1.0)
glEnable(GL_LIGHTING)		# Beleuchtung
glColorMaterial( GL_FRONT, GL_AMBIENT_AND_DIFFUSE )
glEnable(GL_LIGHT0)
glEnable(GL_COLOR_MATERIAL)
glPolygonMode(GL_FRONT_AND_BACK, GL_FILL) # Front- und Rückseite sichtbar 
#
# Viewing
glMatrixMode(GL_PROJECTION)
#gluPerspective(35.0,width/height,0.1,10000.0)
gluPerspective(35.0,width/height,1,10.0)
glMatrixMode(GL_MODELVIEW)
glEnable(GL_LINE_SMOOTH)
glEnable(GL_POINT_SMOOTH)
glEnable(GL_POLYGON_SMOOTH)
glShadeModel(GL_SMOOTH)
end

reshape = lambda do |width,height|
end


############ display
display = Proc.new do
glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT )
glLoadIdentity              # Matrix einlesen/speichern
glTranslate(0.0,0.0,zoom)	# Verschieben, Zentrieren
glRotate(x_rot,1.0,0.0,0.0)	# um die X-Achse drehen 
glRotate(y_rot,0.0,1.0,0.0)	# um die y-Achse drehen
glRotate(z_rot,0.0,0.0,1.0)	# um die Z-Achse drehen
glutPostRedisplay	



### draw this
pyr.draw_lines
pyr.draw_base
pyr.draw_Ebene
glEnable(GL_BLEND)
glutSwapBuffers
end
###

############ keyboard actions
keyboard = Proc.new do|key, x, y|
 case (key)
  when ?s,?S,?-                         #reduziere die Höhe
   if h > 0.01 then
	h = h-0.1*h
    elsif pyr.omega < 89.99999
    h = h-0.5*h
    else
    h = h
   puts "ω: => 90° "
   end
  if pyr.omega < 89.99999 
  pyr = Pyramid.new(n,a,h)
  pyr.output
  glutPostRedisplay	
  end

		when ?b,?B,?+                   #vergrößere die Höhe
		if h < 0.01  then
		h = h+0.5*h
		elsif h < maxh then			
		h = h+0.1*h
		else
        puts "ω: => 45° "	
		end 
  if h < maxh		
  pyr = Pyramid.new(n,a,h)
  pyr.output
  glutPostRedisplay
  end	



		when ?n,?N                   #zoom Ausgangsperspektive
			zoom = -3.5*pyr.r
			x_rot = -70.0
			z_rot = 90.0
				pyr = Pyramid.new(n,a,h)
				pyr.output
			glutPostRedisplay	

		when ?o,?O                   #zoom out
			zoom = zoom -0.09*a
			glutPostRedisplay	
 puts zoom
		when ?i,?I                   #zoom in
			zoom = zoom +0.09*a
			glutPostRedisplay	
puts zoom

		when ?\e                     # Escape key
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
			else z_rot = -355
			end
			glutPostRedisplay
			puts z_rot
		when GLUT_KEY_LEFT
			if z_rot > -360 then
			z_rot = z_rot - 5
			else z_rot = 355
			end
			glutPostRedisplay
			puts z_rot

		when GLUT_KEY_UP
			x_rot = x_rot + 1
			zoom = zoom -h*0.02
			puts "#{x_rot},  #{zoom},  #{z_rot}"					
			glutPostRedisplay
			
		when GLUT_KEY_DOWN
			x_rot = x_rot - 1
			zoom = zoom +h*0.02
			puts "#{x_rot},  #{zoom},  #{z_rot}"							
			glutPostRedisplay
	end
end


glutInit
glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB | GLUT_DEPTH | GLUT_MULTISAMPLE)
glutInitWindowSize(1100,1100)
glutInitWindowPosition(0, 0)
glutCreateWindow("canonical pyramid with polygon base area") 
glutDisplayFunc(display)
glutReshapeFunc(reshape)
glutKeyboardFunc(keyboard)
glutSpecialFunc(special)             # rechts,links,hoch...

init
glutMainLoop()
