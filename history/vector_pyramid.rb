#!/usr/bin/ruby
# see http://www.ruby-doc.org/core/classes/Vector.html
# see http://gpwiki.org/index.php/MathGem:Vector_Operations#Ruby

require "matrix"

# dot produkt (Scalar eines Vektors)
def dot_one(i)
	sum = 0
	for j in 0...i.size
	sum += i[j]**2
	end	
   Math.sqrt( sum )
end

# The Cross Product (Kreuzprodukt)
def cross(m,n)
	c1 = m[1]*n[2] - m[2]*n[1]
	c2 = m[2]*n[0] - m[0]*n[2]
	c3 = m[0]*n[1] - m[1]*n[0]
	Vector[c1,c2,c3]
end


puts "Kantenlänge der Pyramide eingeben:"
a1 = gets.chomp.to_f
a2 = 0.0
a3 = 0.0
	a = Vector[a1, a2, a3]

b1 = 0.0
b2 = a1
b3 = 0.0
	b = Vector[b1, b2, b3]


puts "Höhe der Pyramide eingeben:"
h1 = a1/2.0
h2 = a1/2.0
h3 = gets.chomp.to_f
	h = Vector[h1, h2, h3]


p = cross(a,h)
q = cross(h,b)





# The Dot Product (Scalarprodukt zweier Vektoren)
def dot_two(x,y)
    sum = 0
    for i in 0...x.size
        sum += x[i] * y[i]
    end
    sum
end

# p * q / |p|*|q|=cos omega


# puts p,q
# puts dot_one(p)
# puts dot_one(p)

omega = (180 - Math.acos(dot_two(p,q)/ (dot_one(p) * dot_one(q)))*(180.0 / Math::PI))/2

puts omega





