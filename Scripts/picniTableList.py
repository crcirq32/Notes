def printPicnic(itemsDict, leftWidth, rightWidth):
    print('PICNIC ITEMS'.center(leftWidth + rightWidth, '-'))
    for k, v in itemsDict.items():
        print(k.ljust(leftWidth, '.') + str(v).rjust(rightWidth))

picnicItems = {'Slurping': 4, 'Bananaananaas': 12, 'cups': 4, '8===D~': 69}
#printPicnic(picnicItems, 12, 5)
printPicnic(picnicItems, 20, 6)
