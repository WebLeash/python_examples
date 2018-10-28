numbers = []
def wloop(times):
    i = 0
    y = times
    while i < y:
      print ("At the top i is %d" % ( i))
      numbers.append(i)

      i = i + 1
      print ("Numbers now: ", (numbers))
      print ("At the bottom i is %d" % ( i))


      print ("The numbers: ")

for num in numbers:
 print (num)

loops = int(input("How many times to loop?:>"))
wloop(loops)
