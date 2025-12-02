import hashlib
import os
import random


# A functoin to generate random hex strings, found it on stackoverflow
def random_hex_string(length=6):
    return os.urandom(length).hex()


i = 0
while True:
    t = random_hex_string(random.randint(1, 256))
    x = hashlib.sha256(t.encode())
    i += 1
    if x.hexdigest().startswith("2336766"):
        print("tries: ", i)
        print("input: ", t)
        print("output: ", x.hexdigest())
        open("heater.hex", "w+").write(t)
        break
