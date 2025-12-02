p = 2
q = 10
w = PolynomialRing(GF(p), 'x')
x = w.gen()
f = x^10 + x^9 + x^8 + x^7 + x^6 + x^5 + x^4 + x^3 + x^2 + x^1 +1

Fq = GF(p^q, 'a', modulus=f)
a = Fq.gen() 
g = a^9 + a^5 + a^4 + a^3 + 1

class exchangers:
    def __init__(self):
        n = randint(2,(p^q)-2)
        gn = g^n
        self.sK = n
        self.pK = gn
        self.sharedKey = None
    def send(self):
        return self.pK

    def recieve(self,pK):
        self.sharedKey = pK^self.sK
    
    def __str__(self):
        s1 = "sK: " + str(self.sK) +"\n"
        s2 = "pK: " + str(self.pK) +"\n"
        s3 = "shared secret: : " + str(self.sharedKey) +"\n"
        return s1 + s2 + s3


def DiffieHellman_Fq():
    diffie = exchangers()
    hellman = exchangers()
    
    diffie_pk = diffie.send() 
    hellman.recieve(diffie_pk)
    hellman_pk = hellman.send()
    diffie.recieve(hellman_pk)
    
    assert hellman.sharedKey == diffie.sharedKey
    print("diffie: ",str(diffie))
    print("======================")
    print("hellman: ",str(hellman))

DiffieHellman_Fq()