def BSGS(p: int, g: int, h: int, ell: int) -> int:
    B = 26843545600 # 25GiB in byts
    m = floor(sqrt(ell))
    baby_steps = {}

    # this doesnt work well with Dictionaries, which is why I havent used it for that
    p_Bytesize = sys.getsizeof(p)

    baby_index = -1
    giant_index = -1

    #computing baby steps
    for i in srange(m):
        if (len(baby_steps) * p_Bytesize * 2) >= B: break
        #key-value pair flipped to utilize O(1) lookup for keys
        baby_steps.update({power_mod(g,i,p): i})
    
    #GIANT step time
    geM = power_mod(g,-m,p)
    for i in srange(m):
        possible_solution = (h * power_mod(geM,i,p)) % p
        if possible_solution in baby_steps:
            giant_index = i
            v = baby_steps.get(possible_solution)
            baby_index = v
            break
    # lets check if we found a match
    if  giant_index == -1:
        print("Did not find a match, possibly because of memory bounds, terminating ..")
        return
    solution = (baby_index + (m * giant_index)) % p
    return solution

#print("Answer: ", BSGS(107,4,83,53))
print("Answer: ", BSGS(133736723,2,125783745,133736722)) # 29991398
#print("Answer: ", BSGS(240000000000889,119888251341522,122044725852430,10000000000037))
    




