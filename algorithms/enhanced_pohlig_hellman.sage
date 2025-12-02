load("pollard_p.sage")

#modified copy of the og one which uses if statements
#to check when to use pollard-rho
# Note: I remove the B bound for this algorithm
def enhanced_pohlig_hellman(p: int, g: int, h: int)->int:
    order = p-1
    facs = (order).factor()
    print("The prime factors are: ", facs)
    bits = []
    #f is factor, e is exponent
    for f,e in facs:
        bits_0 = []
        bit1_0 = 0

        lhs = power_mod(h,order//f,p)  
        if f > 100:
            gPrime = power_mod(g,order//f,p)
            bit1_0 = pollard_rho(p,gPrime,lhs,f)
        else:
            while lhs != power_mod(g,(order//f)*bit1_0,p):
                bit1_0 += 1
        bits_0.append(bit1_0)
        for i in srange(1,e):
            bitK_0 = 0
            bits_power = 0
            for j,b in enumerate(bits_0):  
                bits_power += power_mod(f,j,p)*b 
            fe = power_mod(f,i+1,p)
            lhs = power_mod(h,order//fe,p)
            rhs_partial = power_mod(g,(order//fe) * bits_power,p)
            if f > 100:
                gPrime = power_mod(g,order/f,p) % p
                hPrime = (lhs * power_mod(g,(order//fe) * -bits_power,p)) % p
                bitK_0 = pollard_rho(p,gPrime,hPrime,f) %p
            else:
                while lhs!= (rhs_partial * power_mod(power_mod(g,order//f,p),bitK_0,p))% p:
                    bitK_0 += 1
            bits_0.append(bitK_0)
        bitK = 0
        for i,b in enumerate(bits_0):
            
             bitK += b * power_mod(f,i,p)
        bits.append(bitK)
    # 
    #for the sake of conveniece, i will create a list of factors
    # which add any repeated factors as one proper element 
    facList= []
    for f, e in facs:
        num = 1
        for i in srange(e):
            num *= f
        facList.append(num)
    #lets rename the list of a's too
    A = bits
    print("Applying Sun Tzu's theorem...")
    #Now apply the chinese remainder theorem
    mTotal = 1
    for fac in facList:
        mTotal *= fac
    M = []
    for fac in facList:
        M.append(mTotal//fac)
    X = []
    for i,m in enumerate(M):
        x = inverse_mod(m,facList[i])
        X.append(x)
    res = 0
    for i in range(len(X)):
        res += (A[i] * X[i] * M[i]) % mTotal
        res = res % mTotal
    return res


#print("Answer: ",enhanced_pohlig_hellman(10192004369, 3 , 7198247104)) 
#print("Answer: ",enhanced_pohlig_hellman(11520316802179, 2, 3970483220420)) 
#print("Answer: ",enhanced_pohlig_hellman(795189633901933,2,213666326927748)) 