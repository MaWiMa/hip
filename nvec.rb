# ruby needs require 'matrix'
### normal vector for lighting, Normalenvektorenberechnungen für die Beleuchtung
# 0 -> x, 1 -> y, 2 -> z
def cross( v, w )
    x = v[1]*w[2] - v[2]*w[1]
    y = v[2]*w[0] - v[0]*w[2]
    z = v[0]*w[1] - v[1]*w[0]
    Vector[x,y,z]
end


def length(v)                        # Betrag des Vektors
  sqrt( v[0]**2 + v[1]**2 + v[2]**2 )
end


def normalize(v)                     # umwandeln in Einheitsvektor 
  len = length(v)
  Vector[v[0]/len,v[1]/len,v[2]/len]
end

def n_vec(a,b,c)                     # Normalenvektor als Einheitsvektor
	v = c - a
	w = a - b		
	n = cross(v,w)
  normalize(n)
end
