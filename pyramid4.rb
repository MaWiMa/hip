#!/usr/bin/ruby
# encoding: utf-8
# Norbert Reschke 2010-08-20, 2010-12-29, 2011-02-06, 2011-11-01, 2012-10-01, 2012-10-15, 2012-11-02, 2013-01-10
# s. pyrcalc.rb

require_relative 'pyrcalc'           # ruby 1.9.3
#require 'pyrcalc'                   # ruby < 1.9.2

require 'opengl'
require 'matrix'
include Math



unless ARGV.length < 3
puts "Bitte geben Sie nicht mehr als zwei Parameter an!"
puts "Beispiel: #{__FILE__} 100 50"
exit
end

a = ARGV[0].to_f                     # 1. Parameter der Eingabe 
h = ARGV[1].to_f                     # 2. Parameter der Eingabe

if (((a == 0.0 or h == 0.0) and h != a) or ARGV[0] == "-h" or ARGV[0] == "--h")
puts "Bitte geben Sie zwei Parameter an!"
puts "Notation: <Dateiname> <Grundseite> <Höhe>"
puts "Beispiel: #{__FILE__} 100 50"
puts ""
puts "Steuerung per Tastatur nachdem das Grafikfenster den Fokus erhalten hat"
puts "< s > oder < - >           -> reduzieren die Höhe der Pyramide"
puts "< b > oder < + >           -> vergrößern die Höhe der Pyramide"
puts "< n >                     -> Zoom in die Ausgangsperspektive"
puts "< o >                     -> Zoom-Out"
puts "< i >                     -> Zoom-In"
puts "up, down, left, right     -> drehen der Pyramide"
puts "< esc >                   -> Exit"
exit
end


if (a == 0 and h == 0)               # beide Werte 0, z.B. keine Parameterangabe, dann wird 1.0 gesetzt, s. b==a
a,h = 1.0,1.0
end


###
zoom = -3.0*a                        # keyboard n,N; i,I;o,O 
x_rot = -90.0		                 # x Variable für glRotate(); Rotationsstartwinkel um die X-Achse
z_rot = -130.0		                 # z Variable für glRotate(); Rotationsstartwinkel um die Z-Achse
###

pyr = Pyramid.new(a,h)
pyr.output

def init(width=16,height=10)
glEnable(GL_BLEND)
glDepthFunc(GL_LEQUAL)

glBlendFunc(GL_SRC_ALPHA,GL_ONE)     # transparent

glEnable(GL_LIGHTING)
glEnable(GL_LIGHT0)
glEnable(GL_COLOR_MATERIAL)
glPolygonMode(GL_BACK,GL_LINE)
glPolygonMode(GL_FRONT,GL_FILL)
glMatrixMode(GL_PROJECTION)
gluPerspective(35.0,width/height,1.0,1000.0)
glMatrixMode(GL_MODELVIEW)
glLoadIdentity
end

reshape = lambda do |width,height|
end


############ display
display = Proc.new do
glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT )
glLoadIdentity                       # Matrix einlesen/speichern
glTranslate(0.0,-0.5*a,zoom)         # Verschieben, Zentrieren
glRotate(x_rot,a,0.0,0.0)            # um die X-Achse drehen 
glRotate(z_rot*0.5,0.0,0.0,h)        # um die Z-Achse drehen
glTranslate(-0.5*a,-0.5*a, 0.0)      # z-Rotationsachse ins Zentrum des Kubus verschieben
### draw this

pyr.draw_omega
pyr.draw_grund
pyr.draw_lines
pyr.draw_triangle_north
pyr.draw_triangle_west
pyr.draw_triangle_south
pyr.draw_triangle_east
#glEnable(GL_BLEND)
glutSwapBuffers
end
###

############ keyboard actions
keyboard = Proc.new do|key, x, y|
 case (key)
=begin
  when ?a,?A
   puts "Neue Kantenlänge a eingeben:"
   input = gets.chomp  
   puts "input #{input}"
   if input.to_f === 0.0 then
 	a = a
 	elsif input.to_f > 0 then
	a = input.to_f
	else
	puts "ERROR on input"
	exit
    end
   puts "a => #{a}"
   puts "h => #{h}"
   zoom = -3.0 *a
   x_rot = -90.0
   z_rot = -130.0 
   pyr = Pyramid.new(a,h)
   pyr.output
   glutPostRedisplay	

  when ?h,?H
   puts "Neue Höhe h eingeben:"
   input = gets.chomp  
   puts "input #{input}"
   if input.to_f === 0.0 then
 	h = h
 	elsif input.to_f > 0 then
	h = input.to_f
	else
	puts "ERROR on input"
	exit
    end
   puts "a => #{a}"
   puts "h => #{h}"
   zoom = -3.0 *a
   x_rot = -90.0
   z_rot = -130.0 
   pyr = Pyramid.new(a,h)
   pyr.output
   glutPostRedisplay	  
=end
  when ?s,?S,?-                         #reduziere die Höhe
   if h > 0.01 then			
	h = h-0.1*h 
    elsif pyr.omega < 89.99999
    h = h-0.5*h
    else
    h = h
   puts "ω: --> 90° "
   end
  if pyr.omega < 89.99999 
  pyr = Pyramid.new(a,h)
  pyr.output
  glutPostRedisplay	
  end

		when ?b,?B,?+                   #vergrößere die Höhe
		if h < 0.01  then
		h = h+0.5*h
		elsif h < 20000.0 then			
		h = h+0.1*h
		else
		h = h
        puts "ω: --> 45° "	
		end 
  if h < 20000.0		
  pyr = Pyramid.new(a,h)
  pyr.output
  glutPostRedisplay
  end	



		when ?n,?N                   #zoom Ausgangsperspektive
			zoom = -3.0 *a
			x_rot = -90.0
			z_rot = -130.0
				pyr = Pyramid.new(a,h)
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
#glutInitDisplayMode(GLUT_RGB | GLUT_DOUBLE | GLUT_ALPHA | GLUT_DEPTH)
glutInitWindowSize(600,600)
glutInitWindowPosition(0, 0)
#glutCreateWindow("gerade Pyramide mit quadratischer Grundfläche") # Probleme mit Umlauten
glutCreateWindow("canonical pyramid with quadratic base area")     # broken denglisch, maybe
glutDisplayFunc(display)
glutReshapeFunc(reshape)
glutKeyboardFunc(keyboard)
glutSpecialFunc(special)             # rechts,links,hoch...
#glutMouseFunc(mouse)
#glutIgnoreKeyRepeat(0)              # 0 multi;1 einmal

init
glutMainLoop()
