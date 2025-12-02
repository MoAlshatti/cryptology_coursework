load("eg_sign.sage")
load("algorithms/pohlig_hellman.sage")

m = 555
r,sig = oracle(m)

r = ZZ(r)
while gcd(r,p-1) != 1:
    r,sig = oracle(m)
    r = ZZ(r)
k = pohlig_hellman(p,g,r)

r_inv = inverse_mod(r,p-1)
a =  ((m - (sig * k)) * r_inv) % (p-1)
print("THE key is:",a)