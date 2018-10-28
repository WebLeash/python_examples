from sys import argv

script, filename = argv

txt = open(filename)

print ("Here's your file %r:" % (filename))
file1 =  txt.read()

print ("Type the filename again:")
file_again = input("> ")

txt_again = open(file_again)

file2 = txt_again.read()
print (file2)

