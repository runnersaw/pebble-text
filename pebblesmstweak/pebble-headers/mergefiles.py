import os


def getString():
	path = './PebbleTime'
	finalStr = ''

	for filename in os.listdir(path):
		f = open('./PebbleTime/'+filename, 'r')
		content = f.read()
		print filename, len(content)

		finalStr += content
		finalStr += '\n\n'
		f.close()

	return finalStr

def stripString(s):
	index = 0

	while index != -1:
		char = s[index]
		# print('STRINGS')
		# print(index)
		# print(char)
		# print('STRING')
		# print(s)
		nextIndex = s.find('\n', index)
		if (char == '#' or char == '*' or char == '/'):
			if (nextIndex == -1):
				s = s[:index]
			else:
				s = s[:index] + s[nextIndex+1:]
		else:
			index = nextIndex + 1
		if index == len(s)-1:
			break

	return s

def writeFile(s):
	f = open('./pebble43.h', 'w')
	f.write(s)
	f.close()

if __name__=="__main__":
	test = '*\n/\n/\n\n*\n&\n9\n0\n0\n0\n0'
	# print(stripString(test))
	writeFile(stripString(getString()))



