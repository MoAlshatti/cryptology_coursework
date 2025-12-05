load("eg_sign.sage")

m = 555
r,sig = oracle(m)

r = ZZ(r)
while gcd(r,p-1) != 1:
    r,sig = oracle(m)
    r = ZZ(r)
for i in range(1024):
    if power_mod(g,i,p) == r:
        k = i
        break

r_inv = inverse_mod(r,p-1)
a =  ((m - (sig * k)) * r_inv) % (p-1)
print("THE key is:",a)
