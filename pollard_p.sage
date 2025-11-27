# just to make it easier to implement Floyds'
class traverser:
    def __init__(self,G: int,B: int,C: int):
        self.G = G
        self.B = B
        self.C = C
    def next(self, p: int, g: int, h: int, ell: int):
        if (self.G % 3) == 0:
                self.B = (self.B + 1) % ell
                self.G = (self.G * g) % p
        elif (self.G % 3) == 1:
                self.C = (self.C + 1) % ell
                self.G = (self.G * h) % p
        elif (self.G % 3) == 2:
                self.B = (self.B * 2) % ell
                self.C = (self.C * 2) % ell
                self.G = (self.G * self.G) % p
        return self
            

def pollard_rho(p:int, g: int, h: int, ell: int) -> int:
    #
    G0, B0, C0 = g, 1, 0

    # also known as tortoise and hare
    walker = traverser(G0,B0,C0)
    runner = traverser(G0,B0,C0)

    walker = walker.next(p,g,h,ell)
    runner = runner.next(p,g,h,ell).next(p,g,h,ell)
    
    while(walker.G != runner.G) :
        walker = walker.next(p,g,h,ell)
        runner = runner.next(p,g,h,ell).next(p,g,h,ell)

    if(gcd(walker.C - runner.C,ell) != 1):
        print("No inverse exists.. cant produce an answer currently..")
        return -1
    solution = ((runner.B - walker.B)* inverse_mod((walker.C - runner.C),ell)) % ell
    return solution 

#print("Answer: ", pollard_rho(17,3,7,16))
#print("===============================")
#print("Answer: ", pollard_rho(107,4,83,53))
#print("===============================")
#print("Answer: ", pollard_rho(133736723,2,125783745,133736722)) # 29991398 inverse mod !
#print("===============================")
#print("Answer: ", pollard_rho(752557046340383,84483694178164,295976407848672,376278523170191))
#print("===============================")
#print("Answer: ", pollard_rho(133736723,2,125783745,133736722))
#print("===============================")
