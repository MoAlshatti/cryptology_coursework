def pohlig_hellman(p: int, g: int, h: int)->int:
    MAX_PRIME_DIVISOR = 20000000000 
    order = p-1
    facs = (order).factor()
    B = max(MAX_PRIME_DIVISOR,floor((2/3) * p))
    if facs[-1][0] >= B:
        print("The input is not doable, terminating...")
        return -1

    print("The prime factors are: ", facs)
    bits = []
    #f is factor, e is exponent
    for f,e in facs:
        bits_0 = []
        bit1_0 = 0
        lhs = power_mod(h,order//f,p)  
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
    
def testing_ph():
    print("Answer: ",pohlig_hellman(1019, 7, 1001))   # 590
    print("===============================")
    print("Answer: ",pohlig_hellman(1879, 11, 1236))  # 1852
    print("===============================")
    print("Answer: ",pohlig_hellman(2029, 2, 819))    # 41
    print("===============================")
    print("Answer: ",pohlig_hellman(160079,17,66133)) # 16744
    print("===============================")
    print("Answer: ",pohlig_hellman(161386420777,10,148775913664)) # 28165436364
    print("===============================")
    print("Answer: ",pohlig_hellman(599939, 2, 93522)) # 226948
    print("===============================")

        
#testing_ph()

print("Answer: ",pohlig_hellman(10192004369, 3 , 7198247104)) 
#print("Answer: ",pohlig_hellman(14400000337,5,9370058779)) # 7921731534 
#print("Answer: ",pohlig_hellman(4238338164061,6,3689495385185)) # 2430808064962 1.3 minutes
#print("Answer: ",pohlig_hellman(102092514301,10,30246603389)) # 55166371790  17.4 seconds
#print("Answer: ",pohlig_hellman(641617368221,2,472374485029)) # 610027025421 1.3 seconds
#print("Answer: ",pohlig_hellman(12600001177,17,11240688171)) # 9876543210  8.03 minutes
print("===============================")
#print("Answer: ",pohlig_hellman(21600000503, 5, 15151854931))
#print("===============================")