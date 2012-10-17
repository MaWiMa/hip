#!/usr/bin/ruby
# encoding: utf-8

require "matrix"
print "Geben Sie v1 ein: ""\t"
v1 = gets.chomp.to_f
print "Geben Sie v2 ein: ""\t"
v2 = gets.chomp.to_f
print "Geben Sie v3 ein: ""\t"
v3 = gets.chomp.to_f

v = Vector[v1, v2, v3]

print "Geben Sie k1 ein: ""\t"
k1 = gets.chomp.to_f
print "Geben Sie k2 ein: ""\t"
k2 = gets.chomp.to_f
print "Geben Sie k3 ein: ""\t"
k3 = gets.chomp.to_f

k = Vector[k1, k2, k3]


# dot product
#def length(i)
#	Math.sqrt( i[0]**2 + i[1]**2 + i[2]**2 )
#end

def length(i)
	s = 0
	for j in 0...i.size
	s += i[j]**2
	end	
   Math.sqrt( s )
end

# cross products

def c(v,k)
	c1 = v[1]*k[2] - v[2]*k[1]
	c2 = v[2]*k[0] - v[0]*k[2]
	c3 = v[0]*k[1] - v[1]*k[0]
	Vector[c1,c2,c3]
end

def dot_product(x,y)
    sum = 0
    for i in 0...x.size
        sum += x[i] * y[i]
    end
    sum
end




puts "Die Länge des Vektors v beträgt: #{length(v)}"
puts "Die Länge des Vektors k beträgt: #{length(k)}"
puts "Das Kreuzprodukt v X k ist: #{c(v,k)}"
puts "Scalarprodukt v * k: #{dot_product(v,k)}"
