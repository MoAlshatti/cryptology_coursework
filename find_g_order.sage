w = PolynomialRing(GF(2), 'x')
x = w.gen()
f = x^10 + x^9 + x^8 + x^7 + x^6 + x^5 + x^4 + x^3 + x^2 + x^1 +1

Fq = GF(2^10, 'a', modulus=f)
a = Fq.gen() 
g = a^9 + a^5 + a^4 + a^3 + 1

i = 1
while True:
    if g^i == 1:
        print("the order is: ", i)
        break
    i += 1