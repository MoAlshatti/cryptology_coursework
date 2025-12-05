import os

# Note: this is neither tidy nor efficient code(not proud of the quality), but it got the job done


def convHexToAscii(plainText):
    for i in range(len(plainText)):
        hex = int(plainText[i], 16)
        plainText[i] = chr(hex)
    plainText.reverse()
    return "".join(plainText)


def setCipherTextFromPlainText(ogCipherText, ogPlainText, wantedPlainText):
    ogCipherText = int(ogCipherText, 16)
    ogPlainText = int(ogPlainText, 16)
    wantedPlainText = int(wantedPlainText, 16)
    cipherVal = ogCipherText ^ ogPlainText ^ wantedPlainText
    return format(cipherVal, "02x")


def retrievePlainText(paddingVal, ogCipherText, modifiedCipherText):
    ogCipherText = int(ogCipherText, 16)
    modifiedCipherText = int(modifiedCipherText, 16)
    textVal = paddingVal ^ ogCipherText ^ modifiedCipherText
    return format(textVal, "02x")


def setProperPadding(paddingVal, nonce, plainTexts):
    paddingStrVal = format(paddingVal, "02x")
    n = [nonce[i : i + 2] for i in range(0, len(nonce), 2)]
    for i in range(paddingVal - 1):
        n[-(i + 1)] = setCipherTextFromPlainText(
            n[-(i + 1)], plainTexts[i], paddingStrVal
        )
    return "".join(n)


nonce = "8a80d4667ce6072f1d66ec1d066674fb"
hex_numbers = "0123456789abcdef"

c = "4d43c6650013a328d830dc6119d5c2583e6c1aaed5e356a85e8c30f93a7853df"
c = c[0:32]


# contains the original ciphertext
cipherTextList = [nonce[i : i + 2] for i in range(0, len(nonce), 2)]

# this is what we'll change
nonceCopy = nonce
plainText = []
currPadding = 0x01
for i in range(16):
    nonceCopy = setProperPadding(currPadding, nonce, plainText)
    found = False
    counter = 0
    for letter in hex_numbers:
        if found:
            break
        for letter2 in hex_numbers:
            nonceList = [nonceCopy[i : i + 2] for i in range(0, len(nonceCopy), 2)]
            nonceList[-(i + 1)] = letter2 + letter
            nonceCopy = "".join(nonceList)
            output = os.popen("./cbc " + nonceCopy + " " + c).read()
            if output == "Ah ah ah! You did not say the magic phrase.\n":
                if counter != 1:
                    found = True
                    text = retrievePlainText(
                        currPadding, cipherTextList[-(i + 1)], letter2 + letter
                    )
                    plainText.append(text)
                counter += 1
    currPadding += 0x01

# now block 2 time
nonce = "8a80d4667ce6072f1d66ec1d066674fb"
c = "4d43c6650013a328d830dc6119d5c2583e6c1aaed5e356a85e8c30f93a7853df"
ogC1 = c[0:32]
c1 = c[0:32]
c2 = c[32:64]
plainText2 = []

c1List = [c1[i : i + 2] for i in range(0, len(c1), 2)]
c2List = [c2[i : i + 2] for i in range(0, len(c2), 2)]
currPadding = 0x01

for i in range(16):
    c1 = setProperPadding(currPadding, ogC1, plainText2)
    found = False
    counter = 0
    for letter in hex_numbers:
        if found:
            break
        for letter2 in hex_numbers:
            c1CopyList = [c1[i : i + 2] for i in range(0, len(c1), 2)]
            c1CopyList[-(i + 1)] = letter2 + letter
            c1 = "".join(c1CopyList)
            output = os.popen("./cbc " + nonce + " " + c1 + c2).read()
            if output == "Ah ah ah! You did not say the magic phrase.\n" or (
                output
                == "You have said the magic phrase! (But you haven't answered the question.)\n"
                and i >= 6
            ):
                if counter != 1 or (True and i >= 6):
                    found = False
                    text = retrievePlainText(
                        currPadding, c1List[-(i + 1)], letter2 + letter
                    )
                    plainText2.append(text)
                counter += 1
    currPadding += 0x01

print(convHexToAscii(plainText) + convHexToAscii(plainText2))
