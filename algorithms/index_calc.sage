def IC(p: int, g: int, h: int)->int:

    order = ZZ(p-1)
    B = e^(1/2 * (sqrt(ln(order) * ln(ln(order)))))
    B = min(B,10^5)
    
    P = Primes()
    factor_base = set()
    i = 1
    while len(factor_base) < B:
        factor_base.add(P.next(i))
        i += 1

    relations = []
    exponents = [] #gonna be a list of lists
    while len(relations)!= len(factor_base)+10:
        k = randint(1,p-2)        

        factors = []
        y = power_mod(g,k,p)
        for fac in factor_base:
            exponent = 0
            while fac.divides(y):
                y = y // fac
                exponent += 1
            factors.append(exponent)
        if y == 1:
            relations.append(k)
            exponents.append(factors)

    relations = vector(Integers(order),relations)
    exponents = matrix(Integers(order),exponents)
    solved_logs = exponents.solve_right(relations)

    exponents = [] 
    while True:
        factors = []
        k = randint(1,p-2)
        y = (power_mod(g,k,p) * h) % p
        for fac in factor_base:
            exponent = 0
            while fac.divides(y):
                y = y // fac
                exponent += 1
            factors.append(exponent)
        if y == 1:
            exponents = factors
            break
    exponents = vector(Integers(order),exponents)
    sol = ((solved_logs.dot_product(exponents)) - k) % order
    if power_mod(g,sol,p) != h % p:
        return -1
    return ZZ(sol)

# This function repeats running index calclus in case it fails, until success
def recursive_IC(p: int, g: int, h: int)-> int:
    while (res := IC(p,g,h)) == -1:
        continue
    return res
        
                
                
#print("Answer: ",IC(1879, 11, 1236))  # 1852
#print("===============================")
#print("Answer: ",IC(161386420777,10,148775913664)) # 28165436364
#print("===============================")
#print("Answer: ",IC(599939, 2, 93522)) # 226948


#for i in range(25):
#    print("Answer: ",recursive_IC(161386420777,10,148775913664)) # 28165436364
    
print("Answer: ",recursive_IC(4238338164061,6,3689495385185)) # 2430808064962 
print("Answer: ",recursive_IC(102092514301,10,30246603389)) # 55166371790  
print("Answer: ",recursive_IC(641617368221,2,472374485029)) # 610027025421 
print("Answer: ",recursive_IC(12600001177,17,11240688171)) # 9876543210  
print("Answer: ",recursive_IC(950603238735531779,2,425904671921435603)) # 502937120854632774  
