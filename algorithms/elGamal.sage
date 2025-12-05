# the only reason this is a function is because i might decide to generate params differently
#otherwise think of them as global variables
def setup() -> tuple[int, int]:
    p = 5483726216518802424249897077442562360258186756712093186390906972082218310355143492231908067732499577181498166336189598042996867285965189038988256654167594120026656193501771181829704182243693009355886272389135391006901413609798387965796824317759055951823956171897942025373288793935988475118238207290816135461510768187302319963189254664041281518960811597688839953017535630945869995457117563781623579898063452490262494290025004562135890959914607215166867117589353826288561354143416600612633711238208703794112947262208960394385250219265069285224113834450105634576843786438199778210489466293813724145254451900105084190244216442889452305458035016067931437146309150545013430066173726332748475144476675344515561856452332686048218203715879615682569912527392146447893907411121901285309162868834166773135691720191836245739798857486711423979357758728711229595440520146832720457952944323833822200642400963972922887474036495506314515946119
    g = 7
    return p, g

#public parameters (every function has access to it)
p,g = setup()

# this is a separate function because generating a key need only be done once
# so generating everytime a sign happens would be a waste
def gen_signer_key() -> tuple[int,int]:
    # the reason the choice of d does not start from 1 or end with p-1 is to avoid
    #trivial brute force attempts that begin from the start or end
    d = randint(10^7,p-10^7)
    pK = power_mod(g,d,p)
    return d, pK
    
def sign(a: int, m: int, used_nonces: set[int]) -> tuple[int, int]:
    #reason im not starting from 1 or ending with p-1 is the same as the one above
    k = randint(10^7,p-10^7)
    while gcd(k,p-1) != 1 and k not in used_nonces:
        k = randint(1,p-1)
    used_nonces.add(k)
    r = power_mod(g,k,p)
    k_inv = inverse_mod(k,p-1)
    sig = (k_inv * (m - (a * r))) % (p-1)
    return r, sig

def verify(sig: int, r: int, m: int, pK: int) -> bool:
    lhs = power_mod(g,m,p) % p
    rhs = (power_mod(pK,r,p) * power_mod(r,sig,p)) % p
    if lhs == rhs: return true
    return false
    
used_nonces = set()
a,pK = gen_signer_key()

# lets choose some message to be signed
m = 105 % p
# sign the message using the secret key, and a random nonce
r,sig = sign(a,m,used_nonces)
# verify the message, this should be true
print(verify(sig,r,m,pK))
# to make sure it works, lets test with some wrong inputs
print(verify(555,r,m,pK))
print(verify(sig,g^8,m,pK))